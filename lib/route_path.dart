part of 'route.dart';

class RoutePath {
  final logger = Logger(printer: CustomLogPrinter('RoutePath'));
  String _routeName = '';
  RouteInstance _route = InitRouterBase.unknownPage;

  RoutePath({String routeName = ""}) {
    this.updateRouteName(routeName);
  }

  RouteInstance get getRouteInstance => this._route;

  String get routeName => _routeName;

  void updateRouteName(String routeName) {
    this._routeName =
        routeName.startsWith('/', 0) ? routeName.substring(1) : routeName;
    final routeNameSplit = _routeName.split('/');
    this._route = _routeStack[_routeName] ??
        _routeStack[routeNameSplit.first] ??
        InitRouterBase.unknownPage;

    if (_route == InitRouterBase.unknownPage)
      this._route = this
          ._route
          .createChildRouteInstance(extraInformation: 'Page Not Found.');
    else if (routeNameSplit.length > 1)
      this._route = this._route.createChildRouteInstance(
          parameters: routeNameSplit.skip(1).join('/'));

    logger.d('this._routeName = ' + this._routeName);
    logger.d('this._routeStack = [' + _routeStack.keys.join(",") + ']');
    logger.d('this._route.routePath = ' + this._route.routePath);
    logger.d('this._route._parameters = ' + this._route.parameters);
  }
}
