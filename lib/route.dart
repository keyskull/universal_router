import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'init_router_base.dart';
import 'pages/async_loading_page.dart';

part 'path_handler.dart';
part 'route_data.dart';
part 'route_information_parser.dart';
part 'route_path.dart';
part 'router_delegate.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

typedef PageBuilder = Future<Widget> Function(
    String? parameters, dynamic extraInformation);

Widget Function({required Widget child}) _decorationLayer =
    ({required Widget child}) => Container(child: child);
Widget Function({Key? key, required Widget child}) _navigationLayer =
    ({Key? key, required Widget child}) => Container(key: key, child: child);

Map<String, RouteInstance> _routeStack = {};

setDecorationLayer(
        Widget Function({required Widget child}) newDecorationLayer) =>
    _decorationLayer = newDecorationLayer;

setNavigationLayer(
        Widget Function({Key? key, required Widget child})
            newNavigationLayer) =>
    _navigationLayer = newNavigationLayer;

addRoutePathListeners(dynamic Function(RoutePath) function) =>
    _routePathListeners[function.hashCode.toString()] = function;

removeRoutePathListeners(dynamic Function(RoutePath) function) =>
    _routePathListeners.remove(function.hashCode.toString());

class RouteInstance {
  final String routePath;
  final PageBuilder pageBuilder;
  final String title;
  final String parameters;
  final String path;
  final dynamic extraInformation;

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
    log("getRouteInformation:" + path, name: 'ml.cullen.router');
    return RouteInformation(location: path);
  }

  Page getPage() {
    log("path:" + routePath, name: 'ml.cullen.router');
    log("parameter:" + parameters, name: 'ml.cullen.router');
    return MaterialPage(
        key: ValueKey(RouteData(
          path: path,
          title: title,
          parameters: parameters,
          routePath: routePath,
        )),
        child: _navigationLayer(
            child: AsyncLoadPage(
                future: pageBuilder(parameters, extraInformation)
                    .then((value) => _decorationLayer(child: value)))));
  }
}
