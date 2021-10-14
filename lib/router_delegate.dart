part of 'route.dart';

class RouterDelegateInherit extends RouterDelegate<RoutePath>
    with PopNavigatorRouterDelegateMixin<RoutePath>, ChangeNotifier {
  final routerInformationParser = RouteInformationParserInherit();
  final routeInformationProvider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
          location: WidgetsBinding.instance!.window.defaultRouteName !=
                  Navigator.defaultRouteName
              ? WidgetsBinding.instance!.window.defaultRouteName
              : WidgetsBinding.instance!.window.defaultRouteName));

  final logger = Logger(printer: CustomLogPrinter('RouterDelegateInherit'));

  RoutePath? _routePath;

  List<Page<dynamic>> pages = [];

  final PathHandler handler = PathHandler();

  final GlobalKey<NavigatorState> navigatorKey = globalNavigatorKey;

  RoutePath get currentConfiguration {
    logger.d('currentConfiguration get executed.');
    final routPath = this._routePath ?? startPath ?? RoutePath();
    logger.d('routPath.routeName: ' + routPath.routeName);

    return routPath;
  }

  @override
  Widget build(BuildContext context) {
    logger.d('build executed');

    if (startPath != null) handler.routePath = startPath!;
    startPath = null;
    logger.d('handler.routeName: ${handler.routePath?.routeName}');
    final routePath = handler.routePath ?? RoutePath();
    _routePath = routePath;

    // initiate browser title
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: routePath.getRouteInstance.title,
      primaryColor: 0,
    ));
    pages.add(routePath.getRouteInstance.getPage());
    return Navigator(
      key: navigatorKey,
      pages: this.pages,
      onPopPage: (route, result) {
        final oldRoutePath = routePath.getRouteInstance;
        logger.i('Pop Executed = ' + oldRoutePath.routePath);
        logger.i('route.settings.name = ' + (route.settings.name ?? ''));
        if (!route.didPop(result)) return false;
        final newRoutePath = RoutePath(path: oldRoutePath.routePath);
        this.setNewRoutePath(newRoutePath);
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
      handler.changeRoutePath(configuration);
      routeInformationProvider.routerReportsNewRouteInformation(
          configuration.getRouteInstance.getRouteInformation());
    }
    logger.d('_routePath.routeName = ' + (_routePath?.routeName ?? ''));
    logger.d('configuration.routeName = ' + configuration.routeName);
    logger.d('currentConfiguration = ' + currentConfiguration.routeName);
    this._routePath = configuration;
    logger.d('update _routPath');
    logger.d('_routePath.routeName = ' + (_routePath?.routeName ?? ''));
    logger.d('currentConfiguration = ' + currentConfiguration.routeName);
    notifyListeners();
  }
}
