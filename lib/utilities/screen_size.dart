
import 'package:flutter/material.dart';



class ScreenSize {
  static const common_desktop_size = Size(1024,768);
  static const common_phone_size = Size(640,960);
  static Size? _screenSize;

  static bool isDesktop(BuildContext context){
        if((_screenSize ?? MediaQuery.of(context).size).width >
            common_desktop_size.width)
          return true;
        else return false;
  }

  static initScreenSize(BuildContext context){
      _screenSize = _screenSize ?? MediaQuery.of(context).size;
     // _screenSize = MediaQuery.of(context).size;
  }

  static updateScreenSize(BuildContext context){
    _screenSize = MediaQuery.of(context).size;
  }

  static Size get getScreenSize => _screenSize?? common_phone_size;


  static Size getFlashScreenSize(BuildContext context){
    _screenSize = MediaQuery.of(context).size;
    return _screenSize!;
  }
}