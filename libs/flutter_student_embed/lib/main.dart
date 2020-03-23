import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_student_embed/l10n/app_localizations.dart';
import 'package:flutter_student_embed/screens/calendar/calendar_screen.dart';
import 'package:flutter_student_embed/utils/NativeComm.dart';
import 'package:flutter_student_embed/utils/db/db_util.dart';
import 'package:flutter_student_embed/utils/design/student_theme.dart';
import 'package:flutter_student_embed/utils/design/theme_prefs.dart';
import 'package:flutter_student_embed/utils/service_locator.dart';

import 'network/utils/api_prefs.dart';

void main() async {
  await warm();
  launchApp();
}

Future<void> warm() async {
  print('Warming up the engine!');
  WidgetsFlutterBinding.ensureInitialized();
  NativeComm.init();

  await Future.wait([
    ApiPrefs.init(),
    ThemePrefs.init(),
    DbUtil.init(),
  ]);
  setupLocator();
}

void launchApp() {
  print('Launching the app!');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  rebuild(locale) {
    setState(() => _locale = locale);
  }

  @override
  void initState() {
    super.initState();
    _locale = Locale('en'); // FIXME
  }

  @override
  Widget build(BuildContext context) {
    return StudentTheme(
      builder: (context, themeData) => MaterialApp(
        title: 'Flutter Demo',
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          // Material components use these delegate to provide default localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        localeResolutionCallback: _localeCallback(),
        theme: themeData,
        home: CalendarScreen(),
      ),
    );
  }

  // Get notified when there's a new system locale so we can rebuild the app with the new language
  LocaleResolutionCallback _localeCallback() => (locale, supportedLocales) {
        const fallback = Locale('en', '');
        Locale resolvedLocale =
            AppLocalizations.delegate.resolution(fallback: fallback, matchCountry: false)(locale, supportedLocales);

        // Update the state if the locale changed
        if (_locale != resolvedLocale) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() => _locale = resolvedLocale);
          });
        }

        return resolvedLocale;
      };
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
