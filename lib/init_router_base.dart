import 'pages/404.dart' deferred as error;
import 'route.dart';

class InitRouterBase {
  static final unknownPage = RouteInstance(
      routePath: "404",
      title: 'Page not Found',
      pageBuilder: (parameters, extraInformation) => error
          .loadLibrary()
          .then((_) => error.UnknownScreen(errorMSG: extraInformation.toString())));
}
