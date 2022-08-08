import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({Key? key}) : super(key: key);

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  var heightOne = .7;
  var heightTwo = .75;
  var heightThree = .8;
  var percent = 0.0;
  Color? progressColor = Colors.cyan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141b52),
      body: Stack(
        children: [
          WaveWidget(
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
              heightPercentages: [heightOne, heightTwo, heightThree],
              //height percentage for each colors.
              //blur intensity for waves
            ),
            size: Size(
              double.infinity,
              double.infinity,
            ),
          ),
          Positioned(
            bottom: 400,
            left: 125,
            child: CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              animation: true,
              progressColor: progressColor,
              percent: percent / 100,
              center: Text(percent.toString() + '%',
                  style: TextStyle(fontSize: 20.0, color: progressColor)),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 100,
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      heightOne -= .1;
                      heightTwo -= .1;
                      heightThree -= .1;
                      if (percent != 1.0) {
                        percent += 10.0;
                        percent.ceil();
                      }
                      if (percent >= 50.0) {
                        progressColor = Colors.black;
                      }
                      if (percent == 100.0) {
                        progressColor = Colors.green;
                      }
                    });
                  },
                  elevation: 2.0,
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                  color: Colors.white,
                  child: Image(
                      image: AssetImage('assets/images/addwater.png'),
                      height: 60,
                      width: 60),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      heightOne += .1;
                      heightTwo += .1;
                      heightThree += .1;
                      if (percent != 0.0) {
                        percent -= 10.0;
                        percent.ceil();
                      }
                      if (percent < 50.0) {
                        progressColor = Colors.cyan;
                      }
                      if (percent >= 50.0) {
                        progressColor = Colors.black;
                      }
                      if (percent == 100.0) {
                        progressColor = Colors.green;
                      }
                    });
                  },
                  elevation: 2.0,
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                  color: Colors.white,
                  child: Image(
                      image: AssetImage('assets/images/subwater.png'),
                      height: 60,
                      width: 60),
                ),
                /*WaterOutlineButton(
                  text: 'Press me',
                  onPressed: () {
                    setState(() {
                      heightOne -= .08;
                      heightTwo -= .08;
                      heightThree -= .08;
                    });
                  })), */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
