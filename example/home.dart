import 'package:flutter/material.dart';
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{

  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {

    _loginBloc = Injector.getInjector().getBloc(context);

    return  Container(
        child: Text("My beautiful login screen"),
    );
  }
}

class LoginBloc  extends Bloc {

  final LoginInteractor _loginInteractor;

  LoginBloc(this._loginInteractor);

  @override
  void dispose() {
    print("Called when LoginScreen is deposed");
    print("Here you dispose yours Futures and Streams");
  }

}


class LoginInteractor{

  final UserRepository _userRepository;

  LoginInteractor(this._userRepository);

}

class UserRepository{

  final RestApi _restApi;

  UserRepository(this._restApi);

}

class RestApi{

  final String url;

  RestApi(this.url);

}