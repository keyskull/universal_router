import 'package:flutter/material.dart';

class Unknown extends StatelessWidget {
  final String? errorMSG;

  const Unknown({Key? key, this.errorMSG = 'Unknown!'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [const Text('404!'), Text('Error Message: ' + errorMSG!)],
    ));
  }
}
