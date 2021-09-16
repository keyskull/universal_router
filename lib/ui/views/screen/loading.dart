import 'package:cullen_utilities/screen_size.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Loading",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 50),
          ),
          Container(
            height: ScreenSize.getScreenSize.width / 2,
            width: ScreenSize.getScreenSize.width / 2,
            child: SizedBox.expand(
                child: CircularProgressIndicator(strokeWidth: 10)),
          )
        ],
      );
}
