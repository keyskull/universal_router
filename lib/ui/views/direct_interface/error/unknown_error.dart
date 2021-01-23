import 'package:flutter/material.dart';

class UnknownError extends StatelessWidget {
  final String errorMessage;

  UnknownError({this.errorMessage = "nothing"});

  @override
  Widget build(BuildContext context) => Center(
        child: Text("error: $errorMessage"),
      );
}
