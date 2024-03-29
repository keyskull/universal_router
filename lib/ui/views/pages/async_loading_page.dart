import 'package:cullen_utilities/custom_log_printer.dart';
import 'package:cullen_utilities/ui/views/pages/unknown.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'loading.dart';

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
  final logger = Logger(printer: CustomLogPrinter('Router.AsyncLoadPage'));
  final Widget? child;
  final WidgetBuilder? builder;
  final Future<Widget>? future;

  AsyncLoadPage({Key? key, this.child, this.builder, this.future})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future ??
            Future(() async {
              // await Future.delayed(const Duration(seconds: 10));
              return child ?? builder ?? (context);
            }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              logger.e(snapshot.error.toString());
              return Unknown(errorMSG: snapshot.error.toString());
            } else {
              return snapshot.requireData as Widget;
            }
          } else {
            return const Loading();
          }
        });
  }
}
