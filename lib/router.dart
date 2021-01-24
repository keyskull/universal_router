import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'ui/views/direct_interface/error/no_path_error.dart';
import 'ui/views/direct_interface/error/unknown_error.dart';

part 'route/setting.dart';

part 'route/route_register.dart';

part 'route/async_material_page_route.dart';

part 'services/navigation_service.dart';

final GetIt _locator = GetIt.instance;
final _route = _locator<_NavigationService>();
final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

class Router {
  final GlobalKey<NavigatorState> navigatorKey = _navigatorKey;

  Router() {
    _locator.registerLazySingleton(() => _NavigationService());
    _RouteRegister.singlePageRegister('unknown', _RouteSetting.page.unknownError);
    _RouteRegister.singlePageRegister('no_path', _RouteSetting.page.noPathError);
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    if (_RouteRegister.getList().contains(settings.name))
      return AsyncMaterialPageRoute(
          settings: settings, child: _RouteRegister.navigateTo(settings.name));
    else
      return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              _RouteSetting.page.noPathError(path: settings.name));
  }


  static errorPage() => _RouteSetting.page;

  static navigateReplacementTo(String routeName, {dynamic arguments}) =>
      _route.navigateReplacementTo(routeName, arguments: arguments);

  static navigateTo(String routeName, {dynamic arguments}) =>
      _route.navigateTo(routeName, arguments: arguments);

  static goBack() => _route.goBack();

  setUnknownError(Widget Function({String errorMessage}) function) {
    _RouteSetting.page.unknownError = function;
  }

  setNoPathError(Widget Function({String path}) function) {
    _RouteSetting.page.noPathError = function;
  }
}
