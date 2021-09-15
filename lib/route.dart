import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:utilities/custom_log_printer.dart';

import 'init_router_base.dart';
import 'pages/async_loading_page.dart';

part 'path_handler.dart';
part 'route_data.dart';
part 'route_information_parser.dart';
part 'route_path.dart';
part 'router_delegate.dart';

final routerLogger = Logger(printer: CustomLogPrinter('Router'));

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

typedef PageBuilder = Future<Widget> Function(
    String? parameters, dynamic extraInformation);

Widget Function({required Widget child}) _decorationLayer =
    ({required Widget child}) => Container(child: child);

setDecorationLayer(
        Widget Function({required Widget child}) newDecorationLayer) =>
    _decorationLayer = newDecorationLayer;

addRoutePathListeners(dynamic Function(RoutePath) function) {
  _routePathListeners[function.hashCode.toString()] = function;
  routerLogger.d("Added RoutePathListeners: ${function.hashCode.toString()}");
}

removeRoutePathListeners(dynamic Function(RoutePath) function) {
  _routePathListeners.remove(function.hashCode.toString());
  routerLogger.d("Removed RoutePathListeners: ${function.hashCode.toString()}");
}

final Map<String, RouteInstance> _routeStack = {};

class RouteInstance {
  final String routePath;
  final PageBuilder pageBuilder;
  final String title;
  final String parameters;
  final String path;
  final dynamic extraInformation;
  final logger = Logger(printer: CustomLogPrinter('RouteInstance'));

  RouteInstance(
      {required this.routePath,
      required this.pageBuilder,
      String? title,
      this.parameters = '',
      this.extraInformation})
      : path = parameters == ''
            ? '/' + routePath
            : '/' + routePath + '/' + parameters,
        title = title ?? routePath {
    _routeStack[this.path.substring(1)] = this;
  }

  createChildRouteInstance({String parameters = '', dynamic extraInformation}) {
    return new RouteInstance(
        routePath: this.routePath,
        pageBuilder: this.pageBuilder,
        title: this.title,
        parameters: parameters,
        extraInformation: extraInformation);
  }

  RouteInformation getRouteInformation() {
    logger.d("getRouteInformation:" + path);
    return RouteInformation(location: path);
  }

  late final widget = AsyncLoadPage(
      future: pageBuilder(parameters, extraInformation)
          .then((value) => _decorationLayer(child: value)));

  MaterialPage getPage() {
    logger.d('getPage executed');
    logger.i("path:" + routePath);
    logger.i("parameter:" + parameters);
    return MaterialPage(
        key: ValueKey(RouteData(
          path: path,
          title: title,
          parameters: parameters,
          routePath: routePath,
        )),
        child: widget);
  }

  Route getPageRoute() {
    logger.d('getPageRoute executed');

    return MaterialPageRoute(builder: (_) => widget);
  }
}
