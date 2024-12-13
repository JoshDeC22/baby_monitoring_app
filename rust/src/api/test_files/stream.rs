use anyhow::Result;
use std::{thread::sleep, time::Duration, fs::{File, OpenOptions}, path::Path};
use rand;
use csv::{Writer, WriterBuilder};

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;

#[frb(opaque)]
pub struct DataHandler {
    sink: Vec<StreamSink<i32>>,
    writer: Writer<File>,
    data: Vec<i32>,
}

impl DataHandler {
    #[frb(sync)]
    pub fn new(sink: Vec<StreamSink<i32>>, dir: String, filename: String) -> Self {
        let csv_path: String = dir + "\\" + filename.as_str() + ".csv";
        if !Path::new(&csv_path).exists() {
            match File::create(&csv_path) {
                Ok(_) => {},
                Err(e) => panic!("{:?}", e)
            };
        }
        let file = OpenOptions::new()
            .write(true)
            .append(true)
            .open(&csv_path)
            .expect("Unable to open file");

        let writer: Writer<File> = WriterBuilder::new()
            .has_headers(false)
            .from_writer(file);

        DataHandler { sink, writer, data: Vec::with_capacity(2) }
    }

    pub async fn tick(&mut self) -> Result<()> {
        let mut ticks1: i32 = rand::random::<i32>();
        let mut ticks2: i32 = rand::random::<i32>();
        let mut count: i32 = 0;
        let dur: Duration = Duration::from_secs_f32(0.1);
        loop {
            self.data.push(ticks1);
            self.data.push(ticks2);

            self.sink[0].add(ticks1).expect("Error adding value to stream");
            self.sink[1].add(ticks2).expect("Error adding value to stream");

            self.save_data_csv().await;

            sleep(dur);
            if count == 500 {
                break;
            }
            ticks1 = rand::random::<i32>();
            ticks2 = rand::random::<i32>();

            count += 1;
        }

        Ok(())
    }

    async fn save_data_csv(&mut self) {
        let record: Vec<String> = self.data.iter().map(|val| val.to_string()).collect();
        self.writer.write_record(&record).expect("Error writing to file");
        self.writer.flush().expect("Error flushing data to the file.");
        self.data.clear();
    }
}
