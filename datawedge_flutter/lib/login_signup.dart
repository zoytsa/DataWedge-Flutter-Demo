import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/home_page.dart';
//import 'package:datawedgeflutter/open_iconic_flutter.dart';
import 'package:datawedgeflutter/restore_pass_page.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
//import 'package:flutter/cupertino.dart' as cupertino;
import 'model/settings.dart';

var loginEnteredID = 0;
var loginEnteredPin = 0;
var _controllerID = TextEditingController();
var _controllerPin = TextEditingController();

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = false;
  bool isMale = true;
  bool isDCT = false;
  //bool isRememberMe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //isDCT = MediaQuery.of(context).size.width < 721;

    Box<Settings> box = Hive.box<Settings>('settings');
    //  var box = await Hive.openBox<Settings>('settings');
    Settings? userIDSettings = box.get("userID");
    if (userIDSettings != null) {
      selectedUser = users[userIDSettings.value];
      if (selectedUser.id != 111111 && selectedUser.id != 0) {
        print(selectedUser.id);
        isAuthorized = true;
      }
    } else {
      selectedUser = users[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isSignupScreen) {
    //   _controllerID.clear();
    //   _controllerPin.clear();
    //   loginEnteredPin = 0;
    //   loginEnteredID = 0;
    // }
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Palette.backgroundColor,
          body: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -1),
                // top: 0,
                // right: 0,
                // left: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/background_qr.jpg"),
                          //image: AssetImage("images/background.jpg"),
                          fit: BoxFit.fill)),
                  child: Container(
                    padding: EdgeInsets.only(top: 105, left: 20),
                    color: Color(0xFF3b5999).withOpacity(.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Добро пожаловать!",
                            style: TextStyle(
                              fontSize: 23,
                              letterSpacing: 0.8,
                              color: Colors.yellow[500],
                            ),
                            // children: [
                            //   TextSpan(
                            //     text: isSignupScreen
                            //         ? "амиго,"
                            //         : " давно не виделись,",
                            //     style: TextStyle(
                            //       fontSize: 25,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.yellow[700],
                            //     ),
                            //   )
                            // ]
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          isSignupScreen
                              ? "Введите ID и пароль или воспользуйтесь демо-доступом..."
                              : "Введите ID и пароль или воспользуйтесь демо-доступом...",
                          style: TextStyle(
                            letterSpacing: 0.8,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  // top: 0,
                  // right: 0,
                  // left: 0,
                  child: Stack(alignment: Alignment.center, children: [
                    // Trick to add the shadow for the submit button
                    buildBottomHalfContainer(true),
                    //Main Contianer for Login and Signup
                    Positioned(
                      // duration: Duration(milliseconds: 300),
                      // curve: Curves.bounceInOut,
                      top: isSignupScreen ? 230 : 230,
                      child: Container(
                        // duration: Duration(milliseconds: 700),
                        // curve: Curves.bounceInOut,
                        height: isSignupScreen ? 290 : 290,
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 5),
                            ]),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSignupScreen = false;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "Войти...",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: !isSignupScreen
                                                  ? Palette.activeColor
                                                  : Palette.textColor1),
                                        ),
                                        if (!isSignupScreen)
                                          Container(
                                            margin: EdgeInsets.only(top: 3),
                                            height: 2,
                                            width: 55,
                                            color: Colors.yellow[500],
                                          )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //_controllerID.clear();
                                      _clearIDAndPin();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      setState(() {
                                        isSignupScreen = true;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "Демо-доступ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSignupScreen
                                                  ? Palette.activeColor
                                                  : Palette.textColor1),
                                        ),
                                        if (isSignupScreen)
                                          Container(
                                              margin: EdgeInsets.only(top: 3),
                                              height: 2,
                                              width: 55,
                                              color: Colors.yellow[500])
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              if (isSignupScreen) buildSignupSection(),
                              if (!isSignupScreen) buildSigninSection()
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Trick to add the submit button
                    buildBottomHalfContainer(false)
                  ])),
              //  Bottom buttons
              Positioned(
                //alignment: const Alignment(0, 100),
                top: MediaQuery.of(context).size.height < 600
                    ? 12
                    : MediaQuery.of(context).size.height - 100,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    // Text(isSignupScreen
                    //     ? "Забыли ID или пароль?"
                    //     : "Забыли ID или пароль?"),
                    Container(
                      margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildTextButton(
                              Icons.queue_play_next_sharp,
                              "    Забыли ID или пароль?    ",
                              Color(0xFF3b5999).withOpacity(.85)),
                          // Palette.facebookColor),
                          // buildTextButton(MaterialCommunityIcons.google_plus,
                          //     "Google", Palette.googleColor),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextFieldID(
            Icons.perm_identity,
            isAuthorized ? enteredID.toString() : "Введите ID",
            false,
            false,
          ),
          //buildTextField(MaterialCommunityIcons.lock_outline, "**********",
          buildTextFieldPin(
              Icons.lock_outline,
              //  IconData(0xe3b1, fontFamily: 'MaterialIcons'),
              //OpenIconicIcons.target,
              "**********",
              true,
              false),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  Text("Запомнить меня на этом устройстве",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: Text("Забыли ID или пароль?",
              //       style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              // )
            ],
          )
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          //    buildTextField(MaterialCommunityIcons.account_outline, "111111",
          buildTextFieldID(
              //IconData(0xee35, fontFamily: 'MaterialIcons'),
              Icons.person,
              // OpenIconicIcons.share,
              "111111",
              false,
              false),
          // buildTextField(
          //     MaterialCommunityIcons.email_outline, "email", false, true),
          // buildTextField(
          //     MaterialCommunityIcons.lock_outline, "password", true, false),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                  """При использовании демонстрационного входа Вам не будет доступна часть функционала...
Для демонстрационного входа введите 111111.""",
                  style: TextStyle(fontSize: 12, color: Palette.textColor1))
              //   child: Row(
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             isMale = true;
              //           });
              //         },
              //         child: Row(
              //           children: [
              //             Container(
              //               width: 30,
              //               height: 30,
              //               margin: EdgeInsets.only(right: 8),
              //               decoration: BoxDecoration(
              //                   color: isMale
              //                       ? Palette.textColor2
              //                       : Colors.transparent,
              //                   border: Border.all(
              //                       width: 1,
              //                       color: isMale
              //                           ? Colors.transparent
              //                           : Palette.textColor1),
              //                   borderRadius: BorderRadius.circular(15)),
              //               child: Icon(
              //                 MaterialCommunityIcons.account_outline,
              //                 color: isMale ? Colors.white : Palette.iconColor,
              //               ),
              //             ),
              //             Text(
              //               "Male",
              //               style: TextStyle(color: Palette.textColor1),
              //             )
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         width: 30,
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             isMale = false;
              //           });
              //         },
              //         child: Row(
              //           children: [
              //             Container(
              //               width: 30,
              //               height: 30,
              //               margin: EdgeInsets.only(right: 8),
              //               decoration: BoxDecoration(
              //                   color: isMale
              //                       ? Colors.transparent
              //                       : Palette.textColor2,
              //                   border: Border.all(
              //                       width: 1,
              //                       color: isMale
              //                           ? Palette.textColor1
              //                           : Colors.transparent),
              //                   borderRadius: BorderRadius.circular(15)),
              //               child: Icon(
              //                 MaterialCommunityIcons.account_outline,
              //                 color: isMale ? Palette.iconColor : Colors.white,
              //               ),
              //             ),
              //             Text(
              //               "Female",
              //               style: TextStyle(color: Palette.textColor1),
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 20),
            // child: RichText(
            //   textAlign: TextAlign.center,
            //   text: TextSpan(
            //       text: "By pressing 'Submit' you agree to our ",
            //       style: TextStyle(color: Palette.textColor2),
            //       children: [
            //         TextSpan(
            //           //recognizer: ,
            //           text: "term & conditions",
            //           style: TextStyle(color: Colors.orange),
            //         ),
            //       ]),
            // ),
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Restore_pass_page(title: "Restore pass..."),
            ))
      },
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return Positioned(
      // duration: Duration(milliseconds: 700),
      // curve: Curves.bounceInOut,
      top: isSignupScreen ? 480 : 480,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 80,
          width: 150,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? GestureDetector(
                  onTapDown: (TapDownDetails) {
                    //if (
                    accessAlowed(context, loginEnteredID, loginEnteredPin);
                    //   {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         MyHomePage(title: "Connector F"),
                    //   ),
                    // );
                    // } else {
                    //   print('auth error');
                    // }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo,
                              Colors.blue,
                              Color(0xFF3b5999)
                            ],
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
                        SizedBox(width: 15),
                        Icon(
                          //OpenIconicIcons.accountLogin,
                          Icons.stars,
                          // IconData(0xe09c,
                          //     fontFamily: 'MaterialIcons',
                          //     matchTextDirection: true),
                          color: Colors.white,
                        ),
                        Text("СТАРТ",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center)
                        // Icon(
                        //   // Icons.arrow_forward,
                        //   IconData(0xe09c,
                        //       fontFamily: 'MaterialIcons', matchTextDirection: true),
                        //   color: Colors.white,

                        // ),
                      ])))
              : Center(),
        ),
      ),
    );
  }

  Widget buildTextFieldID(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
          ],
          controller: _controllerID,
          obscureText: isPassword,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
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
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
            suffixIcon: !isSignupScreen
                ? IconButton(
                    // onPressed: _controllerID.clear(),
                    onPressed: () => _clearIDAndPin(),
                    icon: Icon(Icons.clear),
                  )
                : null,
          ),
          onChanged: (String str) {
            {
              try {
                loginEnteredID = int.parse(str);
              } catch (e) {
                loginEnteredID = 0;
              }
            }
            ;
          }),
    );
  }
}

Widget buildTextFieldPin(
    IconData icon, String hintText, bool isPassword, bool isEmail) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        controller: _controllerPin,
        obscureText: isPassword,
        keyboardType:
            isEmail ? TextInputType.emailAddress : TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
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
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
          // suffixIcon: IconButton(
          //   onPressed: _controllerPin.clear,
          //   icon: Icon(Icons.clear),
          // ),
        ),
        onChanged: (String str) {
          {
            try {
              loginEnteredPin = int.parse(str);
            } catch (e) {
              loginEnteredPin = 0;
            }
          }

          ;
        }),
  );
}

void _clearIDAndPin() {
  _controllerID.clear();
  _controllerPin.clear();
  loginEnteredID = 0;
  loginEnteredPin = 0;
}
