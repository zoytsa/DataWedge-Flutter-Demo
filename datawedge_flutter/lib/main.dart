import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/home_page.dart';
import 'package:datawedgeflutter/login_signup.dart';
//import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Settings>('settings');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  //final _myTabbedPageKey = GlobalKey<MyHomePageState>();

  @override
  Widget build(BuildContext context) {
    Box<Settings> box = Hive.box<Settings>('settings');
    //  var box = await Hive.openBox<Settings>('settings');
    Settings? userIDSettings = box.get("userID");
    if (userIDSettings != null) {
      selectedUser = users[userIDSettings.value];
      if (selectedUser.id != 111111 && selectedUser.id != 0) {
        print(selectedUser.id);
        isAuthorized = true;
      }
    } else {
      selectedUser = users[0];
    }

    return MaterialApp(
      title: 'DCT',
      //showSemanticsDebugger: true,
      //showPerformanceOverlay: true,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo,
        canvasColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isAuthorized ? MyHomePage(title: 'DCT') : LoginSignupScreen(),
      debugShowCheckedModeBanner: false,
      // key: _myTabbedPageKey,
    );
  }
}
