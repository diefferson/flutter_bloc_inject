import 'package:flutter/material.dart';
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';

import 'app_inject.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    AppInjector.initialise(Injector.getInjector());

    return MaterialApp(

      title: "Flutter Bloc Inject",

      theme: ThemeData(
          primaryColorDark: Colors.blue,
      ),

      home: BlocProvider<LoginBloc>(child:LoginScreen()),
    );

  }
}




