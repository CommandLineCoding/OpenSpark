import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.validate(); // ensure keys

  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // main -- router etc
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenSpark',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
      ),
      home: const MyHomePage(title: 'OpenSpark'),
      // other pages to be added;
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Suman Biswas is here'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
