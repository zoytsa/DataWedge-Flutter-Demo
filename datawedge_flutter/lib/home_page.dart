import 'dart:async';
import 'dart:convert';
import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/tabbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datawedgeflutter/flutter_barcode_scanner.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MethodChannel methodChannel =
      MethodChannel('com.darryncampbell.datawedgeflutter/command');
  static const EventChannel scanChannel =
      EventChannel('com.darryncampbell.datawedgeflutter/scan');

  String _scanBarcode = 'Unknown';
  List<String> _resultDataList = [];
  Good goodInfo = Good();
  final List<Tab> tabs = [];
  final List<Widget> children = [];
  String _barcodeString = "Barcode will be shown here";
  String _barcodeSymbology = "Symbology will be shown here";
  String _scanTime = "Scan Time will be shown here";
  int _goodsCount = 0;
  List<GoodItem> goodsList = [];
  String addButtonTitle = "  + ADD*  ";
  List<GoodItem> goodItems = [];
  DocumentOrder? currentDocument = null;

  //  This example implementation is based on the sample implementation at
  //  https://github.com/flutter/flutter/blob/master/examples/platform_channel/lib/main.dart
  //  That sample implementation also includes how to return data from the method
  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson =
          jsonEncode({"command": command, "parameter": parameter});

      await methodChannel.invokeMethod(
          'sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  // String _barcodeString = "Barcode will be shown here";
  // String _barcodeSymbology = "Symbology will be shown here";
  // String _scanTime = "Scan Time will be shown here";

  @override
  void initState() {
    super.initState();
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");
  }

//void _onEvent(Object event) {
  void _onEvent(event) {
    setState(() {
      Map barcodeScan = jsonDecode(event);
      _barcodeString = "Barcode: " + barcodeScan['scanData'];
      _barcodeSymbology = "Symbology: " + barcodeScan['symbology'];
      _scanTime = "At: " + barcodeScan['dateTime'];
      loadData(barcodeScan['scanData']);
      //_resultDataList.add(barcodeScan['scanData']);
    });
  }

  void _onError(Object error) {
    setState(() {
      _barcodeString = "Barcode: error";
      _barcodeSymbology = "Symbology: error";
      _scanTime = "At: error";
    });
  }

  void startScan() {
    setState(() {
      _sendDataWedgeCommand(
          "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
    });
  }

  void stopScan() {
    setState(() {
      _sendDataWedgeCommand(
          "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "STOP_SCANNING");
    });
  }

  // void startScanPhoto() {
  //   setState(() {
  //     _sendDataWedgeCommand(
  //         "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
  //   });
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      //loadData(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    _scanBarcode = barcodeScanRes;
    _barcodeString = "Barcode: " + barcodeScanRes;
    _barcodeSymbology = "Symbology: " + "Photo Scan";
    String dateTime = DateTime.now().toLocal().toString();
    _scanTime = "At: " + dateTime; //"Now...";
    loadData(barcodeScanRes);
    //_resultDataList.add(barcodeScanRes);
    // });
  }

  void _onManualInputBarcode(text) {
    //setState(() {
    _barcodeString = "Barcode: " + text;
    _barcodeSymbology = "Symbology: manual input";
    String dateTime = DateTime.now().toLocal().toString();
    _scanTime = "At: " + dateTime;
    _resultDataList.clear();

    if (goodInfo.name != "") {
      _resultDataList.add(goodInfo.name);
      _resultDataList.add("Поставщик: " + goodInfo.producer);
      _resultDataList.add("Закупочная цена: " + goodInfo.pricein);
      _resultDataList.add("Розничная цена: " + goodInfo.priceout);
      _resultDataList.add("Страна: " + goodInfo.country);
      _resultDataList.add("Статус: " + goodInfo.status);
      _resultDataList.add("Торговая марка: " + goodInfo.trademark);
      _resultDataList.add("Категория: " + goodInfo.category);
      _resultDataList.add("Дата поставки: " + goodInfo.indate);
    }

//bool noItem = true;
    addButtonTitle = "  +  ADD (0)";
    for (GoodItem item in goodsList) {
      if (item.name == goodInfo.name) {
        // noItem = false;
        addButtonTitle = "  +  ADD (" + item.quantity.toString() + ")";
        break;
      }
    }
    // if (noItem == true) {
    //   GoodItem newItem = GoodItem(goodInfo);
    //   goodsList.add(newItem);
    // }
    _goodsCount = goodsList.length;
    setState(() {
      //addButtonTitle = addButtonTitle;
    });

    //setState(() {});
  }

  void loadData(text) async {
    var receivedGoodInfo = await loadGoods(text);
    goodInfo = receivedGoodInfo;
    _onManualInputBarcode(text);

    // setState(() {
    //   goodInfo = receivedGoodInfo;
    //   //addButtonTitle = addButtonTitle;
    //   _onManualInputBarcode(text);
    // });
  }

  void addNewGood() {
    if (goodInfo.name != "") {
      bool noItem = true;
      addButtonTitle = "  +  ADD (1)";
      for (GoodItem item in goodsList) {
        if (item.name == goodInfo.name) {
          item.quantity++;
          noItem = false;
          addButtonTitle = "  +  ADD (" + item.quantity.toString() + ")";
          break;
        }
      }
      if (noItem == true) {
        GoodItem newItem = GoodItem(goodInfo);
        goodsList.add(newItem);
      }
      _goodsCount = goodsList.length;
      setState(() {
        //addButtonTitle = addButtonTitle;
      });
    }
  }

  void saveData() async {
    // var currentDocumentInfo = await createDocumentOrder(goodItems);
    // currentDocument = currentDocumentInfo;

    createDocumentOrder(goodItems).then((value) {
      currentDocument = value;
      print(currentDocument!.goodItems.length);
      print("Hi");
    });

    setState(() {});
  }

// *** WIDGETS *** //
// *** WIDGETS *** //
// *** WIDGETS *** //

  Widget addTextHeaderBarcode(BuildContext context) {
    Widget widget = Container(
        padding: const EdgeInsets.all(22),
        child: Row(children: [
          Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Container(
                    //padding: const EdgeInsets.only(bottom: 2),
                    child: Text('$_barcodeString',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                addNewGoodButton(context, addButtonTitle)
              ]))
        ]));
    return widget;
  }

  Widget addNewGoodButton(BuildContext context, String addButtonTitle) {
    Widget widget = GestureDetector(
      onTapDown: (TapDownDetails) {
        addNewGood();
      },
      onTapUp: (TapUpDetails) {
        //  stopScan();
      },
      child: Container(
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            addButtonTitle,
            //"  +  ADD  ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    return widget;
  }

  Widget addZebraScanButton(BuildContext context) {
    Widget widget = GestureDetector(
      // When the child is tapped, show a snackbar.
      onTapDown: (TapDownDetails) {
        //startScan();
        startScan();
      },
      onTapUp: (TapUpDetails) {
        stopScan();
      },
      // The custom button
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            "ZEBRA SCAN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    return widget;
  }

  Widget addPhotoScanButton(BuildContext context) {
    Widget widget = GestureDetector(
      // When the child is tapped, scan with camera
      onTapDown: (TapDownDetails) {
        scanBarcodeNormal(); //startScan();
      },
      onTapUp: (TapUpDetails) {
        // stopScan();
      },

      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            "PHOTO SCANY",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              //fontSize: 20,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    );
    return widget;
  }

  Widget addEnterBarcodeField(BuildContext context) {
    Widget widget = Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child:
              // Text(
              //   "ADD BARCODE:",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     //fontSize: 20,
              //     letterSpacing: 2,
              //   ),
              // ),
              TextField(
                  cursorColor: Colors.pinkAccent,
                  maxLength: 13,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.add_to_photos_rounded),
                  ),
                  onSubmitted: (text) {
                    loadData(text);
                    //_onManualInputBarcode(text);
                    //print(text);
                  }),
        )
      ]),
    );

    return widget;
  }

  Widget mainScanPage(BuildContext context) {
    Widget widget = Column(children: <Widget>[
      Flexible(flex: 4, child: addTextHeaderBarcode(context)),
      Flexible(flex: 3, child: addZebraScanButton(context)),
      Flexible(flex: 4, child: addPhotoScanButton(context)),
      Flexible(flex: 4, child: addEnterBarcodeField(context)),
      Flexible(flex: 15, child: addedResultDataList(context, _resultDataList))
    ]);
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    String _goodsHeader = "Goods";
    if (_goodsCount != 0) {
      _goodsHeader = "Goods(" + _goodsCount.toString() + ")";
    } else {}
    return DefaultTabController(
        length: 4, //tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("DCT: 2 PRO"),
            centerTitle: true,
            flexibleSpace: (Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )))),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              //tabs: tabs,

              tabs: [
                Tab(icon: Icon(Icons.search_sharp), text: 'Scanner'),
                //Tab(icon: Icon(Icons.insert_emoticon), text: 'Goods'),
                Tab(icon: Icon(Icons.insert_emoticon), text: _goodsHeader),
                Tab(icon: Icon(Icons.space_bar), text: 'Documents'),
                Tab(icon: Icon(Icons.person), text: 'Profile'),
              ],
            ),
            elevation: 20,
            titleSpacing: 20,
          ),
          //body: mainScanPage(context)
          //body: TabBarView(children: children)
          body: TabBarView(
            children: [
              mainScanPage(context),
              //goodsListWidget(context, goodsList),
              goodsPage(context, goodsList, currentDocument),
              //addedResultDataList(context, _resultDataList),
              addedResultDataList(context, _resultDataList),
              addedResultDataList(context, _resultDataList)
            ],
          ),

          //body: mainScanPage(context),
        ));
  }

  Widget addedResultDataList(BuildContext context, List dataList) {
    // bool isFirst = true;
    Widget widget = Column(children: [
      Expanded(
          child: ListView(
        children: <Widget>[
          //  for (var i in dataList)
          for (int i = 0; i < dataList.length; i++)
            Card(
              elevation: i == 0 ? 8.0 : null,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              child: Container(
                decoration:
                    i == 0 ? BoxDecoration(color: Colors.blue[100]) : null,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    dataList[i].toString(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: i == 0
                        ? const TextStyle(fontWeight: FontWeight.bold)
                        : null,
                  ),
                ),
              ),
            )
        ],
      ))
    ]);

    return widget;
  }

  Widget widgetTextHeaderGoodItems(BuildContext context, String producer,
      List goodItems, currentDocument, docNumberAndDate) {
    Widget widget = Container(
        padding: const EdgeInsets.all(22),
        child: Row(children: [
          Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Container(
                    child: Text(producer,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Container(
                    child: Text(docNumberAndDate,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                addSaveGoodItemButton(context, goodItems)
              ]))
        ]));
    return widget;
  }

  Widget addSaveGoodItemButton(BuildContext context, List goodItems) {
    Widget widget = GestureDetector(
      onTapDown: (TapDownDetails) {
        // saveDocumentGoodItems(goodItems);
        var currentDocumentInfo = createDocumentOrder(goodItems);
        print(currentDocumentInfo);
        // setState(() {});
        //saveData();
      },
      onTapUp: (TapUpDetails) {
        //  stopScan();
      },
      child: Container(
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            "    SAVE    ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    return widget;
  }

  Widget goodsListWidget(BuildContext context, List goodItemsList) {
    String producer = "Контрагент";
    String docNumberAndDate = "***";
    if (goodItemsList.length != 0) {
      producer = goodItemsList[0].producer;
      if (goodItemsList[0].number != "") {
        docNumberAndDate =
            goodItemsList[0].number + " от " + goodItemsList[0].date;
      }
    }

    Widget textHeaderGoodItems = widgetTextHeaderGoodItems(
        context, producer, goodItemsList, currentDocument, docNumberAndDate);

    List<Widget> listGoodsWithDetails = [];
    listGoodsWithDetails.add(textHeaderGoodItems);
    for (GoodItem i in goodItemsList) {
      Widget cardGood = Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[100]),
          child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                i.toString(),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              )),
        ),
      );

      Widget textBarcode = Text(
        "     Штрихкод:     " + i.barcode,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 1,
      );

      Widget textQuantity = Text(
        "     Количество:  " + i.quantity.toString(),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 1,
      );

      Widget textPrice = Text(
        "     Цена:               " + i.pricein.toString(),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 1,
      );

      listGoodsWithDetails.add(cardGood);
      listGoodsWithDetails.add(textBarcode);
      listGoodsWithDetails.add(textQuantity);
      listGoodsWithDetails.add(textPrice);
    }

    Widget widget = Column(children: [
      Expanded(
          child: ListView(
        children: listGoodsWithDetails,
      ))
    ]);

    return widget;
  }

  Widget goodsPage(BuildContext context, List goodsList, currentDocument) {
    Widget widget = Column(children: <Widget>[
      Flexible(flex: 2, child: goodsListWidget(context, goodsList)),
    ]);
    return widget;
  }
}

// Widget addedResultDataList(BuildContext context, List dataList) {
//   Widget widget = Column(children: [
//     Expanded(
//         // ex Expanded
//         child: ListView(
//       children: <Widget>[
//         for (var i in dataList)
//           Card(
//             child: Padding(
//               padding: EdgeInsets.only(left: 5.0),
//               child: Text(
//                 i.toString(),
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: true,
//                 maxLines: 1,
//               ),
//             ),
//           )
//       ],
//     ))
//   ]);

//   return widget;
// }

// Widget addedResultDataList(BuildContext context, List dataList) {
//   // bool isFirst = true;
//   Widget widget = Column(children: [
//     Expanded(
//         child: ListView(
//       children: <Widget>[
//         //  for (var i in dataList)
//         for (int i = 0; i < dataList.length; i++)
//           Card(
//             elevation: i == 0 ? 8.0 : null,
//             margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
//             child: Container(
//               decoration:
//                   i == 0 ? BoxDecoration(color: Colors.blue[100]) : null,
//               child: Padding(
//                 padding: EdgeInsets.all(6.0),
//                 child: Text(
//                   dataList[i].toString(),
//                   overflow: TextOverflow.ellipsis,
//                   softWrap: true,
//                   maxLines: 1,
//                   style: i == 0
//                       ? const TextStyle(fontWeight: FontWeight.bold)
//                       : null,
//                 ),
//               ),
//             ),
//           )
//       ],
//     ))
//   ]);

//   return widget;
// }

// Widget widgetTextHeaderGoodItems(BuildContext context, String producer,
//     List goodItems, currentDocument, docNumberAndDate) {
//   Widget widget = Container(
//       padding: const EdgeInsets.all(22),
//       child: Row(children: [
//         Expanded(
//             child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//               Container(
//                   child: Text(producer,
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               Container(
//                   child: Text(docNumberAndDate,
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               addSaveGoodItemButton(context, goodItems, currentDocument)
//             ]))
//       ]));
//   return widget;
// }

// Widget addSaveGoodItemButton(
//     BuildContext context, List goodItems, currentDocument) {
//   Widget widget = GestureDetector(
//     onTapDown: (TapDownDetails) {
//       //  saveDocumentGoodItems(goodItems);
//       currentDocument = createDocumentOrder(goodItems);
//     },
//     onTapUp: (TapUpDetails) {
//       //  stopScan();
//     },
//     child: Container(
//       margin: EdgeInsets.all(1.0),
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.orange,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Center(
//         child: Text(
//           "    SAVE    ",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
//   );
//   return widget;
// }

// Widget goodsListWidget(
//     BuildContext context, List goodItemsList, currentDocument) {
//   String producer = "Контрагент";
//   String docNumberAndDate = "***";
//   if (goodItemsList.length != 0) {
//     producer = goodItemsList[0].producer;
//     if (goodItemsList[0].number != "") {
//       docNumberAndDate =
//           goodItemsList[0].number + " от " + goodItemsList[0].date;
//     }
//   }

//   Widget textHeaderGoodItems = widgetTextHeaderGoodItems(
//       context, producer, goodItemsList, currentDocument, docNumberAndDate);

//   List<Widget> listGoodsWithDetails = [];
//   listGoodsWithDetails.add(textHeaderGoodItems);
//   for (GoodItem i in goodItemsList) {
//     Widget cardGood = Card(
//       elevation: 8.0,
//       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
//       child: Container(
//         decoration: BoxDecoration(color: Colors.blue[100]),
//         child: Padding(
//             padding: EdgeInsets.all(6.0),
//             child: Text(
//               i.toString(),
//               overflow: TextOverflow.ellipsis,
//               softWrap: true,
//             )),
//       ),
//     );

//     Widget textBarcode = Text(
//       "     Штрихкод:     " + i.barcode,
//       overflow: TextOverflow.ellipsis,
//       softWrap: true,
//       maxLines: 1,
//     );

//     Widget textQuantity = Text(
//       "     Количество:  " + i.quantity.toString(),
//       overflow: TextOverflow.ellipsis,
//       softWrap: true,
//       maxLines: 1,
//     );

//     Widget textPrice = Text(
//       "     Цена:               " + i.pricein.toString(),
//       overflow: TextOverflow.ellipsis,
//       softWrap: true,
//       maxLines: 1,
//     );

//     listGoodsWithDetails.add(cardGood);
//     listGoodsWithDetails.add(textBarcode);
//     listGoodsWithDetails.add(textQuantity);
//     listGoodsWithDetails.add(textPrice);
//   }

//   Widget widget = Column(children: [
//     Expanded(
//         child: ListView(
//       children: listGoodsWithDetails,
//     ))
//   ]);

//   return widget;
// }

// Widget goodsPage(BuildContext context, List goodsList, currentDocument) {
//   Widget widget = Column(children: <Widget>[
//     Flexible(
//         flex: 2, child: goodsListWidget(context, goodsList, currentDocument)),
//   ]);
//   return widget;
// }