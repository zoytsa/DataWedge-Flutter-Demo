import 'dart:async';
import 'dart:convert';
import 'package:datawedgeflutter/dataloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datawedgeflutter/flutter_barcode_scanner.dart';

// void main() {
//   runApp(MyApp());
// }
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCT: 2 PRO',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'DCT: 2 PRO'),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
  List<String> _addedBarcodes = [];
  Good goodInfo = Good();

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

  String _barcodeString = "Barcode will be shown here";
  String _barcodeSymbology = "Symbology will be shown here";
  String _scanTime = "Scan Time will be shown here";

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
      //_addedBarcodes.add(barcodeScan['scanData']);
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
      loadData(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      _barcodeString = "Barcode: " + barcodeScanRes;
      _barcodeSymbology = "Symbology: " + "Photo Scan";
      String dateTime = DateTime.now().toLocal().toString();
      _scanTime = "At: " + dateTime; //"Now...";
      loadData(barcodeScanRes);
      //_addedBarcodes.add(barcodeScanRes);
    });
  }

  void _onManualInputBarcode(text) {
    setState(() {
      _barcodeString = "Barcode: " + text;
      _barcodeSymbology = "Symbology: manual input";
      String dateTime = DateTime.now().toLocal().toString();
      _scanTime = "At: " + dateTime;
      _addedBarcodes.clear();
      _addedBarcodes.add(goodInfo.name);
      _addedBarcodes.add("Поставщик: " + goodInfo.producer);
      _addedBarcodes.add("Дата поставки: " + goodInfo.indate);
      _addedBarcodes.add("Закупочная цена: " + goodInfo.pricein);
      _addedBarcodes.add("Розничная цена: " + goodInfo.priceout);
    });
  }

  void loadData(text) async {
    var receivedGoodInfo = await loadGoods(text);

    setState(() {
      goodInfo = receivedGoodInfo;
      _onManualInputBarcode(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DCT: 2 PRO"),
      ),
      body: Container(
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '$_barcodeString',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.only(bottom: 8),
                            //   child: Text(
                            //     '$_barcodeSymbology',
                            //     style: TextStyle(
                            //       color: Colors.grey[500],
                            //     ),
                            //   ),
                            // ),
                            // Text(
                            //   '$_scanTime',
                            //   style: TextStyle(
                            //     color: Colors.deepPurple,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
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
                    padding: EdgeInsets.all(20.0),
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
                ),
                GestureDetector(
                  // When the child is tapped, show a snackbar.
                  onTapDown: (TapDownDetails) {
                    //startScan();
                    scanBarcodeNormal();
                  },
                  onTapUp: (TapUpDetails) {
                    // stopScan();
                  },
                  // The custom button
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "PHOTO SCAN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //fontSize: 20,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Text('Scan result : $_scanBarcode\n',
                //   style: TextStyle(fontSize: 20))

                Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.cyan[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ]),
                ),
                addedBarcodesList(context, _addedBarcodes),
                // TextField(
                //   margin: EdgeInsets.all(8.0),
                //   decoration: InputDecoration(icon: Icon(Icons.access_alarms)),
                // )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Widget addedBarcodesList(BuildContext context, List addedBarcodes) {
  Widget widget = Flexible(
      child: ListView(
    children: <Widget>[
      for (var i in addedBarcodes)
        Card(
          child: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              i.toString(),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
            ),
          ),
        )
    ],
  ));

  return widget;
}
