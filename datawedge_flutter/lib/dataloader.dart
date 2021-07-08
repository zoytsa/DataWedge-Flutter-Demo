import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum FormatMarket { gipermarket, supermarket, express, gurme }

List<User> users = User.getUsers();
// List<DropdownMenuItem<User>> _dropdownMenuItemsUser =
//     buildDropdownMenuItemsUser(_users);
User selectedUser = users[0];
List<Market> markets = Market.getMarkets();
// List<DropdownMenuItem<Market>> _dropdownMenuItemsMarket =
//     buildDropdownMenuItemsMarket(_markets);
Market selectedMarket = markets[0];
List<DocumentType> documentTypes = DocumentType.getDocumentTypes();
// List<DropdownMenuItem<DocumentType>> _dropdownMenuItemsDocumentType =
//     buildDropdownMenuItemsDocumentTypes(_documentTypes);
DocumentType selectedDocumentType = documentTypes[0];

class User {
  int id = 0;
  String name = "";
  IconData icon = Icons.account_balance_wallet;
  Market market = markets[0];
  User(this.id, this.name, this.market, this.icon);

  static List<User> getUsers() {
    return <User>[
      User(0, '<не выбран>', markets[0], Icons.agriculture_rounded),
      User(1, 'Иванов', markets[0], Icons.agriculture_rounded),
      User(2, 'Петров', markets[0], Icons.agriculture_rounded),
      User(3, 'Сидоров', markets[0],
          Icons.airline_seat_legroom_reduced_outlined),
      User(4, 'Улановский', markets[0], Icons.airline_seat_recline_extra_sharp),
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
      Market(0, '<не выбран>', FormatMarket.gipermarket,
          Icons.radio_button_unchecked_outlined),
      Market(1, 'Ф01', FormatMarket.gipermarket, Icons.account_balance_sharp),
      Market(2, 'Ф02', FormatMarket.express, Icons.account_balance_wallet),
      Market(3, 'Ф03', FormatMarket.supermarket, Icons.flip_to_front_outlined),
      Market(4, 'Ф04', FormatMarket.supermarket, Icons.flip_to_front_outlined),
      Market(5, 'Ф05', FormatMarket.gipermarket, Icons.account_balance_sharp),
    ];
  }
}

class DocumentType {
  int id = 0;
  String name = "";
  IconData icon = Icons.ad_units;
  DocumentType(this.id, this.name, this.icon);

  static List<DocumentType> getDocumentTypes() {
    return <DocumentType>[
      DocumentType(0, '<не выбран>', Icons.radio_button_unchecked_outlined),
      DocumentType(1, 'Заказ внутренний', Icons.airport_shuttle),
      DocumentType(2, 'Заказ поставщику', Icons.add_link),
      DocumentType(3, 'Печать ценников', Icons.add_road_sharp),
    ];
  }
}

class Profile {
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

  Profile(Good good) {
    this.name = good.name;
    this.id = good.id;
    this.quantity = 1;
    this.barcode = good.barcode;
    this.pricein = good.pricein;
    this.producer = good.producer;
  }

  Profile.fromJson(Map<String, dynamic> json) {
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
    print(goodItems.length);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['project'] = this.project;
    data['goodItems'] = this.goodItems.map((v) => v.toJson()).toList();

    return data;
  }
}

Future<Good> loadGoods(String barcode) async {
  var response = await http.get(Uri.parse(
      "http://212.112.116.229:7788/weblink/hs/dct-goods/good/" + barcode));

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
  await Future.delayed(Duration(milliseconds: 200));
  DocumentOrder newDocOrder = DocumentOrder(goodItems);
  var myData = newDocOrder.toJson();
  var body = json.encode(myData);
  //print(body);

  final response = await http.post(
    Uri.parse(
        'http://212.112.116.229:7788/weblink/hs/dct-goods/post_goods_doc'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    return DocumentOrder.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    //throw Exception(response.toString());
    return null;
  }
}
