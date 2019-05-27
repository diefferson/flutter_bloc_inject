import 'package:flutter_bloc_inject/src/bloc.dart';
import 'package:flutter_bloc_inject/src/injector.dart';

class TypeBloc<T extends Bloc> {
  final BlocFactoryFnWithParamsFn<T> _factoryFn;

  T _instance;
  bool _isSingleton;

  TypeBloc(this._factoryFn, this._isSingleton);

  T get(Injector injector, Map<String, dynamic> additionalParameters) {
    if (_isSingleton && _instance != null) {
      return _instance;
    }

    final instance = _factoryFn(injector, additionalParameters);
    if (_isSingleton) {
      _instance = instance;
    }
    return instance;
  }
}
