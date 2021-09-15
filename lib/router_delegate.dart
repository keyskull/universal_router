part of 'route.dart';

class UniversalRouter extends RouterDelegate<RoutePath>
    with PopNavigatorRouterDelegateMixin<RoutePath> {
  final routerInformationParser = RouteInformationParserInherit();
  final routeInformationProvider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
          location: WidgetsBinding.instance!.window.defaultRouteName !=
                  Navigator.defaultRouteName
              ? WidgetsBinding.instance!.window.defaultRouteName
              : WidgetsBinding.instance!.window.defaultRouteName));
  late final RouterDelegate<RoutePath> routerDelegate = this;

  final logger = Logger(printer: CustomLogPrinter('RouterDelegateInherit'));

  RoutePath? _routePath;

  final PathHandler handler = PathHandler();

  final GlobalKey<NavigatorState> navigatorKey = globalNavigatorKey;

  static changePath(String path) =>
      globalNavigatorKey.currentState!.pushNamed(path);

  RoutePath get currentConfiguration {
    logger.d('currentConfiguration get executed.');
    return _routePath ?? startPath ?? RoutePath();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('build executed');

    if (startPath != null) handler.routePath = startPath!;

    logger.d('handler.routeName: ${handler.routePath?.routeName}');
    final routePath = handler.routePath ?? RoutePath();
    _routePath = routePath;

    return Navigator(
      key: navigatorKey,
      pages: [routePath.getRouteInstance.getPage()],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        logger.i('Pop Executed = ' + routePath.getRouteInstance.routePath);
        this.setNewRoutePath(routePath);
        return true;
      },
      onGenerateRoute: (setting) {
        logger.i(
            "onGenerateRoute RouteSettings: [name: ${setting.name ?? ''}, arguments: ${setting.arguments ?? ''}]");
        if ((_routePath?.path ?? '-') == setting.name)
          return _routePath!.getRouteInstance.getPageRoute();
        else {
          final routerPath1 = RoutePath(path: setting.name);
          this.setNewRoutePath(routerPath1);

          return routerPath1.getRouteInstance.getPageRoute();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    logger.d('setNewRoutePath executed.');
    if (configuration.routeName != (_routePath?.routeName ?? '')) {
      logger.i('set new routePath = ' + configuration.routeName);
      _routePath = configuration;
      handler.changeRoutePath(configuration);
      routeInformationProvider.routerReportsNewRouteInformation(
          configuration.getRouteInstance.getRouteInformation());
    }
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
