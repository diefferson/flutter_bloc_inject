
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_inject/src/injector.dart';

abstract class Bloc {
  void dispose(){}
}

class BlocProvider<T extends Bloc> extends StatefulWidget {

  BlocProvider({Key key, @required this.child}) : super(key: key);

  final T bloc = Injector.getInjector().injectBloc<T>();
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends Bloc>(BuildContext context) {
    final type = _typeOf<_HelperBlocProvider<T>>();
    _HelperBlocProvider<T> provider =
    context.inheritFromWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<Bloc>> {

  @override
  void dispose() {
    bloc.dispose();
    Injector.getInjector().disposeBloc(bloc);
    super.dispose();
  }

  T bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    return _HelperBlocProvider<T>(
      child: widget.child,
      bloc: bloc,
    );
  }
}

class _HelperBlocProvider<T extends Bloc> extends InheritedWidget {

  final T bloc;

  _HelperBlocProvider({this.bloc, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}
