import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

ListOfProducts listOfProductsFromJsonBytes(bodyBytes) =>
    ListOfProducts.fromJson(jsonDecode(utf8.decode(bodyBytes)));

ListOfProductCategories listOfProductCategoriesFromJson(String str) =>
    ListOfProductCategories.fromJson(json.decode(str));

ListOfProductCategories listOfProductCategoriesFromJsonBytes(bodyBytes) =>
    ListOfProductCategories.fromJson(jsonDecode(utf8.decode(bodyBytes)));

String listOfProductCategoriesToJson(ListOfProductCategories data) =>
    json.encode(data.toJson());

class ListOfProductCategories {
  int? lastElementId;
  String? lastElementTitle;
  String? firstElementId;
  String? firstElementTitle;
  String? isOffsetPagination;
  String? objectType;
  String? sessionId;
  String? filter;
  int? size;
  int? useCache;
  int? totalElements;
  int? totalPages;
  String? maxElementId;
  List<ProductCategory>? data = [];

  ListOfProductCategories(
      {this.lastElementId,
      this.lastElementTitle,
      this.firstElementId,
      this.firstElementTitle,
      this.isOffsetPagination,
      this.objectType,
      this.sessionId,
      this.filter,
      this.size,
      this.useCache,
      this.totalElements,
      this.totalPages,
      this.maxElementId,
      this.data});

  ListOfProductCategories.fromJson(Map<String, dynamic> json) {
    lastElementId = json['last_element_id'];
    lastElementTitle = json['last_element_title'];
    firstElementId = json['first_element_id'];
    firstElementTitle = json['first_element_title'];
    isOffsetPagination = json['is_offset_pagination'];
    objectType = json['object_type'];
    sessionId = json['session_id'];
    filter = json['filter'];
    size = json['size'];
    useCache = json['use_cache'];
    totalElements = json['total_elements'];
    totalPages = json['total_pages'];
    maxElementId = json['max_element_id'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(ProductCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_element_id'] = this.lastElementId;
    data['last_element_title'] = this.lastElementTitle;
    data['first_element_id'] = this.firstElementId;
    data['first_element_title'] = this.firstElementTitle;
    data['is_offset_pagination'] = this.isOffsetPagination;
    data['object_type'] = this.objectType;
    data['session_id'] = this.sessionId;
    data['filter'] = this.filter;
    data['size'] = this.size;
    data['use_cache'] = this.useCache;
    data['total_elements'] = this.totalElements;
    data['total_pages'] = this.totalPages;
    data['max_element_id'] = this.maxElementId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductCategory {
  int? id;
  String? title;
  int? category0Id;
  String? innerGuid;
  int? level;
  String? guid;
  String? imageUrl;
  String? createdDate;
  String? editedDate;
  String? innerCode;
  String? dateKey;
  String? category0Title;
  bool? inactive;
  String? category0InnerGuid;
  List<ProductChildCategory>? children;

  ProductCategory(
      {this.id,
      this.title,
      this.category0Id,
      this.innerGuid,
      this.level,
      this.guid,
      this.imageUrl,
      this.createdDate,
      this.editedDate,
      this.innerCode,
      this.dateKey,
      this.category0Title,
      this.inactive,
      this.category0InnerGuid,
      this.children});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category0Id = json['category0_id'];
    innerGuid = json['inner_guid'];
    level = json['level'];
    guid = json['guid'];
    imageUrl = json['image_url'];
    createdDate = json['created_date'];
    editedDate = json['edited_date'];
    innerCode = json['inner_code'];
    dateKey = json['date_key'];
    category0Title = json['category0_title'];
    inactive = json['inactive'];
    category0InnerGuid = json['category0_inner_guid'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children!.add(ProductChildCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category0_id'] = this.category0Id;
    data['inner_guid'] = this.innerGuid;
    data['level'] = this.level;
    data['guid'] = this.guid;
    data['image_url'] = this.imageUrl;
    data['created_date'] = this.createdDate;
    data['edited_date'] = this.editedDate;
    data['inner_code'] = this.innerCode;
    data['date_key'] = this.dateKey;
    data['category0_title'] = this.category0Title;
    data['inactive'] = this.inactive;
    data['category0_inner_guid'] = this.category0InnerGuid;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductChildCategory {
  int? id;
  String? title;
  int? category0Id;
  String? innerGuid;
  int? level;
  String? guid;
  String? imageUrl;
  String? createdDate;
  String? editedDate;
  String? innerCode;
  String? dateKey;
  String? category0Title;
  bool? inactive;
  String? category0InnerGuid;

  ProductChildCategory(
      {this.id,
      this.title,
      this.category0Id,
      this.innerGuid,
      this.level,
      this.guid,
      this.imageUrl,
      this.createdDate,
      this.editedDate,
      this.innerCode,
      this.dateKey,
      this.category0Title,
      this.inactive,
      this.category0InnerGuid});

  ProductChildCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category0Id = json['category0_id'];
    innerGuid = json['inner_guid'];
    level = json['level'];
    guid = json['guid'];
    imageUrl = json['image_url'];
    createdDate = json['created_date'];
    editedDate = json['edited_date'];
    innerCode = json['inner_code'];
    dateKey = json['date_key'];
    category0Title = json['category0_title'];
    inactive = json['inactive'];
    category0InnerGuid = json['category0_inner_guid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category0_id'] = this.category0Id;
    data['inner_guid'] = this.innerGuid;
    data['level'] = this.level;
    data['guid'] = this.guid;
    data['image_url'] = this.imageUrl;
    data['created_date'] = this.createdDate;
    data['edited_date'] = this.editedDate;
    data['inner_code'] = this.innerCode;
    data['date_key'] = this.dateKey;
    data['category0_title'] = this.category0Title;
    data['inactive'] = this.inactive;
    data['category0_inner_guid'] = this.category0InnerGuid;
    return data;
  }
}

Future<bool> loadListOfProductCategories_unused() async {
  final with_children = 1;

  final Uri uri = Uri.parse(
      "http://212.112.116.229:7788/weblink/hs/api/categories?with_children=$with_children&use_cache=0");

  final response = await http.get(uri, headers: dct_headers);

  if (response.statusCode == 200) {
//  var json = jsonDecode(utf8.decode(response.bodyBytes));
    final result = listOfProductCategoriesFromJsonBytes(response.bodyBytes);

//if (isRefresh) {
    //  productCategories = result.data!;
    //  } else {
    //   productCategories.addAll(result.data!);
    // }
    return true;
  } else {
    return false;
  }
}

class ListOfProducts {
  int lastElementId = 0;
  String lastElementTitle = '';
  int firstElementId = 0;
  String firstElementTitle = '';
  String isOffsetPagination = 'false';
  String objectType = 'references-products';
  String sessionId = '';
  String filter = '';
  int size = 25;
  int useCache = 0;
  List<ProductInfo> data = [];
  int totalElements = 0;
  int totalPages = 0;
  int maxElementId = 0;

  ListOfProducts(
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

  ListOfProducts.fromJson(Map<String, dynamic> json) {
    lastElementId = json['last_element_id'];
    lastElementTitle = json['last_element_title'];
    firstElementId = json['first_element_id'];
    firstElementTitle = json['first_element_title'];
    isOffsetPagination = json['is_offset_pagination'];
    objectType = json['object_type'];
    sessionId = json['session_id'];
    filter = json['filter'];
    size = json['size'];
    useCache = json['use_cache'];
    totalElements = json['total_elements'];
    totalPages = json['total_pages'];
    maxElementId = json['max_element_id'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_element_id'] = this.lastElementId;
    data['last_element_title'] = this.lastElementTitle;
    data['first_element_id'] = this.firstElementId;
    data['first_element_title'] = this.firstElementTitle;
    data['is_offset_pagination'] = this.isOffsetPagination;
    data['object_type'] = this.objectType;
    data['session_id'] = this.sessionId;
    data['filter'] = this.filter;
    data['size'] = this.size;
    data['use_cache'] = this.useCache;
    data['total_elements'] = this.totalElements;
    data['total_pages'] = this.totalPages;
    data['max_element_id'] = this.maxElementId;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductInfo {
  int id = 0;
  String title = '';
  String createdDate = '';
  String editedDate = '';
  String image_url = '';
  String inner_extra_code = '';
  String barcode = '';
  String price_sell = '';
  String parent0_Title = '';

  ProductInfo({
    required this.id,
    required this.title,
    required this.createdDate,
    required this.editedDate,
    required this.image_url,
    required this.inner_extra_code,
    required this.barcode,
    required this.price_sell,
    required this.parent0_Title,
  });

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdDate = json['created_date'];
    editedDate = json['edited_date'];
    image_url = json['image_url'];
    inner_extra_code = json['inner_extra_code'];
    barcode = json['barcode'];
    price_sell = json['price_sell'];
    parent0_Title = json['parent0_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> productInfo = Map<String, dynamic>();
    productInfo['id'] = this.id;
    productInfo['title'] = this.title;
    productInfo['created_date'] = this.createdDate;
    productInfo['edited_date'] = this.editedDate;
    productInfo['image_url'] = this.image_url;
    productInfo['inner_extra_code'] = this.inner_extra_code;
    productInfo['barcode'] = this.barcode;
    productInfo['price_sell'] = this.price_sell;
    productInfo['parent0_title'] = this.parent0_Title;

    return productInfo;
  }
}
