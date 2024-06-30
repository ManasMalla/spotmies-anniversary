import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class GamePage extends StatelessWidget {
  GamePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const games = ["Spin the Wheel", "CaptionIt", "Slido", "Feedback"];
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
                          showSpinWheelGame(context, spinWheel);
                        } else if (itemIndex == 1) {
                          showCaptionItGame();
                          // Navigator.pushNamed(context, '/memoryGame');
                        } else if (itemIndex == 3) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController();
                                return Builder(builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Feedback",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                        Text(
                                          "Please provide your honest feedback here.\nYour responses will be anonymous.",
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        TextField(
                                          controller: controller,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Enter your feedback here",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("spotmies")
                                                .doc(FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                    "anonymous-user")
                                                .set({
                                              "feedback": controller.text
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text("Submit"),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              });
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

  Future<dynamic> showSpinWheelGame(
      BuildContext context, List<String> spinWheel) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          StreamController<int> controller = StreamController<int>();
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
                  Text("Spin the wheel to know your fortune!"),
                  SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.add(Random().nextInt(spinWheel.length - 1));
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
                          .map((e) => FortuneItem(child: Text(e)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void showCaptionItGame() {}
}
