import 'dart:convert';
import 'package:datawedgeflutter/UI/widgets/widget_product_card.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:flutter/material.dart';

final String _dct_username = 'weblink';
final String _dct_password = 'weblinK312!';
final String _dct_basicAuth =
    'Basic ' + base64Encode(utf8.encode('$_dct_username:$_dct_password'));

final Map<String, String> _dct_headers = {
  'Content-Type': 'application/json; charset=UTF-8',
  'authorization': _dct_basicAuth
};

class GoodsItemsPage extends StatefulWidget {
  @override
  _GoodsItemsPageState createState() => _GoodsItemsPageState();
}

class _GoodsItemsPageState extends State<GoodsItemsPage> {
  List<ProductInfo> _GoodsItems = goodsItems; // =[]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Документы..."),
      // ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final goodItem = _GoodsItems[index];
          return ProductCardForGoodsItemsScreen(
            index: index,
            isDCT: false,
            isGridView: true,
            productInfo: goodItem,
            refreshBodyOnSelectedProductCategory: () {},
          );
        },
        //  separatorBuilder: (context, index) => Divider(),
        itemCount: _GoodsItems.length,
      ),
    );
  }
}
