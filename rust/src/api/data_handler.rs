use flutter_rust_bridge::frb;
use csv::{
    WriterBuilder, ReaderBuilder, Writer
};
use std::{
    error::Error, fs::{File, OpenOptions}, path::Path
};

#[frb(opaque)]
pub struct DataHandler {
    #[frb(name = "dataList")]
    pub data_list: Vec<u16>,  
    pub error: bool,
    csv_path: String,
    writer: Option<Writer<File>>
}

impl DataHandler {
    #[frb(sync)]
    pub fn new(num_channels: u32, dir: String, filename: String) -> Self {
        // Create empty arrays to hold the returned data and byte array
        let data_list: Vec<u16> = Vec::with_capacity(num_channels as usize);
        // let byte_array: Vec<u8> = Vec::with_capacity(num_channels as usize * 2);

        // Path to the csv file
        let csv_path: String = dir + "/" + filename.as_str() + ".csv";

        // If the path does not exist then create the csv file
        if !Path::new(&csv_path).exists() {
            match File::create(&csv_path) {
                Ok(_) => {},
                Err(_) => return DataHandler { data_list, error: true, csv_path: csv_path, writer: None }
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

        
        DataHandler { data_list, error: false, csv_path: csv_path, writer: Some(writer) }
    }

    pub fn process(&mut self, bytes: &[u8]) {
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

        self.save_data_csv();
    }

    // Takes the data stored in data_list and writes onto a csv file
    // Clears data_list for the next iteration
    pub fn save_data_csv(&mut self) {

        // Sets the Writer Object assigned to this DataHandeling Instance as writer
        if let Some(writer) = self.writer.as_mut() {
            
            // Writes each Value in data_list into a csv file at the Specified Location
            let record: Vec<String> = self.data_list.iter().map(|data| data.to_string()).collect();
            writer.write_record(&record).expect("Error: Nothing to Write.");

        } else {
            panic!("Error. Writer not found.");
        }

        // Clear the data_list after Saving
        self.data_list.clear();
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