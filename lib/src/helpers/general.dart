import 'dart:developer' as dev;
import 'package:flutter/material.dart';

class Dev {
  static log(dynamic value) => dev.log('$value');
}

class AddBorder extends StatelessWidget {
  const AddBorder({this.child, Key? key}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: child,
    );
  }
}
