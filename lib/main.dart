import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pookie/pages/auth_page.dart';
import 'package:pookie/pages/start.dart';
import 'package:pookie/pages/user_profile.dart';
import 'package:pookie/theme/themeProvider.dart';
import 'package:provider/provider.dart';

void main() async{
  //ensures that the bindings with the native platform has been created 
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDOlix5yuN9DiX9cV64SCbCrgbghD2pO2Y",
        authDomain: "pookierih.firebaseapp.com",
        projectId: "pookierih",
        storageBucket: "pookierih.firebasestorage.app",
        messagingSenderId: "296857543204",
        appId: "1:296857543204:web:072b2d1a588bb223bbeeb1"
      )
    );
  }else {
    await Firebase.initializeApp();
  }
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => UserProfileProvider()),
    ],
    child: const MyApp(),
  )
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clouds App',
      /*theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,*/
      theme: themeProvider.currentTheme,
      home: const Start(),
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
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Hi:'),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: navigateToLogin,
              child: const Text('Go to Login Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}