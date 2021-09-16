import 'package:flutter/material.dart';
import 'package:universal_router/route.dart';

void main() {
  RouteInstance(
      routePath: '', title: 'Home', pageBuilder: (_, __) async => Home());

  runApp(MyApp());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: () => {UniversalRouter.changePath('somewhere')},
      child: Text('go to somewhere else'));
}

class MyApp extends StatelessWidget {
  final universalRouter = UniversalRouter.initialize();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: universalRouter.routerDelegate,
      routeInformationProvider: universalRouter.routeInformationProvider,
      routeInformationParser: universalRouter.routerInformationParser,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }
}
