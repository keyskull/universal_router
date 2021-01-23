part of '../router.dart';

typedef Widget Builder(BuildContext context);

class AsyncMaterialPageRoute extends MaterialPageRoute {
  final RouteSettings settings;
  final Widget child;
  final Builder builder;

  AsyncMaterialPageRoute({this.settings, this.child, this.builder})
      : super(
            settings: settings,
            builder: (context) =>
                _AsyncLoadPage(child: child, builder: builder));
}

class _AsyncLoadPage extends StatelessWidget {
  final Widget child;
  final Builder builder;

  _AsyncLoadPage({this.child, this.builder})
      : assert(builder != null || child != null);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return new FutureBuilder(future: Future(() async {
      // await new Future.delayed(new Duration(seconds: 10));
      return this.child ?? builder(context);
    }), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError)
          return _RouteSetting.page
              .unknownError(errorMessage: snapshot.error.toString());
        return snapshot.data;
      } else {
        return Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Loading",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 50),
            ),
            Container(
              height: width / 2,
              width: width / 2,
              child: SizedBox.expand(
                  child: CircularProgressIndicator(strokeWidth: 10)),
            )
          ],
        );
      }
    });
  }
}
