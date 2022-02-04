import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final String title;
  final ValueChanged<bool> onChanged;

   const SwitchWidget(
      {Key key, @required this.value, @required this.title, @required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) => SwitchListTile.adaptive(
        value: value,
        title: Text(title),
        onChanged: onChanged,
      );
}
