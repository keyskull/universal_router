part of 'route.dart';

class RouterDelegateInherit extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final logger = Logger(printer: CustomLogPrinter('RouterDelegateInherit'));

  RoutePath? _routePath;
  PathHandler? handler;

  final GlobalKey<NavigatorState> navigatorKey = globalNavigatorKey;

  RoutePath get currentConfiguration {
    logger.d('currentConfiguration get executed.');
    return _routePath ?? startPath ?? RoutePath();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('build executed');

    if (startPath != null) {
      Provider.of<PathHandler>(context).routePath = startPath!;
      startPath = null;
    }
    handler = Provider.of<PathHandler>(context, listen: true);
    handler?.addListener(notifyListeners);

    logger.d('handler.routeName: ${handler?.routePath?.routeName}');
    final routePath = handler?.routePath ?? RoutePath();
    _routePath = routePath;

    return Navigator(
        key: navigatorKey,
        pages: [routePath.getRouteInstance.getPage()],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          logger.d('Pop Executed = ' + routePath.getRouteInstance.routePath);
          handler?.changeRoutePath(routePath);
          return true;
        },
        onGenerateRoute: (setting) {
          logger.i(
              "onGenerateRoute RouteSettings: [name: ${setting.name ?? ''}, arguments: ${setting.arguments ?? ''}]");
          final routePath = RoutePath(path: setting.name);
          if (routePath != _routePath!) {
            this.setNewRoutePath(routePath);
            return routePath.getRouteInstance.getPageRoute();
          } else
            return _routePath!.getRouteInstance.getPageRoute();
        });
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    logger.d('setNewRoutePath executed.');
    if (configuration.getRouteInstance != _routePath?.getRouteInstance) {
      logger.i('set new routePath = ' + configuration.routeName);
      _routePath = configuration;
      handler?.changeRoutePath(configuration);
    }
  }

  @override
  void dispose() {
    handler?.dispose();
    super.dispose();
  }
}
