import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

import 'bottom_bar_line_item.dart';
import 'bottom_bar_line_item_button.dart';

class BottomBarLine extends StatefulWidget {
  final List<BottomBarLineItem> items;
  final Color backgroundColor;

  /// Called when one of the [items] is pressed.
  final Function(int) onTap;

  /// The current index of [items] (active)
  final int currentIndex;

  /// The circle diameter
  final double circleSize;

  /// If it has the snake effect
  final bool hasLineEffect;

  /// If the icon goes up
  final bool iconJump;

  /// The animation duration
  final Duration duration;

  final Color splashColor;
  final Color highlightColor;

  BottomBarLine({
    Key key,
    @required this.onTap,
    @required this.items,
    this.backgroundColor = Colors.transparent,
    this.circleSize = 6,
    this.currentIndex = 0,
    this.hasLineEffect = true,
    this.duration = const Duration(milliseconds: 180),
    this.splashColor,
    this.highlightColor,
    this.iconJump = true,
  }) : super(key: key);

  @override
  _BottomBarLineState createState() => _BottomBarLineState();
}

class _BottomBarLineState extends State<BottomBarLine> {
  bool isAnimating = false;
  bool isForward = false;

  double maxSize, maxDistance, leftPadding, minSize, size, distance;

  @override
  void initState() {
    super.initState();

    minSize = size = widget.circleSize;

    maxSize = maxDistance =
        MediaQuery.of(Scaffold.of(context).context).size.width /
            widget.items.length;

    leftPadding = (maxSize / 2) - minSize / 2;

    // The index is not 0 always
    distance = widget.currentIndex * maxDistance;
  }

  @override
  void didUpdateWidget(BottomBarLine oldWidget) {
    super.didUpdateWidget(oldWidget);

    changeValues(
      currentDistance: oldWidget.currentIndex * maxDistance,
      newDistance: widget.currentIndex * maxDistance,
    );
  }

  @override
  Widget build(BuildContext context) {
    // The MediaQuery.of(context).size.width can change
    maxSize =
        maxDistance = MediaQuery.of(context).size.width / widget.items.length;
    leftPadding = (maxSize / 2) - minSize / 2;

    return SizedBox(
      height: 56 + MediaQuery.of(context).padding.bottom,
      child: Stack(
        children: [
          Container(
            color: widget.backgroundColor,
            child: Row(
              children: widget.items
                  .asMap()
                  .entries
                  .map<Widget>(
                    (item) => BottomBarLineItemButton(
                      item: item.value,
                      isActive: widget.currentIndex == item.key,
                      onTap: isAnimating ? () {} : () => widget.onTap(item.key),
                      highlightColor: widget.highlightColor,
                      splashColor: widget.splashColor,
                      duration: widget.duration,
                      iconJump: widget.iconJump,
                    ),
                  )
                  .toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: widget.duration,
                height: minSize,
                width: size,
                decoration: BoxDecoration(
                  color: widget.items[widget.currentIndex].selectedColor,
                  borderRadius: BorderRadius.circular(minSize / 2),
                  gradient: LinearGradient(
                    begin: isForward
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    end: isForward
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    colors: [
                      widget.items[widget.currentIndex].selectedColor
                          .withOpacity(isAnimating ? .4 : 1),
                      widget.items[widget.currentIndex].selectedColor
                          .withOpacity(isAnimating ? .7 : 1),
                      widget.items[widget.currentIndex].selectedColor,
                    ],
                  ),
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
    if (newDistance > currentDistance) {
      setState(() {
        isAnimating = true;
        isForward = true;
        this.size = (newDistance - currentDistance);
      });

      if (widget.hasLineEffect) await Future.delayed(widget.duration);

      setState(() {
        this.size = minSize;
        this.distance = newDistance;
        isAnimating = false;
      });
    } else if (newDistance < currentDistance) {
      setState(() {
        isAnimating = true;
        isForward = false;
        this.distance = newDistance;
        this.size = (currentDistance - newDistance);
      });

      if (widget.hasLineEffect) await Future.delayed(widget.duration);

      setState(() {
        this.size = minSize;
        isAnimating = false;
      });
    }
  }
}
