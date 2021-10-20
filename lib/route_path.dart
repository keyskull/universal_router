part of 'route.dart';

class RoutePath {
  final logger = Logger(printer: CustomLogPrinter('RoutePath'));
  String _path = '';
  String _routeName = '';
  RouteInstance _route = UniversalRouter.unknownPage;

  RoutePath({String? path = '/'}) {
    updateRouteName(path!);
  }

  RouteInstance get getRouteInstance => _route;

  String get routeName => _routeName;

  String get path => _path;

  void updateRouteName(String path) {
    logger.d('updateRouteName executed.');
    _path = path;
    _routeName = _path.startsWith('/', 0)
        ? path.substring(1)
        : () {
            _path = '/' + _path;
            return path;
          }();
    final routeNameSplit = _routeName.split('/');
    _route = _routeStack[_routeName] ??
        _routeStack[routeNameSplit.first] ??
        UniversalRouter.unknownPage;

    if (_route == UniversalRouter.unknownPage) {
      _route = _route.createChildRouteInstance(
          extraInformation: 'Page Not Found.\n Wrong path:  $path',
          title: 'Page Not Found.');
    } else if (routeNameSplit.length > 1) {
      _route = _route.createChildRouteInstance(
          parameters: routeNameSplit.skip(1).join('/'));
    }
    logger.i('this._path = ' + _path);
    logger.i('this._route.title = ' + _route.title);
    logger.i('this._routeName = ' + _routeName);
    logger.i('this._routeStack = [' + _routeStack.keys.join(',') + ']');
    logger.i('this._route.routePath = ' + _route.routePath);
    logger.i('this._route._parameters = ' + _route.parameters);
  }
}
