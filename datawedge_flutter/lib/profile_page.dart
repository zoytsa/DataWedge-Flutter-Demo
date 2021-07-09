import 'package:datawedgeflutter/model/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dataloader.dart' as dataloader;
import 'dataloader.dart';

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
      dataloader.selectedUser = dataloader.users[userIDSettings.value];
    } else {
      dataloader.selectedUser = dataloader.users[0];
      // print(
      //     'Could not read user settings, value equals: ${userIDSettings!.value}'); // id
    }

    Settings? documentTypeIDSettings = box.get("documentTypeID");
    if (documentTypeIDSettings != null) {
      dataloader.selectedDocumentType =
          dataloader.documentTypes[documentTypeIDSettings.value];
    } else {
      dataloader.selectedDocumentType = dataloader.documentTypes[0];
      // print(
      //     'Could not read document type settings settings, value equals: ${documentTypeIDSettings!.value}'); // id
    }

    Settings? marketIDSettings = box.get("marketID");
    if (marketIDSettings != null) {
      dataloader.selectedMarket = dataloader.markets[marketIDSettings.value];
    } else {
      dataloader.selectedMarket = dataloader.markets[0];
      // print(
      //     'Could not read market settings settings, value equals: ${documentTypeIDSettings.value}'); // id
    }
  }

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
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsUser(dataloader.users),
                    style: TextStyle(color: Colors.blue[300]),
                    value: dataloader.selectedUser,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        dataloader.selectedUser = valueSelectedByUser as User;
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
              Text("Доступ:               "),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsProfile(dataloader.profiles),
                    style: TextStyle(color: Colors.blue[300]),
                    value: dataloader.selectedMarket,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        dataloader.selectedMarket =
                            valueSelectedByUser as Market;
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
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsMarket(dataloader.markets),
                    style: TextStyle(color: Colors.blue[300]),
                    value: dataloader.selectedMarket,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        dataloader.selectedMarket =
                            valueSelectedByUser as Market;
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
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildDropdownMenuItemsDocumentTypes(
                        dataloader.documentTypes),
                    style: TextStyle(color: Colors.blue[300]),
                    value: dataloader.selectedDocumentType,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        dataloader.selectedDocumentType =
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
        saveSettingsHive(context);
        saveProfileOnDCT(context);
      },
      onTapUp: (TapUpDetails) {},
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
