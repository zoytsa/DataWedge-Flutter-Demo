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
  } catch (error) {
    results.producer = error.toString();
  }

  return results;
}
