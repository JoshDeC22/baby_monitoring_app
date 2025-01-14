# baby_monitoring_app

The Baby Monitoring App is designed for real-time monitoring of blood parameters using Bluetooth-connected sensors and CSV data inputs. The app provides dynamic graph plotting, interactive data exploration, and CSV data management through a Flutter front end and a Rust back end.

## Device information

Android Version: 8.1.0
Samsung Experience Version: 9.5
Kernel Version: 3.18.14, built on November 3, 2020
Build Number: MTAJQ.T580XXS9CTK1
SE for Android Status: Enforcing, version SEPF_SM-T580_8.1.0_0008
Knox Version: 3.2 (Knox API level 26, TIMA 3.3.0)
Security Software Version: ASKS v2.0.0, Release 200120ADP v2.0, Release 180525, SMR Apr-2020 Release R
Android Security Patch Level: April 1, 2020


## Prerequisites 
Rust 
Flutter SDK
Android Studio and Emulator
Flutter Rust Bridge

## Setup
1. Clone the repository
   a.clone <repo-url>
   b.cd baby_monitoring_app
   
3. Install Flutter dependencies
   a. flutter pub get
   
3.set up flutter rust bridge
   a.cargo install flutter_rust_bridge_codegen
   
5. Run android emulator or android device
6. Run app (flutter run)

## Bluetooth types
bluetooth low energy
bluetooth classic
