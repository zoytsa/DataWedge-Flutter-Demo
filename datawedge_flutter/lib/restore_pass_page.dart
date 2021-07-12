import 'package:flutter/material.dart';

class Restore_pass_page extends StatefulWidget {
  Restore_pass_page({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Restore_pass_pageState createState() => _Restore_pass_pageState();
}

class _Restore_pass_pageState extends State<Restore_pass_page> {
// *** WIDGETS: MAIN SCAN *** //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
              elevation: 20,
              titleSpacing: 20,
            ),
            body: Container(
                child: Container(
                    // backgroundColor: Color(0xFF3b5999).withOpacity(0.9),

                    child: (Container(
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         image:
                        //             AssetImage("images/background_friends.jpg"),
                        //         // fit: BoxFit.cover,
                        //         colorFilter: new ColorFilter.mode(
                        //             Colors.black.withOpacity(0.1),
                        //             BlendMode.dstATop),
                        //         fit: BoxFit.scaleDown //.fill
                        //         )),
                        child: SizedBox(
                            width: 150,
                            child: Padding(
                                padding: EdgeInsets.only(left: 30, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(
                                    //   height: 40,
                                    // ),
                                    Text("id: 1, pass: 1, Иванов"),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text("id: 2, pass: 2, Петров"),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text("id: 3, pass: 3, Сидоров"),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      "id: 4, pass: 4, Улановский",
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text("id: 5, pass: 5, Путин"),
                                    SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                )))))))));
  }
}
