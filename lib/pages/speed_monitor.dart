// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpeedMonitor extends StatelessWidget {
  bool isSetTemp = false;
  SpeedMonitor({super.key, required this.isSetTemp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text(
            "Motor Speed",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            textBaseline: TextBaseline.alphabetic,
            children: [
              FaIcon(FontAwesomeIcons.gauge, size: 50),
              SizedBox(width: 10),
              Text("30", // $temperature
                  style: TextStyle(fontSize: 40, color: Colors.black)),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text("rpm",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              )
            ],
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}
