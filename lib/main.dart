import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/UserFavorites.dart';
import 'package:hello_me/common/them.dart';
import 'package:hello_me/imageService.dart';
import 'package:hello_me/screens/RandomWords.dart';
import 'package:provider/provider.dart';

import 'UserState.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState.instance()),
        ChangeNotifierProxyProvider<UserState, UserFavorites>(
          create: (_) => UserFavorites.instance(),
          update: (_, userState, userFavorites) =>
              userFavorites.update(userState),
        ),
        ChangeNotifierProxyProvider<UserState, ImageService>(
          create: (_) => ImageService(),
          update: (_, userState, imageService) {
            imageService.userState = userState;
            return imageService;
          },
        )
      ],
      child: MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(primaryColor: darkRed),
        home: RandomWords(),
      ),
    );
  }
}
