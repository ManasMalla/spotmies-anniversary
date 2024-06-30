import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class GamePage extends StatelessWidget {
  GamePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const games = ["Spin the Wheel", "Memory Game", "Puzzle Game"];
    const spinWheel = [
      "Proud",
      "Scariest",
      "Sad",
      "Funniest",
      "Most Embarrasing",
      "Most Challenging",
      "Most Adventurous",
      "Most Learning",
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to our 4th Anniversary Celebration!',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24,
              ),
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: games.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, itemIndex) {
                    return InkWell(
                      onTap: () {
                        if (itemIndex == 0) {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                StreamController<int> controller =
                                    StreamController<int>();
                                return Builder(builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Spin the Wheel',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                            "Spin the wheel to know your fortune!"),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.add(Random()
                                                .nextInt(spinWheel.length - 1));
                                          },
                                          child: Text('Spin the Wheel'),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Container(
                                          height: 300,
                                          child: FortuneWheel(
                                            selected: controller.stream,
                                            items: spinWheel
                                                .map((e) =>
                                                    FortuneItem(child: Text(e)))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              });
                          // Navigator.pushNamed(context, '/spinWheel', arguments: spinWheel);
                        } else if (itemIndex == 1) {
                          // Navigator.pushNamed(context, '/memoryGame');
                        } else if (itemIndex == 2) {
                          // Navigator.pushNamed(context, '/puzzleGame');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text(games[itemIndex])),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
