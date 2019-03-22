
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';

import 'home.dart';
import 'service_one.dart';

class AppInjector {

  static Injector injector() => Injector.getInjector();

  static Injector initialise(Injector injector) {
    return injector
    ..singleWithParams<RestApi>((i, p) => RestApi(p["url"])) // Single Instance with dynamic params
    ..single<UserRepository>((i) => UserRepository(i.get<RestApi>())) // Single instance with injection parameters
    ..factory<LoginInteractor>((i) => LoginInteractor(i.get<UserRepository>())) // Factory to always provide a new instance
    ..bloc<LoginBloc>((i) => LoginBloc(i.get<LoginInteractor>())); // Bloc to use with Bloc provider and inject in a Widget
  }
}


