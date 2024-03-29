part of 'route.dart';

Map<String, Function(RoutePath routePath)> _routePathListeners = {};

RoutePath? startPath;

class RouteInformationParserInherit extends RouteInformationParser<RoutePath> {
  final logger =
      Logger(printer: CustomLogPrinter('RouteInformationParserInherit'));

  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final path = (routeInformation.location ?? '/');

    logger.d('parseRouteInformation executed');
    logger.i('routeInformation.location = ' + path);
    logger.i('startPath.path = ' + (startPath?.path ?? ''));

    if ((startPath?.path ?? '') != path) {
      logger.d('startPath updated.');
      startPath = RoutePath(path: path);
    }
    return startPath!;
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath configuration) {
    logger.d('restoreRouteInformation executed');

    logger.i('restoreRouteInformation = ' + configuration.routeName);
    logger.i('routePath.getRouteInstance.getRouteInformation().location = ' +
        (configuration.getRouteInstance.getRouteInformation().location ?? ''));
    logger.i('routePath.getRouteInstance.getRouteInformation().state = ' +
        configuration.getRouteInstance.getRouteInformation().state.toString());

    return configuration.getRouteInstance.getRouteInformation();
  }
}
