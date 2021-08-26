import 'dart:async';
import 'dart:convert';
import 'package:datawedgeflutter/model/dataloader.dart';
import 'package:datawedgeflutter/extra_widgets.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:datawedgeflutter/UI/profile_screen.dart';
import 'package:datawedgeflutter/UI/search_screen.dart';
import 'package:datawedgeflutter/show_html_page2.dart';
import 'package:datawedgeflutter/UI/show_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datawedgeflutter/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';

import 'UI/documents_screen.dart';
import 'model/settings.dart';

var enteredBarcode = "";

//_MyHomePageState _globalStateHomePage = _MyHomePageState();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  //final selectedProducts = <Product>[];
  @override
  _MyHomePageState createState() => _MyHomePageState();
  //_MyHomePageState createState() => _globalStateHomePage;
}

class _MyHomePageState extends State<MyHomePage> {
  // final GlobalKey expansionTileKey = GlobalKey();
  //static const Duration _kExpand = Duration(milliseconds: 200);
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
  String addButtonTitle = "  + В СПИСОК*  ";
  List<GoodItem> goodItems = [];
  DocumentOrder? currentDocument = null;
  var tabIndex = 0;
  bool isDCT = false;
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
    addButtonTitle = "  +  В СПИСОК (0)";
    for (GoodItem item in goodsList) {
      if (item.name == goodInfo.name) {
        // noItem = false;
        addButtonTitle = "  +  В СПИСОК (" + item.quantity.toString() + ")";
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
    //text = "111";
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
      addButtonTitle = "  +  В СПИСОК (1)";
      for (GoodItem item in goodsList) {
        if (item.name == goodInfo.name) {
          item.quantity++;
          noItem = false;
          addButtonTitle = "  +  В СПИСОК (" + item.quantity.toString() + ")";
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

  addGoodItemsFromSelected() {
    print('go to items 3');
    // selectedProducts = newSelectedProducts;
    if (selectedProducts.length != 0) {
      bool noItem = true;
      //addButtonTitle = "  +  В СПИСОК (1)";
      for (Product itemOfSelectedProducts in selectedProducts) {
        noItem = true;
        for (GoodItem item in goodsList) {
          if (item.name == itemOfSelectedProducts.title) {
            item.quantity++;
            noItem = false;
            //  addButtonTitle = "  +  В СПИСОК (" + item.quantity.toString() + ")";
            break;
          }
        }
        if (noItem == true) {
          GoodItem newItem = GoodItem.fromProduct(itemOfSelectedProducts);
          goodsList.add(newItem);
        }
      }
    }

    // var _tabController = DefaultTabController.of(context);
    // _tabController!.animateTo(1);
    setState(() {
      tabIndex = 2;
      _goodsCount = goodsList.length;
    });
    // var _tabController = DefaultTabController.of(context);
    // _tabController!.animateTo(1);
    ;
  }

// *** WIDGETS: MAIN SCAN *** //
  @override
  Widget build(BuildContext context) {
    // print('tabIndex: ${tabIndex} ');
    isDCT = MediaQuery.of(context).size.height < 600;
    //final tabIndex = 0;
    IconData _profileHeaderIcon = Icons.person;
    if (selectedProfile != null) {
      _profileHeaderIcon = selectedProfile.getIcon();
    }
    String _goodsHeader = "Список";
    if (_goodsCount != 0) {
      _goodsHeader = "Список(" + _goodsCount.toString() + ")";
    } else {}
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
            length: 4, //tabs.length,
            initialIndex: tabIndex,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              drawer: myDrawer3(context),
              appBar: myAppBar(context, _goodsHeader, _profileHeaderIcon),

              body: TabBarView(children: [
                mainScanPage(context),

                goodItemsPage(context, goodsList, currentDocument),
                DocumentsPage(),
                //addResultDataList(context, _resultDataList),
                profilePage(
                    vcbUsingZebraOnSelected: () {
                      print("vcb rules");
                    },
                    vcbUsinZebraOnChanged: (bool val) {
                      setState(() {
                        usingZebra = val;
                      });
                    },
                    vcbUsingZebra: usingZebra)
              ]),

              //body: mainScanPage(context),
            )));
  }

  Widget mainScanPage(BuildContext context) {
    var heightDetails = MediaQuery.of(context).size.height - 258;
    Widget widget = Stack(children: [
      Align(
          alignment: Alignment.topCenter,
          child: SizedBox(height: 80, child: addTextHeaderBarcode(context))),
      Column(children: [
        SizedBox(height: isDCT ? 55 : 55),
        SizedBox(height: 85, child: addEnterBarcodeField(context)),
        SizedBox(
            height: isDCT ? 270 : heightDetails, //550,
            //child: SizedBox(
            //   height: 600,
            child: addResultDataList(context, _resultDataList))
      ]),

      // Align(
      //     alignment:
      //         isDCT ? Alignment(0, 0.22) : Alignment(0, 0.85), // pixel 2 5.2
      //     child: SizedBox(
      //         height: isDCT ? 270 : 600,
      //         //child: SizedBox(
      //         //   height: 600,
      //         child: addResultDataList(context, _resultDataList))),
      // //SizedBox(height: 90),

      Align(
        alignment: isDCT ? Alignment(0, 0.92) : Alignment(0, 0.87),
        child: !usingZebra
            ? //Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            //children: [
            //   SizedBox(width: 40),
            SizedBox(
                height: isDCT ? 60 : 70,
                // width: isDCT ? 180 : null,
                child: addPhotoScanButton(context, isDCT))
            // ])
            : Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                    height: isDCT ? 60 : 70,
                    width: isDCT ? 200 : 220,
                    child: addPhotoScanButton(context, isDCT)),
                usingZebra
                    ? SizedBox(
                        height: isDCT ? 60 : 70,
                        child: addZebraScanButton(context, isDCT))
                    : SizedBox(height: 60),
              ]),
      )
    ]);
    return widget;
  }

  Widget myDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: 30.0,
                    left: 20.0,
                    child: CircleAvatar(
                      radius: isDCT ? 30 : 35,
                      backgroundColor: Colors.indigo.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.green.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Text(selectedUser.name,
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    top: 120,
                    left: 30,
                  ),
                  Positioned(
                    child: Text('Connector F.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                    top: 50,
                    right: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.pageview,
                    color: Colors.white,
                    //   size: 30,
                  ),
                  Text(
                    ' Go to sample page',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.white,
                    //    size: 30,
                  ),
                  Text(
                    ' About',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.settings_applications,
                    color: Colors.white,
                    // size: 30,
                  ),
                  Text(
                    ' Settings',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
                width: 200,
                height: 30,
                child: TextButton(
                  onPressed: () => _loadAndShowHTML(context),
                  style: TextButton.styleFrom(
                      //side: BorderSide(width: 1, color: Colors.white),
                      minimumSize: Size(60, 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      primary: Colors.white,
                      backgroundColor: Colors.indigo.withOpacity(0.1)),
                  child: Text(
                    " Проверка обмена... 📊",
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget myDrawer2(BuildContext context) {
    return Drawer(
      //backgroundColor: Colors.white,
      child: Container(
        color: Colors.grey.withOpacity(0.42),
        child: ListView(
          children: <Widget>[
            //Set User Information Username Avatar
            UserAccountsDrawerHeader(
              accountName: new Text(selectedUser.name),
              //   accountEmail: new Text(selectedProfile.name),
              accountEmail: ListTile(
                title: DropdownButton(
                    items: buildTest(profiles),
                    style: TextStyle(color: Colors.blue[300]),
                    value: selectedProfile,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        selectedProfile = valueSelectedByUser as Profile;
                        saveSettingsHive(context);
                        saveProfileOnDCT(context);
                      });
                      ;
                    }),
              ),

              //Current avatar
              currentAccountPicture: new CircleAvatar(
                child: Icon(
                  selectedProfile.getIcon(),
                  //     size: 45,
                  //     color: Colors.green.withOpacity(0.8),
                ),
                // backgroundImage: new  AssetImage("images/1.jpeg"),
              ),
              onDetailsPressed: () {
                print("onDetailsPressed");
              },
              //Other account avatars
              otherAccountsPictures: <Widget>[
                new Container(
                  child: Text("assests/images/bag_1.png"),
                )
              ],
            ),
            // ListTile(
            //   leading: new CircleAvatar(
            //     child: new Icon(Icons.color_lens),
            //   ),
            //   title: Text("personalized dress up"),
            // ),
            // ListTile(
            //   leading: new CircleAvatar(
            //     child: new Icon(Icons.photo),
            //   ),
            //   title: Text("My Album"),
            // ),
            // ListTile(
            //   leading: new CircleAvatar(
            //     child: new Icon(Icons.wifi),
            //   ),
            //   title: new Text("wifi"),
            // ),
            ExpansionTile(
              onExpansionChanged: (valueSelectedByUser) {
                setState(() {
                  debugPrint('User selected $valueSelectedByUser');
                  // onChangeDropdownItem(valueSelectedByUser as Market);
                  selectedProfile = valueSelectedByUser as Profile;
                  saveSettingsHive(context);
                  saveProfileOnDCT(context);
                });
              },
              title: Text("Expansion Title"),
              children: <Widget>[
                Text("children 1"),
                Text("children 2"),
                Text("children 3"),
                Text("children 4"),
                Text("children 5"),
                Text("children 6"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget myDrawer3(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * (isDCT ? 0.10 : 0.13),
            width: MediaQuery.of(context).size.width,
            //  color: Colors.white,
            decoration: BoxDecoration(
                gradient:

                    //  Colors.white
                    LinearGradient(
              colors: [Colors.indigo, Colors.blue, Colors.indigo],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )),
            child: Stack(
              children: [
                Positioned(
                  top: isDCT ? 10 : 25.0,
                  left: isDCT ? 16 : 20.0,
                  child: CircleAvatar(
                    radius: isDCT ? 20 : 31,
                    // backgroundColor: Colors.white.withOpacity(0.4),
                    child: CircleAvatar(
                      radius: isDCT ? 19 : 30,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: isDCT ? 19 : 30,
                        backgroundColor: Colors.indigo.withOpacity(0.6),
                        child: Icon(
                          selectedProfile.getIcon(),
                          //  Icons.person,
                          size: isDCT ? 28 : 45,
                          color: Colors.green.withOpacity(0.99),
                        ),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   child: Text(selectedUser.name,
                //       style: TextStyle(fontSize: 15, color: Colors.grey)),
                //   top: 120,
                //   left: 30,
                // ),
                Positioned(
                  child: Text(selectedUser.name,
                      style: TextStyle(
                        fontSize: isDCT ? 12 : 15,
                        color: Colors.grey[200],
                      )),
                  top: isDCT ? 10 : 30,
                  right: 20,
                ),
                Positioned(
                  child: Text(selectedProfile.getName(),
                      style: TextStyle(
                          fontSize: isDCT ? 12 : 15,
                          color: Colors.grey[200],
                          fontStyle: FontStyle.italic)),
                  top: isDCT ? 29 : 55,
                  right: 20,
                ),
              ],
            ),
          ),
          // SizedBox(
          //     height: 12,
          //     child: Container(
          //         decoration: BoxDecoration(
          //             gradient:

          //                 //  Colors.white
          //                 LinearGradient(
          //       colors: [Colors.indigo, Colors.blue, Colors.indigo],
          //       begin: Alignment.bottomRight,
          //       end: Alignment.topLeft,
          //     )))),
          listItemDocTypes(title: "Операции", icon: Icons.dock_outlined),
          listItemReport(title: "Отчеты", icon: Icons.assignment_outlined),
          listItem(title: "Инструкции", icon: Icons.help_rounded, isDCT: isDCT),
          listItem(title: "Настройки", icon: Icons.settings, isDCT: isDCT),
          SizedBox(height: isDCT ? 0 : 0),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatalogScreen(
                        title: "Searching...",
                        selectedUser: selectedUser,
                        // onProductSelection: addGoodItemsFromSelected(
                        //     selectedProducts)
                        onProductSelection: () => addGoodItemsFromSelected()
                        // (
                        //     selectedProducts)
                        ),
                  ))
            },
            child: ListTile(
              dense: isDCT ? false : true,
              //contentPadding: EdgeInsets.all(20),
              leading: Icon(
                Icons.search_outlined,
                size: 30,
              ),
              title: Text(
                "Каталог товаров",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: isDCT ? 0 : 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Статистика за сегодня:",
                style: TextStyle(fontSize: isDCT ? 10 : 11)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Новых документов: 4",
                style: TextStyle(fontSize: isDCT ? 10 : 11)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Позиций товаров: 18",
                style: TextStyle(fontSize: isDCT ? 10 : 11)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Общее колиичество товаров: 512 ед.",
                style: TextStyle(fontSize: isDCT ? 10 : 11)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Время работы: 02:05:12",
                style: TextStyle(fontSize: isDCT ? 10 : 11)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Последнее сохранение: 18 минут назад",
                style: TextStyle(fontSize: isDCT ? 10 : 11)),
          ),
        ],
      ),
    );
  }

  Widget listItem({int? index, String? title, icon, bool? isDCT}) {
    final GlobalKey expansionTileKey = GlobalKey();
    return Material(
      color: Colors.indigo,
      child: Theme(
        data: ThemeData(accentColor: Colors.black),
        child: ExpansionTile(
          key: expansionTileKey,
          iconColor: Colors.white,
          collapsedIconColor: Palette.greenSelected,
          backgroundColor: Colors.blue.withOpacity(0.3),
          onExpansionChanged: (value) {
            if (value) {
              _scrollToSelectedContent(expansionTileKey: expansionTileKey);
            }
          },
          leading: GradientIcon(
              icon,
              isDCT! ? 25.0 : 30,
              LinearGradient(
                colors: [Colors.lightGreen, Colors.green],
                begin: Alignment.topRight,
              )),
          // Icon(
          //   icon,
          //   size: 40,
          // ),
          title: Text(
            title!,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          children: <Widget>[for (int i = 0; i < 5; i++) cardWidget3()],
        ),
      ),
    );
  }

  Widget listItemDocTypes({int? index, String? title, icon}) {
    final GlobalKey expansionTileKey = GlobalKey();
    var items = <Widget>[];
    for (DocumentType documentType in documentTypes) {
      items.add(cardWidgetDocTypes(documentType));
    }
    return Material(
      color: Colors.indigo,
      child: Theme(
        data: ThemeData(accentColor: Colors.black),
        child: ExpansionTile(
          key: expansionTileKey,
          iconColor: Colors.white,
          collapsedIconColor: Palette.greenSelected,
          backgroundColor: Colors.blue.withOpacity(0.3),
          onExpansionChanged: (value) {
            if (value) {
              _scrollToSelectedContent(expansionTileKey: expansionTileKey);
            }
          },
          leading: GradientIcon(
              icon,
              isDCT ? 25.0 : 30,
              LinearGradient(
                colors: [Colors.lightGreen, Colors.green],
                begin: Alignment.topRight,
              )),
          // Icon(
          //   icon,
          //   size: 40,
          // ),
          title: Text(
            title!,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          children: items,
        ),
      ),
    );
  }

  Widget cardWidgetDocTypes(DocumentType docType) {
    return Container(
      margin: EdgeInsets.all(isDCT ? 2 : 3.0),
      width: MediaQuery.of(context).size.width * 0.55,
      height: selectedDocumentType == docType ? 35.0 : 33,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        border: Border.all(
            color: selectedDocumentType == docType
                ? Palette.greenSelected
                : Colors.white70,
            width: selectedDocumentType == docType
                ? isDCT
                    ? 2.5
                    : 3
                : isDCT
                    ? 1
                    : 1.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextButton.icon(
          label: Text(docType.name,
              style: TextStyle(
                  color: selectedDocumentType == docType
                      ? Colors.white
                      : Colors.white70,
                  fontSize: 12)),
          icon: Icon(docType.icon,
              color: selectedDocumentType == docType
                  ? Colors.white
                  : Colors.white70,
              size: 15),
          onPressed: () {
            setState(() {
              selectedDocumentType = docType;
              saveSettingsHive(context);
              saveProfileOnDCT(context);
            });
          }),
    );
  }

  Widget listItemReport({int? index, String? title, icon}) {
    final GlobalKey expansionTileKey = GlobalKey();
    var items = <Widget>[];

    if (starredReport1 != null) {
      items.add(cardWidgetReport(starredReport1!));
    }
    if (starredReport2 != null) {
      items.add(cardWidgetReport(starredReport2!));
    }
    if (starredReport3 != null) {
      items.add(cardWidgetReport(starredReport3!));
    }
    if (starredReport4 != null) {
      items.add(cardWidgetReport(starredReport4!));
    }

    items.add(cardWidgetReport(allReports));

    return Material(
      color: Colors.indigo,
      child: Theme(
        data: ThemeData(accentColor: Colors.black),
        child: ExpansionTile(
          key: expansionTileKey,
          iconColor: Colors.white,
          collapsedIconColor: Palette.greenSelected,
          backgroundColor: Colors.blue.withOpacity(0.3),
          onExpansionChanged: (value) {
            if (value) {
              _scrollToSelectedContent(expansionTileKey: expansionTileKey);
            }
          },
          leading: GradientIcon(
              icon,
              isDCT ? 25.0 : 30,
              LinearGradient(
                colors: [Colors.lightGreen, Colors.green],
                begin: Alignment.topRight,
              )),
          // Icon(
          //   icon,
          //   size: 40,
          // ),
          title: Text(
            title!,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          children: items,
        ),
      ),
    );
  }

  Widget cardWidgetReport(Report report) {
    return Container(
      margin: EdgeInsets.all(isDCT ? 2 : 3.0),
      width: MediaQuery.of(context).size.width * 0.55,
      height: 33,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        border: Border.all(color: Colors.white, width: isDCT ? 1 : 1.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextButton.icon(
          label: Text(
            report.title,
            style: new TextStyle(fontSize: 12.0, color: Colors.white),
          ),
          icon: Icon(
              report.reportID != 0
                  ? Icons.star_rate
                  : Icons.assessment_outlined,
              color:
                  report.reportID != 0 ? Colors.yellow : Palette.greenSelected,
              size: 15),
          onPressed: () => {
                print(report.title),
                selectedReport = report,
                _loadAndShowReport(context, report)
              }),
    );
  }

  _loadAndShowReport(BuildContext context, Report report) async {
    selectedReport = report;
    DataHTML? receivedHTML = await loadReport();
    if (receivedHTML != null) {
      DataHTML _dataHTML = receivedHTML;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowReport(
                title: report.title, htmlContent: _dataHTML.htmlContent),
          ));
    }
  }

  Widget cardWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.51,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 3),
                color: Colors.grey,
              ),
              // BoxShadow(
              //   offset: Offset(-1, -3),
              //   color: Colors.grey,
              // )
            ]),
        child: Row(
          children: [
            Icon(
              Icons.arrow_forward_outlined,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Title of Card",
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  Widget cardWidget2() {
    return Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1),
        child: Card(
          /// height:50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          color: Colors.lightBlue,
          child: Container(
              width: 220,
              height: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.security_rounded, size: 30),
                    title: Text("Проверка состояни обмена",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  )
                ],
              )),
        ));
  }

  Widget cardWidget3() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () => print('hello'),
        child: new Container(
          margin: EdgeInsets.all(2.0),
          width: MediaQuery.of(context).size.width * 0.5, //100.0,
          height: 35.0,
          decoration: new BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            border: new Border.all(color: Colors.white, width: isDCT ? 1 : 1.5),
            borderRadius: new BorderRadius.circular(15.0),
          ),
          child: new Center(
            child: new Text(
              'Проверка состояния обмена',
              style: new TextStyle(fontSize: 12.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSelectedContent({GlobalKey? expansionTileKey}) {
    final keyContext = expansionTileKey!.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  PreferredSizeWidget myAppBar(
      BuildContext context, _goodsHeader, _profileHeaderIcon) {
    return AppBar(
      // automaticallyImplyLeading: false,
      toolbarHeight: isDCT ? 85 : 90,
      title: Text(
        selectedUser.name == ""
            ? "Connector F."
            : "Connector F.: " + selectedUser.name,
        style: TextStyle(fontSize: 15),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      // flexibleSpace: (Container(
      //     //height: 200,
      //     decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //   //colors: [Colors.purple, Colors.blue, Color(0xFF3b5999)],
      //   colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
      //   begin: Alignment.bottomRight,
      //   end: Alignment.topLeft,
      // )))),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              Icons.search_outlined,
            ),
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatalogScreen(
                        title: "Searching...",
                        selectedUser: selectedUser,
                        // onProductSelection: addGoodItemsFromSelected(
                        //     selectedProducts)
                        onProductSelection: () => addGoodItemsFromSelected()
                        // (
                        //     selectedProducts)
                        ),
                  ))
            },
          ),
        )
      ],
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Colors.white,
        indicatorWeight: 5,

        //tabs: tabs,

        tabs: [
          Tab(
              // icon: isDCT
              //     ? null
              //     : Icon(
              //         Icons.search_sharp,
              //         color: Colors.white,
              //       ),
              text: 'Сканер'),
          Tab(
              // icon: isDCT
              //     ? null
              //     : Icon(
              //         Icons.insert_emoticon,
              //         color: Colors.white,
              //       ),
              text: _goodsHeader),
          Tab(
              //  icon: isDCT ? null : Icon(Icons.space_bar, color: Colors.white),
              text: 'Документы'),
          Tab(
            // icon: isDCT
            //     ? null
            //     : Icon(
            //         _profileHeaderIcon,
            //         color: Colors.white,
            //       ),
            text: 'Профиль',
          ),
        ],
        labelColor: Colors.white,
      ),
      elevation: 20,
      titleSpacing: 20,
    );
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
        //margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.all(10.0),

        decoration: BoxDecoration(
            gradient: LinearGradient(
              // colors: [
              //   Colors.green,
              //   Colors.tealAccent,
              //   Colors.green,
              //   Colors.black54
              // ],
              // colors: [Colors.black87, Colors.green],
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.bottomRight,
              //end: Alignment.topLeft,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  spreadRadius: 1.5,
                  blurRadius: 3,
                  offset: Offset(0, 1))
            ]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Icon(
          //   Icons.add_circle_outline,
          //   color: Colors.white,
          // ),
          Text(
            addButtonTitle,
            //"  +  ADD  ",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
          ),
        ]),
      ),
    );
    return widget;
  }

  Widget addZebraScanButton(BuildContext context, bool isDCT) {
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
          width: isDCT ? 140 : 160,
          child: Container(
            //alignment: ,
            margin: EdgeInsets.all(10.0),
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
                isDCT ? "  ZEBRA" : "   ZEBRA",
                style: TextStyle(
                    //  fontSize: 12,
                    letterSpacing: isDCT ? 1.2 : 1.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ));
    return widget;
  }

  Widget addPhotoScanButton(BuildContext context, isDCT) {
    Widget widget = GestureDetector(
        // When the child is tapped, scan with camera
        onTapDown: (TapDownDetails) {
          scanBarcodeNormal(); //startScan();
        },
        onTapUp: (TapUpDetails) {
          // stopScan();
        },
        child: SizedBox(
          width: isDCT ? 200 : 220,
          child: Container(
            //alignment: ,
            margin: EdgeInsets.all(10.0),
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
              Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
              Text(
                !isDCT ? "   СКАНИРОВАТЬ" : " СКАНИРОВАТЬ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    //  fontSize: 12,
                    letterSpacing: !isDCT ? 1.5 : 1,
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
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterStyle: TextStyle(
              color: Palette.textColor1,
            ),
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
              icon: Icon(Icons.check, color: Palette.textColor1),
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
              color: Colors.indigo[300],
              elevation: i == 0 ? 8.0 : null,
              margin: new EdgeInsets.only(left: 0.0),
              child: Container(
                //decoration:
                // i == 0 ? BoxDecoration(color: Colors.blue[100]) : null,

                decoration: i == 0
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo,
                            Colors.blue,
                            Colors.indigo,
                            Colors.indigo,
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        //  borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ])
                    : BoxDecoration(
                        // borderRadius: BorderRadius.circular(0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo,
                            //   Colors.blue,
                            Colors.indigo,
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        boxShadow: [
                            BoxShadow(
                                color: Palette.textColor1
                                    .withOpacity(.4), //.white.withOpacity(.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ]),

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
                        : const TextStyle(color: Colors.white),
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
                    width: MediaQuery.of(context).size.height < 600 ? 120 : 180,
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

_loadAndShowHTML(BuildContext context) async {
  selectedReport = "report2";
  var receivedHTML = await loadHTML(selectedReport);
  DataHTML _dataHTML = receivedHTML;
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowHTML_Page2(
            title: selectedReport, htmlContent: _dataHTML.htmlContent),
      ));
}
