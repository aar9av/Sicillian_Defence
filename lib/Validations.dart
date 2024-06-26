import 'package:flutter/material.dart';
import 'LoadBoard.dart';

class Validations {
  static void findPossibleMoves(int i, int j) {
    if ((LoadBoard.player % 2 == 0 &&
        LoadBoard.pieces[i][j][1] == Colors.white) ||
        (LoadBoard.player % 2 == 1 &&
            LoadBoard.pieces[i][j][1] == Colors.black)) {
      return;
    }
    if (LoadBoard.pieces[i][j][0] == '') {
      return;
    }
    if (LoadBoard.pieces[i][j][0] == '♙') {
      findPossibleMovesPawn(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♜') {
      findPossibleMovesRook(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♞') {
      findPossibleMovesKnight(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♝') {
      findPossibleMovesBishop(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♚') {
      findPossibleMovesKing(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♛') {
      findPossibleMovesQueen(i, j);
    }
    chkForKingCheck(i, j);
  }

  static void findPossibleMovesPawn(int i, int j) {
    int chance = LoadBoard.pieces[i][j][1] == Colors.black ? 1 : -1;
    if (isValidSquare(i + chance, j) &&
        LoadBoard.pieces[i + chance][j][0] == '') {
      updateMoveIfEmptyOrOpponent(i + chance, j, chance);
    }
    if ((i == 1 && chance == 1) || (i == 6 && chance == -1)) {
      if (isValidSquare(i + 2 * chance, j) &&
          LoadBoard.pieces[i + 2 * chance][j][0] == '' &&
          LoadBoard.pieces[i + chance][j][0] == '') {
        updateMoveIfEmptyOrOpponent(i + 2 * chance, j, chance);
      }
    }
    if (isValidSquare(i + chance, j + 1)) {
      if (LoadBoard.pieces[i + chance][j + 1][0] != '') {
        updateMoveIfEmptyOrOpponent(i + chance, j + 1, chance);
      }
    }
    if (isValidSquare(i + chance, j - 1)) {
      if (LoadBoard.pieces[i + chance][j - 1][0] != '') {
        updateMoveIfEmptyOrOpponent(i + chance, j - 1, chance);
      }
    }
  }

  static void findPossibleMovesRook(int i, int j) {
    int x,
        chance = LoadBoard.pieces[i][j][1] == Colors.black ? 1 : -1;
    for (x = i - 1; isValidSquare(x, j); --x) {
      if (updateMoveIfEmptyOrOpponent(x, j, chance)) break;
    }
    for (x = i + 1; isValidSquare(x, j); ++x) {
      if (updateMoveIfEmptyOrOpponent(x, j, chance)) break;
    }
    for (x = j - 1; isValidSquare(i, x); --x) {
      if (updateMoveIfEmptyOrOpponent(i, x, chance)) break;
    }
    for (x = j + 1; isValidSquare(i, x); ++x) {
      if (updateMoveIfEmptyOrOpponent(i, x, chance)) break;
    }
  }

  static void findPossibleMovesKnight(int i, int j) {
    int chance = LoadBoard.pieces[i][j][1] == Colors.black ? 1 : -1;
    List<List<int>> knightMoves = [
      [i - 2, j - 1], [i - 2, j + 1], [i - 1, j - 2], [i - 1, j + 2],
      [i + 1, j - 2], [i + 1, j + 2], [i + 2, j - 1], [i + 2, j + 1]
    ];
    for (var move in knightMoves) {
      if (isValidSquare(move[0], move[1])) {
        updateMoveIfEmptyOrOpponent(move[0], move[1], chance);
      }
    }
  }

  static void findPossibleMovesBishop(int i, int j) {
    int chance = LoadBoard.pieces[i][j][1] == Colors.black ? 1 : -1;
    List<List<int>> directions = [
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ];
    for (var dir in directions) {
      int dx = dir[0],
          dy = dir[1];
      int x = i + dx,
          y = j + dy;
      while (isValidSquare(x, y)) {
        if (updateMoveIfEmptyOrOpponent(x, y, chance)) {
          break;
        }
        x += dx;
        y += dy;
      }
    }
  }

  static void findPossibleMovesQueen(int i, int j) {
    findPossibleMovesRook(i, j);
    findPossibleMovesBishop(i, j);
  }

  static void findPossibleMovesKing(int i, int j) {
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        int ni = i + dx;
        int nj = j + dy;
        if (isValidSquare(ni, nj)) {
          if (LoadBoard.pieces[ni][nj][0] == '' ||
              (LoadBoard.pieces[ni][nj][1] != LoadBoard.pieces[i][j][1] &&
                  LoadBoard.pieces[ni][nj][0] != '♚')) {
            LoadBoard.moves[ni][nj] = 1;
          }
        }
      }
    }
    if (LoadBoard.isCastle[1] && LoadBoard.isCastle[0] &&
        LoadBoard.pieces[0][1][0] == '' && LoadBoard.pieces[0][2][0] == '' &&
        LoadBoard.pieces[0][3][0] == '' &&
        LoadBoard.pieces[i][j][1] == Colors.black) {
      LoadBoard.moves[0][2] = 1;
    } else if (LoadBoard.isCastle[1] && LoadBoard.isCastle[2] &&
        LoadBoard.pieces[0][5][0] == '' && LoadBoard.pieces[0][6][0] == '' &&
        LoadBoard.pieces[i][j][1] == Colors.black) {
      LoadBoard.moves[0][6] = 1;
    } else if (LoadBoard.isCastle[4] && LoadBoard.isCastle[3] &&
        LoadBoard.pieces[7][1][0] == '' && LoadBoard.pieces[7][2][0] == '' &&
        LoadBoard.pieces[7][3][0] == '' &&
        LoadBoard.pieces[i][j][1] == Colors.white) {
      LoadBoard.moves[7][2] = 1;
    } else if (LoadBoard.isCastle[4] && LoadBoard.isCastle[5] &&
        LoadBoard.pieces[7][5][0] == '' && LoadBoard.pieces[7][6][0] == '' &&
        LoadBoard.pieces[i][j][1] == Colors.white) {
      LoadBoard.moves[7][6] = 1;
    }
  }

  static bool isValidSquare(int i, int j) {
    if (i < 0 || i >= 8) {
      return false;
    }
    if (j < 0 || j >= 8) {
      return false;
    }
    return true;
  }

  static bool updateMoveIfEmptyOrOpponent(int i, int j, int chance) {
    if (LoadBoard.pieces[i][j][0] == '') {
      LoadBoard.moves[i][j] = 1;
      return false;
    } else {
      int oppositePieceChance = LoadBoard.pieces[i][j][1] == Colors.black
          ? 1
          : -1;
      if (chance + oppositePieceChance == 0) {
        LoadBoard.moves[i][j] = 1;
      }
      return true;
    }
  }

  static void chkForKingCheck(int i, int j) {
    List<List<int>> temp = [];
    for(int x=0; x<8; ++x) {
      List<int> t = [];
      for(int y=0; y<8; ++y) {
        t.add(LoadBoard.moves[x][y]);
      }
      temp.add(t);
    }
    for (int x = 0; x < 8; ++x) {
      for (int y = 0; y < 8; ++y) {
        if (temp[x][y] == 1) {
          LoadBoard.resetMoves();
          var t = LoadBoard.pieces[x][y];
          LoadBoard.pieces[x][y] = LoadBoard.pieces[i][j];
          LoadBoard.pieces[i][j] = ['', Colors.transparent];
          if (isKingInCheck(LoadBoard.player % 2 == 0 ? Colors.black : Colors.white)) {
            temp[x][y] = 0;
          }
          LoadBoard.pieces[i][j] = LoadBoard.pieces[x][y];
          LoadBoard.pieces[x][y] = t;
        }
      }
    }
    LoadBoard.moves = temp;
  }

  static bool isKingInCheck(Color kingColor) {
    int x = -1, y = -1;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (LoadBoard.pieces[i][j][0] == '♚' && LoadBoard.pieces[i][j][1] == kingColor) {
          x = i;
          y = j;
          break;
        }
      }
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (LoadBoard.pieces[i][j][0] != '' && LoadBoard.pieces[i][j][1] != kingColor) {
          canPieceAttackPosition(i, j);
        }
      }
    }
    if (LoadBoard.moves[x][y] == 1) {
      return true;
    }
    return false;
  }

  static void canPieceAttackPosition(int i, int j) {
    if (LoadBoard.pieces[i][j][0] == '♙') {
      findPossibleMovesPawn(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♜') {
      findPossibleMovesRook(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♞') {
      findPossibleMovesKnight(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♝') {
      findPossibleMovesBishop(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♚') {
      findPossibleMovesKing(i, j);
    }
    if (LoadBoard.pieces[i][j][0] == '♛') {
      findPossibleMovesQueen(i, j);
    }
  }
}