part of 'route.dart';

class PathHandler extends ChangeNotifier {
  final logger = Logger(printer: CustomLogPrinter('PathHandler'));

  String routeName = "";

  /// TODO: Experimental Function
  RoutePath? routePath;

  void changePath(String path) {
    routeName = path;
    final routePathInstance = RoutePath(routeName: path).getRouteInstance;
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: routePathInstance.title,
      primaryColor: 0,
    ));

    logger.d('Changed path:' + routeName);
    notifyListeners();
  }

  /// TODO: Experimental Function
  void changeRoutePath(RoutePath routePath) {
    routePath = routePath;
    // SystemChrome.setApplicationSwitcherDescription(
    //     ApplicationSwitcherDescription(
    //       label: routePath.getRouteInstance.title,
    //       primaryColor: 0,
    //     ));

    logger.d('Changed path:' + routeName);
    notifyListeners();
  }
}
