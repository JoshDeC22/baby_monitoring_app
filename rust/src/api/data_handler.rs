use flutter_rust_bridge::frb;
use csv::{
    ReaderBuilder, Writer, WriterBuilder
};
use std::{
    error::Error, fs::{File, OpenOptions}, path::Path
};
use anyhow::Result;

use crate::frb_generated::StreamSink;

#[frb(opaque)]
pub struct DataHandler {
    #[frb(name = "dataList")]
    pub data_list: Vec<u16>,  
    pub error: bool,
    csv_path: String,
    writer: Option<Writer<File>>,
    byte_array: Vec<Vec<u16>>,
    stream_sinks: Vec<StreamSink<i32>>,
}

impl DataHandler {
    #[frb(sync)]
    pub fn new(stream_sinks: Vec<StreamSink<i32>>, num_channels: u32, dir: String, filename: String) -> Self {
        // Create empty arrays to hold the returned data and byte array
        let data_list: Vec<u16> = Vec::with_capacity(num_channels as usize);
        let byte_array: Vec<Vec<u16>> = Vec::with_capacity(num_channels as usize);

        // let byte_array: Vec<u8> = Vec::with_capacity(num_channels as usize * 2);

        // Path to the csv file
        let csv_path: String = dir + "/" + filename.as_str() + ".csv";

        // If the path does not exist then create the csv file
        if !Path::new(&csv_path).exists() {
            match File::create(&csv_path) {
                Ok(_) => {},
                Err(_) => return DataHandler { data_list, error: true, csv_path: csv_path, writer: None, byte_array, stream_sinks }
            };
        }

        // Opens the csv file for Appending (If not opened, data will be overwritten)
        let file = OpenOptions::new()
            .write(true)
            .append(true)
            .open(&csv_path)
            .expect("Unable to open file");

        // Create the Writer to Write Data to the csv file
        let writer: Writer<File> = WriterBuilder::new()
            .has_headers(false)  // Do we want headers in our csv files?
            .from_writer(file);

        
        DataHandler { data_list, error: false, csv_path: csv_path, writer: Some(writer), byte_array, stream_sinks }
    }

    pub async fn process(&mut self, bytes: &[u8]) {
        let mut byte_one: u8 = 0x00;
        // Loop Through the Given Byte Array
        for (i, b) in bytes.iter().enumerate() {
            // For Debugging
            //println!("{} {}", i, *b);

            if i % 2 == 0 {
                // Assign the Even bytes to byte_one
                byte_one = *b;
            } 
            else if i % 2 != 0 {
                // Assign the Even bytes to byte_two
                let byte_two = *b;
                
                // For Debugging
                // println!("{} {}", byte_one, b);

                // Combine the Byte Values (With Shift and Or Operation) and push to data_list
                self.data_list.push( ((byte_one as u16) << 8) | (byte_two as u16) );
            }

        }

        self.filter();

        self.save_data_csv().await;
    }

    // Takes the data stored in data_list and writes onto a csv file
    // Clears data_list for the next iteration
    async fn save_data_csv(&mut self) {

        // Sets the Writer Object assigned to this DataHandeling Instance as writer
        if let Some(writer) = self.writer.as_mut() {
            
            // Writes each Value in data_list into a csv file at the Specified Location
            let record: Vec<String> = self.data_list.iter().map(|data| data.to_string()).collect();
            writer.write_record(&record).expect("Error: Nothing to Write.");
            writer.flush().expect("Error flushing data to the file.")

        } else {
            panic!("Error. Writer not found.");
        }

        // Clear the data_list after Saving
        self.data_list.clear();
    }

    async fn filter(&mut self) -> Result<()> {
        // Enumerate over data_list, this is done to get the correct index of the byte_array and stream sink for the current channel
        self.data_list.iter().enumerate().map(|(ind, &val)| {
            let byte_array: &mut Vec<u16> = &mut self.byte_array[ind]; // byte array for the current channel

            byte_array.push(val); // Add the new value for the channel

            // If the byte array is 10 elements long, take the sum of all the data points and send it back to flutter
            // Once in flutter the sum will be divided by 10 to get the average. This is done since stream sinks can only send
            // i32 values.
            if byte_array.len() == 10 {
                let sum: i32 = byte_array.iter().map(|&val| val as i32).sum::<i32>(); // Sum elements of the byte array

                // Calling the add method on the stream sink for this channel sends the data to flutter
                self.stream_sinks[ind].add(sum).expect("Error streaming data"); //Implement better error handling

                byte_array.clear(); // Clear the byte array
            }
        });

        Ok(())
    }

    pub fn read_data_csv(&mut self) -> Result<Vec<Vec<u16>>, Box<dyn Error>>{

    // Create data_list
    let mut data_list: Vec<Vec<u16>> = Vec::new();
    
    // Open the file and create the reader with no headers
    let file = File::open(self.csv_path.clone())?;
    let mut reader = ReaderBuilder::new()
        .has_headers(false)
        .from_reader(file);

    // Loop through each line in the csv file
    for result in reader.records() {

        // Set each line to record
        let record = result?;
        // Data Points for 1 time instant
        let mut data_points: Vec<u16> = Vec::new();
        

        // Iterate through each channel value for 1 time instant
        for value in &record {

            if let Ok(data_point) = value.parse::<u16>() {
                // Add them to data_points
                data_points.push(data_point);
            } else {
                println!("Error parsing value: {}", value);
            }

        }

        // Add each channel value for 1 time instant to the main data_list
        data_list.push(data_points);

    }
    // Return data_list
    Ok(data_list)

    }

}