part of 'route.dart';
// import 'package:firebase_integration/firebase.dart';

Map<String, Function(RoutePath routePath)> _routePathListeners = {};

class RouteInformationParserInherit extends RouteInformationParser<RoutePath> {
  final logger =
      Logger(printer: CustomLogPrinter('RouteInformationParserInherit'));

  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    logger
        .i('routeInformation.location = ' + (routeInformation.location ?? '/'));
    return RoutePath(routeName: routeInformation.location ?? '/');
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath routePath) {
    logger.d('restoreRouteInformation = ' + routePath.routeName);
    logger.d('routePath.getRouteInstance.getRouteInformation().location = ' +
        (routePath.getRouteInstance.getRouteInformation().location ?? ''));
    logger.d('routePath.getRouteInstance.getRouteInformation().state = ' +
        routePath.getRouteInstance.getRouteInformation().state.toString());

    _routePathListeners.values.map((e) => e(routePath));
    // FirebaseIntegration.firebaseAnalytics
    //     .setCurrentScreen(
    //         screenName: routePath.routeName,
    //         screenClassOverride:
    //             routePath.getRouteInstance.getPage().runtimeType.toString())
    //     .then((value) => log(
    //         'firebaseAnalytics.setCurrentScreen(screenName: ${routePath.routeName})',
    //         name: 'firebaseAnalytics.setCurrentScreen'))
    //     .catchError(
    //   (Object error) {
    //     debugPrint(': $error');
    //   },
    //   test: (Object error) => error is PlatformException,
    // );
    // FirebaseIntegration.firebaseAnalytics.logEvent(name: 'page_view');

    return routePath.getRouteInstance.getRouteInformation();
  }
}
