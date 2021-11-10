import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onPressed;

  const MyRaisedButton(
      {Key? key, required this.color, this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
        disabledColor: color.withOpacity(0.8),
        color: color,
        onPressed: onPressed,
        child: child,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
