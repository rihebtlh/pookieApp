import 'package:flutter/material.dart';
//BIG ERROR HERE
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gender Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GenderSelectionPage(),
    );
  }
}

class GenderSelectionPage extends StatelessWidget {
  const GenderSelectionPage({super.key});

  void _showSelection(BuildContext context, String gender) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You selected: $gender')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Gender'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showSelection(context, 'Boy'),
              child: const Text('Boy'),
            ),
            const SizedBox(height: 20), // Add some space between buttons
            ElevatedButton(
              onPressed: () => _showSelection(context, 'Girl'),
              child: const Text('Girl'),
            ),
          ],
        ),
      ),
    );
  }
}