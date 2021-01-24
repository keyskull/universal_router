part of '../router.dart';

class _RouteSetting {
  static final page = _Page();
}

class _Page {
  Widget Function({String errorMessage}) unknownError =
      ({String errorMessage}) => UnknownError(errorMessage: errorMessage);
  Widget Function({String path}) noPathError =
      ({String path}) => NoPathError(path: path);
}
