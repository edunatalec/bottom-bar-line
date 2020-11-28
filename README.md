# BottomBarLine

A bottom navigation bar with a beautiful effect.

## Preview

## Properties

```dart
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
```
