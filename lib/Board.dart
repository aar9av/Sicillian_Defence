import 'dart:math';

import 'package:flutter/material.dart';
import 'Game.dart';

class Board extends StatelessWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: const Game(),
            ),
          ],
        ),
      ),
    );
  }
}
