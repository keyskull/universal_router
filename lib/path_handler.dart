part of 'route.dart';

class PathHandler extends ChangeNotifier {
  final logger = Logger(printer: CustomLogPrinter('PathHandler'));

  String _routeName = "";

  get routeName => _routeName;

  void changePath(String path) {
    _routeName = path;
    logger.d('routeName:' + routeName);
    final routePathInstance = RoutePath(routeName: path).getRouteInstance;
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: routePathInstance.title,
      primaryColor: 0,
    ));

    notifyListeners();
  }
}
