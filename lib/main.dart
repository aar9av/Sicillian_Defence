import 'package:flutter/material.dart';

import 'Board.dart';

void main() {
  runApp(const SicillianDefence());
}

class SicillianDefence extends StatefulWidget {
  const SicillianDefence({super.key});

  @override
  State<SicillianDefence> createState() => _SicillianDefenceState();
}

class _SicillianDefenceState extends State<SicillianDefence> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Board(),
    );
  }
}