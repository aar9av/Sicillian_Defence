import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const Board());
}

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<dynamic>> pieces = List.generate(8, (index) => List.generate(8, (index) => []));

  @override
  Widget build(BuildContext context) {
    resetBoard();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            height: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
            width: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueGrey.shade900,
                width: 12,
              )
            ),
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 8,
              children: List.generate(
                64,
                    (index) {
                  return Container(
                    color: getSquereColor(index),
                    child: Center(
                      child: Text(
                        pieces[index~/8][index%8][0],
                        style: TextStyle(
                          fontSize: 40,
                          color: pieces[index~/8][index%8][1],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getSquereColor(int index) {
    int i = index~/8, j = index%8;
    if(i%2 == 0) {
      return j%2 == 0 ? Colors.blueGrey : Colors.blueGrey.shade100;
    } else {
      return j%2 == 1 ? Colors.blueGrey : Colors.blueGrey.shade100;
    }
  }

  void resetBoard() {
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        pieces[i][j] = [getPieceValue(i, j), getPieceColor(i)];
      }
    }
  }

  String getPieceValue(int i, int j) {
    if ((i == 0 || i == 7) && (j == 0 || j == 7)) {
      return '♜';
    } else if ((i == 0 || i == 7) && (j == 1 || j == 6)) {
      return '♞';
    } else if ((i == 0 || i == 7) && (j == 2 || j == 5)) {
      return '♝';
    } else if ((i == 0 && j == 3) || (i == 7 && j == 3)) {
      return '♛';
    } else if ((i == 0 && j == 4) || (i == 7 && j == 4)) {
      return '♚';
    } else if (i == 1 || i == 6) {
      return '♙';
    }
    return '';
  }

  Color getPieceColor(int i) {
    if(i==0 || i==1) {
      return Colors.black;
    }
    if(i==6 || i==7) {
      return Colors.white;
    }
    return Colors.transparent;
  }
}
