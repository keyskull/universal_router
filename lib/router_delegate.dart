part of 'route.dart';

class RouterDelegateInherit extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final logger = Logger(printer: CustomLogPrinter('RouterDelegateInherit'));
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

    logger.d('handler.routeName: ${handler.routeName}');
    final routePath = RoutePath(routeName: handler.routeName);
    _routePath = routePath;
    return Navigator(
      key: navigatorKey,
      pages: [routePath.getRouteInstance.getPage()],
      reportsRouteUpdateToEngine: false,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        logger.d('Pop Executed = ' + routePath.getRouteInstance.routePath);
        handler.changePath(routePath.getRouteInstance.routePath);
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    logger.d('setNewRoutePath = ' + configuration.routeName);
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
