## Usage example

Import `flutter_bloc_inject`

```dart
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';
```

### Injector Configuration

As this injector relies on factories rather than reflection (as mirrors in not available in Flutter)
each mapped type needs to provide a factory function.  In most cases this can just be a simple 
new object returned function.  In slightly more advanced scenarios where the type to be created relies
on other types an injector instances is passed into the factory function to allow the type of be created
to get other types it depends on (see below for examples).
    
```dart
import 'package:flutter_bloc_inject/flutter_bloc_inject.dart';

class AppInjector {
  
  static const _NAME = "BaseInjector";

  static getInjector() => Injector.getInjector(_NAME);
  
  Injector initialise() {
      return getInjector()
        // Single Instance with dynamic params
        ..singleWithParams<RestApi>((i, p) => RestApi(p["url"])) 
         // Single instance with injection parameters
        ..single<UserRepository>((i) => UserRepository(i.get<RestApi>()))
        // Factory to always provide a new instance
        ..factory<LoginInteractor>((i) => LoginInteractor(i.get<UserRepository>())) 
         // Bloc to use with Bloc provider and inject in a Widget
        ..bloc<LoginBloc>((i) => LoginBloc(i.get<LoginInteractor>()));
        
        //Injector also has factoryWithParams and blocWithParams method 
  }
}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    //Remember that initialize your dependencies map on start your application
    AppInjector.initialise();

    return MaterialApp(
      title: "Flutter Bloc Inject",
      theme: ThemeData(
          primaryColorDark: Colors.blue,
      ),

      //Bloc provider inject HomeBloc with Home widget context to provides auto dispose to Bloc when widget is disposed
      home: BlocProvider<HomeBloc>(
        child:LoginScreen(),
        injector: AppInjector.getInjector() 
      ),
    );

  }
}

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{

  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    
    //Use method getBloc to receive a instance of your contextualized Bloc
     _loginBloc = AppInjector.getInjector().getBloc<LoginBloc>(context);
    
    return  Container(
        child: Text("My beautiful login screen"),
    );
  }
}


//Your Blocs should extends Bloc class to have auto dispose feature and use methods bloc and getBloc of Injector
class LoginBloc  extends Bloc {

  final LoginInteractor _loginInteractor;

  LoginBloc(this._loginInteractor);
  
  ...

  @override
  void dispose() {
    print("Called when LoginScreen is deposed");
    print("Here you dispose yours Futures and Streams");
  }

}

//Injection is transparent for the classes, so you should have a clean code \0/
class LoginInteractor{

  final UserRepository _userRepository;

  LoginInteractor(this._userRepository);

}

class UserRepository{

  final RestApi _restApi;

  UserRepository(this._restApi);
  
  ...
}

class RestApi{

  final String url;

  RestApi(this.url);
  
  ...
}

```

### Multiple Injectors

The Injector class has a static method [getInjector] that by default returns the default instance of the injector.  In most cases this will be enough.
However, you can pass a name into this method to return another isolated injector that is independent from the default injector.  Passing in a new 
injector name will create the injector if it has not be retrieved before.  To destroy isolated injector instances call their [dispose] method.

```dart
  final defaultInjector = Injector.getInjector();
  final isolatedInjector = Injector.getInjector("Isolated");
```