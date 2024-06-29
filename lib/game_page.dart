import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const games = [
      "Spin the Wheel",
      "Scratch Card",
      "Memory Game",
      "Puzzle Game"
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
                      onTap: () {},
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
