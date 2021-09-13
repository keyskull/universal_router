part of 'route.dart';

class RouterDelegateInherit extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final logger = Logger(printer: CustomLogPrinter('RouterDelegateInherit'));

  /// TODO: Need Optimize: It shouldn't need to initialize _routePath;
  RoutePath? _routePath;
  PathHandler? handler;

  final GlobalKey<NavigatorState> navigatorKey = globalNavigatorKey;

  RoutePath get currentConfiguration {
    logger.d('currentConfiguration get executed.');
    return _routePath ?? startPath ?? RoutePath();
  }

  @override
  Widget build(BuildContext context) {
    if (startPath != null) {
      Provider.of<PathHandler>(context).routeName = startPath!.routeName;
      startPath = null;
    }
    handler = Provider.of<PathHandler>(context, listen: true);
    handler?.addListener(notifyListeners);

    logger.d('handler.routeName: ${handler?.routeName}');
    final routePath = _routePath?.routeName == handler?.routeName
        ? _routePath!
        : RoutePath(routeName: handler?.routeName);
    _routePath = routePath;

    return Navigator(
      key: navigatorKey,
      pages: [routePath.getRouteInstance.getPage()],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        logger.d('Pop Executed = ' + routePath.getRouteInstance.routePath);
        handler?.changePath(routePath.getRouteInstance.routePath);
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    logger.d('setNewRoutePath executed.');
    if (configuration.getRouteInstance != _routePath?.getRouteInstance) {
      logger.i('set new routePath = ' + configuration.routeName);
      _routePath = configuration;
      handler?.changePath(configuration.routeName);
    }
  }

  @override
  void dispose() {
    handler?.dispose();
    super.dispose();
  }
}
