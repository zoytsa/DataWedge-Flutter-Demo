import 'dart:convert';
import 'package:datawedgeflutter/model/documents_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

final String _dct_username = 'weblink';
final String _dct_password = 'weblinK312!';
final String _dct_basicAuth =
    'Basic ' + base64Encode(utf8.encode('$_dct_username:$_dct_password'));

final Map<String, String> _dct_headers = {
  'Content-Type': 'application/json; charset=UTF-8',
  // 'accept': 'application/json',
  'authorization': _dct_basicAuth
};

class DocumentsPage extends StatefulWidget {
  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  int _currentPage = 1;
  String _lastElementId = "";
  String _maxElementId = "";
  late int _totalPages;
  final ScrollController _scrollController = ScrollController();

  List<DocumentInfo> _documents = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  //final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future<bool> getListOfDocuments({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _lastElementId = "";
    } else {
      if (_currentPage >= _totalPages ||
          _lastElementId.compareTo(_maxElementId) == 1) {
        // ???!!! str1.compareTo(str2) ==1
        _refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri = Uri.parse(
        "http://212.112.116.229:7788/weblink/hs/api/documents/1?last_element_id=$_lastElementId&size=50");

    final response = await http.get(uri, headers: _dct_headers);

    if (response.statusCode == 200) {
      final result = listOfDocumentsFromJson(response.body);

      if (isRefresh) {
        _documents = result.data;
      } else {
        _documents.addAll(result.data);
      }

      _currentPage++;
      _lastElementId = result.lastElementId;
      _totalPages = result.totalPages;
      _maxElementId = result.maxElementId;

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Документы..."),
      // ),
      body: SmartRefresher(
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Потяните вверх, чтобы загрузить еще...",
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic));
            } else if (mode == LoadStatus.loading) {
              body = Container();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Загрузить еще.", // "release to load more"
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic));
            } else {
              body = Text("Загрузка завершена.", // "No more Data"
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic));
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          final result = await getListOfDocuments(isRefresh: true);
          if (result) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getListOfDocuments();
          if (result) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadFailed();
          }
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            final document = _documents[index];
            return documentInfoListTile3(document, index);
            // return ListTile(
            //   title: Text(document.number),
            //   subtitle: Text(document.date),
            //   trailing: Text(
            //     document.editedDate,
            //     style: TextStyle(color: Colors.green),
            //   ),
            // );
          },
          //  separatorBuilder: (context, index) => Divider(),
          itemCount: _documents.length,
          controller: _scrollController,
        ),
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          shape: CircleBorder(),
          //  childPadding: const EdgeInsets.symmetric(vertical: 5),
          overlayOpacity: 0,
          //childrenButtonSize: 60,
          spacing: 6,
          animationSpeed: 200, // openCloseDial: isDialOpen,
          childPadding: EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          //  icon: Icons.share,
          backgroundColor: Colors.indigo[400],
          children: [
            SpeedDialChild(
                //child: Icon(Icons.arrow_downward_sharp,
                child: Icon(Icons.keyboard_arrow_down_outlined,
                    color: Colors.indigo[400]),
                // label: 'Social Network',
                backgroundColor: Colors.white,
                onTap: () {
                  if (_scrollController.hasClients) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }
                }
                //  foregroundColor: Colors.white70,
                // onTap: () {/* Do someting */},
                ),
            SpeedDialChild(
                child: Icon(Icons.keyboard_arrow_up_outlined,
                    color: Colors.indigo[400]),
                // label: 'Social Network',
                backgroundColor: Colors.white,
                onTap: () {
                  if (_scrollController.hasClients) {
                    _scrollController
                        .jumpTo(_scrollController.position.minScrollExtent);
                  }
                }),
            // SpeedDialChild(
            //   child: Icon(Icons.chat),
            //   label: 'Message',
            //   backgroundColor: Colors.amberAccent,
            //   onTap: () {/* Do something */},
            // ),
          ]),
    );
  }

  Widget documentInfoListTile3(DocumentInfo document, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${index + 1}) Номер: ${document.number}'),
            subtitle: Text('Дата: ${document.date}'),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.indigo),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'open',
                    child: Text('Открыть'),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Редактировать'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Удалить'),
                  )
                ];
              },
              onSelected: (String value) =>
                  actionPopUpItemSelected(value, document.number),
            ),
          ),
          // Divider(
          //   height: 1.0,
          // ),
          ListTile(
            leading: Icon(Icons.description, color: Colors.indigo[400]),
            title: Text(document.operationId.toString() +
                ' Товар 1: Кока-кола 1 л, 5 ед.'),
            subtitle: Text('Товар 17: Кока-кола 1 л, 5 ед.'),
          )
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  void actionPopUpItemSelected(String value, String name) {
    //_scaffoldkey.currentState.hideCurrentSnackBar();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    String message;
    if (value == 'edit') {
      message = 'You selected edit for $name';
    } else if (value == 'delete') {
      message = 'You selected delete for $name';
    } else {
      message = 'Not implemented';
    }
    // final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.deepOrange[100],
        content: Text(message),
      ),
    );
    // _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
