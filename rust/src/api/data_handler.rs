use flutter_rust_bridge::frb;
use csv::{
    ReaderBuilder, Writer, WriterBuilder
};
use std::{
    error::Error, fs::{File, OpenOptions}, path::Path
};
use anyhow::Result;
use chrono::{Duration, DateTime, NaiveTime, Utc};

use crate::frb_generated::StreamSink;

#[frb(opaque)]
pub struct DataHandler {
    #[frb(name = "dataList")]
    stream_sinks: Vec<StreamSink<u16>>,
    csv_path: String,
    writer: Option<Writer<File>>,
    num_channels: u8,
    current_time: DateTime<Utc>,
    day: u8,
    
    // byte_array: Vec<Vec<u16>>,
    pub data_list: Vec<u16>,
    pub error: bool,
}

impl DataHandler {
    #[frb(sync)]
    // Constructor of the DataHandler Class
    pub fn new(stream_sinks: Vec<StreamSink<i32>>, num_channels: u8, dir: String, filename: String) -> Self {
        // Create empty arrays to hold the returned data and byte array
        let data_list: Vec<u16> = Vec::with_capacity(num_channels as usize);
        let byte_array: Vec<Vec<u16>> = Vec::with_capacity(num_channels as usize);

        // Set this DataHandler for Day 1
        let day: u8 = 1;

        // Define CSV File pathway
        let csv_path: String = dir + "/" + filename.as_str();

        // Creates CSV File
        let (writer, error, current_time) = Self::create_file(&csv_path, day, num_channels);

        DataHandler { stream_sinks, csv_path, writer, num_channels, current_time, day, data_list, error }
    }


    /*  
        This Function Takes in the pathway to the CSV File, the current day and the number of Channels being monitored
        - Creates a File Specified by the csv_path
        - Adds a Header in the CSV File with the Date and the Number of Channels.
        - Returns a Writer Object for the Created File, A boolean value indicating if an Error has occured, and the Current Date and Time the file was created.
    */
    fn create_file(csv_path: &String, day: u8, num_channels: u8) -> (Option<Writer<File>>, bool, DateTime<Utc>) {
        let csv_name = format!("{}_{}.csv", csv_path, day); // Path to the CSV File
        let current_time = Utc::now();               // Get the Current Time

        // If the path does not exist then create the CSV file
        if !Path::new(&csv_name).exists() {
            match File::create(&csv_name) {
                Ok(_) => {},
                Err(_) => {
                    return (None, true, current_time)
                }
            };
        } else {
            panic!("File Already Exists!"); // Throws an Error if the File Name given Already Exists
        }

        // Opens the CSV file for Appending. If not Opened, the Data in the File will be Overwritten
        let file = match OpenOptions::new()
            .write(true)
            .append(true)
            .open(&csv_name)
        {
            Ok(file) => file,
            Err(_) => return (None, true, current_time)
        };
        
        // Create the Writer Object that will Write Data to the CSV File
        let mut writer: Writer<File> = WriterBuilder::new()
            .has_headers(false)
            .from_writer(file);


        // The Following Code Creates the Header of the CSV File
        // Reformats the Current Time to give Year, Month, Date
        let mut header:Vec<String> = vec![current_time.format("%Y-%m-%d").to_string()]; 
        for i in 1..=num_channels {
            header.push(format!(" Channel {}", i));
        }
        if let Err(_) = writer.write_record(header) {
            return (None, true, current_time)
        }

        return (Some(writer), false, current_time)
    }


    /*  
        This Function Takes in no Arguments.
        - Creates a File For the Next Day 
        - Updates the Values of the Current Instance. (Day and the Writer Object)
        - It Returns an Empty Result Object.
        Note: Replacing the Previous Writer Object will bring the Previous File Out
        of Scope and Rust will Automatically Close that CSV File.
    */
    fn update_file(&mut self) -> Result<(), Box<dyn std::error::Error>>{
        self.day += 1; // Increments the Current Day by 1
        // Creates a New CSV File for the Next Day
        let (writer, error, current_time) = Self::create_file(&self.csv_path, self.day, self.num_channels);

        // Updates the Current_Time and Writer Object
        if !error {
            self.current_time = current_time;
            self.writer = writer;
        }

        Ok(())
    }


    /*  
        This Function Takes in a List of Bytes. 
        - It Combines Every Two Byte into a u16 integer which corresponds to a DataPoint. 
        - Each DataPoint is then Saved (Written) into the CSV File.
        - The DataPoint is also Then Saved to byte_list where it is then sent to the filter function.
    */
    pub async fn process(&mut self, bytes: &[u8]) {
        let mut current_channel:u8 = 0; // Current Channel Counter
        let mut byte_one: u8 = 0x00;    // The First Byte of the two-byte DataPoint value

        // Loop Through the Given Byte Array
        for (i, b) in bytes.iter().enumerate() {
            if i % 2 == 0 {
                byte_one = *b; // Assign the Even bytes to byte_one
            } else {
                let byte_two = *b; // Assign the Odd bytes to byte_two
                
                // Combine the Byte Values (With Shift and Or Operation)
                let processed_datapoint: u16 = ((byte_one as u16) << 8) | (byte_two as u16);

                // Everytime a Datapoint is Processed
                self.data_list.push(processed_datapoint);                   // Add into data_list

                // Need Change: Filter First and then Push to Flutter
                // self.stream_sinks[current_channel].add(processed_datapoint) // Send Datapoint to Flutter 
                //   .expect("Error: Failed to add value to Stream");

                current_channel += 1;

            }

            // Once Each Channel has a Processed Data Point
            if current_channel == self.num_channels {
                // Save (Write) it into the CSV File
                let cloned_data = self.data_list.clone();
                self.save_data_csv(&cloned_data).await;

                self.data_list.clear(); // Clear the data_list after Saving
                current_channel = 0;    // Restart Current Channel Counter
            }

        }

    }

    // Previous process Function
    /*
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
                // Assign the Odd bytes to byte_two
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
    */


    /* 
        This Function Takes in data, a list of u16 Integers (One for each Channel) which corresponds to the Channel Value
        - Gets the Time of when the Channel Value is Taken. 
        - If the Time is 24 hours after the Current File was made, it creates a new file (update_file Function)
        - Saves (Writes) the Time and the Channel Values on the Next Row of the CSV File
    */
    async fn save_data_csv(&mut self, data: &Vec<u16>) {
        let current_time = Utc::now(); // Get the Current Time

        // If the program has been running for more than 24 hours
        if current_time - Duration::seconds(5) > self.current_time {
            // Create a new CSV File to store data
            match self.update_file() {
                Ok(_) => {},
                Err(_) => {
                    panic!("ERROR: Update File Function is NOT WORKING!")
                }
            };
        }

        // Unwraps Writer Option Object
        if let Some(writer) = self.writer.as_mut() {
            // Splits Each u16 integer value from the data given and Converts them to String Objects
            let record: Vec<String> = data.iter().map(|data| data.to_string()).collect();

            // Reformats the Current Time to Give Hours, Months, Seconds.3sf
            let mut timed_record: Vec<String> = vec![current_time.format("%H:%M:%S%.3f").to_string()];
            timed_record.extend(record); // Adds a Time DataPoint to be Written alongside the Channel Values
            
            // Writes each Value in data_list into a csv file
            writer.write_record(&timed_record).expect("Error: Nothing to Write.");

        } else {
            println!("Error: Writer not Found.")
        }

    } 

    // Filter Function
    /*
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
    */


    /*
        // Should Probably be a Static Function
        This Function Takes in the Pathway to CSV File
        - Returns a Result Object Containing time_list and data_list
        - time_list is a Vector containing all the Time Points taken
        - data_list is a Vector containing a Vector of Channel Values for each Channel

        E.g. 
        return [ time_list , data_list ]
        time_list = [14:18:46.677, 14:18:46.782, 14:18:46.887, 14:18:46.989, 14:18:47.094]
        data_list = [ [Channel 1 Values] , [Channel 2 Values] ]
                  = [ [ 13, 9, 5, 7, 8 ] , [ 3, 6, 11, 8, 1 ] ]
     */
    pub fn read_data_csv(&mut self, file_directory: String) -> Result<(Vec<String>, Vec<Vec<u16>>), Box<dyn Error>> {
        // Creates time_list. time_list stores all the time points refering to when each Channel Value was Collected
        let mut time_list: Vec<String> = Vec::new();
        // Creates data_list. data_list is a Vector containg a multiple Vectors of Channel Values. One for each Channel
        let mut data_list: Vec<Vec<u16>> = vec![Vec::new(); self.num_channels as usize];
        
        // Open the CSV File and create the Reader
        let file = File::open(file_directory)?;
        let mut reader = ReaderBuilder::new()
            .has_headers(true)
            .from_reader(file);
    
        // Loop through each Line in the CSV File
        for result in reader.records() {
            let record = result?; // Unpackage Result into Record

            // Iterate through each Channel Value at a Single Time Tnstant
            for (channel, value) in record.iter().enumerate() {

                // Converts the Channel Values (String Objects) into u16 integers
                if let Ok(channel_value) = value.parse::<u16>() {
                    // Add the Channel Value to data_points
                    if let Some(channel_list) = data_list.get_mut(channel - 1) {
                        channel_list.push(channel_value);
                    }
                    
                // Converts the Time Points into NaiveTime Objects
                } else if let Ok(_time) = NaiveTime::parse_from_str(value, "%H:%M:%S%.3f") {
                    // Add the Time (as a String) to time_points
                    time_list.push(value.to_string());
    
                } else {
                    println!("Error parsing value: {}", value)
                }
            }
        }
        // Return data_list
        Ok((time_list, data_list))
    
        }

}