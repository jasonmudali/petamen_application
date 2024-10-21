// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TemperatureMonitor extends StatelessWidget {
  bool isSetTemp = false;
  String temperature = "N/A";
  TemperatureMonitor(
      {super.key, required this.isSetTemp, required this.temperature});

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
            "Temperature",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            textBaseline: TextBaseline.alphabetic,
            children: [
              FaIcon(FontAwesomeIcons.temperatureHalf, size: 50),
              //Icon(Icons.thermostat, size: 50),
              SizedBox(width: 10),
              Text(temperature,
                  style: TextStyle(fontSize: 40, color: Colors.black)),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("°C",
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 90,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSetTemp ? Colors.green : Colors.red,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                isSetTemp ? "Heating done" : "Heating...",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
