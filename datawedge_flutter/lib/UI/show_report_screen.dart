import 'dart:async';
import 'dart:convert';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/dataloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowReport extends StatefulWidget {
  ShowReport({Key? key, required this.title, required this.htmlContent})
      : super(key: key);

  final String htmlContent;
  final String title;

  @override
  _ShowReportState createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedReport.title, style: TextStyle(fontSize: 15)),
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
      body: WebviewScaffold(
        withZoom: true,
        displayZoomControls: true,
        useWideViewPort: true,
        withOverviewMode: true,
        url: new Uri.dataFromString(widget.htmlContent,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString(),
      ),
    );
  }
}
