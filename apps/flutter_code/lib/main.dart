import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget _widgetForRoute(String route) {
  switch(route) {
    case 'options':
      return OptionsPageStateful();
      break;
    default:
      return Center(
          child: Text('Unknown route $route', textDirection: TextDirection.ltr)
      );
  }
}

class OptionsPageStateful extends StatefulWidget {

  @override
  _OptionsPageState createState() => _OptionsPageState() ;
}

class _OptionsPageState extends State<OptionsPageStateful> {
  bool isHappy = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "User Options",
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),

        home: Scaffold(
            key: Key('container'),
            appBar: AppBar(
                title: Text("User Options")
            ),
            body: Builder(
                builder: (BuildContext scaffoldContext) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            key: Key('continue'),
                            onPressed: () {
                              Scaffold.of(scaffoldContext).showSnackBar(new SnackBar(
                                  content: new Text("Yay!!"),
                                  duration: Duration(milliseconds: 1500) ));
                              setState( () {
                                isHappy = true;
                              });
                            },
                            child: Text(
                              'Keep using the app',
                              style: TextStyle(fontSize: 20, color: Colors.green[400]),
                            ),
                          ),
                          FlatButton(
                            key: Key('quit'),
                            onPressed: () {
                              Scaffold.of(scaffoldContext).showSnackBar(new SnackBar(
                                  content: new Text("Awww!!"),
                                  duration: Duration(milliseconds: 1500) ));
                              setState( () {
                                isHappy = false;
                              });
                            },
                            child: Text(
                              'Ditch the app',
                              style: TextStyle(fontSize: 20, color: Colors.red[400]),
                            ),
                          ),
                          Icon( isHappy ? Icons.sentiment_satisfied : Icons.sentiment_dissatisfied, size: 48, key: Key('face')),
                        ]
                    ),
                  );
                })));

  }
}

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "User Options",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),

      home: Scaffold(
          key: Key('container'),
          appBar: AppBar(
              title: Text("User Options")
          ),
          body: Builder(
    builder: (BuildContext scaffoldContext) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              key: Key('continue'),
              onPressed: () {
                Scaffold.of(scaffoldContext).showSnackBar(new SnackBar(
                  content: new Text("Yay!!"),
                  duration: Duration(milliseconds: 1500) ));

              },
              child: Text(
                'Keep using the app',
                style: TextStyle(fontSize: 20, color: Colors.green[400]),
              ),
            ),
            FlatButton(
              key: Key('quit'),
              onPressed: null,
              child: Text(
                'Ditch the app',
                style: TextStyle(fontSize: 20, color: Colors.red[400]),
              ),
            ),
            Icon(Icons.sentiment_dissatisfied, size: 24, key: Key('face')),
            Icon(Icons.sentiment_satisfied, size: 24),
          ]
        ),
      );
    })));
    }
  }




