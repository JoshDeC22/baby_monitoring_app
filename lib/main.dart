import 'package:baby_monitoring_app/screens/first_screen.dart';
import 'package:baby_monitoring_app/screens/test_pages/static_plot_page_test.dart';
import 'package:baby_monitoring_app/utils/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:baby_monitoring_app/src/rust/frb_generated.dart';
import 'package:provider/provider.dart';
import 'widgets/graph_widget.dart';
import 'blood_data.dart';
import '../utils/csv_reader.dart'; // Import the CSV loader

Future<void> main() async {
  await RustLib.init();
  runApp(
    ChangeNotifierProvider(create: (context) => AppStateProvider(), child: const MyApp())
  );
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph Widgets',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GraphScren(), //screneing for displaying graphs
    );
  }
}

// Screen displaying the graphs
class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late Future<List<BloodData>> glucoseDataFuture; //  glucose data will be initialised later and contain BloodData
  late Future<List<BloodData>> lactateDataFuture; //  lactate data will be initialised later and contain BloodData

  @override
  void initState() { //initialising the intial state of the widget
    super.initState();

    //Loading glucose data from the CSV file
    glucoseDataFuture = loadGlucoseData('assets/Glucose_Data.csv'); 
    // Load inglactate data from the CSV file
    lactateDataFuture = loadGlucoseData('assets/Glucose_Data.csv');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //provides the structure for the screen
      appBar: AppBar( //top navigation bar
        centerTitle: true, 
        title: const Text('Real-Time Blood Parameter Monitoring',
         style: TextStyle(fontWeight: FontWeight.bold, ),),
      ),
      body: SingleChildScrollView( //vertical scrolling
        scrollDirection: Axis.vertical,
        child: Column( //arrange graph widgets down the page
          crossAxisAlignment: CrossAxisAlignment.stretch, // Graphs fill the full width
          children: [
            // Glucose Graph
            FutureBuilder<List<BloodData>>( //widget which wiats for data to be loaded in from the CSV file
              future: glucoseDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) { // checks if the data is still be loaded
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()), //display loading symbol
                  );
                } else if (snapshot.hasError) { //checks if there was an error while laoding the data
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text('Error: ${snapshot.error}')), //display the error message
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) { //checks if the loaded data is empty
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No glucose data available')), //display the error message
                  );
                }

                final glucoseData = snapshot.data!; //extracting and storing the glucose data returned 
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: graph_widget(
                    parameterName: 'Glucose',
                    lineColor: Colors.red,
                    graphData: glucoseData,
                  ),
                );
              },
            ),

            // Lactate Graph
            FutureBuilder<List<BloodData>>( //widget which wiats for data to be loaded in from the CSV file
              future: lactateDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) { // checks if the data is still be loaded
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),  //display loading symbol
                  );
                } else if (snapshot.hasError) { //checks if there was an error while laoding the data
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text('Error: ${snapshot.error}')), //display the error message
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) { //checks if the loaded data is empty
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No lactate data available')), //display the error message
                  );
                }

                final lactateData = snapshot.data!;  //extracting and storing the lactate data returned 
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: graph_widget(
                    parameterName: 'Lactate',
                    lineColor: Colors.green,
                    graphData: lactateData,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
