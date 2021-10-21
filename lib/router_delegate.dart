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
  RoutePath? _navigatorRoutePath;

  List<Page<dynamic>> pages = [];

  final PathHandler handler = PathHandler();

  @override
  final GlobalKey<NavigatorState> navigatorKey = globalNavigatorKey;

  @override
  RoutePath get currentConfiguration {
    logger.d('currentConfiguration get executed.');
    final routPath = _routePath ?? startPath ?? RoutePath();
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
      pages: pages,
      onPopPage: (route, result) {
        final oldRoutePath = routePath.getRouteInstance;
        logger.i('Pop Executed = ' + oldRoutePath.routePath);
        logger.i('route.settings.name = ' + (route.settings.name ?? ''));
        if (!route.didPop(result)) return false;
        final newRoutePath = RoutePath(path: oldRoutePath.routePath);
        _navigatorRoutePath = newRoutePath;
        setNewRoutePath(newRoutePath);
        return true;
      },
      onGenerateRoute: (setting) {
        logger.i(
            "onGenerateRoute RouteSettings: [name: ${setting.name ?? ''}, arguments: ${setting.arguments ?? ''}]");
        if ((_routePath?.path ?? '-') == setting.name) {
          return _routePath!.getRouteInstance.getPageRoute();
        } else {
          final newRouterPath = RoutePath(path: setting.name);
          _navigatorRoutePath = newRouterPath;
          setNewRoutePath(newRouterPath);
          return newRouterPath.getRouteInstance.getPageRoute();
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

    _routePath = configuration;

    ///
    /// Prevent path has change but router has move to new page.
    ///
    if (_navigatorRoutePath != _routePath) {
      _navigatorRoutePath = _routePath;
      navigatorKey.currentState?.pushNamed(_routePath?.path ?? '');
    }

    // logger.i('_routePathListeners = ' + _routePathListeners.toString());

    ///
    ///  execute listeners
    ///
    for (var e in _routePathListeners.values) {
      e(configuration);
    }
    notifyListeners();
  }
}
