part of 'route.dart';

class PathHandler extends ChangeNotifier {
  final logger = Logger(printer: CustomLogPrinter('PathHandler'));

  String routeName = "";

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
}
