// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'LoadBoard.dart';
import 'Validations.dart';

class Board extends StatefulWidget {
  const Board({Key? key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var temp;
  static List<String> deadBlackPieces = [], deadWhitePieces = [];
  int chkX = -1, chkY = -1;

  @override
  void initState() {
    super.initState();
    LoadBoard.resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                deadBlackPieces.join(''),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          Stack(
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
                          if(LoadBoard.player%2 == (LoadBoard.pieces[i][j][1] == Colors.black ? 0 : 1) || LoadBoard.isPieceSelected) {
                            if (LoadBoard.isPieceSelected) {
                              if (LoadBoard.moves[i][j] == 1) {
                                setState(() {
                                  swapPieces(i, j);
                                  if(!chkWinner()) {
                                    chkPawnPromotion(i, j);
                                  }
                                  castle(i, j);
                                  deadPieces(temp);
                                  LoadBoard.resetMoves();
                                  chkCheck();
                                  LoadBoard.player++;
                                });
                              }
                              setState(() {
                                LoadBoard.resetMoves();
                                LoadBoard.isPieceSelected = false;
                              });
                            } if(!LoadBoard.isPieceSelected){
                              Validations.findPossibleMoves(i, j);
                              setState(() {
                                LoadBoard.x = i;
                                LoadBoard.y = j;
                                LoadBoard.isPieceSelected = true;
                              });
                            }
                          }
                        },
                        child: Container(
                          color: (LoadBoard.moves[index~/8][index%8] == 1 && LoadBoard.pieces[index~/8][index%8][0] != '') || chkX == index~/8 && chkY == index%8 ? Colors.red.shade300 : LoadBoard.getSquereColor(index),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: LoadBoard.moves[index~/8][index%8] == 1 ? (min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24) / 24 : 0,
                                  width: LoadBoard.moves[index~/8][index%8] == 1 ? (min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - 24) / 24 : 0,
                                  decoration: BoxDecoration(
                                    color: LoadBoard.pieces[index~/8][index%8][0] != '' ? Colors.transparent : Colors.green,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  LoadBoard.pieces[index~/8][index%8][0],
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: LoadBoard.pieces[index~/8][index%8][1],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                deadWhitePieces.join(''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void chkPawnPromotion(int i, int j) {
    if (LoadBoard.pieces[i][j][0] == '♙' &&
        (i == 7 || i == 0)) {
      List<String> pieces = ['♜', '♞', '♝', '♛'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pawn Promotion !!!'),
            content: SizedBox(
              height: 240,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  4,
                      (index) {
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          LoadBoard.pieces[LoadBoard.x][LoadBoard.y][0] =
                          pieces[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        pieces[index],
                        style: TextStyle(
                          fontSize: 80,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void swapPieces(int i, int j) {
    temp = LoadBoard.pieces[i][j];
    LoadBoard.pieces[i][j] = LoadBoard.pieces[LoadBoard.x][LoadBoard.y];
    LoadBoard.pieces[LoadBoard.x][LoadBoard.y] =
    temp[0] == '' ? temp : ['', Colors.transparent];
  }

  void castle(int i, int j) {
    if (LoadBoard.pieces[i][j][0] == '♚' &&
        (LoadBoard.y - j == 2 || LoadBoard.y - j == -2)) {
      if (j == 2) {
        LoadBoard.pieces[i][0] = ['', Colors.transparent];
        LoadBoard.pieces[i][3] = ['♜', LoadBoard.pieces[i][j][1]];
      } else if (j == 6) {
        LoadBoard.pieces[i][7] = ['', Colors.transparent];
        LoadBoard.pieces[i][5] = ['♜', LoadBoard.pieces[i][j][1]];
      }
    }
    if (LoadBoard.x == 0 && LoadBoard.y == 0) {
      LoadBoard.isCastle[0] = false;
    } else if (LoadBoard.x == 0 && LoadBoard.y == 4) {
      LoadBoard.isCastle[1] = false;
    } else if (LoadBoard.x == 0 && LoadBoard.y == 7) {
      LoadBoard.isCastle[2] = false;
    } else if (LoadBoard.x == 7 && LoadBoard.y == 0) {
      LoadBoard.isCastle[3] = false;
    } else if (LoadBoard.x == 7 && LoadBoard.y == 4) {
      LoadBoard.isCastle[4] = false;
    } else if (LoadBoard.x == 7 && LoadBoard.y == 7) {
      LoadBoard.isCastle[5] = false;
    }
  }

  void deadPieces(var temp) {
    setState(() {
      if (temp[0] != '') {
        temp[1] == Colors.black ? deadBlackPieces.add(temp[0]) : deadWhitePieces.add(temp[0]);
        deadBlackPieces.sort((a, b) => b.compareTo(a));
        deadWhitePieces.sort();
      }
    });
  }

  bool chkWinner() {
    if (temp[0] == '♚') {
      String winner = temp[1] == Colors.black ? "White" : "Black";
      showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over'),
              content: Text('$winner Wins !!!'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      LoadBoard.resetBoard();
                      deadWhitePieces = [];
                      deadBlackPieces = [];
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'New Game',
                    style: TextStyle(
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ],
            );
          },
      );
      return true;
    }
    return false;
  }

  chkCheck() {
    chkX = -1;
    chkY = -1;
    Color playerColor = LoadBoard.player%2 == 0 ? Colors.black : Colors.white;
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        if(LoadBoard.pieces[i][j][1] == playerColor) {
          Validations.findPossibleMoves(i, j);
        }
      }
    }
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        if(LoadBoard.moves[i][j] == 1 && LoadBoard.pieces[i][j][0] == '♚') {
          setState(() {
            chkX = i;
            chkY = j;
          });
        }
      }
    }
  }
}
