import 'dart:async';
import 'dart:convert';
import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:datawedgeflutter/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datawedgeflutter/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';

import 'model/settings.dart';

var enteredBarcode = "";

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
  String _barcodeString = "Просканируйте товар...";
  String _barcodeSymbology = "Symbology will be shown here";
  String _scanTime = "Scan Time will be shown here";
  List<String> _resultDataList = [];
  Good goodInfo = Good();
  final List<Tab> tabs = [];
  final List<Widget> children = [];
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

  @override
  void initState() {
    super.initState();
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");

    Box<Settings> box = Hive.box<Settings>('settings');
    //  var box = await Hive.openBox<Settings>('settings');

    Settings? userIDSettings = box.get("userID");
    if (userIDSettings != null) {
      selectedUser = users[userIDSettings.value];
    } else {
      selectedUser = users[0];
    }

    Settings? documentTypeIDSettings = box.get("documentTypeID");
    if (documentTypeIDSettings != null) {
      selectedDocumentType = documentTypes[documentTypeIDSettings.value];
    } else {
      selectedDocumentType = documentTypes[0];
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

    Settings? usingZebraSettings = box.get("usingZebra");
    if (usingZebraSettings != null) {
      usingZebra =
          usingZebraSettings.value is bool ? usingZebraSettings.value : false;
    } else {
      usingZebra = false;
    }
  }

  void _onEvent(event) {
    setState(() {
      Map barcodeScan = jsonDecode(event);
      _barcodeString = "Barcode: " + barcodeScan['scanData'];
      _barcodeSymbology = "Symbology: " + barcodeScan['symbology'];
      _scanTime = "At: " + barcodeScan['dateTime'];
      _loadData(barcodeScan['scanData']);
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
      //_loadData(barcodeScanRes);
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
    _loadData(barcodeScanRes);
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
      _resultDataList.add("  Поставщик: " + goodInfo.producer);
      _resultDataList.add("  Закупочная цена: " + goodInfo.pricein);
      _resultDataList.add("  Розничная цена: " + goodInfo.priceout);
      _resultDataList.add("  Страна: " + goodInfo.country);
      _resultDataList.add("  Статус: " + goodInfo.status);
      _resultDataList.add("  Торговая марка: " + goodInfo.trademark);
      _resultDataList.add("  Категория: " + goodInfo.category);
      _resultDataList.add("  Дата поставки: " + goodInfo.indate);

      FocusManager.instance.primaryFocus?.unfocus();
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

  void _loadData(text) async {
    var receivedGoodInfo = await loadGoods(text);
    goodInfo = receivedGoodInfo;
    _onManualInputBarcode(text);

    // setState(() {
    //   goodInfo = receivedGoodInfo;
    //   //addButtonTitle = addButtonTitle;
    //   _onManualInputBarcode(text);
    // });
  }

  void _addNewGood() {
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

// *** WIDGETS: MAIN SCAN *** //
  @override
  Widget build(BuildContext context) {
    IconData _profileHeaderIcon = Icons.person;
    if (selectedProfile != null) {
      _profileHeaderIcon = selectedProfile.getIcon();
    }
    String _goodsHeader = "Goods";
    if (_goodsCount != 0) {
      _goodsHeader = "Goods(" + _goodsCount.toString() + ")";
    } else {}
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
            length: 4, //tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Connector F"),
                centerTitle: true,
                flexibleSpace: (Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue, Color(0xFF3b5999)],
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
                    //Tab(icon: Icon(Icons.person), text: 'Profile'),
                    Tab(icon: Icon(_profileHeaderIcon), text: 'Profile'),
                  ],
                ),
                elevation: 20,
                titleSpacing: 20,
              ),

              body: TabBarView(
                children: [
                  mainScanPage(context),
                  //addGoodItemsList(context, goodsList),
                  goodItemsPage(context, goodsList, currentDocument),
                  //addResultDataList(context, _resultDataList),
                  addResultDataList(context, _resultDataList),
                  // addResultDataList(context, _resultDataList)
                  profilePage(),
                ],
              ),

              //body: mainScanPage(context),
            )));
  }

  // Widget mainScanPage(BuildContext context) {
  //   Widget widget = Column(children: <Widget>[
  //     Flexible(flex: 5, child: addTextHeaderBarcode(context)),
  //     Flexible(flex: 4, child: addZebraScanButton(context)),
  //     Flexible(flex: 5, child: addPhotoScanButton(context)),
  //     Flexible(flex: 5, child: addEnterBarcodeField(context)),
  //     Flexible(flex: 17, child: addResultDataList(context, _resultDataList))
  //   ]);
  //   return widget;
  // }

  Widget mainScanPage(BuildContext context) {
    Widget widget = SingleChildScrollView(
        child: Column(children: <Widget>[
      SizedBox(height: 80, child: addTextHeaderBarcode(context)),
      usingZebra
          ? SizedBox(height: 60, child: addZebraScanButton(context))
          : SizedBox(),
      SizedBox(height: 70, child: addPhotoScanButton(context)),
      SizedBox(height: 85, child: addEnterBarcodeField(context)),
      SizedBox(height: 305, child: addResultDataList(context, _resultDataList))
    ]));
    return widget;
  }

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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.textColor1))),
                addNewGoodButton(context, addButtonTitle)
              ]))
        ]));
    return widget;
  }

  Widget addNewGoodButton(BuildContext context, String addButtonTitle) {
    Widget widget = GestureDetector(
      onTapDown: (TapDownDetails) {
        _addNewGood();
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

        child: SizedBox(
          width: 250,
          child: Container(
            //alignment: ,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.only(left: 20.0),
            // decoration: BoxDecoration(
            //   color: Colors.lightBlueAccent,
            //   borderRadius: BorderRadius.circular(8.0),
            // ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ]),
            child: Row(children: [
              ImageIcon(
                AssetImage("images/icon_zebra.png"),
                color: Colors.white,
              ),
              Text(
                "         ZEBRA",
                style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ));
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
        child: SizedBox(
          width: 250,
          child: Container(
            //alignment: ,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.only(left: 20.0),
            // decoration: BoxDecoration(
            //   color: Colors.lightBlueAccent,
            //   borderRadius: BorderRadius.circular(8.0),
            // ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue, Color(0xFF3b5999)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ]),
            child: Row(children: [
              Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
              Text(
                "    СКАНИРОВАТЬ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //  fontSize: 12,
                    letterSpacing: 1.5,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ));
    return widget;
  }

  Widget addEnterBarcodeField(BuildContext context) {
    Widget widget = Container(
      width: 250,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        //color: Colors.deepPurple[200],
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
            prefixIcon: Icon(
              Icons.qr_code_sharp,
              color: Palette.iconColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.textColor1),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.textColor1),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            contentPadding: EdgeInsets.all(10),
            hintText: "Введите штрихкод",
            hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
            suffixIcon: IconButton(
              // onPressed: _controllerID.clear(),
              onPressed: () => _loadData(enteredBarcode),
              icon: Icon(Icons.search_outlined),
            ),
          ),
          onChanged: (String str) {
            {
              try {
                enteredBarcode = str;
              } catch (e) {
                enteredBarcode = "";
              }
            }
            ;
          },
          onSubmitted: (text) {
            _loadData(text);
            //_onManualInputBarcode(text);
            //print(text);
          },
        ))
      ]),
    );

    return widget;
  }

  Widget addResultDataList(BuildContext context, List dataList) {
    // bool isFirst = true;
    Widget widget = Column(children: [
      Expanded(
          // width: 200,
          child: ListView(
        children: <Widget>[
          //  for (var i in dataList)
          for (int i = 0; i < dataList.length; i++)
            Card(
              elevation: i == 0 ? 8.0 : null,
              // margin: new EdgeInsets.only(left: 10.0),
              child: Container(
                //decoration:
                // i == 0 ? BoxDecoration(color: Colors.blue[100]) : null,

                decoration: i == 0
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo,
                            Colors.blue,
                            Color(0xFF3b5999)
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        //borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ])
                    : null,

                child: Padding(
                  padding: i == 0 ? EdgeInsets.all(12.0) : EdgeInsets.all(4.0),
                  child: Text(
                    dataList[i].toString(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    textAlign: i == 0 ? TextAlign.center : null,
                    style: i == 0
                        ? const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)
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

// *** WIDGETS: GOOD ITEMS AND CURRENT DOCUMENT SAVING ***
  Widget goodItemsPage(BuildContext context, List goodsList, currentDocument) {
    Widget widget = Column(children: <Widget>[
      Flexible(flex: 2, child: addGoodItemsList(context, goodsList)),
    ]);
    return widget;
  }

  Widget addTextHeaderGoodItems(
      BuildContext context, String producer, List goodItems, docNumber) {
    Widget widget = Container(
        //   width: 100,
        padding: const EdgeInsets.all(22),
        child: Row(children: [
          Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Container(
                    width: 180,
                    child: Text(producer,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Container(
                    child: Text(docNumber,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                addSaveGoodItemButton(context, goodItems)
              ]))
        ]));
    return widget;
  }

  Widget addSaveGoodItemButton(BuildContext context, List goodItems) {
    Widget widget = GestureDetector(
      onTapDown: (TapDownDetails) async {
        // saveDocumentGoodItems(goodItems);
        var currentDocumentInfo = await createDocumentOrder(goodItems);
        currentDocument = currentDocumentInfo;
        setState(() {});
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

  Widget addGoodItemsList(BuildContext context, List goodItemsList) {
    String producer = "Контрагент";
    String docNumber = "***";

    if (goodItemsList.length != 0) {
      producer = goodItemsList[0].producer;
    }

    if (currentDocument != null) {
      if (currentDocument!.goodItems.length != 0) {
        docNumber = currentDocument!.goodItems[0].number;
      }
    }

    Widget textHeaderGoodItems =
        addTextHeaderGoodItems(context, producer, goodItemsList, docNumber);

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
}
