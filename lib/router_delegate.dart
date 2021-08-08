import 'dart:developer';

import 'package:flutter/material.dart';
import 'path_handler.dart';
import 'route.dart';
import 'package:provider/provider.dart';


class RouterDelegateInherit extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  late RoutePath _routePath;
  late PathHandler handler;

  GlobalKey<NavigatorState> navigatorKey = globalNavigatorKey;

  RoutePath get currentConfiguration {
    return _routePath;
  }
  @override
  Widget build(BuildContext context) {
    handler = Provider.of<PathHandler>(context, listen: true);
    handler.addListener(notifyListeners);

    log('handler.routeName: ${handler.routeName}',
        name: 'ml.cullen.RouterDelegateInherit');
    final routePath = RoutePath(routeName: handler.routeName);
    _routePath = routePath;
    return Navigator(
      key: navigatorKey,
      pages: [routePath.getRouteInstance.getPage()],
      reportsRouteUpdateToEngine: false,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        log('Pop Executed = ' + routePath.getRouteInstance.routePath,
            name: 'ml.cullen.RouterDelegateInherit');
        handler.changePath(routePath.getRouteInstance.routePath);
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    log('setNewRoutePath = ' + configuration.routeName,
        name: 'ml.cullen.RouterDelegateInherit');
    _routePath = configuration;
    handler.changePath(configuration.routeName);
    notifyListeners();
  }


  @override
  void dispose() {
    handler.dispose();
    super.dispose();
  }
}
