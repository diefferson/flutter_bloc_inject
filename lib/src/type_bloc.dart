import 'package:flutter_bloc_inject/src/bloc.dart';
import 'package:flutter_bloc_inject/src/injector.dart';

class TypeBloc<T extends Bloc> {

  final BlocFactoryFnWithParamsFn<T> _factoryFn;

  T _instance;

  TypeBloc(this._factoryFn);

  T get(Injector injector,  Map<String, dynamic> additionalParameters) {

    if (_instance == null) {
      _instance = _factoryFn(injector,additionalParameters);
    }

    return _instance;
  }
}