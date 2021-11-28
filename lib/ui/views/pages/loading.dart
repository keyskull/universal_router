import 'package:cullen_utilities/screen_size.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Loading',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 50),
          ),
          SizedBox(
            height: ScreenSize.getScreenSize.width / 2,
            width: ScreenSize.getScreenSize.width / 2,
            child: const SizedBox.expand(
                child: CircularProgressIndicator(strokeWidth: 10)),
          )
        ],
      );
}
