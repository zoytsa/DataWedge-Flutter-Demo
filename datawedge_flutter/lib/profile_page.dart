import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/model/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
//import 'package:fluttertoast/fluttertoast.dart';

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

List<DropdownMenuItem<Profile>> buildTest(List profiles) {
  List<DropdownMenuItem<Profile>> items = [];
  for (Profile profile in profiles) {
    items.add(
      DropdownMenuItem(
        value: profile,
        child: Row(
          children: [
            Icon(
              profile.getIcon(),
              color: Colors.blue[100],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                profile.name,
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

List<DropdownMenuItem<ProfileRole>> buildDropdownMenuItemsProfileRoles(
    List profileRoles) {
  List<DropdownMenuItem<ProfileRole>> items = [];
  //var profile = profiles[0];
  for (ProfileRole profileRole in profileRoles) {
    items.add(
      DropdownMenuItem(
        value: profileRole,
        child: Row(
          children: [
            Icon(
              profileRole.icon,
              color: Colors.blue[100],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                profileRole.name,
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

List<DropdownMenuItem<Profile>> buildDropdownMenuItemsProfile(List profiles) {
  List<DropdownMenuItem<Profile>> items = [];
  //var profile = profiles[0];
  for (Profile profile in profiles) {
    items.add(
      DropdownMenuItem(
        value: profile,
        child: Row(
          children: [
            Icon(
              profile.getIcon(),
              color: Colors.blue[100],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                profile.name,
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
      selectedProfile = profiles[profileIDSettings.value];
    } else {
      selectedProfile = profiles[0];
    }

    // Settings? profileDataSettings = box.get("profileData");
    // if (profileDataSettings != null) {
    //   //converting map dynamic dynamic to map string dynamic
    //   Map<String, dynamic> dataJson = {};
    //   profileDataSettings.value.forEach((k, v) => dataJson[k.toString()] = v);
    //   selectedProfile = Profile.fromJson(dataJson);
    //   print(selectedProfile);
    // }
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
                    items: buildDropdownMenuItemsUser(users),
                    style: TextStyle(color: Colors.blue[300]),
                    value: selectedUser,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        selectedUser = valueSelectedByUser as User;
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
                    items: buildDropdownMenuItemsMarket(markets),
                    style: TextStyle(color: Colors.blue[300]),
                    value: selectedMarket,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        selectedMarket = valueSelectedByUser as Market;
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
                    items: buildDropdownMenuItemsDocumentTypes(documentTypes),
                    style: TextStyle(color: Colors.blue[300]),
                    value: selectedDocumentType,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        selectedDocumentType =
                            valueSelectedByUser as DocumentType;
                      });
                      ;
                    }),
              ))
            ])),
      ),
      // SizedBox(
      //   height: 30.0,
      // ),
      // Container(
      //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      //   child: Padding(
      //       padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
      //       child: Row(children: <Widget>[
      //         Text("Профиль-роль:                  "),
      //         SizedBox(
      //           height: 5.0,
      //         ),
      //         Expanded(
      //           child: Text(selectedProfile.name.toString()),
      //           // child: ListTile(
      //           //   title: DropdownButton(
      //           //       items: buildDropdownMenuItemsProfileRoles(profileRoles),
      //           //       style: TextStyle(color: Colors.blue[300]),
      //           //       value: selectedProfile,
      //           //       onChanged: (valueSelectedByUser) {
      //           //         setState(() {
      //           //           debugPrint('User selected $valueSelectedByUser');
      //           //           // onChangeDropdownItem(valueSelectedByUser as Market);
      //           //           //selectedProfile = valueSelectedByUser as ProfileRole;
      //           //         });
      //           //       }),
      //           // ),
      //         )
      //       ])),
      // ),
      Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Padding(
            padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
            child: Row(children: <Widget>[
              Text("Профиль:           "),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                  child: ListTile(
                title: DropdownButton(
                    items: buildTest(profiles),
                    style: TextStyle(color: Colors.blue[300]),
                    value: selectedProfile,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        // onChangeDropdownItem(valueSelectedByUser as Market);
                        selectedProfile = valueSelectedByUser as Profile;
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
