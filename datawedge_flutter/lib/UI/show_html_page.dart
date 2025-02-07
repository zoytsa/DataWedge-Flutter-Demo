import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ShowHTML_Page extends StatefulWidget {
  ShowHTML_Page({Key? key, required this.title, required this.htmlContent})
      : super(key: key);

  final String htmlContent;
  final String title;

  @override
  _ShowHTML_PageState createState() => _ShowHTML_PageState();
}

class _ShowHTML_PageState extends State<ShowHTML_Page> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text("Browser")),
        child: SafeArea(
          child: WebView(
              initialUrl: "",
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptMode: JavascriptMode.unrestricted),
        ));
  }

  @override
  void initState() {
    super.initState();
    _controller.future.then((controller) {
      _loadHtmlFromAssets(controller);
    });
  }

  Future<void> _loadHtmlFromAssets(WebViewController controller) async {
    String fileText =
        await rootBundle.loadString('assets/webpages/report1.html');
    String theURI = Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();

    //String theURI = widget.htmlContent;
    setState(() {
      print(theURI);
      controller.loadUrl(theURI);
    });
  }

//   @override
//   Widget build(BuildContext context) {
// // dom.Document document = htmlparser.parse(widget.htmlContent);
// // /// sanitize or query document here
// // Widget html = Html(
// //   document: document, data: '',
// // );
//     //print(widget.htmlContent);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: TextStyle(fontSize: 15)),
//         centerTitle: true,
//         flexibleSpace: (Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//           colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
//           begin: Alignment.bottomRight,
//           end: Alignment.topLeft,
//         )))),
//         elevation: 20,
//         titleSpacing: 20,
//       ),
//       // body: SafeArea(
//       //   child: widget.title == "report1"
//       //       ? SingleChildScrollView(
//       //           // scrollDirection: Axis.horizontal,
//       //           child: Html(
//       //           shrinkWrap: true,
//       //           data: widget.htmlContent,
//       //           style: {
//       //             'h1': Style(color: Colors.red),
//       //             'p': Style(color: Colors.black87, fontSize: FontSize.medium),
//       //             'ul': Style(margin: EdgeInsets.symmetric(vertical: 20))
//       //           },
//       //         ))
//       //       : SingleChildScrollView(
//       //           scrollDirection: Axis.horizontal,
//       //           child: //HtmlWidget(widget.htmlContent
//       //               SingleChildScrollView(
//       //             scrollDirection: Axis.vertical,
//       //             child: Html(
//       //               shrinkWrap: true,
//       //               data: widget.htmlContent,
//       //               style: {
//       //                 'h1': Style(color: Colors.red),
//       //                 'p': Style(
//       //                     color: Colors.black87, fontSize: FontSize.medium),
//       //                 'ul': Style(margin: EdgeInsets.symmetric(vertical: 20))
//       //               },
//       //             ),
//       //           )),
//       // ),

//       body: (SizedBox()),
//     );
//   }
}
