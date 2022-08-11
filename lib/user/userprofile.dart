import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff141b52),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: const Text('AH'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                WaterOutlineButton(
                  text: 'Your Water Goal: ',
                  onPressed: () {},
                  active: false,
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "8",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  "cups of water per day",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 20),
                WaterOutlineButton(
                  text: 'Your Water Goal: ',
                  onPressed: () {},
                  active: false,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Goal Streak:",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
