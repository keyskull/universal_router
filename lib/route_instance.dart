part of 'route.dart';

class RouteInstance {
  final logger = Logger(printer: CustomLogPrinter('RouteInstance'));
  final String routePath;
  final PageBuilder pageBuilder;
  final String title;
  final String parameters;
  final String path;
  final dynamic extraInformation;
  late final widget = AsyncLoadPage(
      future: pageBuilder(parameters, extraInformation)
          .then((value) => _decorationLayer(child: value)));

  RouteInstance(
      {required this.routePath,
      required this.pageBuilder,
      String? title,
      this.parameters = '',
      this.extraInformation})
      : path = parameters == ''
            ? '/' + routePath
            : '/' + routePath + '/' + parameters,
        title = title ?? routePath {
    _routeStack[this.path.substring(1)] = this;
  }

  createChildRouteInstance({String parameters = '', dynamic extraInformation}) {
    return new RouteInstance(
        routePath: this.routePath,
        pageBuilder: this.pageBuilder,
        title: this.title,
        parameters: parameters,
        extraInformation: extraInformation);
  }

  RouteInformation getRouteInformation() {
    logger.d("getRouteInformation:" + path);
    return RouteInformation(location: path);
  }

  bool remove() => _routeStack[this.path.substring(1)]?.remove() ?? false;

  MaterialPage getPage() {
    logger.d('getPage executed');
    logger.i("path:" + routePath);
    logger.i("parameter:" + parameters);
    return MaterialPage(
        key: ValueKey(RouteData(
          path: path,
          title: title,
          parameters: parameters,
          routePath: routePath,
        )),
        child: widget);
  }

  Route getPageRoute() {
    logger.d('getPageRoute executed');

    return MaterialPageRoute(builder: (_) => widget);
  }
}
