// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'LoadBoard.dart';
import 'Validations.dart';

class Board extends StatefulWidget {
  final bool isAI;

  const Board({Key? key, required this.isAI});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool isLoading = true;
  var temp;
  List<String> deadBlackPieces = [], deadWhitePieces = [];
  int chkX = -1, chkY = -1;
  String op = 'HELLO';
  final gemini = Gemini.instance;

  @override
  void initState() {
    super.initState();
    LoadBoard.resetBoard();
    if(widget.isAI) {
      trainAI();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isAI) {
      setState(() {
        isLoading = false;
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.blueGrey.shade100,
          ),
          isLoading ?
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
          ) :
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: widget.isAI == true ? null : 0,
                  child: Center(
                    child: Text(
                      op,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    deadBlackPieces.join(' '),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
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
                            onTap: () async {
                              int i = index~/8, j = index%8;
                              if (widget.isAI) {
                                if (LoadBoard.isPieceSelected) {
                                  if (LoadBoard.moves[i][j] == 1) {
                                    setState(() {
                                      swapPieces(i, j);
                                      if (!chkWinner()) {
                                        chkPawnPromotion(i, j);
                                      }
                                      castle(i, j);
                                      deadPieces(temp);
                                      chkCheck();
                                      LoadBoard.resetMoves();
                                      LoadBoard.player++;
                                    });
                                    String move = await callAI(String.fromCharCode(LoadBoard.y + 97) + String.fromCharCode(56 - LoadBoard.x) + String.fromCharCode(j + 97) + String.fromCharCode(56 - i), false);
                                    setState(() {
                                      op = move;
                                    });
                                    while(isUnvalidMove(move)) {
                                      move = await callAI(move, true);
                                      setState(() {
                                        op = move;
                                      });
                                    }
                                    setState(() {
                                      changeMoveToIndex(move);
                                      if (!chkWinner()) {
                                        chkPawnPromotion(i, j);
                                      }
                                      castle(i, j);
                                      deadPieces(temp);
                                      chkCheck();
                                      LoadBoard.resetMoves();
                                      LoadBoard.player++;
                                    });
                                  }
                                  LoadBoard.isPieceSelected = false;
                                } else {
                                  Validations.findPossibleMoves(i, j);
                                  setState(() {
                                    LoadBoard.x = i;
                                    LoadBoard.y = j;
                                    LoadBoard.isPieceSelected = true;
                                  });
                                }
                              } else {
                                if (LoadBoard.player % 2 ==
                                    (LoadBoard.pieces[i][j][1] == Colors.black
                                        ? 0
                                        : 1) || LoadBoard.isPieceSelected) {
                                    if (LoadBoard.moves[i][j] == 1) {
                                      setState(() {
                                        swapPieces(i, j);
                                        if (!chkWinner()) {
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
                                      Validations.findPossibleMoves(i, j);
                                      setState(() {
                                        LoadBoard.x = i;
                                        LoadBoard.y = j;
                                        LoadBoard.isPieceSelected = true;
                                      });
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
                margin: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    deadWhitePieces.join(' '),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert !!!'),
                content: const Text('Are you sure you want to reset the game?'),
                backgroundColor: Colors.blueGrey.shade100,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        LoadBoard.resetBoard();
                        deadWhitePieces = [];
                        deadBlackPieces = [];
                        chkX = -1;
                        chkY = -1;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'New Game',
                      style: TextStyle(
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blueGrey.shade700,
        child: const Icon(Icons.refresh),
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
            backgroundColor: Colors.blueGrey.shade100,
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
                          LoadBoard.pieces[i][j][0] =
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
    LoadBoard.resetMoves();
    Color player = LoadBoard.player%2==1 ? Colors.black : Colors.white;
    LoadBoard.player++;
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        if(LoadBoard.pieces[i][j][1] == player) {
          Validations.findPossibleMoves(i, j);
        }
      }
    }
    int sum = 0;
    for(int i=0; i<8; ++i) {
      for(int j=0; j<8; ++j) {
        sum += LoadBoard.moves[i][j];
      }
    }
    LoadBoard.player--;
    if (sum == 0) {
      String winner = LoadBoard.player%2 == 1 ? "White" : "Black";
      showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over'),
              content: Text('$winner Wins !!!'),
              backgroundColor: Colors.blueGrey.shade100,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    LoadBoard.resetBoard();
                    LoadBoard.resetMoves();
                    setState(() {});
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
          Validations.canPieceAttackPosition(i, j);
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

  // AI

  void trainAI() {
    gemini.streamGenerateContent('Lets play a chess game. Always make your move like "e7e5" as black. Wait for my opening move. Print "YES" if you understand well.')
        .listen((value) {
      setState(() {
        op = value.output!;
        isLoading = false;
      });
    }).onError((e) {
      const SnackBar(content: Text('Unable to connect to network.\n Please try again after some time.'),duration: Durations.long1,);
      final snackBar = SnackBar(
        content: Text(
            'Unable to connect to network !!!\nPlease try again after some time.',
          style: TextStyle(
            color: Colors.blueGrey.shade100,
          ),
        ),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    });
  }

  Future<String> callAI(String move, bool isUnvalid) async {
    Completer<String> completer = Completer<String>();
    String prompt = "Can you analyse ${LoadBoard.pieces} the current board state and make a valid move as black according to the current position of all chess pieces and print the output in 'x1y2' like format.";
    gemini.streamGenerateContent(prompt)
        .listen((value) {
      completer.complete(value.output);
    }, onError: (e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  changeMoveToIndex(String move) {
    setState(() {
      LoadBoard.x = 56 - move.codeUnitAt(1);
      LoadBoard.y = move.codeUnitAt(0) - 97;
      swapPieces(56 - move.codeUnitAt(3), move.codeUnitAt(2) - 97);
    });
  }

  bool isUnvalidMove(String move) {
    if(move.toString().length != 4) {
      return true;
    }
    if(move.codeUnitAt(0) < 97 || move.codeUnitAt(0) > 104) {
      return true;
    }
    if(move.codeUnitAt(1) < 49 || move.codeUnitAt(1) > 56) {
      return true;
    }
    if(move.codeUnitAt(2) < 97 || move.codeUnitAt(2) > 104) {
      return true;
    }
    if(move.codeUnitAt(3) < 49 || move.codeUnitAt(3) > 56) {
      return true;
    }
    LoadBoard.resetMoves();
    Validations.findPossibleMoves(56 - move.codeUnitAt(1), move.codeUnitAt(0) - 97);
    if(LoadBoard.moves[56 - move.codeUnitAt(3)][move.codeUnitAt(2) - 97] != 1) {
      return true;
    }
    LoadBoard.resetMoves();
    return false;
  }
}
