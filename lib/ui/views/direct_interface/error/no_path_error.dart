import 'package:flutter/material.dart';

class NoPathError extends StatelessWidget {
  final String path;

  NoPathError({this.path = "unknown"});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text('No path for $path'),
    ),
  );
}
