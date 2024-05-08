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
                      if(LoadBoard.pieces[LoadBoard.x][LoadBoard.y][0] == '♙' && (i == 7 || i == 0)) {
                        showPawnPromotionDialog();
                      }
                      var temp = LoadBoard.pieces[i][j];
                      LoadBoard.pieces[i][j] = LoadBoard.pieces[LoadBoard.x][LoadBoard.y];
                      LoadBoard.pieces[LoadBoard.x][LoadBoard.y] = temp[0] == '' ? temp : ['', Colors.transparent];
                      if(temp[0] != '') {
                        temp[1] == Colors.black ? LoadBoard.deadBlackPieces.add(temp[0]) : LoadBoard.deadWhitePieces.add(temp[0]);
                        LoadBoard.deadWhitePieces.sort();
                        LoadBoard.deadBlackPieces.sort();
                      }
                      if (temp[0] == '♚') {
                        String winner = temp[1] == Colors.black ? "White" : "Black";
                        showWinnerDialog('$winner Wins !!!');
                      }
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

  showWinnerDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(text),
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

  showPawnPromotionDialog() {
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
