part of 'route.dart';

class RouteData {
  final String routePath;
  final String title;
  final String parameters;
  final String path;

  RouteData(
      {required this.routePath,
      required this.parameters,
      required this.title,
      required this.path});

  bool isRoot() => parameters.isEmpty;
}
