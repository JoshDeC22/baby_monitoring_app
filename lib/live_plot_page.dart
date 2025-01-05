import 'package:flutter/material.dart';

class LivePlotPage extends StatelessWidget {
  const LivePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Data Plot')),
      body: Column(
        children: [
          Expanded(child: GraphCard(graphTitle: 'Graph 1')),
          Expanded(child: GraphCard(graphTitle: 'Graph 2')),
          Expanded(child: GraphCard(graphTitle: 'Graph 3')),
        ],
      ),
    );
  }
}

class GraphCard extends StatelessWidget {
  final String graphTitle;

  const GraphCard({super.key, required this.graphTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(graphTitle),
            trailing: IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpandedGraphPage(graphTitle: graphTitle),
                  ),
                );
              },
            ),
          ),
          const Expanded(
            child: Placeholder(), // Replace with actual graph widget later
          ),
        ],
      ),
    );
  }
}

class ExpandedGraphPage extends StatelessWidget {
  final String graphTitle;

  const ExpandedGraphPage({super.key, required this.graphTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(graphTitle)),
      body: const Center(
        child: Placeholder(), // Placeholder for full-screen graph
      ),
    );
  }
}
