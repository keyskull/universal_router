import 'dart:developer';

import 'package:flutter/material.dart';
import '../ui/views/direct_interface/loading.dart';
import '404.dart';

// class AsyncMaterialPageRoute extends MaterialPageRoute {
//   final Widget? child;
//
//   AsyncMaterialPageRoute(settings, {this.child, builder})
//       : super(
//             settings: settings,
//             builder: (context) =>
//                 _AsyncLoadPage(child: child, builder: builder));
// }

class AsyncLoadPage extends StatelessWidget {
  final Widget? child;
  final WidgetBuilder? builder;
  final Future<Widget>? future;

  AsyncLoadPage({this.child, this.builder, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.future ??
            Future(() async {
              // await Future.delayed(const Duration(seconds: 10));
              return child ?? builder ?? (context);
            }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              log(snapshot.error.toString(),
                  level: 2000,
                  name: 'ml.cullen.router.loading',
                  error: snapshot.error);
              return UnknownScreen(errorMSG: snapshot.error.toString());
            } else
              return snapshot.requireData as Widget;
          } else
            return Loading();
        });
  }
}
