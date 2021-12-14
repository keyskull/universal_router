import 'package:cullen_utilities/custom_log_printer.dart';
import 'package:cullen_utilities/ui/views/pages/unknown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'ui/views/pages/async_loading_page.dart';

part 'path_handler.dart';
part 'route_data.dart';
part 'route_information_parser.dart';
part 'route_instance.dart';
part 'route_path.dart';
part 'router_delegate.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

final Map<String, RouteInstance> _routeStack = {};

class UniversalRouter {
  static final _logger = Logger(printer: CustomLogPrinter('Router'));
  static addRoutePathChangingListeners(dynamic Function(RoutePath) function) {
    _routePathListeners[function.hashCode.toString()] = function;
    _logger.d('Added RoutePathListeners: ${function.hashCode.toString()}');
  }

  static removeRoutePathListeners(dynamic Function(RoutePath) function) {
    _routePathListeners.remove(function.hashCode.toString());
    _logger.d('Removed RoutePathListeners: ${function.hashCode.toString()}');
  }

  static changePath(String path) {
    _logger.i('changePath: ' + path);
    globalNavigatorKey.currentState!.pushNamed(path);
  }

  static String getPath() {
    return routerDelegate._routePath?.path ?? '/';
  }

  static String getName() {
    return routerDelegate._routePath?.routeName ?? '/';
  }

  static RouteInstance getRouteInstance(String path) {
    return RoutePath(path: path).getRouteInstance;
  }

  static pop() => globalNavigatorKey.currentState!.pushNamed(
      routerDelegate.currentConfiguration.getRouteInstance.routePath);

  @Deprecated('''
  RouteData is not gonna update when we have change the route path.
  Now, the RouteData only have the original page's information
  as the first screen you run in to the app.
  ''')
  static RouteData? getCurrentRouteData() =>
      (globalNavigatorKey.currentState?.widget.pages.first.key as ValueKey?)
          ?.value as RouteData?;

  ///
  /// to access current router table status;
  static get getRegisteredRoute => _routeStack;

  ///
  /// This is a pre-registered Route as the 404 page.
  /// Also, the value is able to access from outside to get the information
  /// and unregister the route;
  ///
  /// For the next version, add a setting for override 404 page.
  static final unknownPage = RouteInstance(
      routePath: '404',
      title: 'Page not Found',
      pageBuilder: (parameters, extraInformation) =>
          Future.value(Unknown(errorMSG: extraInformation.toString())));

  static final RouterDelegateInherit routerDelegate = RouterDelegateInherit();
  static final routerInformationParser = routerDelegate.routerInformationParser;
  static final routeInformationProvider =
      routerDelegate.routeInformationProvider;

  static RoutePath get currentConfiguration =>
      routerDelegate.currentConfiguration;
}
