// import 'package:datawedgeflutter/dataloader.dart';
// import 'package:datawedgeflutter/details_screen.dart';
// import 'package:datawedgeflutter/home_page.dart';
// import 'package:datawedgeflutter/model/Product.dart';
// import 'package:datawedgeflutter/selected_products_couner.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:shop_app/constants.dart';
// // import 'package:shop_app/screens/home/components/body.dart';

// import 'constants.dart';
// import 'model/palette.dart';

// //import 'package:datawedgeflutter/selected_products_couner.dart';

// var selectedCategory = categories[0];
// var enteredSearchString = "";
// List<Product> selectedProducts = [];
// //var selectedProducts = [];

// class ItemCard extends StatefulWidget {
//   final VoidCallback vcbOnlongPress;

//   const ItemCard({required this.vcbOnlongPress});

//   @override
//   _ItemCardState createState() => _ItemCardState();
// }

// class _ItemCardState extends State<ItemCard> {
//   void _onLongPress() {
//     widget.vcbOnlongPress;
//     print('tried to call vcbOnlongPress');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       //onLongPress: _onLongPress,
//       onLongPress: widget.vcbOnlongPress,

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(kDefaultPaddin),
//               // For  demo we use fixed height  and width
//               // Now we dont need them
//               // height: 180,
//               // width: 160,
//               decoration: BoxDecoration(
//                 color: widget.product.color,
//                 borderRadius: BorderRadius.circular(16),
//                 border: widget.product.inTheList
//                     ? Border.all(color: Colors.lightBlue, width: 5)
//                     : widget.product.check
//                         ? Border.all(color: Colors.green, width: 5)
//                         : null,
//               ),
//               child: Hero(
//                 tag: "${widget.product.id}",
//                 child: Image.asset(widget.product.image),
//               ),
//             ),
//           ),
//           // SizedBox(height: 4),
//           Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: Text(
//               // products is out demo list
//               widget.product.title,
//               style: TextStyle(color: kTextLightColor),
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 2),
//               child: Text(
//                 "\$${widget.product.price}",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               )),
//           // SizedBox(
//           //   height: 25,
//           //   child: Row(
//           //       // crossAxisAlignment: CrossAxisAlignment.stretch,
//           //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //       children: [
//           //         Expanded(
//           //           child: Padding(
//           //               padding: const EdgeInsets.symmetric(vertical: 0),
//           //               child: Text(
//           //                 "\$${widget.product.price}",
//           //                 style: TextStyle(fontWeight: FontWeight.bold),
//           //               )),
//           //         ),
//           //         // Checkbox(
//           //         //     // checkColor: Colors.green[200],
//           //         //     //hoverColor: Colors.green,
//           //         //     side: BorderSide(
//           //         //       color: Colors.grey,
//           //         //     ),
//           //         //     activeColor: Colors.green.withOpacity(0.80),
//           //         //     value: widget.product.check,
//           //         //     onChanged: (bool? newValue) => _onCheck(newValue)),
//           //       ]),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class CatalogScreen extends StatefulWidget {
//   CatalogScreen({Key? key, required this.title, required this.selectedUser})
//       : super(key: key);
//   final String title;
//   final User selectedUser;
//   var addGoodsTitle = "";

//   @override
//   _CatalogScreenState createState() => _CatalogScreenState();
// }

// class _CatalogScreenState extends State<CatalogScreen> {
//   var addGoodsTitle2 = "";

//   void _updateSelectedProductsTitle() {
//     print('called _updateSelectedProductsTitle');
//     setState(() {
//       addGoodsTitle2 = "Выбрано: " + selectedProducts.length.toString() + ".";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: buildAppBar(context, widget.addGoodsTitle, addGoodsTitle2),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //  SizedBox(height: 100),
//             addEnterSearchField(context),
// //SizedBox(height: 100),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: kDefaultPaddin, vertical: 0),
//               child: SizedBox(
//                   width: 230,
//                   child: DropdownButton(
//                       elevation: 0,
//                       isDense: true,
//                       isExpanded: true,
//                       items: buildDropdownMenuItemsCategories(categories),
//                       style: Theme.of(context).textTheme.headline6!.copyWith(
//                           fontWeight: FontWeight.w500, color: kTextLightColor),
//                       value: selectedCategory,
//                       onChanged: (valueSelectedByUser) {
//                         setState(() {
//                           debugPrint('User selected $valueSelectedByUser');

//                           selectedCategory = valueSelectedByUser as Category;
//                           //saveSettingsHive(context);
//                         });
//                       })),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(
//             //       horizontal: kDefaultPaddin, vertical: 10),
//             //   child: Text(
//             //     "Кулинария",
//             //     style: Theme.of(context)
//             //         .textTheme
//             //         .headline6!
//             //         .copyWith(fontWeight: FontWeight.bold),
//             //   ),
//             // ),
//             SubcategoriesWidget(),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
//                 child: GridView.builder(
//                     itemCount: products.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: kDefaultPaddin,
//                       crossAxisSpacing: kDefaultPaddin,
//                       childAspectRatio: 0.75,
//                     ),
//                     itemBuilder: (context, index) => ItemCard(
//                           product: products[index],
//                           // press: () => Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //       builder: (context) => DetailsScreen(
//                           //         product: products[index],
//                           //       ),
//                           //     )),
//                           // longPress: () => products[index].check = false,

//                           doubleTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MyHomePage(
//                                   title: "we are back",
//                                 ),
//                               )),
//                           vcbOnlongPress: () => _updateSelectedProductsTitle(),
//                         )),
//               ),
//             ),
//           ],
//         ));
//   }

//   AppBar buildAppBar(
//       BuildContext context, String addGoodsTitle, String addGoodsTitle2) {
//     final isDCT = MediaQuery.of(context).size.height < 600;

//     //updateSelectedProductsTitle();

//     var addGoodsTitle3 = "Выбрано: " + selectedProducts.length.toString() + ".";

//     return AppBar(
//       //automaticallyImplyLeading: false,
//       toolbarHeight: isDCT ? 45 : null,
//       title: GestureDetector(
//         onTapDown: (TapDownDetails) {
//           _addNewGoodsFromSearch();
//         },
//         child:
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           SizedBox(
//               width: 100,
//               child: Container(
//                 child: Text(addGoodsTitle2,
//                     style: TextStyle(fontSize: isDCT ? 12 : 13)),
//               )),
//           Container(
//             //margin: EdgeInsets.all(1.0),
//             padding: EdgeInsets.all(isDCT ? 6.0 : 10),

//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   // colors: [
//                   //   Colors.green,
//                   //   Colors.tealAccent,
//                   //   Colors.green,
//                   //   Colors.black54
//                   // ],
//                   // colors: [Colors.black87, Colors.green],
//                   colors: [Colors.green, Colors.lightGreen],
//                   begin: Alignment.bottomRight,
//                   //end: Alignment.topLeft,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(.3),
//                       spreadRadius: 1,
//                       blurRadius: 2,
//                       offset: Offset(0, 1))
//                 ]),
//             child:
//                 Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//               // Icon(
//               //   Icons.turned_in_not_outlined,
//               //   color: Colors.white,
//               // ),
//               Text(
//                 " +  В СПИСОК ",
//                 style: TextStyle(fontSize: 13),
//               ),
//             ]),
//           ),
//           //SizedBox(width: 10)
//         ]),
//       ),

//       centerTitle: true,
//       elevation: 0,
//       iconTheme: IconThemeData(color: Colors.white),
//       flexibleSpace: (Container(
//           //height: 200,
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//         //colors: [Colors.purple, Colors.blue, Color(0xFF3b5999)],
//         colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
//         begin: Alignment.bottomRight,
//         end: Alignment.topLeft,
//       )))),
//       // actions: <Widget>[
//       //addNewGoodromSearchButton(context, addGoodsTitle)
//       // Padding(
//       //   padding: const EdgeInsets.only(right: 8),
//       //   child: IconButton(
//       //     icon: Icon(
//       //       Icons.search_outlined,
//       //     ),
//       //     onPressed: () => {
//       //       Navigator.push(
//       //           context,
//       //           MaterialPageRoute(
//       //             builder: (context) => CatalogScreen(
//       //                 title: "Searching...", selectedUser: selectedUser),
//       //           ))
//       //     },
//       //   ),
//       // )
//       //],
//     );
//   }
// }

// Widget addNewGoodromSearchButton(BuildContext context, String addGoodsTitle) {
//   Widget widget = GestureDetector(
//     onTapDown: (TapDownDetails) {
//       _addNewGoodsFromSearch();
//     },
//     child: Center(
//       child: Container(
//         //margin: EdgeInsets.all(1.0),
//         padding: EdgeInsets.all(10.0),

//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//               // colors: [
//               //   Colors.green,
//               //   Colors.tealAccent,
//               //   Colors.green,
//               //   Colors.black54
//               // ],
//               // colors: [Colors.black87, Colors.green],
//               colors: [Colors.green, Colors.lightGreen],
//               begin: Alignment.bottomRight,
//               //end: Alignment.topLeft,
//             ),
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(.3),
//                   spreadRadius: 1,
//                   blurRadius: 2,
//                   offset: Offset(0, 1))
//             ]),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           // Icon(
//           //   Icons.add_circle_outline,
//           //   color: Colors.white,
//           // ),
//           Text(
//             addGoodsTitle,
//             //"  +  ADD  ",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
//           ),
//         ]),
//       ),
//     ),
//   );
//   return widget;
// }

// void _addNewGoodsFromSearch() {
//   print('go to tems');
//   print(products);
// }
// // We need satefull widget for our categories

// class SubcategoriesWidget extends StatefulWidget {
//   @override
//   _SubcategoriesWidgetState createState() => _SubcategoriesWidgetState();
// }

// class _SubcategoriesWidgetState extends State<SubcategoriesWidget> {
//   List<String> categories = ["Hand bag", "Jewellery", "Footwear", "Dresses"];
//   // By default our first item will be selected
//   int selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 2),
//       child: SizedBox(
//         height: 25,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: categories.length,
//           itemBuilder: (context, index) => buildCategory(index),
//         ),
//       ),
//     );
//   }

//   Widget buildCategory(int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               categories[index],
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: selectedIndex == index ? kTextColor : kTextLightColor,
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
//               height: 2,
//               width: 30,
//               color: selectedIndex == index ? Colors.black : Colors.transparent,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// List<DropdownMenuItem<Category>> buildDropdownMenuItemsCategories(List items) {
//   List<DropdownMenuItem<Category>> items = [];
//   for (Category category in categories) {
//     items.add(
//       DropdownMenuItem(
//         value: category,
//         child: Row(
//           children: [
//             // Icon(
//             //   category.icon,
//             //   color: Colors.indigo[200],
//             // ),
//             SizedBox(
//               // width: 130,
//               child: Text(
//                 category.title,
//                 style: TextStyle(
//                   color: Colors.black54,
//                   // fontStyle: FontStyle.italic,
//                   fontSize: 16,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   return items;
// }

// Widget addEnterSearchField(BuildContext context) {
//   Widget widget = Container(
//     // width: 250,
//     height: 32,
//     // margin: EdgeInsets.all(8.0),
//     // padding: EdgeInsets.all(5.0),
//     //decoration: BoxDecoration(
//     //color: Colors.deepPurple[200],
//     // borderRadius: BorderRadius.circular(8.0)),

//     child: Container(
//       // margin: const EdgeInsets.all(15.0),
//       // padding: const EdgeInsets.all(23.0),
//       decoration: BoxDecoration(border: Border.all(color: Colors.white)),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//                 child:
//                     // Text(
//                     //   "ADD BARCODE:",
//                     //   style: TextStyle(
//                     //     fontWeight: FontWeight.bold,
//                     //     //fontSize: 20,
//                     //     letterSpacing: 2,
//                     //   ),
//                     // ),
//                     TextField(
//               cursorColor: Colors.pinkAccent,
//               // maxLength: 100,
//               // keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 //   // prefixIcon: Icon(
//                 //   //   Icons.qr_code_sharp,
//                 //   //   color: Palette.iconColor,
//                 //   // ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                   borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                   borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                 ),
//                 contentPadding: EdgeInsets.only(left: 15),
//                 hintText: "Введите код или наименование...",
//                 hintStyle: TextStyle(
//                     fontSize: 14,
//                     color: Palette.textColor1,
//                     fontStyle: FontStyle.italic),
//                 // suffixIcon: IconButton(
//                 //   // onPressed: _controllerID.clear(),
//                 //   onPressed: () => searchingGoods(enteredSearchString),
//                 //   icon: Icon(Icons.search_rounded),
//                 // ),
//               ),
//               onChanged: (String str) {
//                 {
//                   try {
//                     enteredSearchString = str;
//                   } catch (e) {
//                     enteredSearchString = "";
//                   }
//                 }
//                 ;
//               },
//               onSubmitted: (text) {
//                 searchingGoods(text);
//               },
//             )),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 0),
//               child: IconButton(
//                 // onPressed: _controllerID.clear(),
//                 onPressed: () => searchingGoods(enteredSearchString),
//                 icon: Icon(
//                   Icons.search,
//                   color: Colors.black26,
//                 ),
//               ),
//             ),
//           ]),
//     ),
//   );

//   return widget;
// }

// void searchingGoods(String text) {}
