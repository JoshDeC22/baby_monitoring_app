// base_plot_page.dart (Modified to use GraphItem)
import 'package:flutter/material.dart';
import '../widgets/graph_item.dart';

class BasePlotPage extends StatelessWidget {
  const BasePlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final numChannels = args['numChannels'];
    final plotType = args['plotType'];

    return Scaffold(
      appBar: AppBar(title: const Text('Base Plot Page')),
      body: ListView.builder(
        itemCount: numChannels,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GraphItem(
              number: index + 1,
              plotType: plotType,
            ),
          );
        },
      ),
    );
  }
}
