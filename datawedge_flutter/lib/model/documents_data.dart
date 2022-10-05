import 'dart:convert';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/presentation/cubit/goods_items_cubit.dart';
import 'package:datawedgeflutter/presentation/cubit/goods_items_title_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
//import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/categories_data.dart';

ListOfDocuments listOfDocumentsFromJsonBytes(bodyBytes) =>
    ListOfDocuments.fromJson(jsonDecode(utf8.decode(bodyBytes)));

ListOfDocuments listOfDocumentsFromJson(String str) =>
    ListOfDocuments.fromJson(json.decode(str));

String listOfDocumentsToJson(ListOfDocuments data) =>
    json.encode(data.toJson());

class ListOfDocuments {
  String lastElementId = '';
  String lastElementTitle = '';
  String firstElementId = '';
  String firstElementTitle = '';
  String isOffsetPagination = 'false';
  String objectType = 'documents-task';
  String sessionId = '';
  String filter = '';
  int size = 25;
  int useCache = 0;
  List<DocumentInfo> data = [];
  int totalElements = 0;
  int totalPages = 0;
  String maxElementId = "";

  ListOfDocuments(
      {required this.lastElementId,
      required this.lastElementTitle,
      required this.firstElementId,
      required this.firstElementTitle,
      required this.isOffsetPagination,
      required this.objectType,
      required this.sessionId,
      required this.filter,
      required this.size,
      required this.useCache,
      required this.totalElements,
      required this.totalPages,
      required this.maxElementId,
      required this.data});

  ListOfDocuments.fromJson(Map<String, dynamic> json) {
    lastElementId = json['last_element_id'];
    lastElementTitle = json['last_element_title'];
    firstElementId = json['first_element_id'];
    firstElementTitle = json['first_element_title'];
    isOffsetPagination = json['is_offset_pagination'];
    objectType = json['object_type'];
    sessionId = json['session_id'];
    filter = json['filter'];
    size = json['size'];
    totalElements = json['total_elements'];
    totalPages = json['total_pages'];
    useCache = json['use_cache'];
    maxElementId = json['max_element_id'];
    //comment = json['comment'];

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new DocumentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> DocumentInfo = new Map<String, dynamic>();
    DocumentInfo['last_element_id'] = this.lastElementId;
    DocumentInfo['last_element_title'] = this.lastElementTitle;
    DocumentInfo['first_element_id'] = this.firstElementId;
    DocumentInfo['first_element_title'] = this.firstElementTitle;
    DocumentInfo['is_offset_pagination'] = this.isOffsetPagination;
    DocumentInfo['object_type'] = this.objectType;
    DocumentInfo['session_id'] = this.sessionId;
    DocumentInfo['filter'] = this.filter;
    DocumentInfo['size'] = this.size;
    DocumentInfo['use_cache'] = this.useCache;
    DocumentInfo['total_elements'] = this.totalElements;
    DocumentInfo['total_pages'] = this.totalPages;
    DocumentInfo['max_element_id'] = this.maxElementId;

    if (this.data != null) {
      DocumentInfo['DocumentInfo'] = this.data.map((v) => v.toJson()).toList();
    }
    return DocumentInfo;
  }
}

class DocumentInfo {
  String id = '';
  String createdDate = '';
  String editedDate = '';
  int operationId = 1;
  int productsCount = 0;
  String number = '';
  String date = '';
  String comment = "";

  DocumentInfo(
      {required this.id,
      required this.createdDate,
      required this.editedDate,
      required this.operationId,
      required this.productsCount,
      required this.number,
      required this.date,
      required this.comment});

  DocumentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = json['created_date'];
    editedDate = json['edited_date'];
    operationId = json['operation_id'];
    productsCount = json['products_count'];
    number = json['number'];
    date = json['date'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> documentInfo = Map<String, dynamic>();
    documentInfo['id'] = this.id;
    documentInfo['created_date'] = this.createdDate;
    documentInfo['edited_date'] = this.editedDate;
    documentInfo['operation_id'] = this.operationId;
    documentInfo['products_count'] = this.productsCount;
    documentInfo['number'] = this.number;
    documentInfo['date'] = this.date;
    documentInfo['comment'] = this.comment;
    return documentInfo;
  }
}

class DocumentPricePrint {
  String project = "DCT";
  List<ProductInfo> goodsItems = [];
  String id = '';
  String createdDate = '';
  String editedDate = '';
  int operationId = 2;
  int productsCount = 0;
  String number = '';
  String date = '';
  String doc_ref = '';

  DocumentPricePrint(_goodsItems, _currentDoc) {
    this.project = project;
    this.goodsItems = _goodsItems;
    //this.id = id;
    this.createdDate = createdDate;
    this.editedDate = editedDate;
    this.operationId = operationId;
    this.productsCount = productsCount;
    if (_currentDoc != null) {
      this.id = _currentDoc.id;
      this.number = _currentDoc.number;
      this.date = _currentDoc.date;
    }
  }

  DocumentPricePrint.fromJson(Map<String, dynamic> json) {
    project = json['project'];
    id = json['id'];
    createdDate = json['created_date'];
    editedDate = json['edited_date'];
    operationId = json['operation_id'];
    productsCount = json['products_count'];
    number = json['number'];
    date = json['date'];
    doc_ref = json['doc_ref'];
    if (json['goodsItems'] != null && json['goodsItems'] != '') {
      goodsItems = [];
      print(json['goodsItems']);
      json['goodsItems'].forEach((v) {
        goodsItems.add(ProductInfo.fromJson(v));
      });
    }
    //print(goodsItems.length);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['project'] = this.project;
    data['id'] = this.id;
    data['created_date'] = this.createdDate;
    data['edited_date'] = this.editedDate;
    data['operation_id'] = this.operationId;
    data['products_count'] = this.productsCount;
    data['number'] = this.number;
    data['date'] = this.date;
    data['goodsItems'] = this.goodsItems.map((v) => v.toJson()).toList();

    return data;
  }
}

Future<DocumentPricePrint?> createDocumentPricePrint(
    List goodsItems, currentDoc, context) async {
  DocumentPricePrint newDocPricePrint =
      DocumentPricePrint(goodsItems, currentDoc);
  var myData = newDocPricePrint.toJson();
  var body = json.encode(myData);

  final Uri uri = Uri.parse(
      "http://212.112.116.229:7788/weblink/hs/api/documents_price_print/0");
  final response = await http.post(
    uri,
    headers: kDctHeaders,
    body: body,
  );

  if (response.statusCode == 200) {
    var _data = jsonDecode(utf8.decode(response.bodyBytes));
    var newDoc = DocumentPricePrint.fromJson(_data);
    //BlocProvider.of<GoodsItemsTitleCubit>(context).updateSum();
    kCurrentDocument = newDoc;
    if (kCurrentDocumentIsSaved != true && kCurrentDocument != null) {
      kCurrentDocumentIsSaved = true;
      //setStateGoodsItemsScreen();
    }
    if (kCurrentDocument == null) {
      kCurrentDocumentIsSaved = false;
    }
    // BlocProvider.of<GoodsItemsTitleCubit>(context).updateSum();
    BlocProvider.of<GoodsItemsCubit>(context).updateState();

    return newDoc;
  } else {
    print(response.body);

    //throw Exception(response.toString());
    return null;
  }
}

Future<DocumentPricePrint?> getDocumentPricePrint(id, context) async {
  final Uri uri = Uri.parse(
      "http://212.112.116.229:7788/weblink/hs/api/documents_price_print/$id");
  final response = await http.get(uri, headers: kDctHeaders);

  if (response.statusCode == 200) {
    var _data = jsonDecode(utf8.decode(response.bodyBytes));
    var newDoc = DocumentPricePrint.fromJson(_data);
    kCurrentDocument = newDoc;
    kGoodsItems = kCurrentDocument.goodsItems;
    BlocProvider.of<GoodsItemsCubit>(context).updateState();
    // callBloc = true;
    return newDoc;
  } else {
    print(response.body);
    //throw Exception(response.toString());
    return null;
  }
}
