part of '../router.dart';

class _NavigationService {
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateReplacementTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return _navigatorKey.currentState.pop();
  }
}
