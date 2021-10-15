part of 'route.dart';

class PathHandler {
  final logger = Logger(printer: CustomLogPrinter('PathHandler'));

  @Deprecated(
    'no longer use this variable',
  )
  String routeName = '';

  RoutePath? routePath;

  @Deprecated('use UniversalRouter.changePath instead')

  ///
  /// use UniversalRouter.changePath instead
  ///
  void changePath(String path) {
    routeName = path;
    final routePathInstance = RoutePath(path: path).getRouteInstance;
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: routePathInstance.title,
      primaryColor: 0,
    ));

    logger.d('Changed path:' + routeName);
    // notifyListeners();
  }

  void changeRoutePath(RoutePath routePath) {
    logger.d('Changed path:' + routePath.routeName);

    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: routePath.getRouteInstance.title,
      primaryColor: 0,
    ));

    this.routePath = routePath;
  }
}
