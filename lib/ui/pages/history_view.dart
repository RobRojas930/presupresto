import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text('Transacción ${index + 1}'),
            subtitle: const Text('Fecha y descripción'),
            trailing: const Text('\$0.00'),
          );
        },
      ),
    );
  }
}