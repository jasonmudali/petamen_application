// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:aplikasi_petamen/pages/speed_monitor.dart';
import 'package:aplikasi_petamen/pages/temperature_monitor.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_petamen/buttons.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String broker = '172.203.134.8'; //'postman.cloudmqtt.com';
  int port =
      1883; //1883 itu port gak diencrypt, kalo mau encrypted bisa pake port 8883
  String topic = 'petamen/temp';
  String pubTopic = 'petamen/pubtest';
  String clientIdentifier = 'flutter_client';

  late MqttServerClient client;
  //MqttClientConnectionStatus? connectionStatus;

  StreamSubscription? subscription;
  TextEditingController pController = TextEditingController();
  String temperature = "N/A";
  int setTemp = 150;
  int setSpeed = 30;
  bool isConnected = false;
  bool _isSwitchOn = false;
  bool _isSetTemp = false;

  @override
  void initState() {
    super.initState();
    _connectMQTT();
  }

  Future<void> _connectMQTT() async {
    client = MqttServerClient(broker, '');
    client.port = 1883; // Standard MQTT port
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    // Connection message setup
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      print('Connecting to MQTT broker...');
      await client.connect();
    } catch (e) {
      print('Connection failed: $e'); // Log the error during connection
      client.disconnect();
    }

    // Listen for incoming messages
    client.updates?.listen(_onMessage);
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker');
    setState(() {
      isConnected = false;
    });
  }

  void _publishMessage(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
    print('Published message: $message to topic: $pubTopic');
  }

  void _onConnected() {
    print('Connected to MQTT broker');
    setState(() {
      isConnected = true;
    });
    client.subscribe(topic, MqttQos.atMostOnce); // Subscribe to the topic

    print('Subscribed to topic: $topic');
  }

  void _onSubscribed(String topic) {
    print('Successfully subscribed to: $topic');
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? event) {
    final MqttPublishMessage message = event![0].payload as MqttPublishMessage;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    print('Received message: $payload from topic: ${event[0].topic}');

    if (payload.isNotEmpty) {
      setState(() {
        temperature =
            payload; // Update temperature data with the received payload
        print('Updated temperature: $temperature');
      });
    } else {
      print('Received empty payload!');
    }
  }

  void _toggleHeating() {
    setState(() {
      _isSetTemp = !_isSetTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(98, 255, 153, 221),
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text("PETAMEN"),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TemperatureMonitor(
                    isSetTemp: _isSetTemp,
                    temperature: temperature,
                  ),
                  SpeedMonitor(isSetTemp: _isSetTemp)
                ],
              ),
            ),
            //=============================Trouble Shoot Heating Status==============================================
            // ElevatedButton(
            //   onPressed: _toggleHeating,
            //   child: Text('Toggle Heating'),
            // ),
            //=============================Trouble Shoot Heating Status==============================================

            Container(
              margin: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    "Set Temperature",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 19),
                        child: Text(
                          "$setTemp°C",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 15),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              setTemp--;
                            });
                          },
                          icon: Icon(Icons.remove)),
                      Expanded(
                        child: Slider(
                          thumbColor: Colors.black,
                          activeColor: Colors.black,
                          value: setTemp.toDouble(),
                          min: 100,
                          max: 250,
                          // divisions: 100,
                          // label: setTemp.toString(),
                          onChanged: (double value) {
                            setState(() {
                              setTemp = value.toInt();
                            });
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              setTemp++;
                            });
                          },
                          icon: Icon(Icons.add)),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    "Set Speed",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "$setSpeed rpm",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              setSpeed--;
                            });
                          },
                          icon: Icon(Icons.remove)),
                      Expanded(
                        child: Slider(
                          thumbColor: Colors.black,
                          activeColor: Colors.black,
                          value: setSpeed.toDouble(),
                          min: 10,
                          max: 60,
                          // divisions: 100,
                          // label: setTemp.toString(),
                          onChanged: (double value) {
                            setState(() {
                              setSpeed = value.toInt();
                            });
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              setSpeed++;
                            });
                          },
                          icon: Icon(Icons.add)),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _publishMessage('Hello from Flutter');
                    },
                    child: Text('Publish Message'),
                  ),
                ],
              ),
            ),

            // Switch(
            //   activeTrackColor: Colors.black,
            //   value: _isSwitchOn,
            //   onChanged: (bool value) {
            //     setState(() {
            //       _isSwitchOn = value; // Update status switch
            //     });
            //   },
            // ),
            SizedBox(height: 10),
            // Row(
            //   children: [
            //     Text("P value: "),
            //     Container(
            //       height: 20,
            //       width: 30,
            //       child:
            //           // get user input
            //           TextField(
            //         controller: pController,
            //         cursorHeight: 15,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     OKButton()
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   children: [
            //     Text("I value: "),
            //     Container(
            //       height: 20,
            //       width: 30,
            //       child:
            //           // get user input
            //           TextField(
            //         controller: pController,
            //         cursorHeight: 15,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     OKButton()
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   children: [
            //     Text("D value: "),
            //     Container(
            //       height: 20,
            //       width: 30,
            //       child:
            //           // get user input
            //           TextField(
            //         controller: pController,
            //         cursorHeight: 15,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     OKButton()
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
