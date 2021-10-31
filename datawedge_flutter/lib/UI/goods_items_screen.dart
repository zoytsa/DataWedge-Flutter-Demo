import 'dart:convert';
import 'package:datawedgeflutter/UI/search_screen.dart';
import 'package:datawedgeflutter/UI/widgets/extra_widgets.dart';
import 'package:datawedgeflutter/UI/widgets/widget_product_card.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/documents_data.dart';
import 'package:datawedgeflutter/presentation/cubit/goods_items_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final String _dct_username = 'weblink';
final String _dct_password = 'weblinK312!';
final String _dct_basicAuth =
    'Basic ' + base64Encode(utf8.encode('$_dct_username:$_dct_password'));

final Map<String, String> _dct_headers = {
  'Content-Type': 'application/json; charset=UTF-8',
  'authorization': _dct_basicAuth
};

class GoodsItemsPage extends StatefulWidget {
  GoodsItemsPage({Key? key, required this.onProductSelection})
      : super(key: key);

  final VoidCallback onProductSelection;
  @override
  _GoodsItemsPageState createState() => _GoodsItemsPageState();
}

class _GoodsItemsPageState extends State<GoodsItemsPage> {
  List<ProductInfo> _GoodsItems = kGoodsItems; // =[]

  @override
  Widget build(BuildContext context) {
    if (callBloc) {
      callBloc = false;
      BlocProvider.of<GoodsItemsCubit>(context).updateSum();
    }
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
          backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,
          toolbarHeight: kGoodsItems.length != 0 ? 64 : 10,
          // collapsedHeight: 56,
          primary: false,
          floating: false,
          //  pinned: true,
          // brightness: Brightness.light,
          elevation: 0.0,
          flexibleSpace: kGoodsItems.length != 0
              ? BlocBuilder<GoodsItemsCubit, GoodsItemsState>(
                  builder: (context, state) {
                    return DocumentNumberTitle(
                      currentDocument: kCurrentDocument,
                    );
                  },
                )
              : null),
      SliverAppBar(
          backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,
          toolbarHeight: 46,
          // collapsedHeight: 56,
          primary: false,
          floating: false,
          pinned: true,
          // brightness: Brightness.light,
          elevation: 0.0,
          flexibleSpace: DocumentTotalsTitle(
            setStateGoodsItemsScreen: () {
              setState(() {});
            },
          )),

      SliverList(
        delegate: new SliverChildListDelegate(_buildList()),
      ), //

      // appBar: AppBar(
      //   title: Text("Документы..."),
      // ),
      // body: ListView.builder(
      //   itemBuilder: (context, index) {
      //     final goodItem = _GoodsItems[index];
      //     return ProductCardForGoodsItemsScreen(
      //       index: index,
      //       isDCT: false,
      //       isGridView: true,
      //       productInfo: goodItem,
      //       refreshBodyOnSelectedProductCategory: () {},
      //     );
      //   },
      //   //  separatorBuilder: (context, index) => Divider(),
      //   itemCount: _GoodsItems.length,
      // ),
    ]));
  }

  List<Widget> _buildList() {
    List<Widget> listItems = [];
    for (int index = 0; index < _GoodsItems.length; index++) {
      final goodItem = _GoodsItems[index];
      listItems.add(ProductCardForGoodsItemsScreen(
        index: index,
        isDCT: false,
        isGridView: true,
        productInfo: goodItem,
        refreshBodyOnSelectedProductCategory: () {},
      ));
    }
    listItems.add(AddGoodsItemViaSearchWidget(
        onProductSelection: widget.onProductSelection));
    return listItems;
  }
}

class AddGoodsItemViaSearchWidget extends StatelessWidget {
  const AddGoodsItemViaSearchWidget(
      {Key? key, required this.onProductSelection})
      : super(key: key);

  final VoidCallback onProductSelection;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWellWidget(
        color: Colors.blue.withOpacity(0.6),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CatalogScreen(

                    // onProductSelection: addGoodItemsFromSelected(
                    //     selectedProducts)
                    onProductSelection: () => onProductSelection()
                    // (
                    //     selectedProducts)
                    ),
              ))
        },
        onLongPress: () => {},
        builder: (isTapped) {
          final color = isTapped ? Colors.white : Colors.white;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //   SizedBox(),
                Icon(
                  Icons.add,
                  color: color,
                  size: 27,
                ),
                const SizedBox(width: 8),
                // Text(
                //   ' + ',
                //   style: TextStyle(
                //     color: color,
                //     fontSize: 15,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                //   SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DocumentNumberTitle extends StatelessWidget {
  final currentDocument;
  const DocumentNumberTitle({Key? key, this.currentDocument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _textNumber = '  -  ';
    if (currentDocument != null) {
      _textNumber = currentDocument.number;
    }
    var _textDate = '  -  ';
    if (currentDocument != null) {
      _textDate = currentDocument.date;
    }
//    return Text('data');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Номер: ' + _textNumber + '  Дата: ' + _textDate,
                  style: TextStyle(
                      color: kTextLightColor, fontStyle: FontStyle.italic)),
            ),
            InkWellWidget(
              color: Colors.blue.withOpacity(0.6),
              onTap: () {},
              onLongPress: () {},
              builder: (isTapped) {
                final color = kCurrentDocument == null
                    ? Colors.grey[500]
                    : Colors.blue[400];

                return Container(
                  // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.refresh, color: color),
                      const SizedBox(width: 8),
                      Text(
                        ' Перечитать ',
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),
    );
  }
}

class DocumentTotalsTitle extends StatelessWidget {
  final currentDocument;
  final VoidCallback setStateGoodsItemsScreen;
  const DocumentTotalsTitle(
      {Key? key, this.currentDocument, required this.setStateGoodsItemsScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var _textNumber = '< - >';
    // if (currentDocument != null) {
    //   _textNumber = currentDocument.number;
    // }
    // var _textDate = '< - >';
    // if (currentDocument != null) {
    //   _textDate = currentDocument.date;
    // }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: BlocBuilder<GoodsItemsCubit, GoodsItemsState>(
                builder: (context, state) {
                  return
                      // Text(
                      //     'Товаров: ' +
                      //         goodsItems.length.toString() +
                      //         '    Сумма: ' +
                      //         state.sum.toString(),
                      //     style: TextStyle(color: Colors.white));

                      RichText(
                    text: TextSpan(
                      text: 'Товаров: ',
                      style: TextStyle(color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: kGoodsItems.length.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                          text: '    Сумма: ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: state.sum.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            InkWellWidget(
              color: Colors.blue.withOpacity(0.6),
              // onTap: () {},
              onLongPress: () {},
              onTap: () async {
                //print('start');
                // saveDocumentGoodItems(goodItems);
                var currentDocumentInfo2 = await createDocumentPricePrint(
                    kGoodsItems, kCurrentDocument);
                BlocProvider.of<GoodsItemsCubit>(context).updateSum();
                kCurrentDocument = currentDocumentInfo2;
                if (kCurrentDocumentIsSaved != true &&
                    kCurrentDocument != null) {
                  kCurrentDocumentIsSaved = true;
                  setStateGoodsItemsScreen();
                }
                if (kCurrentDocument == null) {
                  kCurrentDocumentIsSaved = false;
                }
              },

              builder: (isTapped) {
                final color = isTapped ? Colors.white : Colors.green[300];

                return Container(
                  // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.save, color: color),
                      const SizedBox(width: 8),
                      Text(
                        'Записать  ',
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),
    );
  }
}
