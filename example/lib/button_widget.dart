import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Widget childText;
  final VoidCallback onPressed;

   const Button({Key key, @required this.onPressed, this.text, this.childText})
      : assert(childText != null || text != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton.filled(
            child: childText ?? Text(text),
            pressedOpacity: 0.5,
            onPressed: onPressed,
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: childText ?? Text(text.toUpperCase()),
          );
  }
}
