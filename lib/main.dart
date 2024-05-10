import 'package:flutter/material.dart';
import 'Board.dart';

void main() {
  runApp( const SicillianDefence());
}

class SicillianDefence extends StatefulWidget {
  const SicillianDefence({super.key});

  @override
  State<SicillianDefence> createState() => _SicillianDefenceState();
}

class _SicillianDefenceState extends State<SicillianDefence> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blueGrey.shade100,
          onPrimary: Colors.blueGrey.shade100,
          secondary: Colors.blueGrey.shade100,
          onSecondary: Colors.blueGrey.shade100,
          error: Colors.blueGrey.shade900,
          onError: Colors.blueGrey.shade900,
          background: Colors.blueGrey.shade100,
          onBackground: Colors.blueGrey.shade100,
          surface: Colors.blueGrey.shade800,
          onSurface: Colors.blueGrey.shade900,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sicillian Defence',
          style: TextStyle(
            color: Colors.blueGrey.shade100,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Board(),),
                );
              },
              child: const SizedBox(
                width: 100,
                child: Center(child: Text('Play with AI')),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Board(),),
                );
              },
              child: const SizedBox(
                width: 100,
                child: Center(child: Text('Play with Player')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}