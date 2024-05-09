// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';
import 'package:flutter/material.dart';
import 'LoadBoard.dart';
import 'Validations.dart';

class Game extends StatefulWidget{
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  var temp;

  @override
  void initState() {
    super.initState();
    LoadBoard.resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
                      chkPawnPromotion(i);
                      swapPieces(i, j);
                      castle(i, j);
                      deadPieces();
                      chkWinner();
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
              color: LoadBoard.moves[index~/8][index%8] == 1 && LoadBoard.pieces[index~/8][index%8][0] != '' ? Colors.red.shade300 : LoadBoard.getSquereColor(index),
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
    );
  }

  void chkPawnPromotion(int i) {
    if(LoadBoard.pieces[LoadBoard.x][LoadBoard.y][0] == '♙' && (i == 7 || i == 0)) {
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
                          LoadBoard.pieces[LoadBoard.x][LoadBoard.y][0] = pieces[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        pieces[index],
                        style: const TextStyle(
                          fontSize: 80,
                          color: Colors.black,
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
    LoadBoard.pieces[LoadBoard.x][LoadBoard.y] = temp[0] == '' ? temp : ['', Colors.transparent];
  }

  void castle(int i, int j) {
    if(LoadBoard.pieces[i][j][0] == '♚' && (LoadBoard.y - j == 2 || LoadBoard.y - j == -2)) {
      if(j == 2) {
        LoadBoard.pieces[i][0] = ['', Colors.transparent];
        LoadBoard.pieces[i][3] = ['♜', LoadBoard.pieces[i][j][1]];
      } else if (j == 6) {
        LoadBoard.pieces[i][7] = ['', Colors.transparent];
        LoadBoard.pieces[i][5] = ['♜', LoadBoard.pieces[i][j][1]];
      }
    }
    if(LoadBoard.x == 0 && LoadBoard.y == 0) {
      LoadBoard.isCastle[0] = false;
    } else if(LoadBoard.x == 0 && LoadBoard.y == 4) {
      LoadBoard.isCastle[1] = false;
    } else if(LoadBoard.x == 0 && LoadBoard.y == 7) {
      LoadBoard.isCastle[2] = false;
    } else if(LoadBoard.x == 7 && LoadBoard.y == 0) {
      LoadBoard.isCastle[3] = false;
    } else if(LoadBoard.x == 7 && LoadBoard.y == 4) {
      LoadBoard.isCastle[4] = false;
    } else if(LoadBoard.x == 7 && LoadBoard.y == 7) {
      LoadBoard.isCastle[5] = false;
    }
  }

  void deadPieces() {
    if(temp[0] != '') {
      temp[1] == Colors.black ? LoadBoard.deadBlackPieces.add(temp[0]) : LoadBoard.deadWhitePieces.add(temp[0]);
      LoadBoard.deadWhitePieces.sort();
      LoadBoard.deadBlackPieces.sort();
    }
  }

  void chkWinner() {
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
                  });
                  Navigator.pop(context);
                },
                child: const Text('New Game'),),
            ],
          );
        },
      );
    }
  }
}
