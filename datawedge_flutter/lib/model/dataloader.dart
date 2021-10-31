import 'dart:async';
import 'dart:convert';
import 'package:datawedgeflutter/UI/home_screen.dart';
import 'package:datawedgeflutter/UI/login_signup_screen.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/settings.dart';
import 'package:datawedgeflutter/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

enum FormatMarket { gipermarket, supermarket, express, gurme }
enum ReportPeriodFormat {
  forToday,
  forThisWeek,
  forThisMonth,
  forThisYear,
  forTodayAndYesterday,
  forThisWeekAndLastWeek,
  ForThisMonthAndLastMonth,
  ForThisYearAndLastYear
}

class User {
  int id = 0;
  String name = "";
  IconData icon = Icons.account_balance_wallet;
  Market market = markets[0];
  bool useMultiProfiles = false;
  User(this.id, this.name, this.market, this.icon);

  static List<User> getUsers() {
    return <User>[
      User(0, '<не выбран>', markets[0], Icons.unfold_more),
      User(1, 'Иванов', markets[0], Icons.agriculture_rounded),
      User(2, 'Петров', markets[0], Icons.agriculture_rounded),
      User(3, 'Сидоров', markets[0],
          Icons.airline_seat_legroom_reduced_outlined),
      User(4, 'Трамп', markets[0], Icons.airline_seat_recline_extra_sharp),
      User(5, 'Путин', markets[0], Icons.airline_seat_recline_extra_sharp),
    ];
  }
}

class Market {
  int id = 0;
  String name = "";
  FormatMarket format = FormatMarket.gipermarket;
  IconData icon = Icons.account_balance_wallet;
  Market(this.id, this.name, this.format, this.icon);

  static List<Market> getMarkets() {
    return <Market>[
      Market(
          0, '<маркет не выбран>', FormatMarket.gipermarket, Icons.unfold_more),
      Market(1, 'Льва Толстого', FormatMarket.gipermarket,
          Icons.account_balance_sharp),
      Market(2, 'Көк-Жар', FormatMarket.express, Icons.account_balance_wallet),
      Market(3, 'Ош', FormatMarket.supermarket, Icons.flip_to_front_outlined),
      //Market(4, 'Ф04', FormatMarket.supermarket, Icons.flip_to_front_outlined),
      //Market(5, 'Ф05', FormatMarket.gipermarket, Icons.account_balance_sharp),
    ];
  }
}

class DocumentType {
  // Операции
  int id = 0;
  String name = "";
  IconData icon = Icons.ad_units;
  ImageIcon? imageIcon;
  DocumentType(this.id, this.name, this.icon, this.imageIcon);

  static List<DocumentType> getDocumentTypes() {
    return [
      DocumentType(
          2,
          'Печать ценников',
          Icons.sell_outlined,
          ImageIcon(AssetImage("assets/icons/icon_price_tag.png"),
              color: Colors.black)),
      DocumentType(1, 'Заказ поставщику', Icons.menu_book_outlined, null),
      //    DocumentType(3, 'Поступление товаров', Icons.add_box_outlined, null),
      DocumentType(3, 'Заказ покупателя', Icons.airport_shuttle, null),
      DocumentType(
          4, 'Инвентаризация', Icons.account_balance_wallet_outlined, null),
    ];
  }

  static DocumentType getDocumentTypesByID(int _id) {
    switch (_id) {
      case 1:
        return documentTypes[1];
      case 2:
        return documentTypes[0];
      default:
        return documentTypes[_id - 1];
    }
  }
}

class ProfileRole {
  int id = 0;
  String name = "undefined";
  IconData icon = Icons.unfold_more;
  ProfileRole(this.id, this.name, this.icon);

  static List<ProfileRole> getProfileRoles() {
    // get profile 'cars'
    return <ProfileRole>[
      ProfileRole(0, '<Гость>', Icons.unfold_more),
      ProfileRole(1, 'root', Icons.airline_seat_recline_extra_sharp),
      ProfileRole(
          2, 'administrator', Icons.airline_seat_legroom_reduced_outlined),
      ProfileRole(3, 'Менеджер', Icons.headset_mic_rounded),
      ProfileRole(4, 'Руководитель', Icons.manage_accounts_outlined),
      ProfileRole(5, 'Персонал', Icons.pregnant_woman_rounded), // preblwole
    ];
  }
}

class Profile {
  int profileID = 0;
  int userID = 0;
  int roleID = 0;
  int marketID = 0;
  int defaultDocumentTypeID = 0;
  bool usingZebra = false;
  String name = "undefined";
  String date = "";
  String status = "";
  int profilePin = 111111;

  Profile(this.profileID, this.userID, this.roleID, this.marketID,
      this.defaultDocumentTypeID, this.name, this.profilePin);

  Profile.fromJson(Map<String, dynamic> json) {
    profileID = json['profileID'];
    userID = json['userID'];
    roleID = json['roleID'];
    marketID = json['marketID'];
    defaultDocumentTypeID = json['defaultDocumentTypeID'];
    usingZebra = json['usingZebra'];
    name = json['name'];
    date = json['date'];
    status = json['status'];
    try {
      profilePin = json['profilePin'];
    } catch (e) {
      profilePin = 111111;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileID'] = this.profileID;
    data['userID'] = this.userID;
    data['roleID'] = this.roleID;
    data['marketID'] = this.marketID;
    data['defaultDocumentTypeID'] = this.defaultDocumentTypeID;
    data['usingZebra'] = this.usingZebra;
    data['name'] = this.name;
    data['date'] = this.date;
    data['status'] = this.status;

    try {
      data['profilePin'] = this.profilePin;
    } catch (e) {}
    return data;
  }

  Map<dynamic, dynamic> toJsonDynamic() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['profileID'] = this.profileID;
    data['userID'] = this.userID;
    data['roleID'] = this.roleID;
    data['marketID'] = this.marketID;
    data['defaultDocumentTypeID'] = this.defaultDocumentTypeID;
    data['usingZebra'] = this.usingZebra;
    data['name'] = this.name;
    data['date'] = this.date;
    data['status'] = this.status;

    try {
      data['profilePin'] = this.profilePin;
    } catch (e) {}
    return data;
  }

  static Profile getDefaultProfile() {
    return Profile(0, 0, 0, 0, 0, "<не выбран>", 0);
  }

  static List<Profile> getAvailableProfiles() {
    return <Profile>[
      Profile(0, 0, 0, 5, 0, "<0>", 0),
      Profile(1, 1, 1, 0, 0, "<1>", 1),
      Profile(2, 2, 2, 2, 0, "<2>", 2),
      Profile(3, 3, 3, 3, 0, "<3>", 3),
      Profile(4, 4, 4, 4, 0, "<4>", 4),
      Profile(5, 5, 5, 5, 0, "<5>", 5),
    ];
  }

  IconData getIcon() {
    return (profileRoles[this.roleID].icon);
  }

  String getName() {
    if (this.marketID == 0) {
      return (profileRoles[this.roleID].name + " (все)").trim();
    } else {
      return (profileRoles[this.roleID].name +
              " [" +
              selectedMarket.name +
              //markets[this.marketID].name +
              "]")
          .trim();
    }
  }
}

class Good {
  int id = 0;
  String barcode = "";
  String name = "";
  String pricein = "";
  String priceout = "";
  String producer = "";
  String indate = "";
  String country = "";
  String trademark = "";
  String status = "";
  String weight = "";
  String category = "";
}

class GoodItem {
  int id = 0;
  String barcode = "";
  String name = "";
  String pricein = "";
  String priceout = "";
  String producer = "";
  String indate = "";
  String country = "";
  String trademark = "";
  String status = "";
  String weight = "";
  String category = "";
  String number = "";
  String date = "";
  int quantity = 0;

  GoodItem(Good good) {
    this.name = good.name;
    this.id = good.id;
    this.quantity = 1;
    this.barcode = good.barcode;
    this.pricein = good.pricein;
    this.producer = good.producer;
  }

  GoodItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    quantity = json['quantity'];
    barcode = json['barcode'];
    pricein = json['pricein'];
    producer = json['producer'];
    try {
      date = json['date'];
      number = json['number'];
      print(date);
      print(number);
    } catch (e) {}
  }

  GoodItem.fromProduct(Product product) {
    name = product.title;
    id = product.id;
    quantity = 0;
    barcode = product.barcode;
    pricein = "";
    producer = "";
  }
  GoodItem.fromProductInfo(ProductInfo product) {
    name = product.title;
    id = product.id;
    quantity = 0;
    barcode = product.barcode;
    pricein = "";
    producer = "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['barcode'] = this.barcode;
    data['pricein'] = this.pricein;
    data['producer'] = this.producer;

    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.name;
  }
}

class DocumentOrder {
  String project = "DCT";
  List<GoodItem> goodItems = [];

  DocumentOrder(goodItems) {
    this.project = project;
    this.goodItems = goodItems;
  }

  DocumentOrder.fromJson(Map<String, dynamic> json) {
    project = json['project'];
    if (json['goodItems'] != null) {
      goodItems = [];
      json['goodItems'].forEach((v) {
        goodItems.add(GoodItem.fromJson(v));
      });
    }
    //print(goodItems.length);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['project'] = this.project;
    data['goodItems'] = this.goodItems.map((v) => v.toJson()).toList();

    return data;
  }
}

class DataHTML {
  int profileID = 0;
  int userID = 0;
  int reportID = 0;
  int marketID = 0;
  String title = "";
  String htmlContent = "";

  DataHTML();

  DataHTML.fromJson(Map<String, dynamic> json) {
    profileID = json['profileID'];
    userID = json['userID'];
    reportID = json['reportID'];
    marketID = json['marketID'];
    title = json['title'];
    htmlContent = json['htmlContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileID'] = this.profileID;
    data['userID'] = this.userID;
    data['reportID'] = this.reportID;
    data['marketID'] = this.marketID;
    data['title'] = this.title;
    data['htmlContent'] = this.htmlContent;
    return data;
  }
}

class Report {
  int userID = 0;
  int profileID = 0;
  int reportID = 0;
  int marketID = 0;
  String title = "";
  String htmlContent = "";
  int roleID = 0;

  FormatMarket? marketFormatID = null;
  int regionID = 0;
  int departmentID = 0;
  int categoryID = 0;
  String filter = '';

  ReportPeriodFormat? reportPeriodFormatID = null;

  Report(this.reportID, this.title);

  Report.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    profileID = json['profileID'];
    reportID = json['reportID'];
    marketID = json['marketID'];
    title = json['title'];
    htmlContent = json['htmlContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['profileID'] = this.profileID;
    data['reportID'] = this.reportID;
    data['marketID'] = this.marketID;
    data['title'] = this.title;
    data['htmlContent'] = this.htmlContent;
    return data;
  }

  static List<Report> getReports() {
    return <Report>[
      Report(0, 'Все отчеты...'),
      Report(1, 'Состояние обмена'),
      Report(2, "Список акций для ДДК"),
      Report(3, "Остатки товара"),
      Report(4, "Анализ заказов"),
      Report(5, "Анализ цен"),
      Report(6, "Остатки и обороты товара"),
    ];
  }
}

Future<Good> loadGoods(String barcode) async {
  var response = await http.get(
      Uri.parse(
          "http://212.112.116.229:7788/weblink/hs/dct-goods/good/" + barcode),
      headers: kDctHeaders);

  var json = jsonDecode(utf8.decode(response.bodyBytes));
  var jsonGood = json["data"];
  Good results = Good();
  try {
    results.barcode = jsonGood[0]["barcode"];
    results.name = jsonGood[0]["name"];
    results.pricein = jsonGood[0]["pricein"];
    results.priceout = jsonGood[0]["priceout"];
    results.producer = jsonGood[0]["producer"];
    results.indate = jsonGood[0]["indate"];
    results.country = jsonGood[0]["country"];
    results.trademark = jsonGood[0]["trademark"];
    results.status = jsonGood[0]["status"];
    results.weight = jsonGood[0]["weight"];
    results.category = jsonGood[0]["category"];
  } catch (error) {
    results.producer = error.toString();
  }

  return results;
}

Future<DocumentOrder?> createDocumentOrder(List goodItems) async {
  //await Future.delayed(Duration(milliseconds: 200));
  DocumentOrder newDocOrder = DocumentOrder(goodItems);
  var myData = newDocOrder.toJson();
  var body = json.encode(myData);

  final response = await http.post(
    Uri.parse(
        'http://212.112.116.229:7788/weblink/hs/dct-goods/post_goods_doc'),
    headers: kDctHeaders,
    body: body,
  );

  if (response.statusCode == 200) {
    return DocumentOrder.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    //throw Exception(response.toString());
    return null;
  }
}

saveSettingsHive(BuildContext context) {
  print('selectedUser.id: ${selectedUser.id}');
  print('selectedMarket.id: ${selectedMarket.id}');
  print('selectedDocumentType.id: ${kSelectedDocumentType.id}');
  print('selectedProfile.profileID: ${selectedProfile.profileID}');

  bool noNeedToSave = true;
  Box<Settings> box = Hive.box<Settings>('settings');

  Settings? userIDSettings = box.get("userID");
  if (userIDSettings != null) {
    if (selectedUser.id != userIDSettings.value) {
      userIDSettings.value = selectedUser.id;
      userIDSettings.name = selectedUser.name;
      userIDSettings.save();
      noNeedToSave = false;
    }
  }
  if (userIDSettings == null) {
    Settings userID = Settings(selectedUser.name, selectedUser.id);
    box.put("userID", userID);
    noNeedToSave = false;
  }

  Settings? documentTypeSettings = box.get("documentTypeID");
  if (documentTypeSettings != null) {
    if (kSelectedDocumentType.id != documentTypeSettings.value) {
      documentTypeSettings.value = kSelectedDocumentType.id;
      documentTypeSettings.name = kSelectedDocumentType.name;
      documentTypeSettings.save();
      noNeedToSave = false;
    }
  }

  if (documentTypeSettings == null) {
    Settings documentTypeID =
        Settings(kSelectedDocumentType.name, kSelectedDocumentType.id);
    noNeedToSave = false;
    box.put("documentTypeID", documentTypeID);
  }

  Settings? marketSettings = box.get("marketID");
  if (marketSettings != null) {
    if (selectedMarket.id != marketSettings.value) {
      marketSettings.value = selectedMarket.id;
      marketSettings.name = selectedMarket.name;
      marketSettings.save();
      noNeedToSave = false;
    }
  }

  if (marketSettings == null) {
    Settings marketID = Settings(selectedMarket.name, selectedMarket.id);
    box.put("marketID", marketID);
    noNeedToSave = false;
  }

  Settings? profileIDSettings = box.get("profileID");
  if (profileIDSettings != null) {
    if (selectedProfile.profileID != profileIDSettings.value) {
      profileIDSettings.value = selectedProfile.profileID;
      profileIDSettings.name = selectedProfile.name;
      profileIDSettings.save();
      noNeedToSave = false;
    }
  }

  if (profileIDSettings == null) {
    Settings profileID =
        Settings(selectedProfile.name, selectedProfile.profileID);
    noNeedToSave = false;
    box.put("profileID", profileID);
  }

  Settings? usingZebraSettings = box.get("usingZebra");
  if (usingZebraSettings != null) {
    if (usingZebra != usingZebraSettings.value) {
      usingZebraSettings.value = usingZebra;
      usingZebraSettings.name = 'usingZebra';
      usingZebraSettings.save();
      noNeedToSave = false;
    }
  }

  if (usingZebraSettings == null) {
    Settings hiveUsingZebra = Settings('usingZebra', usingZebra);
    noNeedToSave = false;
    box.put("usingZebra", hiveUsingZebra);
  }

  var profileData = selectedProfile.toJsonDynamic();

  Settings? profileDataSettings = box.get("profileData");
  if (profileDataSettings != null) {
    if (profileData.toString() != profileDataSettings.value.toString()) {
      profileDataSettings.value = profileData;
      profileDataSettings.name = selectedProfile.name;
      profileDataSettings.save();
      noNeedToSave = false;
    }
  }

  if (profileDataSettings == null) {
    Settings profileDataSettings2Save =
        Settings(selectedProfile.name, profileData);
    noNeedToSave = false;
    box.put("profileData", profileDataSettings2Save);
  }

  if (noNeedToSave == true) {
    Fluttertoast.showToast(
        msg: "No need to save...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green[300],
      duration: Duration(seconds: 1),
      content: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text("Saved!", textAlign: TextAlign.center)),
    ));

    BlocProvider.of<ProfileCubit>(context).updateProfileState(
        selectedUser,
        selectedMarket,
        kSelectedDocumentType,
        selectedProfile,
        usingZebra,
        isAuthorized);
  }
}

saveExitSettingsHive(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Подтвердите выход...', style: TextStyle(fontSize: 15)),
          content:
              Text('Вы уверены, что хотите выйти и ввести ID и пароль вновь?'),
          actions: [
            // The "Yes" button
            TextButton(
                child: Text("Да"),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  // do the rest
                  bool noNeedToSave = true;
                  Box<Settings> box = Hive.box<Settings>('settings');

                  Settings? userIDSettings = box.get("userID");
                  if (userIDSettings != null) {
                    selectedUser = users[0];
                    userIDSettings.value = 0;
                    userIDSettings.name = selectedUser.name;
                    userIDSettings.save();
                    noNeedToSave = false;
                  }

                  Settings? profileIDSettings = box.get("profileID");
                  if (profileIDSettings != null) {
                    selectedProfile = profiles[0]; // IDSettings.value) {
                    profileIDSettings.value = selectedProfile.profileID;
                    profileIDSettings.name = selectedProfile.name;
                    profileIDSettings.save();
                    // noNeedToSave = false;
                  }

                  var profileData = selectedProfile.toJsonDynamic();

                  Settings? profileDataSettings = box.get("profileData");
                  if (profileDataSettings != null) {
                    if (profileData.toString() !=
                        profileDataSettings.value.toString()) {
                      profileDataSettings.value = profileData;
                      profileDataSettings.name = selectedProfile.name;
                      profileDataSettings.save();
                      //  noNeedToSave = false;
                    }
                  }

                  // print('yo what the hell');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginSignupScreen(),
                      ));

                  if (noNeedToSave == true) {
                    Fluttertoast.showToast(
                        msg: "Не удалось выйти...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.orange[400],
                      duration: Duration(seconds: 1),
                      content: Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Text("ВЫХОД", textAlign: TextAlign.center)),
                    ));
                  }
                }),

            TextButton(
                child: Text('Нет'),
                onPressed: () {
                  // noNeedForAction = true;
                  // Close the dialog
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
}

Future<Profile?> saveProfileOnDCT(BuildContext context) async {
  //await Future.delayed(Duration(milliseconds: 200));
  //Profile newProfile = DocumentOrder(goodItems);

  bool notSaved = true;

  var myData = selectedProfile.toJson();

  print('myData: ${myData}');
  var body = json.encode(myData);

  final response = await http.post(
    Uri.parse(
        'http://212.112.116.229:7788/weblink/hs/dct-profile/post_profile'),
    headers: kDctHeaders,
    body: body,
  );

  Profile? newresponse = null;

  if (response.statusCode == 200) {
    newresponse = Profile.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    notSaved = false;
  }

  if (notSaved == true) {
    Fluttertoast.showToast(
        msg: "Error! Not saved on DCT...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   backgroundColor: Colors.green[300],
    //   duration: Duration(seconds: 1),
    //   content: Padding(
    //       padding: EdgeInsets.only(top: 3),
    //       child: Text("Saved on DCT!", textAlign: TextAlign.center)),
    // ));
  }

  return newresponse;
}

Future<bool> accessAlowed(
    BuildContext context, loginEnteredID, loginEnteredPin) async {
  var result = false;
  switch (loginEnteredID) {
    case 1:
      {
        if (loginEnteredPin == 1) {
          selectedUser = users[1];

          result = true;
        }
      }
      break;
    case 2:
      {
        if (loginEnteredPin == 2) {
          selectedUser = users[2];
          result = true;
        }
      }
      break;
    case 3:
      {
        if (loginEnteredPin == 3) {
          selectedUser = users[3];
          result = true;
        }
      }
      break;
    case 4:
      {
        if (loginEnteredPin == 4) {
          selectedUser = users[4];
          result = true;
        }
      }
      break;
    case 5:
      {
        if (loginEnteredPin == 5) {
          result = true;
        }
      }
      break;
    case 111111:
      {
        selectedUser = users[0];
        result = true;
      }
      break;
    default:
  }

  //if (result != true) {
  FocusManager.instance.primaryFocus?.unfocus();
  await showError(context, result);
  //}
  return result;
}

Future<void> showError(BuildContext context, bool result) async {
  await Future.delayed(Duration(milliseconds: 300));
  if (result != true) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.orange[600],
      duration: Duration(seconds: 1),
      content: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text("Не верный ID или пароль!", textAlign: TextAlign.center)),
    ));
    ;
  } else {
    saveSettingsHive(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: "Connector F"),
      ),
    );
  }
}

Future<DataHTML> loadHTML(String title) async {
  var response = await http.get(Uri.parse(
          // "http://212.112.116.229:7788/weblink/hs/dct-goods/good/" + barcode));
          // "http://212.112.116.229:7788/weblink/hs/dct-html/html_example"));
          "http://212.112.116.229:7788/weblink/hs/dct-html/get_html/" + title),
      headers: kDctHeaders);

  var json = jsonDecode(utf8.decode(response.bodyBytes));
  print(title);
  DataHTML results = DataHTML();
  try {
    results.profileID = json["profileID"];
    results.userID = json["userID"];
    results.reportID = json["reportID"];
    results.marketID = json["marketID"];
    results.title = json["title"];
    results.htmlContent = json["htmlContent"];
  } catch (error) {
    results.htmlContent = error.toString();
  }

  return results;
}

Future<DataHTML?> loadReport() async {
  bool noReport = true;

  var myData = selectedReport.toJson();

  print('myData: ${myData}');
  var body = json.encode(myData);

  // final response = await http.post(
  //   Uri.parse('http://212.112.116.229:7788/weblink/hs/dct-report/report/0'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: body,
  // );

  final response = await http.post(
    Uri.parse('http://212.112.116.229:7788/weblink/hs/dct-report/report/0'),
    headers: kDctHeaders,
    body: body,
  );

  DataHTML? newResponse = null;

  if (response.statusCode == 200) {
    newResponse =
        DataHTML.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return newResponse;
  } else {
    return null;
  }
}
