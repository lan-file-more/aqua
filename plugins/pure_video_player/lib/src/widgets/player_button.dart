import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final double size;
  final Icon icon;
  final VoidCallback onPressed;
  final Color backgrounColor, iconColor;
  final bool circle;
  final Widget? customIcon;

  const PlayerButton({
    Key? key,
    this.size = 40,
    required this.icon,
    required this.onPressed,
    this.circle = true,
    this.backgrounColor = Colors.white54,
    this.iconColor = Colors.black,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: customIcon ?? Container(child: icon),
      onPressed: this.onPressed,
    );
  }
}
