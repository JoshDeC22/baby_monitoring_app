use flutter_rust_bridge::frb;
use csv::{
    ReaderBuilder, Writer, WriterBuilder
};
use std::{
    fs::{File, OpenOptions}, path::Path
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
    is_static: bool,
    
    filter_matrix: Vec<Vec<u16>>,
    pub data_list: Vec<u16>,
    pub error: bool
}

impl DataHandler {
    #[frb(sync)]
    // Constructor of the DataHandler Class
    pub fn new(stream_sinks: Vec<StreamSink<u16>>, num_channels: u8, dir: String, filename: String, is_static: bool) -> Self {
        // Create empty arrays to hold the returned data and byte array
        let data_list: Vec<u16> = Vec::with_capacity(num_channels as usize);
        let filter_matrix: Vec<Vec<u16>> = vec![Vec::new(); num_channels as usize];

        // Set this DataHandler for Day 1
        let day: u8 = 1;

        // Define CSV File pathway
        let csv_path: String = dir + "/" + filename.as_str();

        // Creates CSV File
        let writer: Option<Writer<File>>;
        let error: bool;
        let current_time: DateTime<Utc>;

        if !is_static {
            (writer, error, current_time) = Self::create_file(&csv_path, day, num_channels);
        } else {
            error = false;
            current_time = Utc::now();
            writer = None;
        }

        DataHandler { stream_sinks, csv_path, writer, num_channels, current_time, day, filter_matrix, data_list, error, is_static }
    }


    /*  
        create_file() is a Static Function that takes in the pathway to the CSV File, the current day and the number of Channels being monitored
        - Creates a File Specified by the csv_path
            - panics if the filename given aready Exists!
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
        update_file is a Function that takes in no Arguments.
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
        process() is a Public, Asynchronous Function that takes in a List of Bytes. 
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

                // Everytime a Datapoint is Processed, Add it into data_list
                self.data_list.push(processed_datapoint);

                current_channel += 1; // Increment Current Channel Count

            }

            // Once Each Channel has a Processed Data Point
            if current_channel == self.num_channels {
                // Clone data_list
                // Reason: Throws an error if you borrow two different mutable references of self
                let cloned_data = self.data_list.clone();

                self.filter(&cloned_data).await;   // Sends the data to the filter() function
                self.save_data_csv(&cloned_data).await; // Saves (Writes) the data into the CSV File

                self.data_list.clear(); // Clear the data_list after Saving
                current_channel = 0;    // Restart Current Channel Counter
            }

        }

    }

    
    /*
        filter() is an Asynchronous Function that takes in data_list. data_list contains a processed Data Point for each channel
        - Adds each Data Point to its corresponding Channel Vector in the filter_matrix
        - When "each channel" has 10 elemets, sum them up
        - Send the sum of each channel to Flutter via its corresponding StreamSink
        - Clear filter_matrix and reallocate some memory for it
        Note: The function assumes EACH CHANNEL has 10 elements if the FIRST channel has 10 elements.
        This assumption is based on the fact that data_list is only sent when it has the a Data Point
        for each channel.
    */
    async fn filter(&mut self, data_list: &Vec<u16>) -> Result<()> {
        // For each Data Point, add the Data Point to its corresponding Channel Vector in the filter_matrix
        for (channel, value) in data_list.iter().enumerate() {
            self.filter_matrix[channel].push(*value);
        }

        // Once "each channel" has 10 Data Points
        if self.filter_matrix[0].len() == 10 {
            for (channel, points) in self.filter_matrix.iter().enumerate() {

                // Take the sum of all the Data Points
                let sum: u16 = points.iter().map(|&val| val).sum();

                // Send sum to Flutter via the corresponding StreamSink
                self.stream_sinks[channel].add(sum).expect("Error streaming data")
                /*
                    Note: Once in flutter the sum will be divided by 10 to get the average.
                    This is done since stream sinks can only send i32 values.
                 */
            }

            self.filter_matrix.clear(); // Clear filter_matrix
            // Reallocate some memory for the new filter_matrix
            self.filter_matrix = vec![Vec::new(); self.num_channels as usize];
        }

        Ok(())
    }


    /* 
        save_data_csv() is a Public, Asynchronous Function that takes in data, a list of u16 Integers (One for each Channel) which corresponds to the Channel Value
        - Gets the Time of when the Channel Value is Taken. 
        - If the Time is 24 hours after the Current File was made, it creates a new file (update_file Function)
        - Saves (Writes) the Time and the Channel Values on the Next Row of the CSV File
    */
    pub async fn save_data_csv(&mut self, data: &Vec<u16>) {
        let current_time = Utc::now(); // Get the Current Time

        // If the program has been running for more than 24 hours
        if current_time - Duration::days(1) > self.current_time {
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


    /*
        read_data_csv() is a Public, Static Function that takes in the Pathway to CSV File
        - Returns a Result Object Containing time_list and data_list
        - time_list is a Vector containing all the Time Points taken
        - data_list is a Vector containing a Vector of Channel Values for each Channel
        - comment_list is a Vector containing Comments made on the Same Day as the File and their Time Stamps

        E.g. 
        return [ time_list , data_list , comment_list ]
        time_list = [14:18:46.677, 14:18:46.782, 14:18:46.887, 14:18:46.989, 14:18:47.094]
        data_list = [ [Channel 1 Values] , [Channel 2 Values] ]
                  = [ [ 13, 9, 5, 7, 8 ] , [ 3, 6, 11, 8, 1 ] ]

        comment_list = [ 14:18:46, "Glucose Spike" ]
     */
    pub fn read_data_csv(mut file_directory: String) -> Option<(Vec<String>, Vec<Vec<u16>>, Vec<Vec<String>>)> {
        // Open the CSV File and create the Reader
        let file = match File::open(&file_directory) {
            Ok(file) => file,
            Err(_) => return None,
        };
        let mut reader = ReaderBuilder::new()
            .has_headers(true)
            .from_reader(file);

        // Creates time_list. time_list stores all the time points refering to when each Channel Value was Collected
        let mut time_list: Vec<String> = Vec::new();
        // Creates data_list. data_list is a Vector containg a multiple Vectors of Channel Values. One for each Channel
        let headers = match reader.headers() {
            Ok(headers) => headers,
            Err(_) => return None,
        };

        let mut data_list: Vec<Vec<u16>> = vec![Vec::new(); headers.len() - 1];
    
        // Loop through each Line in the CSV File
        for result in reader.records() {
            let record = match result {
                Ok(record) => record,
                Err(_) => return None,
            }; // Unpackage Result into Record

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
                    return None;
                }
            }
        }

        // The Day of the File Opened
        let mut day = String::new();

        // From the File Name, extract the root_name and the day
        if let Some(root_name_length) = file_directory.rfind('_') {
            file_directory.truncate(root_name_length);
            file_directory.push_str("comment");
            day = file_directory[root_name_length + 1..].to_string();
        }
        
        // Open the comment CSV File and create the Reader
        let comment_file = match File::open(file_directory) {
            Ok(comment_file) => comment_file,
            Err(_) => return Some((time_list, data_list, vec![])),
        };

        // Create the Reader Object for the comment CSV file
        let mut comment_reader = ReaderBuilder::new()
            .from_reader(comment_file);

        // Vectors contatining the Comments and their Time Stamps
        let mut comments: Vec<String> = Vec::new();
        let mut timestamps: Vec<String> = Vec::new();

        // Iterate through each Line in the comment CSV file
        for result in comment_reader.records() {
            let record = match result {
                Ok(record) => record,
                Err(_) => return None,
            }; // Unpackage Result into Record

            // Iterate through each Comment and their Time Stamp and Day
            for value in record.iter() {
                if value.parse::<u16>() != day.parse::<u16>() {
                    // Disregard the comment it was not made on the Day of the read CSV File
                    break;
                } else if let Ok(_time) = NaiveTime::parse_from_str(value, "%H:%M:%S") {
                    // Add the Time (as a String) to timestamps
                    timestamps.push(value.to_string());
                } else {
                    // Add the Comment to somments
                    comments.push(value.to_string());
                }
            }
        }
        
        // Combine the Comments and Time Stamps into a single Vector
        let comment_list: Vec<Vec<String>> = vec![timestamps, comments];

        // Return data_list
        return Some((time_list, data_list, comment_list));
    
    }


    /*
        save_comments_csv() is a Public Function that takes in a comment and its timestamp
        - Returns nothing
        - Creates a comment CSV file if one does not yet exist
        - Calls write_function() to write the comment, its timestamp and the day into the comment CSV file
    */
    pub async fn save_comments_csv(&mut self, comment: String, timestamp: DateTime<Utc>) {
        let csv_name = format!("{}_comments.csv", self.csv_path); // Path to the CSV File

        // If the comment CSV file does not yet exist, create it
        if !Path::new(&csv_name).exists() {
            match File::create(&csv_name) {
                Ok(_) => {},
                Err(_) => {
                    panic!("Couldn't Create File");
                }
            };
        }

        // Write the Comment with the Time Stamp into the comment CSV file
        Self::write_comment(self, csv_name, comment, timestamp);

    }


    /*
        write_comment() is a Private, Static Function that takes in a comment and its timestamp
        - Returns a trivial Option<i32> object
        - Opens the comment CSV file and creates a Writer Object for it
        - Writes the Comment, Day, TimeStamp (H/M/S) in to the comment CSV file
    */
    fn write_comment(&mut self, csv_name: String, comment: String, timestamp: DateTime<Utc>) -> Option<i32> {
        // Opens the comment CSV file for Appending. If not Opened, the Data in the File will be Overwritten
        let file = match OpenOptions::new()
        .write(true)
        .append(true)
        .open(&csv_name)
        {
            Ok(file) => file,
            Err(_) => {
                return Some(1);
            }
        };
        
        // Create the Writer Object that will Write Data to the CSV File
        let mut writer: Writer<File> = WriterBuilder::new()
            .from_writer(file);

        let comment_line:Vec<String> = vec![self.day.to_string(), timestamp.format("%H:%M:%S%").to_string(), comment];
        writer.write_record(comment_line).expect("Error: Nothing to Write.");

        return Some(1);
    }
}