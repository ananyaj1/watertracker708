import 'dart:async';

import 'package:flutter/material.dart';
import 'package:water_tracker/signin.dart';
import 'package:water_tracker/signup.dart';
import 'package:water_tracker/widgets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation firstAnimation;

  late AnimationController secondController;
  late Animation secondAnimation;

  late AnimationController thirdController;
  late Animation thirdAnimation;

  late AnimationController fourthController;
  late Animation fourthAnimation;
  @override
  void initState() {
    super.initState();
    firstController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });
    thirdController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });
    fourthController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.8, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });
    Timer(Duration(seconds: 2), () {
      firstController.forward();
    });
    Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });
    Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });
    fourthController.forward();

    @override
    void dispose() {
      firstController.dispose();
      secondController.dispose();
      thirdController.dispose();
      fourthController.dispose();
      super.dispose();
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff141b52),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Water Tracker',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  WaterOutlineButton(
                      text: 'Sign Up',
                      onPressed: () {
                        _goToPage(context, SignUpPage());
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  WaterOutlineButton(
                      text: 'Login',
                      onPressed: () {
                        _goToPage(context, SignInPage());
                      }),
                ],
              ),
            ),
            Expanded(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: PaintWater(
                      firstAnimation.value,
                      secondAnimation.value,
                      thirdAnimation.value,
                      fourthAnimation.value),
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _goToPage(BuildContext context, Widget destination) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
  return result;
}

class PaintWater extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;
  PaintWater(
      this.firstValue, this.secondValue, this.thirdValue, this.fourthValue);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xff3B6ABA).withOpacity(.8)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height / firstValue)
      ..cubicTo(size.width * .4, (size.height / secondValue), size.width * .7,
          size.height / thirdValue, size.width, size.height / fourthValue)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
