import 'dart:convert';
import 'package:datawedgeflutter/model/documents_data.dart';
import 'package:flutter/material.dart';
import 'Product.dart';
import 'categories_data.dart';
import 'dataloader.dart';

// dynamic-interactive
var selectedReport = null;
var selectedCategory = categories[0];
var enteredSearchString = "";
List<Product> selectedProducts = [];
ProductCategory? selectedProductCategory;
ProductChildCategory? selectedProductChildCategory;
int selectedProductChildCategoryIndex = 0;
List<ProductInfo> selectedProducts2 = [];
List<ProductInfo> kGoodsItems = [];
DocumentInfo? currentDocument;
bool callBloc = false;

// view
const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);
const kDefaultPaddin = 15.0;

// collections
var users = User.getUsers();
var markets = Market.getMarkets();
var documentTypes = DocumentType.getDocumentTypes();
var profiles = Profile.getAvailableProfiles();
var profileRoles = ProfileRole.getProfileRoles();
var reports = Report.getReports();
var allReports = reports[0];
List<ProductCategory> productCategories = [];
List<ProductChildCategory> productChildCategories = [];

// auth
var enteredID = 111111;
var enteredPin = 111111;
var isRememberMe = true;
const dct_username = 'weblink';
const dct_password = 'weblinK312!';
final String dct_basicAuth =
    'Basic ' + base64Encode(utf8.encode('$dct_username:$dct_password'));
final Map<String, String> kDctHeaders = {
  'Content-Type': 'application/json; charset=UTF-8',
  'authorization': dct_basicAuth
};

// profile
var selectedUser = users[0];
var selectedMarket = markets[0];
var selectedDocumentType = documentTypes[0];
var selectedProfile = profiles[0];
var usingZebra = false;
var isAuthorized = false;

// starred 🌟reports
var starredReport1 = reports[1];
var starredReport2 = reports[2];
var starredReport3 = null; //reports[3];
var starredReport4 = null; //reports[4];

// starred 🌟instructions
// * TO DO

// starred 🌟contacts
// * TO DO

// starred 🌟tasks
// * TO DO

