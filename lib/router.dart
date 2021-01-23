
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:router/ui/views/direct_interface/error/no_path_error.dart';
import 'package:router/ui/views/direct_interface/error/unknown_error.dart';

part 'route/setting.dart';

part 'route/route_register.dart';

part 'route/async_material_page_route.dart';

part 'services/navigation_service.dart';

GetIt locator = GetIt.instance;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (_RouteRegister.getList().contains(settings.name))
      return AsyncMaterialPageRoute(
          settings: settings, child: _RouteRegister.navigateTo(settings.name));
    else
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => _RouteSetting.page.noPathError(path: settings.name));
  }

  static initial() {
    locator.registerLazySingleton(() => NavigationService());
    _RouteRegister.register('unknown', _RouteSetting.page.unknownError);
    _RouteRegister.register('no_path', _RouteSetting.page.noPathError);
    return Router();
  }

  static errorPage() => _RouteSetting.page;

  final route = locator<NavigationService>();

  setUnknownError(Widget Function({String errorMessage}) function) {
    _RouteSetting.page.unknownError = function;
  }

  setNoPathError(Widget Function({String path}) function) {
    _RouteSetting.page.noPathError = function;
  }

}
