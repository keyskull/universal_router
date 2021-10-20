part of 'route.dart';

typedef PageBuilder = Future<Widget> Function(
    String? parameters, dynamic extraInformation);

class RouteInstance {
  final logger = Logger(printer: CustomLogPrinter('RouteInstance'));
  final String routePath;
  final PageBuilder pageBuilder;
  final String Function(String parameters, String parentTitle)
      childPageTitleBuilder;
  final String title;
  final String parameters;
  final String path;
  final dynamic extraInformation;
  final Widget widget;

  RouteInstance(
      {required this.routePath,
      required this.pageBuilder,
      String? title,
      this.parameters = '',
      this.extraInformation,
      String Function(String parentTitle, String path)? childPageTitleBuilder})
      : path = parameters == ''
            ? '/' + routePath
            : '/' + routePath + '/' + parameters,
        title = title ?? routePath,
        widget =
            AsyncLoadPage(future: pageBuilder(parameters, extraInformation)),
        childPageTitleBuilder = childPageTitleBuilder ??
            ((parameters, parentTitle) => parentTitle) {
    _routeStack[path.substring(1)] = this;
  }

  createChildRouteInstance(
      {String parameters = '', String? title, dynamic extraInformation}) {
    return RouteInstance(
        routePath: routePath,
        pageBuilder: pageBuilder,
        title: title ?? childPageTitleBuilder(parameters, this.title),
        parameters: parameters,
        extraInformation: extraInformation);
  }

  RouteInformation getRouteInformation() {
    logger.d('getRouteInformation:' + path);
    return RouteInformation(location: path);
  }

  bool remove() => _routeStack[path.substring(1)]?.remove() ?? false;

  MaterialPage getPage() {
    logger.d('getPage executed');
    logger.i('path:' + routePath);
    logger.i('parameter:' + parameters);
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
