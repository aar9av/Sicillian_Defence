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
  List<List<int>> moves = List.generate(8, (i) => List<int>.filled(8, 0));
  int x = -1, y = -1;
  bool isPieceSelected = false;
  int player = 0;
  List<String> deadWhitePieces = [], deadBlackPieces = [];

  @override
  void initState() {
    super.initState();
    resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                height: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
                width: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
                color: Colors.blueGrey.shade900,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          height: 12,
                          width: 12,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 12,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                String columnName = String.fromCharCode('A'.codeUnitAt(0) + index);
                                return Container(
                                  width: (min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24) / 8,
                                  height: 12,
                                  alignment: Alignment.center,
                                  child: Text(
                                    columnName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                String rowName = (8 - index).toString();
                                return Container(
                                  width: 12,
                                  height: (min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24) / 8,
                                  alignment: Alignment.center,
                                  child: Text(
                                    rowName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                String rowName = (8 - index).toString();
                                return Container(
                                  width: 12,
                                  height: (min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24) / 8,
                                  alignment: Alignment.center,
                                  child: Text(
                                    rowName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          height: 12,
                          width: 12,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 12,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                String columnName = String.fromCharCode('A'.codeUnitAt(0) + index);
                                return Container(
                                  width: (min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24) / 8,
                                  height: 12,
                                  alignment: Alignment.center,
                                  child: Text(
                                    columnName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                          width: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
                width: min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                      width: 12,
                    )
                ),
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 8,
                  children: List.generate(
                    64,
                        (index) {
                      return GestureDetector(
                        onTap: () {
                          int i = index~/8, j = index%8;
                          if(player%2 == (pieces[i][j][1] == Colors.black ? 0 : 1) || isPieceSelected) {
                            if (isPieceSelected) {
                              if (moves[i][j] == 1) {
                                setState(() {
                                  var temp = pieces[i][j];
                                  pieces[i][j] = pieces[x][y];
                                  pieces[x][y] = temp[0] == '' ? temp : ['', Colors.transparent];
                                  if(temp[0] != '') {
                                    temp[1] == Colors.black ? deadBlackPieces.add(temp[0]) : deadWhitePieces.add(temp[0]);
                                    deadWhitePieces.sort();
                                    deadBlackPieces.sort();
                                  }
                                  player++;
                                });
                              }
                              setState(() {
                                resetMoves();
                                isPieceSelected = false;
                              });
                            } if(!isPieceSelected){
                              findPossibleMoves(i, j);
                              setState(() {
                                x = i;
                                y = j;
                                isPieceSelected = true;
                              });
                            }
                          }
                        },
                        child: Container(
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getSquereColor(int index) {
    int i = index~/8, j = index%8;
    if(moves[i][j] == 1) {
      return pieces[i][j][0] != '' ? Colors.red : Colors.greenAccent;
    }
    if(i%2 == 0) {
      return j%2 == 1 ? Colors.blueGrey : Colors.blueGrey.shade100;
    } else {
      return j%2 == 0 ? Colors.blueGrey : Colors.blueGrey.shade100;
    }
  }

  void resetBoard() {
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        pieces[i][j] = [getPieceValue(i, j), getPieceColor(i)];
      }
    }
    player = 0;
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


  void findPossibleMoves(int i, int j) {
    if ((player % 2 == 0 && pieces[i][j][1] == Colors.white) ||
        (player % 2 == 1 && pieces[i][j][1] == Colors.black)) {
      return;
    }
    if(pieces[i][j][0] == '') {
      return;
    }
    if(pieces[i][j][0] == '♙') {
      findPossibleMovesPawn(i, j);
    }
    if(pieces[i][j][0] == '♜') {
      findPossibleMovesRook(i, j);
    }
    if(pieces[i][j][0] == '♞') {
      findPossibleMovesKnight(i, j);
    }
    if(pieces[i][j][0] == '♝') {
      findPossibleMovesBishop(i, j);
    }
    if(pieces[i][j][0] == '♚') {
      findPossibleMovesKing(i, j);
    }
    if(pieces[i][j][0] == '♛') {
      findPossibleMovesQueen(i, j);
    }
    return;
  }


  void findPossibleMovesPawn(int i, int j) {
    int chance = pieces[i][j][1] == Colors.black ? 1 : -1;
    if (isValidSquare(i + chance, j) && pieces[i + chance][j][0] == '') {
      updateMoveIfEmptyOrOpponent(i + chance, j, chance);
    }
    if ((i == 1 && chance == 1) || (i == 6 && chance == -1)) {
      if (isValidSquare(i + 2 * chance, j) && pieces[i + 2 * chance][j][0] == '') {
        updateMoveIfEmptyOrOpponent(i + 2*chance, j, chance);
      }
    }
    if (isValidSquare(i + chance, j + 1)) {
      if (pieces[i + chance][j + 1][0] != '') {
        updateMoveIfEmptyOrOpponent(i + chance, j + 1, chance);
      }
    }
    if (isValidSquare(i + chance, j - 1)) {
      if (pieces[i + chance][j - 1][0] != '') {
        updateMoveIfEmptyOrOpponent(i + chance, j - 1, chance);
      }
    }
  }

  void findPossibleMovesRook(int i, int j) {
    int x, chance = pieces[i][j][1] == Colors.black ? 1 : -1;
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

  void findPossibleMovesKnight(int i, int j) {
    int chance = pieces[i][j][1] == Colors.black ? 1 : -1;
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

  void findPossibleMovesBishop(int i, int j) {
    int chance = pieces[i][j][1] == Colors.black ? 1 : -1;
    List<List<int>> directions = [
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ];
    for (var dir in directions) {
      int dx = dir[0], dy = dir[1];
      int x = i + dx, y = j + dy;
      while (isValidSquare(x, y)) {
        if(updateMoveIfEmptyOrOpponent(x, y, chance)) {
          break;
        }
        x += dx;
        y += dy;
      }
    }
  }

  void findPossibleMovesQueen(int i, int j) {
    findPossibleMovesRook(i, j);
    findPossibleMovesBishop(i, j);
  }

  void findPossibleMovesKing(int i, int j) {
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        int ni = i + dx;
        int nj = j + dy;
        if (isValidSquare(ni, nj)) {
          if (pieces[ni][nj][0] == '' || (pieces[ni][nj][1] != pieces[i][j][1] && pieces[ni][nj][0] != '♚')) {
            moves[ni][nj] = 1;
          }
        }
      }
    }
  }


  bool updateMoveIfEmptyOrOpponent(int i, int j, int chance) {
    if (pieces[i][j][0] == '') {
      moves[i][j] = 1;
      return false;
    } else {
      int oppositePieceChance = pieces[i][j][1] == Colors.black ? 1 : -1;
      if (chance + oppositePieceChance == 0) {
        moves[i][j] = 1;
      }
      return true;
    }
  }

  bool isValidSquare(int i, int j) {
    if(i<0 || i>=8) {
      return false;
    }
    if(j<0 || j>=8) {
      return false;
    }
    return true;
  }


  void resetMoves() {
    for(int i=0; i<8; ++i) {
      moves[i] = [0, 0, 0, 0, 0, 0, 0, 0];
    }
  }

}
