
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';

import 'home.dart';
import 'service_one.dart';

class AppInject {

  static T inject<T>(){
    try{
      final injector = Injector.getInjector();
      return injector.get<T>();
    }catch(e){
      init();
      final injector = Injector.getInjector();
      return injector.get<T>();
    }
  }

  static T block<T extends Bloc>(BuildContext context){
    try{
      final injector = Injector.getInjector();
      return injector.getBloc<T>(context);
    }catch(e){
      init();
      final injector = Injector.getInjector();
      return injector.getBloc<T>(context);
    }
  }

  static void init() {
    Injector.getInjector()
    ..single<ServiceOne>((i) => ServiceOne())
    ..single<ServiceTwo>((i) => ServiceTwo())
    ..bloc<HomeBloc>((i) => HomeBloc(i.get(), i.get()));
  }
}