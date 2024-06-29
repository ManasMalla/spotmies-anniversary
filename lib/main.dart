import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_anniversary/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Nusar"),
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          var isPortrait = constraints.maxHeight > constraints.maxWidth;
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/${isPortrait ? "background_potrait" : "background"}.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SpotmiesKalkiLogo(
                isMobile: isPortrait,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SpotmiesKalkiLogo extends StatefulWidget {
  final bool isMobile;
  const SpotmiesKalkiLogo({
    super.key,
    this.isMobile = true,
  });

  @override
  State<SpotmiesKalkiLogo> createState() => _SpotmiesKalkiLogoState();
}

class _SpotmiesKalkiLogoState extends State<SpotmiesKalkiLogo> {
  var title = '';
  var index = 0;
  var isTimelineVisible = false;
  final hindiLetters = [
    'क',
    'ख',
    'ग',
    'घ',
    'ङ',
    'च',
    'छ',
    'ज',
    'झ',
    'ञ',
    'ट',
    'ठ',
    'ड',
    'ढ',
    'ण',
    'त',
    'थ',
    'द',
    'ध',
    'न',
    'प',
    'फ',
    'ब',
    'भ',
    'म',
    'य',
    'र',
    'ल',
    'व',
    'श',
    'ष',
    'स',
    'ह',
    'ळ',
    'क',
    'ष',
    'ज्',
    'ञ'
  ];
  var showTextField = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer.periodic(Duration(milliseconds: 250), (timer) {
        if (index == 32) {
          timer.cancel();
          setState(() {
            isTimelineVisible = true;
          });
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              showTextField = true;
            });
          });
          return;
        } else {
          if (index % 4 == 3) {
            setState(() {
              updateTitle("Spotmies"[(index / 4).floor()]);
              index++;
            });
          } else if (index % 4 == 0) {
            setState(() {
              title += hindiLetters[Random().nextInt(36)];
              index++;
            });
          } else {
            setState(() {
              updateTitle(hindiLetters[Random().nextInt(36)]);
              index++;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title.toUpperCase(),
          style: (!widget.isMobile
                  ? Theme.of(context).textTheme.headlineLarge
                  : Theme.of(context).textTheme.titleLarge)
              ?.copyWith(
                  fontFamily: "Nusar",
                  letterSpacing: widget.isMobile ? 15 : 24,
                  color: Color(0xFFf1672e)),
        ),
        Text(
          isTimelineVisible ? '2019AD' : "",
          style: (!widget.isMobile
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.bodyMedium)
              ?.copyWith(
            fontFamily: "Nusar",
            letterSpacing: widget.isMobile ? 10 : 20,
            color: Color(
              0xFFff9955,
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        AnimatedCrossFade(
          firstChild: SizedBox(),
          secondChild: Padding(
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 12.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.orange,
                  onSurface: Colors.white,
                ),
              ),
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.white,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your nickname',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.5),
                      ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          crossFadeState: showTextField
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 500),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox(),
          secondChild: Padding(
            padding: const EdgeInsets.all(24.0).copyWith(top: 0),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.orange,
                  onSurface: Colors.white,
                ),
              ),
              child: TextField(
                onSubmitted: (email) {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter your nickname'),
                      ),
                    );
                    return;
                  }
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter your email'),
                      ),
                    );
                  }
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: "SPOTMIESINTERN")
                      .then((value) {
                    value.user?.updateDisplayName(_nameController.text);
                    goToGamePage();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User created successfully'),
                      ),
                    );
                  }).catchError((error) {
                    if (error is FirebaseException) {
                      if (error.code == 'email-already-in-use') {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: "SPOTMIESINTERN")
                            .then((value) {
                          value.user?.updateDisplayName(_nameController.text);
                          goToGamePage();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User logged in successfully'),
                            ),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error logging in user'),
                            ),
                          );
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error creating user'),
                        ),
                      );
                    }
                  });
                },
                cursorColor: Colors.white,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.5),
                      ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          crossFadeState: showTextField
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 500),
        ),
      ],
    );
  }

  void updateTitle(String s) {
    title = title.substring(0, title.length - 1) + s;
  }

  void goToGamePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome to our 4th Anniversary Celebration!'),
                Text("Coming soon!"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
