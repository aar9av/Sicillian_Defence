import 'package:flutter/material.dart';

class LoadBoard {
  static List<List<dynamic>> pieces = List.generate(8, (index) => List.generate(8, (index) => []));
  static List<List<int>> moves = List.generate(8, (i) => List<int>.filled(8, 0));
  static int x = -1, y = -1;
  static bool isPieceSelected = false;
  static int player = 0;
  static List<String> deadWhitePieces = [], deadBlackPieces = [];
  static List<bool> isCastle = List.generate(6, (index) => true);

  static Color getSquereColor(int index) {
    int i = index~/8, j = index%8;
    if(i%2 == 0) {
      return j%2 == 1 ? Colors.blueGrey : Colors.blueGrey.shade100;
    } else {
      return j%2 == 0 ? Colors.blueGrey : Colors.blueGrey.shade100;
    }
  }

  static String getPieceValue(int i, int j) {
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

  static Color getPieceColor(int i) {
    if(i==0 || i==1) {
      return Colors.black;
    }
    if(i==6 || i==7) {
      return Colors.white;
    }
    return Colors.transparent;
  }

  static void resetBoard() {
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        pieces[i][j] = [getPieceValue(i, j), getPieceColor(i)];
      }
    }
    resetMoves();
    x = -1;
    y = -1;
    isPieceSelected = false;
    player = 0;
    deadWhitePieces = [];
    deadBlackPieces = [];
    isCastle = List.generate(6, (index) => true);
  }

  static void resetMoves() {
    for(int i=0; i<8; ++i) {
      moves[i] = [0, 0, 0, 0, 0, 0, 0, 0];
    }
  }
}