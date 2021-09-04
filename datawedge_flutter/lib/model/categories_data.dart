import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

//var json = jsonDecode(utf8.decode(response.bodyBytes));
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
  List<ChildCategory>? children;

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
        children!.add(ChildCategory.fromJson(v));
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

class ChildCategory {
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

  ChildCategory(
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

  ChildCategory.fromJson(Map<String, dynamic> json) {
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

Future<bool> loadListOfProductCategories() async {
  final with_children = 1;

  final Uri uri = Uri.parse(
      "http://212.112.116.229:7788/weblink/hs/api/categories?with_children=$with_children&use_cache=0");

  final response = await http.get(uri, headers: dct_headers);

  if (response.statusCode == 200) {
//  var json = jsonDecode(utf8.decode(response.bodyBytes));
    final result = listOfProductCategoriesFromJson(response.body);

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
