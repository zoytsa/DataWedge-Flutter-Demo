import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  //http://212.112.116.229:7788/weblink/hs/dct-goods/good/4605246010132
  var response = await http.get(Uri.parse(
      "http://212.112.116.229:7788/weblink/hs/dct-goods/good/" + barcode));
  //var response = await http.get(Uri.parse(
  //   "http://212.112.116.229:7788/weblink/hs/dct-goods/good/4605246010132"));
  //var json = convert.jsonDecode(response.body);
  //var json = convert.jsonDecode(convert.Utf8Decoder.(response.bodyBytes));
  //var databody;
  //var json = await convert.jsonDecode(convert.jsonEncode(response.bodyBytes));
  //Utf8Codec utf8;
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

Future<String> saveDocumentGoodItems(List goodItems) async {
  return "OK";

  // var response = await http.put(Uri.parse(
  //     "http://212.112.116.229:7788/weblink/hs/dct-goods/good/" + goodItems[0]));

  // var json = jsonDecode(utf8.decode(response.bodyBytes));
  // var jsonSavingStatus = json["status"];
  // Map results = Map();
  // try {
  //   results.barcode = jsonGood[0]["barcode"];
  //   results.name = jsonGood[0]["name"];
  //   results.pricein = jsonGood[0]["pricein"];

  // } catch (error) {
  //   results.name = error.toString();
  // }

  // return results;
}

Future<DocumentOrder?> createDocumentOrder(List goodItems) async {
  await Future.delayed(Duration(milliseconds: 200));
  DocumentOrder newDocOrder = DocumentOrder(goodItems);

  var myData = newDocOrder.toJson();
  //encode Map to JSON
  var body = json.encode(myData);
  //var body = newDocOrder.toJson();
  print(body);
  final response = await http.post(
    Uri.parse(
        'http://212.112.116.229:7788/weblink/hs/dct-goods/post_goods_doc'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    return DocumentOrder.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //throw Exception(response.toString());
    return null;
  }
}
