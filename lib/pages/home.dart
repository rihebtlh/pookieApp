import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pookie/askPookie/chat_Bot.dart';
import 'package:pookie/pages/learn_Lang.dart';
import 'package:pookie/pages/storytelling.dart';
import 'package:pookie/theme/boy.dart';
import 'package:pookie/theme/themeProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  // Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(
  backgroundColor: Theme.of(context).primaryColor, // Full color background
  child: Stack(
    children: [
      ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              'Pookie',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),//AccountScreen()
              );
            },//AccountScreen
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: signUserOut,
          ),
          const SizedBox(height: 20), // Adds space after the logout button
          // Theme switch
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0), // Adds space from the left
                child: Text(
                  'Theme',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(width: 10), // Space between text and switch
              Switch(
                value: themeProvider.currentTheme == boyTheme,
                onChanged: (bool isBoyTheme) {
                  themeProvider.toggleTheme(isBoyTheme);
                },
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveThumbColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Theme.of(context).colorScheme.secondary, 
              ),
            ],
          ),
        ],
      ),
      Positioned(
        top: 95, // Adjust as needed
        right: 50,
        child: Image.asset(
          'assets/cat1.png',
          width: 100,
          height: 100,
        ),
      ),
    ],
  ),
)
,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              themeProvider.currentTheme == boyTheme ? 'assets/boy_bg.png' : 'assets/girl_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 30),
              onPressed: signUserOut,
              tooltip: "Logout",
            ),
          ),
          Positioned(
  top: 40,
  left: 20,
  child: Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.secondary, size: 30),
      onPressed: () => Scaffold.of(context).openDrawer(),
    ),
  ),
),

          /*ElevatedButton(
            onPressed: () {
              themeProvider.toggleTheme(themeProvider.currentTheme == boyTheme ? false : true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text(
              "Switch Theme",
              style: TextStyle(color: Colors.white),
            ),
          ),*/

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton('Ask Pookie',
                Theme.of(context).primaryColor,
                 () {
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => const AskPage()),
                    MaterialPageRoute(builder: (context) => const ChatBotPage()),
                  );
                }),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSmallButton('Storytelling', Theme.of(context).colorScheme.secondary, () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TextCorrectionScreen()),
                  );
                    }),
                    const SizedBox(width: 25),
                    buildSmallButton('Learn Languages', Theme.of(context).colorScheme.primary, () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnPage()),
                  );
                    }),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Colors.white.withOpacity(0.5),
              animationDuration: const Duration(milliseconds: 300),
              items: const [
                Icon(Icons.home, color: Colors.black),
                Icon(Icons.settings, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 350,
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSmallButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 160,
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
