part of '../router.dart';


class _RouteRegister{
  static final Map<String, Widget Function() > _routeTable = Map();

  static singlePageRegister(String name, Widget Function() function){
      _routeTable[name] = function;
  }

  static List<String> getList() => _routeTable.keys;

  static Widget navigateTo(String name) => _routeTable[name]();

}

