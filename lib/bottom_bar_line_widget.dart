import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

import 'bottom_bar_line_item.dart';
import 'bottom_bar_line_item_button.dart';

class BottomBarLine extends StatefulWidget {
  final Color background;
  final Function(int) onTap;
  final int currentIndex;
  final double circleSize;
  final List<BottomBarLineItem> items;

  BottomBarLine({
    Key key,
    @required this.background,
    @required this.onTap,
    @required this.items,
    this.circleSize = 6,
    this.currentIndex = 0,
  }) : super(key: key) {
//    assert(items.length);
  }

  @override
  _BottomBarLineState createState() => _BottomBarLineState();
}

class _BottomBarLineState extends State<BottomBarLine> {
  double maxSize = 0,
      maxDistance = 0,
      leftPadding = 0,
      minSize = 0,
      size = 0,
      distance = 0;

  @override
  void initState() {
    super.initState();

    minSize = size = widget.circleSize;
    maxSize = maxDistance =
        MediaQuery.of(Scaffold.of(context).context).size.width /
            widget.items.length;
    leftPadding = (maxSize / 2) - minSize / 2;

    distance = widget.currentIndex * maxDistance;
  }

  @override
  void didUpdateWidget(BottomBarLine oldWidget) {
    changeValues(
      currentDistance: oldWidget.currentIndex * maxDistance,
      newDistance: widget.currentIndex * maxDistance,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Stack(
        children: [
          Container(
            height: 56 + MediaQuery.of(context).padding.bottom,
            color: widget.background,
            child: Row(
              children: widget.items
                  .asMap()
                  .entries
                  .map<Widget>((item) => BottomBarLineItemButton(
                        item: item.value,
                        isActive: widget.currentIndex == item.key,
                        onTap: () => widget.onTap(item.key),
                      ))
                  .toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 180),
                height: minSize,
                width: size,
                decoration: BoxDecoration(
                  color: widget.items[widget.currentIndex].color,
                  borderRadius: BorderRadius.circular(minSize / 2),
                ),
                transform: Matrix4Transform()
                    .directionDegrees(0, distance + leftPadding)
                    .matrix4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeValues({double currentDistance, double newDistance}) async {
    // forward
    if (newDistance > currentDistance) {
      setState(() {
        this.size = (newDistance - currentDistance);
      });

      await Future.delayed(Duration(milliseconds: 180));

      setState(() {
        this.size = minSize;
        this.distance = newDistance;
      });
    }
    // backward
    else if (newDistance < currentDistance) {
      setState(() {
        this.distance = newDistance;
        this.size = (currentDistance - newDistance);
      });

      await Future.delayed(Duration(milliseconds: 180));

      setState(() {
        this.size = minSize;
      });
    }
  }
}
