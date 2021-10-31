import 'package:datawedgeflutter/model/dataloader.dart';
import 'package:datawedgeflutter/UI/home_screen.dart';
import 'package:datawedgeflutter/UI/login_signup_screen.dart';
//import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/settings.dart';
import 'package:datawedgeflutter/presentation/cubit/goods_items_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/constants.dart';
import 'presentation/cubit/profile_cubit.dart';
import 'presentation/cubit/selected_products_cubit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Settings>('settings');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ProfileCubit(),
      ),
      BlocProvider(
        create: (context) => SelectedProductsCubit(),
      ),
      BlocProvider(
        create: (context) => GoodsItemsCubit(),
      ),
    ],
    child: MyApp(),
  ));
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
      //   Settings? userIDSettings = box.get("userID");
      // if (userIDSettings != null) {
      //   selectedUser = users[userIDSettings.value];
      // } else {
      //   selectedUser = users[0];
      // }

      Settings? documentTypeIDSettings = box.get("documentTypeID");
      if (documentTypeIDSettings != null) {
        kSelectedDocumentType =
            DocumentType.getDocumentTypesByID(documentTypeIDSettings.value);
      } else {
        kSelectedDocumentType = documentTypes[0];
      }

      Settings? marketIDSettings = box.get("marketID");
      if (marketIDSettings != null) {
        selectedMarket = markets[marketIDSettings.value];
      } else {
        selectedMarket = markets[0];
      }

      Settings? profileIDSettings = box.get("profileID");
      if (profileIDSettings != null) {
        selectedProfile = profileIDSettings.value is int
            ? profiles[profileIDSettings.value]
            : selectedProfile = profiles[0];
      } else {
        selectedProfile = profiles[0];
      }

      // Settings? profileDataSettings = box.get("profileData");
      // if (profileDataSettings != null) {
      //   //converting map dynamic dynamic to map string dynamic
      //   Map<String, dynamic> dataJson = {};
      //   profileDataSettings.value.forEach((k, v) => dataJson[k.toString()] = v);
      //   selectedProfile = Profile.fromJson(dataJson);
      //   print(selectedProfile);
      // }

      BlocProvider.of<ProfileCubit>(context).updateProfileState(
          selectedUser,
          selectedMarket,
          kSelectedDocumentType,
          selectedProfile,
          usingZebra,
          isAuthorized);
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
