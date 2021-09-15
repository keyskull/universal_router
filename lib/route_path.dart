part of 'route.dart';

class RoutePath {
  final logger = Logger(printer: CustomLogPrinter('RoutePath'));
  String _path = '';
  String _routeName = '';
  RouteInstance _route = InitRouterBase.unknownPage;

  RoutePath({String? path = "/"}) {
    this.updateRouteName(path!);
  }

  RouteInstance get getRouteInstance => this._route;

  String get routeName => _routeName;
  String get path => _path;

  void updateRouteName(String path) {
    logger.d('updateRouteName executed.');
    this._path = path;
    this._routeName = path.startsWith('/', 0) ? path.substring(1) : path;
    final routeNameSplit = _routeName.split('/');
    this._route = _routeStack[_routeName] ??
        _routeStack[routeNameSplit.first] ??
        InitRouterBase.unknownPage;

    if (_route == InitRouterBase.unknownPage)
      this._route = this._route.createChildRouteInstance(
          extraInformation: 'Page Not Found.\n Wrong path:  $path');
    else if (routeNameSplit.length > 1)
      this._route = this._route.createChildRouteInstance(
          parameters: routeNameSplit.skip(1).join('/'));
    logger.i('this._path = ' + this._path);
    logger.i('this._route.title = ' + this._route.title);
    logger.i('this._routeName = ' + this._routeName);
    logger.i('this._routeStack = [' + _routeStack.keys.join(",") + ']');
    logger.i('this._route.routePath = ' + this._route.routePath);
    logger.i('this._route._parameters = ' + this._route.parameters);
  }
}
