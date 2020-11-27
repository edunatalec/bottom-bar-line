import 'package:bottom_bar_line/bottom_bar_line.dart';
import 'package:flutter/material.dart';

class BottomBarLineItemButton extends StatelessWidget {
  final BottomBarLineItem item;
  final Function onTap;
  final bool isActive;

  BottomBarLineItemButton({
    @required this.item,
    @required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final newIcon = TweenAnimationBuilder(
      duration: Duration(milliseconds: 360),
      curve: Curves.fastOutSlowIn,
      tween: ColorTween(
          begin: item.icon.color, end: isActive ? item.color :( item.icon.color ?? Colors.grey.shade500 )),
      builder: (_, color, __) {
        return Icon(
          item.icon.icon,
          color: color,
          size: item.icon.size,
        );
      },
//      iconData: item.icon.icon,
//      color: isActive ? item.color : (item.icon.color ?? Colors.grey.shade500),
//      color: 10.2,
//      size: item.icon.size,
    );

    return Expanded(
      child: Stack(
        children: [
          Container(
            height: 56,
            child: Center(
              child: newIcon,
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ))
        ],
      ),
    );
  }
}

//class AnimatedColorIcon extends AnimatedWidget {
//  const AnimatedColorIcon({color}) : super(listenable: color);
//
//  Animation<double> get color => listenable;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: 20,
//      height: color.value,
//      color: Colors.red.shade50,
//    );
////    return Icon(
////      iconData,
////      color: color.value,
////      size: size,
////    );
//  }
//}
