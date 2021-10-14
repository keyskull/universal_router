import 'package:cullen_utilities/custom_log_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'pages/async_loading_page.dart';
import 'ui/views/screen/404.dart' deferred as error;

part 'path_handler.dart';
part 'route_data.dart';
part 'route_information_parser.dart';
part 'route_instance.dart';
part 'route_path.dart';
part 'router_delegate.dart';

final routerLogger = Logger(printer: CustomLogPrinter('Router'));

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

typedef PageBuilder = Future<Widget> Function(
    String? parameters, dynamic extraInformation);

Widget Function({required Widget child}) _decorationLayer =
    ({required Widget child}) => Container(child: child);

final Map<String, RouteInstance> _routeStack = {};

class UniversalRouter {
  static setDecorationLayer(
          Widget Function({required Widget child}) newDecorationLayer) =>
      _decorationLayer = newDecorationLayer;

  static addRoutePathListeners(dynamic Function(RoutePath) function) {
    _routePathListeners[function.hashCode.toString()] = function;
    routerLogger.d("Added RoutePathListeners: ${function.hashCode.toString()}");
  }

  static removeRoutePathListeners(dynamic Function(RoutePath) function) {
    _routePathListeners.remove(function.hashCode.toString());
    routerLogger
        .d("Removed RoutePathListeners: ${function.hashCode.toString()}");
  }

  static changePath(String path) {
    routerLogger.i('changePath: ' + path);
    globalNavigatorKey.currentState!.pushNamed(path);
  }

  static pop() => globalNavigatorKey.currentState!.pushNamed(
      _routerDelegate.currentConfiguration.getRouteInstance.routePath);

  static RouteData? getCurrentRouteData() =>
      (globalNavigatorKey.currentState?.widget.pages.first.key as ValueKey?)
          ?.value as RouteData?;

  ///
  /// to access current router table status;
  get getRegisteredRoute => _routeStack;

  ///
  /// This is a pre-registered Route as the 404 page.
  /// Also, the value is able to access from outside to get the information
  /// and unregister the route;
  ///
  /// For the next version, add a setting for override 404 page.
  static final unknownPage = RouteInstance(
      routePath: "404",
      title: 'Page not Found',
      pageBuilder: (parameters, extraInformation) => error.loadLibrary().then(
          (_) => error.UnknownScreen(errorMSG: extraInformation.toString())));

  ///
  /// This static method use for materialize the [UniversalRouter] class.
  ///
  static UniversalRouter initialize() => UniversalRouter();

  static final RouterDelegateInherit _routerDelegate = RouterDelegateInherit();

  final RouterDelegateInherit routerDelegate = _routerDelegate;
  late final routerInformationParser = routerDelegate.routerInformationParser;
  late final routeInformationProvider = routerDelegate.routeInformationProvider;

  get currentConfiguration => routerDelegate.currentConfiguration;
}
