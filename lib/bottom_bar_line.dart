library bottom_bar_line;

import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

class BottomBarLine extends StatefulWidget {
  BottomBarLine({Key key}) : super(key: key);

  @override
  _BottomBarLineState createState() => _BottomBarLineState();
}

class _BottomBarLineState extends State<BottomBarLine> {
  final double maxSize = 100;
  final double maxDistance = 100;
  final double minSize = 10;
  final double minDistance = 0;

  double size = 10, distance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 56,
                width: double.maxFinite,
                color: Colors.blue,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 10,
                width: size,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                transform:
                    Matrix4Transform().directionDegrees(0, distance).matrix4,
              ),
            ],
          ),
          RaisedButton(
            onPressed: () =>
                changeValues(currentDistance: distance, newDistance: 0),
          ),
          RaisedButton(
            onPressed: () =>
                changeValues(currentDistance: distance, newDistance: 100),
          ),
          RaisedButton(
            onPressed: () =>
                changeValues(currentDistance: distance, newDistance: 200),
          )
        ],
      ),
    );
  }

  void changeValues(
      {double currentDistance, double newDistance, Color color}) async {
    // forward
    if (newDistance > currentDistance) {
      setState(() {
        this.size = (newDistance - currentDistance);
      });

      await Future.delayed(Duration(milliseconds: 200));

      setState(() {
        this.size = minSize;
        this.distance = newDistance;
      });
    }
    // backward
    else {
      setState(() {
        this.distance = newDistance;
        this.size = (currentDistance - newDistance);
      });

      await Future.delayed(Duration(milliseconds: 200));

      setState(() {
        this.size = minSize;
      });
    }
  }
}
