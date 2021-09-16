# `universal_router` [![pub package](https://img.shields.io/pub/v/universal_router.svg)](https://pub.dartlang.org/packages/universal_router)

This package is a implementation of Navigator 2.0 in Flutter.

## Features

- Easy to use.
- Router table concept.
- Various parameter setting.

## Install

Install by adding this package to your `pubspec.yaml`:

```yaml
dependencies:
  universal_router: ^[latest version]
```

## Usage
---

### Import

```dart
import 'package:universal_router/route.dart';
```

### Simple Example

```dart

import 'package:universal_router/route.dart';



void main() {
  final universalRouter = UniversalRouter.initialize();

  RouteInstance(
      routePath: "",
      title: "Home",
      pageBuilder: (_, __) async => Home());

  runApp(
      MaterialApp.router(
        routerDelegate: universalRouter.routerDelegate,
        routeInformationProvider: universalRouter.routeInformationProvider,
        routeInformationParser: universalRouter.routerInformationParser,
      ));
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: () => {UniversalRouter.changePath("somewhere")},
          child: Text('go to somewhere else'));

}


```

# License

Copyright © 2021, [Jialin Li](https://github.com/keyskull).  
Released under the [GNU AGPLv3](LICENSE).