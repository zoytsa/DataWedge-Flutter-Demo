import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:datawedgeflutter/model/settings.dart';
import 'package:datawedgeflutter/show_html_page.dart';
import 'package:datawedgeflutter/show_html_page2.dart';
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
              color: Colors.indigo[200],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    user.name,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ))
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
              color: Colors.indigo[200],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    market.name,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ))
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
              color: Colors.indigo[200],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    documentType.name,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                )),
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
              color: Colors.indigo[200],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    profile.getName(),
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<String>> buildDropDownReports() {
  List<DropdownMenuItem<String>> items = [];
  var reports = ["report1", "report2", "report3", "report4", "report5"];
  for (String report in reports) {
    items.add(
      DropdownMenuItem(
        value: report,
        child: Row(
          children: [
            // Icon(
            //   profile.getIcon(),
            //   color: Colors.indigo[200],
            // ),
            Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    report,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ))
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
              color: Colors.indigo[200],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    profileRole.name,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ))
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
              color: Colors.indigo[200],
            ),
            Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: SizedBox(
                  width: 130,
                  child: Text(
                    profile.getName(),
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  return items;
}

class profilePage extends StatefulWidget {
  var vcbUsingZebra = usingZebra;
  final VoidCallback? vcbUsingZebraOnSelected;
  final Function(bool) vcbUsinZebraOnChanged;

  profilePage(
      {Key? key,
      required this.vcbUsingZebra,
      this.vcbUsingZebraOnSelected,
      required this.vcbUsinZebraOnChanged})
      : super(key: key);

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    // var my_vcbUsingZebraOnSelected = widget.vcbUsingZebraOnSelected!();
    // var vcbUsinZebraOnChanged = widget.vcbUsinZebraOnChanged();
    bool isDCT = MediaQuery.of(context).size.height < 600;
    return Container(
        // backgroundColor: Color(0xFF3b5999).withOpacity(0.9),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage("images/background.jpg"),
        //   fit: BoxFit.cover,
        //   colorFilter: new ColorFilter.mode(
        //       Colors.black.withOpacity(0.1), BlendMode.dstATop),

        //   // fit: BoxFit.scaleDown //.fill
        // )),
        child: SingleChildScrollView(
            // child: Container(
            // color: Colors.white.withOpacity(.85),
            //child: //Column(children: <Widget>[
            //Container(
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Row(children: [
                  //   ? isDCT Icon(Icons.person) : Icon(Icons.person),
                  //Icon(Icons.person),
                  isDCT
                      ? Icon(Icons.person, color: Palette.textColor1)
                      : SizedBox(),
                  !isDCT
                      ? Text("Пользователь: ",
                          style: TextStyle(color: Palette.textColor2))
                      : SizedBox(),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                      width: 220,
                      child: ListTile(
                        title: DropdownButton(
                            items: buildDropdownMenuItemsUser(users),
                            style: TextStyle(color: Colors.blue[300]),
                            value: selectedUser,
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                debugPrint(
                                    'User selected $valueSelectedByUser');
                                // onChangeDropdownItem(valueSelectedByUser as Market);
                                selectedUser = valueSelectedByUser as User;
                                saveSettingsHive(context);
                                saveProfileOnDCT(context);
                              });
                            }),
                      )),
                  //buttonExit(context)
                ])),
          ),
          buttonExit(context),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 20.0),
                child: Row(children: [
                  // isDCT
                  //     ? Icon(
                  //         Icons.security_rounded,
                  //         color: Palette.textColor1,
                  //       )
                  //     : SizedBox(),
                  // !isDCT
                  //     ? Text("Профиль:          ",
                  //         style: TextStyle(color: Palette.textColor2))
                  //     : SizedBox(),
                  // SizedBox(
                  //   height: 5.0,
                  //   //          width: 100,
                  // ),
                  SizedBox(
                      width: 120,
                      child: ListTile(
                        title: DropdownButton(
                            items: buildDropDownReports(),
                            style: TextStyle(color: Colors.blue[300]),
                            value: selectedReport,
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                debugPrint(
                                    'User selected $valueSelectedByUser');

                                selectedReport = valueSelectedByUser as String;
                              });
                              ;
                            }),
                      )),
                  buttonHTMLSample(context),
                ])),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Row(children: <Widget>[
                  isDCT
                      ? Icon(
                          Icons.security_rounded,
                          color: Palette.textColor1,
                        )
                      : SizedBox(),
                  !isDCT
                      ? Text("Профиль:          ",
                          style: TextStyle(color: Palette.textColor2))
                      : SizedBox(),
                  SizedBox(
                    height: 5.0,
                    //          width: 100,
                  ),
                  SizedBox(
                      width: 220,
                      child: ListTile(
                        title: DropdownButton(
                            items: buildTest(profiles),
                            style: TextStyle(color: Colors.blue[300]),
                            value: selectedProfile,
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                debugPrint(
                                    'User selected $valueSelectedByUser');
                                // onChangeDropdownItem(valueSelectedByUser as Market);
                                selectedProfile =
                                    valueSelectedByUser as Profile;
                                saveSettingsHive(context);
                                saveProfileOnDCT(context);
                              });
                              ;
                            }),
                      ))
                ])),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(children: <Widget>[
                  isDCT
                      ? Icon(Icons.shop_outlined, color: Palette.textColor1)
                      : SizedBox(),
                  !isDCT
                      ? Text("Маркет:             ",
                          style: TextStyle(color: Palette.textColor2))
                      : SizedBox(),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                      width: 220,
                      child: ListTile(
                        title: DropdownButton(
                            items: buildDropdownMenuItemsMarket(markets),
                            style: TextStyle(color: Colors.blue[300]),
                            value: selectedMarket,
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                debugPrint(
                                    'User selected $valueSelectedByUser');
                                // onChangeDropdownItem(valueSelectedByUser as Market);
                                selectedMarket = valueSelectedByUser as Market;
                                saveSettingsHive(context);
                                saveProfileOnDCT(context);
                              });
                            }),
                      ))
                ])),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(children: <Widget>[
                  isDCT
                      ? Icon(Icons.document_scanner_outlined,
                          color: Palette.textColor1)
                      : SizedBox(),
                  !isDCT
                      ? Text("Документ:        ",
                          style: TextStyle(color: Palette.textColor2))
                      : SizedBox(),
                  SizedBox(height: 5.0),
                  SizedBox(
                      width: 220,
                      child: ListTile(
                        title: DropdownButton(
                            items: buildDropdownMenuItemsDocumentTypes(
                                documentTypes),
                            style: TextStyle(color: Colors.blue[300]),
                            value: selectedDocumentType,
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                debugPrint(
                                    'User selected $valueSelectedByUser');
                                // onChangeDropdownItem(valueSelectedByUser as Market);
                                selectedDocumentType =
                                    valueSelectedByUser as DocumentType;
                                saveSettingsHive(context);
                                saveProfileOnDCT(context);
                              });
                              ;
                            }),
                      ))
                ])),
          ),
          Container(
            //width: 250,

            padding: const EdgeInsets.only(right: 20.0),
            child: Column(//crossAxisAlignment: CrossAxisAlignment.center,
                // width: 250,
                children: [
              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      //SizedBox(width: 3),
                      Checkbox(
                        value: usingZebra,
                        activeColor: Palette.textColor2,
                        onChanged: (value) {
                          setState(() {
                            usingZebra = !usingZebra;
                            saveSettingsHive(context);
                            saveProfileOnDCT(context);
                            widget.vcbUsinZebraOnChanged(usingZebra);
                            widget.vcbUsingZebraOnSelected!();
                            // my_vcbUsingZebraOnSelected();
                            //  super.setState(() {});
                          });
                        },
                      ),
                      Container(
                          width: 250,
                          child: Text(
                            "Отображать кнопку встроенного сканера ТСД (Zebra)",
                            style: TextStyle(
                                fontSize: 14, color: Palette.textColor1),
                            softWrap: true,
                            textAlign: TextAlign.left,
                          ))
                    ],
                  )),
            ]),
          ),
        ]))));

    // Container(child: addSaveSettingsButton(context)),
    // Flexible(flex: 5, child: addPhotoScanButton(context)),
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
      selectedProfile = profileIDSettings.value is int
          ? profiles[profileIDSettings.value]
          : selectedProfile = profiles[0];
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

  _loadAndShowHTML(BuildContext context) async {
    var receivedHTML = await loadHTML(selectedReport);
    DataHTML _dataHTML = receivedHTML;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowHTML_Page2(
              title: selectedReport, htmlContent: _dataHTML.htmlContent),
        ));
  }

  // setState(() {
  //   goodInfo = receivedGoodInfo;
  //   //addButtonTitle = addButtonTitle;
  //   _onManualInputBarcode(text);
  // });

  Widget addProfileWidget(
      BuildContext context, VoidCallback my_vcbUsingZebraOnSelected) {
    return widget;
  }

  Widget addSaveSettingsButton(BuildContext context) {
    Widget widget = GestureDetector(
        onTapDown: (TapDownDetails) async {
          saveSettingsHive(context);
          saveProfileOnDCT(context);
        },
        onTapUp: (TapUpDetails) {},
        child: SizedBox(
          width: 120,
          child: Container(
            margin: EdgeInsets.only(bottom: 50),
            padding: EdgeInsets.all(15.0),
            // decoration: BoxDecoration(
            //   color: Colors.blue[200],
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
            child: Center(
              child: Text(
                "    Сохранить    ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ));
    return widget;
  }

  Widget buttonExit(BuildContext context) {
    return
        // GestureDetector(
        //     onTapDown: (TapDownDetails) async {
        //       saveExitSettingsHive(context);
        //     },
        //     onTapUp: (TapUpDetails) {},
        //     child:
        SizedBox(
            width: 120,
            height: 40,
            child: TextButton(
              onPressed: () => saveExitSettingsHive(context),
              style: TextButton.styleFrom(
                  //side: BorderSide(width: 1, color: Colors.white),
                  minimumSize: Size(60, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  primary: Colors.white,
                  backgroundColor: Colors.indigo[200]),
              child: Row(
                children: [
                  Text(
                    "   Выйти...",
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.exit_to_app_rounded,
                  ),
                ],
              ),
            ));
  }

  Widget buttonHTMLSample(BuildContext context) {
    return
        // GestureDetector(
        //     onTapDown: (TapDownDetails) async {
        //       saveExitSettingsHive(context);
        //     },
        //     onTapUp: (TapUpDetails) {},
        //     child:
        SizedBox(
            width: 100,
            height: 30,
            child: TextButton(
              onPressed: () => _loadAndShowHTML(context),
              style: TextButton.styleFrom(
                  //side: BorderSide(width: 1, color: Colors.white),
                  minimumSize: Size(60, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  primary: Colors.white,
                  backgroundColor: Colors.black54),
              child: Row(
                children: [
                  Text(
                    " HTML  ",
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.http,
                  ),
                ],
              ),
            ));
  }
}
