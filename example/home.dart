import 'package:flutter/material.dart';
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';
import 'app_inject.dart';
import 'details.dart';
import 'service_one.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => HomeState();
}

class HomeState extends State<Home>{

  HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    homeBloc = AppInject.block(context);
    homeBloc.success();
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Bloc Inject")),
      body: Container(

      ),
      floatingActionButton: FloatingActionButton(onPressed: _goToDetails) ,
    );
  }

  void _goToDetails(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Details(),
      ));
  }
}

class HomeBloc  extends Bloc {

  final ServiceOne serviceOne;
  final ServiceTwo serviceTwo;

  HomeBloc(this.serviceOne, this.serviceTwo);

  void success(){
    print(serviceOne.value());
    print(serviceTwo.value());
  }

  @override
  void dispose() {
    print("diposed");
  }


}