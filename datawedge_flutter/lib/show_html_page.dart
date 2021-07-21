import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class ShowHTML_Page extends StatefulWidget {
  ShowHTML_Page({Key? key, required this.title, required this.htmlContent})
      : super(key: key);

  final String title;
  final String htmlContent;

  @override
  _ShowHTML_PageState createState() => _ShowHTML_PageState();
}

class _ShowHTML_PageState extends State<ShowHTML_Page> {
// *** WIDGETS: MAIN SCAN *** //

  @override
  Widget build(BuildContext context) {
// dom.Document document = htmlparser.parse(widget.htmlContent);
// /// sanitize or query document here
// Widget html = Html(
//   document: document, data: '',
// );
    //print(widget.htmlContent);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 15)),
        centerTitle: true,
        flexibleSpace: (Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )))),
        elevation: 20,
        titleSpacing: 20,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  // direction: Axis.horizontal,
                  children: <Widget>[
                    // Flexible(
                    //   child:
                    Html(
                      shrinkWrap: true,
                      data: widget.htmlContent,

                      // document: document,
                      // Styling with CSS (not real CSS)
                      style: {
                        'h1': Style(color: Colors.red),
                        'p': Style(
                            color: Colors.black87, fontSize: FontSize.medium),
                        'ul': Style(margin: EdgeInsets.symmetric(vertical: 20))
                      },
                    ),
                    //  ),
                  ])),
        ),
      ),
    );
  }
}
