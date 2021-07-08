import 'package:datawedgeflutter/model/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum FormatMarket { gipermarket, supermarket, express, gurme }

List<User> _users = User.getUsers();
// List<DropdownMenuItem<User>> _dropdownMenuItemsUser =
//     buildDropdownMenuItemsUser(_users);
User _selectedUser = _users[0];
List<Market> _markets = Market.getMarkets();
// List<DropdownMenuItem<Market>> _dropdownMenuItemsMarket =
//     buildDropdownMenuItemsMarket(_markets);
Market _selectedMarket = _markets[0];
List<DocumentType> _documentTypes = DocumentType.getDocumentTypes();
// List<DropdownMenuItem<DocumentType>> _dropdownMenuItemsDocumentType =
//     buildDropdownMenuItemsDocumentTypes(_documentTypes);
DocumentType _selectedDocumentType = _documentTypes[0];

class User {
  int id = 0;
  String name = "";
  IconData icon = Icons.account_balance_wallet;
  Market market = _markets[0];
  User(this.id, this.name, this.market, this.icon);

  static List<User> getUsers() {
    return <User>[
      User(0, '<не выбран>', _markets[0], Icons.agriculture_rounded),
      User(1, 'Иванов', _markets[0], Icons.agriculture_rounded),
      User(2, 'Петров', _markets[0], Icons.agriculture_rounded),
      User(3, 'Сидоров', _markets[0],
          Icons.airline_seat_legroom_reduced_outlined),
      User(
          4, 'Улановский', _markets[0], Icons.airline_seat_recline_extra_sharp),
      User(5, 'Путин', _markets[0], Icons.airline_seat_recline_extra_sharp),
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

saveSettingsHive() async {
  print(_selectedUser.id);
  print(_selectedMarket.id);
  print(_selectedDocumentType.id);

  var box = await Hive.openBox<Settings>('settings');

  Settings? mySettings = box.get("userID");
  print(mySettings!.name);
  print(mySettings.value); // id
  print(mySettings.key);

  if (_selectedUser.id == mySettings.value) {
  } else {}
  // Settings userID = Settings(_selectedUser.name, _selectedUser.id);
  // box.put("userID", userID);
  // Settings marketID = Settings(_selectedMarket.name, _selectedMarket.id);
  // box.put("marketID", marketID);
  // Settings documentTypeID =
  //     Settings(_selectedDocumentType.name, _selectedDocumentType.id);
  // box.put("documentTypeID", documentTypeID);
  //notifyListeners();
}

List<DropdownMenuItem<User>> buildDropdownMenuItemsUser(List users) {
  List<DropdownMenuItem<User>> items = [];
  for (User user in users) {
    items.add(
      DropdownMenuItem(
        value: user,
        child: Row(
          children: [
            Icon(
              user.icon,
              color: Colors.blue[100],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                user.name,
                style: TextStyle(color: Colors.blue.shade900),
              ),
            )
          ],
        ),
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<Market>> buildDropdownMenuItemsMarket(List markets) {
  List<DropdownMenuItem<Market>> items = [];
  for (Market market in markets) {
    items.add(
      DropdownMenuItem(
        value: market,
        child: Row(
          children: [
            Icon(
              market.icon,
              color: Colors.blue[100],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                market.name,
                style: TextStyle(color: Colors.blue.shade900),
              ),
            )
          ],
        ),
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<DocumentType>> buildDropdownMenuItemsDocumentTypes(
    List documentTypes) {
  List<DropdownMenuItem<DocumentType>> items = [];
  for (DocumentType documentType in documentTypes) {
    items.add(
      DropdownMenuItem(
        value: documentType,
        child: Row(
          children: [
            Icon(
              documentType.icon,
              color: Colors.blue[100],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                documentType.name,
                style: TextStyle(color: Colors.blue.shade900),
              ),
            )
          ],
        ),
      ),
    );
  }
  return items;
}

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(flex: 4, child: addProfileWidget(context)),
      Container(child: addSaveSettingsButton(context)),
      // Flexible(flex: 5, child: addPhotoScanButton(context)),
    ]);
  }

  @override
  void initState() {
    super.initState();

    Box<Settings> box = Hive.box<Settings>('settings');
    //  var box = await Hive.openBox<Settings>('settings');
    Settings? userIDSettings = box.get("userID");
    if (userIDSettings != null) {
      _selectedUser = _users[userIDSettings.value];
    } else {
      print(
          'Could not read user settings, value equals: ${userIDSettings!.value}'); // id
    }

    Settings? documentTypeIDSettings = box.get("documentTypeID");
    if (documentTypeIDSettings != null) {
      _selectedDocumentType = _documentTypes[documentTypeIDSettings.value];
    } else {
      print(
          'Could not read document type settings settings, value equals: ${documentTypeIDSettings!.value}'); // id
    }

    Settings? marketIDSettings = box.get("marketID");
    if (marketIDSettings != null) {
      _selectedMarket = _markets[marketIDSettings.value];
    } else {
      print(
          'Could not read market settings settings, value equals: ${documentTypeIDSettings.value}'); // id
    }
  }
  // @override
  // Future<void> initState() {

  //   super.initState();

  // }

// _loadSavedSettingsHive(){}
//  Box<Settings> box = Hive.box<Settings>('settings');
//     //  var box = await Hive.openBox<Settings>('settings');
//     Settings? userIDSettings = box.get("userID");
//     if (userIDSettings != null) {
//       _selectedUser = _users[userIDSettings.value];
//     } else {
//       print(
//           'Could not read user settings, value equals: ${userIDSettings!.value}'); // id
//     }

//     Settings? documentTypeIDSettings = box.get("documentTypeID");
//     if (documentTypeIDSettings != null) {
//       _selectedDocumentType = _documentTypes[documentTypeIDSettings.value];
//     } else {
//       print(
//           'Could not read document type settings settings, value equals: ${documentTypeIDSettings!.value}'); // id
//     }

//     Settings? marketIDSettings = box.get("marketID");
//     if (marketIDSettings != null) {
//       _selectedMarket = _markets[marketIDSettings.value];
//     } else {
//       print(
//           'Could not read market settings settings, value equals: ${documentTypeIDSettings.value}'); // id
//     }

//   Settings marketID = Settings(_selectedMarket.name, _selectedMarket.id);
//   box.put("marketID", marketID);
//   Settings documentTypeID =
//       Settings(_selectedDocumentType.name, _selectedDocumentType.id);
//   box.put("documentTypeID", documentTypeID);

// }

  Widget addProfileWidget(BuildContext context) {
    Widget widget = Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            child: Row(children: <Widget>[
              Text("Пользователь:  "),
              SizedBox(
                height: 5.0,
              ),
              // First element
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsUser(_users),
                    style: TextStyle(color: Colors.blue[300]),
                    value: _selectedUser,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        _selectedUser = valueSelectedByUser as User;
                      });
                    }),
              ))
            ])),
      ),
      Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Padding(
            padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
            child: Row(children: <Widget>[
              Text("Маркет:               "),
              SizedBox(
                height: 5.0,
              ),
              // First element
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsMarket(_markets),
                    style: TextStyle(color: Colors.blue[300]),
                    value: _selectedMarket,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        _selectedMarket = valueSelectedByUser as Market;
                      });
                    }),
              ))
            ])),
      ),
      Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Padding(
            padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
            child: Row(children: <Widget>[
              Text("Вид документа:"),
              SizedBox(
                height: 5.0,
              ),
              // First element
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsDocumentTypes(_documentTypes),
                    style: TextStyle(color: Colors.blue[300]),
                    value: _selectedDocumentType,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        _selectedDocumentType =
                            valueSelectedByUser as DocumentType;
                      });
                      ;
                    }),
              ))
            ])),
      ),
    ]);
    return widget;
  }

  Widget addSaveSettingsButton(BuildContext context) {
    Widget widget = GestureDetector(
      onTapDown: (TapDownDetails) async {
        saveSettingsHive();
        //setState(() {});
      },
      onTapUp: (TapUpDetails) {
        //  stopScan();
      },
      child: Container(
        margin: EdgeInsets.only(left: 120.0, right: 120, top: 10, bottom: 60),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blue[200],
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
}
