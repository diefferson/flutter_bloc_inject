import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_inject/src/bloc.dart';
import 'package:flutter_bloc_inject/src/injector_exception.dart';
import 'package:flutter_bloc_inject/src/type_bloc.dart';
import 'package:flutter_bloc_inject/src/type_factory.dart';

typedef T ObjectFactoryFn<T>(Injector injector);
typedef T ObjectFactoryWithParamsFn<T>(Injector injector, Map<String, dynamic> additionalParameters);

typedef T BlocFactoryFn<T extends Bloc>(Injector injector);
typedef T BlocFactoryFnWithParamsFn<T extends Bloc>(Injector injector, Map<String, dynamic> additionalParameters);

class Injector {

  static final Map<String, Injector> _injectors = Map<String, Injector>();
  final Map<String, TypeFactory<Object>> _factories = Map<String, TypeFactory<Object>>();
  final Map<String, TypeBloc<Bloc>> _blocs = Map<String, TypeBloc<Bloc>>();

  /// The name of this injector.
  ///
  /// Naming injectors enable each app to have multiple atomic injectors.
  final String name;

  static Injector getInjector([String name = "default"]) {
    if (!_injectors.containsKey(name)) {
      _injectors[name] = Injector._internal(name);
    }

    return _injectors[name];
  }

  Injector._internal(this.name);

  String _makeKey<T>(T type, [String key]) => "${type.toString()}::${key == null ? "default" : key}";

  void _map<T>(ObjectFactoryFn<T> factoryFn,
      {bool isSingleton = false, String key}) {
    final objectKey = _makeKey(T, key);
    if (_factories.containsKey(objectKey)) {
      throw InjectorException("Mapping already present for type '$objectKey'");
    }
    _factories[objectKey] = TypeFactory<T>((i, p) => factoryFn(i), isSingleton);
  }

  void _mapWithParams<T>(ObjectFactoryWithParamsFn<T> factoryFn,
      {bool isSingleton = false,String key}) {
    final objectKey = _makeKey(T, key);
    if (_factories.containsKey(objectKey)) {
      throw InjectorException("Mapping already present for type '$objectKey'");
    }
    _factories[objectKey] = TypeFactory<T>(factoryFn, isSingleton);
  }

  void single<T>(ObjectFactoryFn<T> factoryFn, {String key}) {
    _map(factoryFn, isSingleton: true, key: key);
  }

  void singleWithParams<T>(ObjectFactoryWithParamsFn<T> factoryFn, {String key}) {
    _mapWithParams(factoryFn, isSingleton: true, key: key);
  }

  void factory<T>(ObjectFactoryFn<T> factoryFn, {String key}) {
    _map(factoryFn, isSingleton: false, key: key);
  }

  void factoryWithParams<T>(ObjectFactoryWithParamsFn<T> factoryFn, {String key}) {
    _mapWithParams(factoryFn, isSingleton: false, key: key);
  }

  void bloc<T extends Bloc>(BlocFactoryFn<T> factoryFn, {String key}){
    final objectKey = _makeKey(T, key);
    if (_blocs.containsKey(objectKey)) {
      throw InjectorException("Mapping already present for type '$objectKey'");
    }
    _blocs[objectKey] = TypeBloc<T>((i, p) => factoryFn(i));
  }

  void blocWithParams<T extends Bloc>(BlocFactoryFnWithParamsFn<T> factoryFn, {String key}){
    final objectKey = _makeKey(T, key);
    if (_blocs.containsKey(objectKey)) {
      throw InjectorException("Mapping already present for type '$objectKey'");
    }
    _blocs[objectKey] = TypeBloc<T>(factoryFn);
  }

  T get<T>({String key, Map<String, dynamic> additionalParameters}) {
    final objectKey = _makeKey(T, key);
    final objectFactory = _factories[objectKey];
    if (objectFactory == null) {
      throw InjectorException(
          "Cannot find object factory for '$objectKey'");
    }

    return objectFactory.get(this, additionalParameters);
  }

  T injectBloc<T extends Bloc>({String key, Map<String, dynamic> additionalParameters}) {
    final objectKey = _makeKey(T, key);
    final objectFactory = _blocs[objectKey];
    if (objectFactory == null) {
      throw InjectorException(
          "Cannot find object factory for '$objectKey'");
    }

    return objectFactory.get(this, additionalParameters);
  }

  T getBloc<T extends Bloc>(BuildContext context) {
    return BlocProvider.of<T>(context);
  }

  /// Disposes of the injector instance and removes it from the named collection of injectors
  void dispose() {
    _factories.clear();
    _blocs.clear();
    _injectors.remove(name);
  }

  void disposeBloc(Bloc bloc){
    _blocs.remove(bloc);
  }
}