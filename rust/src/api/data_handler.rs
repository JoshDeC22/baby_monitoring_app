use flutter_rust_bridge::frb;
use csv::Writer;
use std::{
    fs::File,
    path::Path,
};

#[frb]
pub struct DataHandler {
    #[frb(name = "dataList")]
    pub data_list: Vec<i32>,  
    pub error: bool,
    byte_array: Vec<u8>,
    writer: Option<Writer<File>>,
}

impl DataHandler {
    #[frb(sync)]
    pub fn new(num_channels: u32, dir: String, filename: String) -> Self {
        // Create empty arrays to hold the returned data and byte array
        let data_list: Vec<i32> = Vec::with_capacity(num_channels as usize);
        let byte_array: Vec<u8> = Vec::with_capacity(num_channels as usize * 2);

        // Path to the csv file
        let csv_path: String = dir + "/" + filename.as_str() + ".csv";

        // If the path does not exist then create the csv file
        if !Path::new(&csv_path).exists() {
            match File::create(&csv_path) {
                Ok(_) => {},
                Err(_) => return DataHandler { data_list, error: true, byte_array, writer: None}
            };
        }

        // Create the writer to write data to the csv file
        let writer: Writer<File> = match Writer::from_path(&csv_path) {
            Ok(writer) => writer,
            Err(_) => return DataHandler { data_list, error: true, byte_array, writer: None}
        };

        DataHandler { data_list, error: false, byte_array, writer: Some(writer)}
    }

    pub fn process(&self, bytes: &[u8]) {
        // process the data
    }

    // Example for handling the save data aspect of this
    pub fn save_data(&mut self) {
        let mut _writer = match self.writer.as_mut() {
            Some(writer) => writer,
            None => panic!("Josh is a dumbass")
        };
    }
}