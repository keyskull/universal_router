import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  final String? errorMSG;

  UnknownScreen({this.errorMSG = "Unknown!"});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [Text('404!'), Text('Error Message:' + errorMSG!)],
    ));
  }
}
