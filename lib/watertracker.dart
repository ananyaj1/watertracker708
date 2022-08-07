import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({Key? key}) : super(key: key);

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141b52),
      body: WaveWidget(
        //user Stack() widget to overlap content and waves
        config: CustomConfig(
          gradients: [
            [
              const Color.fromRGBO(66, 141, 245, .4),
              Color.fromRGBO(13, 23, 49, .9)
            ],
            [Colors.cyan, const Color.fromRGBO(66, 141, 245, .4)],
            [Color.fromRGBO(2, 126, 250, .5), Colors.white],
          ],
          durations: [4000, 5000, 7000],
          //durations of animations for each colors,
          // make numbers equal to numbers of colors
          heightPercentages: [0.4, 0.5, 0.56],
          //height percentage for each colors.
          //blur intensity for waves
        ),
        size: Size(
          double.infinity,
          double.infinity,
        ),
      ),
    );
  }
}
