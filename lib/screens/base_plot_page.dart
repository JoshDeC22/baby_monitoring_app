// Haven't fully finished this but it is the basic concept that I'm going for
// Still lots of work needs to be done on the cosmetic part and I haven't tested it yet

import 'package:flutter/material.dart';

class BasePlotPage extends StatelessWidget {
  const BasePlotPage({super.key});

  // Class to create the list of plot views
  @override
  Widget build(BuildContext context) {
    // This is used to pass the information on the number of channels and the plot type to this particular widget
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final numChannels = args['numChannels']; // get the number of channels
    final plotType = args['plotType']; // get the plot type

    // Create a list of graphs (of the correct plot type) with titles based on their index 
    final List<Widget> graphItems = List.generate(
      numChannels,
      (index) => GraphItem(number: index + 1, plotType: plotType)
    );

    // return a listview of the graphs
    return Scaffold(
      appBar: AppBar(title: Text("placeholder name")),
      body: ListView.builder(
        itemCount: numChannels,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: graphItems[index],
          );
        },
      )
    );
  }
}

class GraphItem extends StatelessWidget {
  final int number;
  final String plotType;

  const GraphItem({super.key, required this.number, required this.plotType});

  @override
  Widget build(BuildContext context) {
    // Get the graph title based on the index
    final String title = "Graph " + this.number.toString();
    
    if (plotType == 'live') {
      return Placeholder(); // Here the graph title would be used to create the live plot graph
    } else if (plotType == 'static') {
      return Placeholder(); // Here the graph title would be used to create the static plot graph
    } else {
      return Placeholder(); // Placeholder for error handling
    }
  }
}