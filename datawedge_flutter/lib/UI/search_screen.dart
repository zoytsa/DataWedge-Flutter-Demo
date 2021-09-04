import 'dart:convert';

import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/dataloader.dart';
import 'package:datawedgeflutter/UI/product_details_screen.dart';
import 'package:datawedgeflutter/UI/home_screen.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/selected_products_counter.dart';
import 'package:flutter/material.dart';
import '../model/constants.dart';
import '../model/palette.dart';
import 'package:http/http.dart' as http;

class ItemCard extends StatefulWidget {
  final Product product;

  final VoidCallback doubleTap;
  final VoidCallback vcbOnTap;
  final VoidCallback vcbOnlongPress;

  const ItemCard(
      {required this.product,
      required this.doubleTap,
      required this.vcbOnTap,
      required this.vcbOnlongPress});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  void _onCheck(bool? newValue) {
    setState(() {
      widget.product.check = newValue!;
    });
  }

  void _onTap() {
    !widget.product.check
        ? addProductToSelected(widget.product, selectedProducts)
        : removeProductFromSelected(widget.product, selectedProducts);
    setState(() {
      widget.product.check = !widget.product.check;
    });
    // update parent widget Appbar via Void Callback
    widget.vcbOnTap();
  }

  void _onLongPress() {
    !widget.product.check
        ? addProductToSelected(widget.product, selectedProducts)
        : removeProductFromSelected(widget.product, selectedProducts);
    setState(() {
      widget.product.check = !widget.product.check;
    });
    // update parent widget Appbar via Void Callback
    widget.vcbOnlongPress();
  }

  @override
  Widget build(BuildContext context) {
    // print('called build ItemCard: ${widget.product.title}');
    return GestureDetector(
      onTap: _onTap,
      onLongPress: _onLongPress,
      onDoubleTap: widget.doubleTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: widget.product.color,
                borderRadius: BorderRadius.circular(16),
                border: widget.product.inTheList
                    ? Border.all(color: Colors.lightBlue, width: 5)
                    : widget.product.check
                        ? Border.all(color: Colors.green, width: 5)
                        : null,
              ),
              child: Hero(
                tag: "${widget.product.id}",
                child: Image.asset(widget.product.image),
              ),
            ),
          ),
          // SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              // products is out demo list
              widget.product.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "\$${widget.product.price}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // SizedBox(
          //   height: 25,
          //   child: Row(
          //       // crossAxisAlignment: CrossAxisAlignment.stretch,
          //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Expanded(
          //           child: Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 0),
          //               child: Text(
          //                 "\$${widget.product.price}",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               )),
          //         ),
          //         // Checkbox(
          //         //     // checkColor: Colors.green[200],
          //         //     //hoverColor: Colors.green,
          //         //     side: BorderSide(
          //         //       color: Colors.grey,
          //         //     ),
          //         //     activeColor: Colors.green.withOpacity(0.80),
          //         //     value: widget.product.check,
          //         //     onChanged: (bool? newValue) => _onCheck(newValue)),
          //       ]),
          // ),
        ],
      ),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  CatalogScreen(
      {Key? key,
      required this.title,
      required this.selectedUser,
      required this.onProductSelection})
      : super(key: key);
  final String title;
  final User selectedUser;
  final VoidCallback onProductSelection;

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  ProductCategory? _myCategory;
  final GlobalKey<_AppBarSearchWidgetState> _keyAppbar = GlobalKey();
  var addGoodsTitle2 = "Выбрано: " + selectedProducts.length.toString();
  List<ProductCategory> productCategories = [];

  // bool _showBackToTopButton = false;
  // ScrollController? _scrollController;

  @override
  void initState() {
    if (productCategories.length == 0) _getProductCategoriesList();
    super.initState();
  }

  Future<void> _getProductCategoriesList() async {
    final with_children = 1;

    final Uri uri = Uri.parse(
        "http://212.112.116.229:7788/weblink/hs/api/categories?with_children=$with_children&use_cache=0");

    await http.get(uri, headers: dct_headers).then((response) {
      if (response.statusCode == 200) {
        //  var json = jsonDecode(utf8.decode(response.bodyBytes));
        final result = listOfProductCategoriesFromJsonBytes(response.bodyBytes);

        setState(() {
          productCategories = result.data!;
          if (productCategories.length > 0) {
            _myCategory = productCategories[0];
          }
          //   ;
        });
      }
    });
  }

  List<DropdownMenuItem<ProductCategory>> buildDropdownMenuItemsCategories2() {
    List<DropdownMenuItem<ProductCategory>> items = [];
    for (ProductCategory category in productCategories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              // Icon(
              //   category.icon,
              //   color: Colors.indigo[200],
              // ),
              SizedBox(
                // width: 130,
                child: Text(
                  category.title!,
                  style: TextStyle(
                    color: Palette.textColor1,
                    // fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    print('items${items.length}');
    return items;
  }

  List<DropdownMenuItem<ProductCategory>> getItems() {
    List<DropdownMenuItem<ProductCategory>> items = [];
    for (ProductCategory category in productCategories) {
      items.add(DropdownMenuItem(
        value: category,
        child: Text(
          category.title!, //.substring(0, 18),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: category == _myCategory ? Colors.white : Palette.textColor1,
            // fontStyle: FontStyle.italic,
            fontSize: category == _myCategory ? 15 : 14,
          ),
        ),
      ));
    }
    print('items${items.length}');
    return items;
  }

  Widget buildDropDown(BuildContext context) {
    if (_myCategory == null) {
      return Row(
        children: [Expanded(child: Container()), CircularProgressIndicator()],
      );
    } else {
      return SizedBox(
        width: 130,
        child: DropdownButton<ProductCategory>(
          isExpanded: true,
          value: _myCategory,
          iconSize: 20,
          iconEnabledColor: Colors.green.withOpacity(0.5),
          // IconSizefocusColor: Colors.red,
          dropdownColor: Colors.indigo.withOpacity(0.75),
          icon: (null),
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          hint: Text('Выберите категорию...'),
          onChanged: (ProductCategory? newValue) {
            setState(() {
              _myCategory = newValue;
              //   _getCitiesList();
              //   print(_myState);
            });
          },
          items: getItems(),
          // items: [],
        ),
      );
    }
  }

//   @override
//   void dispose() {
//     _scrollController!.dispose(); // dispose the controller
//     super.dispose();
//   }

// // This function is triggered when the user presses the back-to-top button
//   void _scrollToTop() {
//     _scrollController!
//         .animateTo(0, duration: Duration(seconds: 3), curve: Curves.linear);
//   }

  void _updateSelectedProductsTitle() {
    //print('called _updateSelectedProductsTitle');

    //setState(() {
    addGoodsTitle2 = "Выбрано: " + selectedProducts.length.toString();
    //});
    // _keyAppbar.currentState!.title = addGoodsTitle2;
    _keyAppbar.currentState!.widget.appBarSearchTitle = addGoodsTitle2;
    _keyAppbar.currentState!.updateAppbarWidget();
  }

  void onSelectedProductsSearch() {
    print('go to items 2');
    print('called onSelectedProductsSearch');
    print(selectedProducts);
    //widget.onProductSelection(selectedProducts);
    widget.onProductSelection();
    //setState(() {
    //   addGoodsTitle2 = "Выбрано: " + selectedProducts.length.toString();
    //   //});
    //   // _keyAppbar.currentState!.title = addGoodsTitle2;
    //   _keyAppbar.currentState!.widget.appBarSearchTitle = addGoodsTitle2;
    //   _keyAppbar.currentState!.updateAppbarWidget();
  }

  @override
  Widget build(BuildContext context) {
    print(selectedUser.name); // = users[0];
    print(selectedMarket.name); //  = markets[0];
    print(selectedDocumentType.name); //  = documentTypes[0];
    print(
        selectedProfile.name); //  = profiles[0]; //Profile.getDefaultProfile();
    // print(selectedReport.name); //  = null;

    return Scaffold(
      appBar: AppBarSearchWidget(
          key: _keyAppbar,
          appBarSearchTitle: addGoodsTitle2,
          onSelectedProductsAppBar: () => onSelectedProductsSearch()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addEnterSearchField2(context),

          Row(
              // padding: const EdgeInsets.symmetric(
              //     horizontal: kDefaultPaddin, vertical: 0),
              children: [
                SizedBox(width: kDefaultPaddin),
                SizedBox(
                  width: 250,
                  child: buildDropDown(context),
                  // child: DropdownButton(
                  //     elevation: 0,
                  //     isDense: true,
                  //     isExpanded: true,
                  //     //items: buildDropdownMenuItemsCategories(categories),
                  //     items: buildDropdownMenuItemsCategories2(),
                  //     style: Theme.of(context).textTheme.headline6!.copyWith(
                  //         fontWeight: FontWeight.w500,
                  //         color: kTextLightColor),
                  //     value: selectedCategory,
                  //     onChanged: (valueSelectedByUser) {
                  //       setState(() {
                  //         debugPrint('User selected $valueSelectedByUser');

                  //         selectedCategory = valueSelectedByUser as Category;
                  //         //saveSettingsHive(context);
                  //       });
                  //     })
                ),
                Container(
                    child: Expanded(
                        child: SizedBox(
                            // width: 165,
                            ))),
                Container(
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.grid_view_outlined,
                        size: 17,
                      ),
                      onPressed: () => {},
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.list),
                      onPressed: () => {},
                    ),
                  ),
                ),
              ]),

          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: kDefaultPaddin, vertical: 10),
          //   child: Text(
          //     "Кулинария",
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline6!
          //         .copyWith(fontWeight: FontWeight.bold),
          //   ),
          // ),
          SubcategoriesWidget(),
          // SingleChildScrollView(
          //   controller: _scrollController,
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints(maxHeight: 380),
          //     child:
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: kDefaultPaddin,
                    crossAxisSpacing: kDefaultPaddin,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => ItemCard(
                        product: products[index],
                        // press: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => DetailsScreen(
                        //         product: products[index],
                        //       ),
                        //     )),
                        // longPress: () => products[index].check = false,

                        doubleTap: () => {}, //Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => MyHomePage(
                        //         title: "we are back",
                        //       ),
                        //     )),
                        vcbOnTap: () => _updateSelectedProductsTitle(),
                        vcbOnlongPress: () => _updateSelectedProductsTitle(),
                      )),
            ),
          ),
          //  ),
          //),
        ],
      ),
      // floatingActionButton: _showBackToTopButton == true
      //     ? null
      //     : FloatingActionButton(
      //         onPressed: _scrollToTop,
      //         child: Icon(Icons.arrow_upward),
      //       ),
    );
  }
}

class AppBarSearchWidget extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(55);
  //Function(List<Product>) onSelectedProductsAppBar;
  Function() onSelectedProductsAppBar;

  //const AppBarSearchWidget({Key? key, required this.appBarSearchTitle})
  AppBarSearchWidget(
      {Key? key,
      required this.appBarSearchTitle,
      required this.onSelectedProductsAppBar})
      : super(key: key);

  String appBarSearchTitle;
  @override
  _AppBarSearchWidgetState createState() => _AppBarSearchWidgetState();

  //final title = "";
}

class _AppBarSearchWidgetState extends State<AppBarSearchWidget> {
  void updateAppbarWidget() {
    setState(() {});
  }

  void _addNewGoodsFromSearch() {
    print('go to items 1');
    // print(selectedProducts);
    //widget.onSelectedProductsAppBar(selectedProducts);
    widget.onSelectedProductsAppBar();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDCT = MediaQuery.of(context).size.height < 600;
    return AppBar(
      //automaticallyImplyLeading: false,
      // toolbarHeight: isDCT ? 45 : null,
      title: Container(
        //padding: const EdgeInsets.only(right: 0),
        child: Row(children: [
          // Align(
          //     alignment: Alignment.topLeft,
          SizedBox(
              width: 100,
              child: Container(
                child: Text(widget.appBarSearchTitle, //title, // addGoodsTitle2
                    style: TextStyle(fontSize: isDCT ? 12 : 13)),
              )),

          // ButtonBar(
          //     // onTapDown: (TapDownDetails) {
          //     //   _addNewGoodsFromSearch();
          //     children: [
          //       // Text(
          //       //   " +  В СПИСОК ",
          //       //   style: TextStyle(fontSize: 13),
          //       // )
          //     ]),

          // // Align(
          // //   alignment: Alignment.topRight,
          // Container(
          //   //margin: EdgeInsets.all(1.0),
          //   padding: EdgeInsets.all(isDCT ? 6.0 : 8),

          //   decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         // colors: [
          //         //   Colors.green,
          //         //   Colors.tealAccent,
          //         //   Colors.green,
          //         //   Colors.black54
          //         // ],
          //         // colors: [Colors.black87, Colors.green],
          //         colors: [Colors.green, Colors.lightGreen],
          //         begin: Alignment.bottomRight,
          //         //end: Alignment.topLeft,
          //       ),
          //       borderRadius: BorderRadius.circular(8),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.black.withOpacity(.3),
          //             spreadRadius: 1,
          //             blurRadius: 2,
          //             offset: Offset(0, 1))
          //       ]),
          //   child:
          //       Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //     // Icon(
          //     //   Icons.turned_in_not_outlined,
          //     //   color: Colors.white,
          //     // ),
          //     // GestureDetector(
          //     //   onTapDown: (TapDownDetails) {
          //     //     _addNewGoodsFromSearch();
          //     // Text(
          //     //   " +  В СПИСОК ",
          //     //   style: TextStyle(fontSize: 13),
          //     // ),
          //     // },
          //   ]),
          // ),
        ]),
        //SizedBox(width: 10)
      ),

      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: (Container(
          //height: 200,
          decoration: BoxDecoration(
              gradient: LinearGradient(
        //colors: [Colors.purple, Colors.blue, Color(0xFF3b5999)],
        colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      )))),
      actions: <Widget>[
        //addNewGoodromSearchButton( addGoodsTitle)
        SizedBox(
            //width: 111,
            // height: 40,
            //padding: const EdgeInsets.only(right: 8),
            child: Container(
          margin: isDCT
              ? EdgeInsets.only(top: 11, bottom: 11, left: 10, right: 10)
              : EdgeInsets.all(8.5),
          padding: EdgeInsets.all(isDCT ? 9.0 : 12),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [
                //   Colors.green,
                //   Colors.tealAccent,
                //   Colors.green,
                //   Colors.black54
                // ],
                // colors: [Colors.black87, Colors.green],
                colors: [Colors.green, Colors.lightGreen],
                begin: Alignment.bottomRight,
                //end: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(isDCT ? 8 : 8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1))
              ]),
          child: GestureDetector(
              onTapDown: (TapDownDetails) {
                _addNewGoodsFromSearch();
              },
              child: Row(children: [
                // Icon(Icons.list, size: 14),
                Icon(Icons.document_scanner_outlined, size: 14),
                Text(
                  "   В СПИСОК  ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: isDCT ? 12 : 13),
                ),
              ])),
        ))
      ],
    );
  }
}

class SubcategoriesWidget extends StatefulWidget {
  @override
  _SubcategoriesWidgetState createState() => _SubcategoriesWidgetState();
}

class _SubcategoriesWidgetState extends State<SubcategoriesWidget> {
  List<String> categories = ["Hand bag", "Jewellery", "Footwear", "Dresses"];
  // By default our first item will be selected
  int selectedIndex = 0;
  //var _searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 2),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}

List<DropdownMenuItem<Category>> buildDropdownMenuItemsCategories_unused(
    List items) {
  List<DropdownMenuItem<Category>> items = [];
  for (Category category in categories) {
    items.add(
      DropdownMenuItem(
        value: category,
        child: Row(
          children: [
            // Icon(
            //   category.icon,
            //   color: Colors.indigo[200],
            // ),
            SizedBox(
              // width: 130,
              child: Text(
                category.title,
                style: TextStyle(
                  color: Palette.textColor1,
                  // fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  return items;
}

Widget addEnterSearchField2(BuildContext context) {
  var _textController = new TextEditingController();
  Widget widget = Container(
    // width: 250,
    height: 32,
    // margin: EdgeInsets.all(8.0),
    // padding: EdgeInsets.all(5.0),
    //decoration: BoxDecoration(
    //color: Colors.deepPurple[200],
    // borderRadius: BorderRadius.circular(8.0)),

    child: Container(
      margin: const EdgeInsets.only(right: 12),
      // padding: const EdgeInsets.all(23.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.indigo)),
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.up,
          children: [
            Expanded(
                child:

                    // Text(
                    //   "ADD BARCODE:",
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     //fontSize: 20,
                    //     letterSpacing: 2,
                    //   ),
                    // ),
                    TextField(
              controller: _textController,
              style: TextStyle(color: Colors.white),

              cursorColor: Colors.pinkAccent,
              // maxLength: 100,
              // keyboardType: TextInputType.number,

              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.withOpacity(0.5),
                    size: 19,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.green.withOpacity(0.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 0.0,
                ),
                fillColor: Colors.indigo,
                filled: true,
                hintText: 'Поиск по наименованию и штрихкоду...',
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: Palette.textColor1.withOpacity(0.5),
                    fontStyle: FontStyle.italic),
                //    hasFloatingPlaceholder: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
                ),
              ),
              //*** */
              // decoration: InputDecoration(
              //     //   // prefixIcon: Icon(
              //     //   //   Icons.qr_code_sharp,
              //     //   //   color: Palette.iconColor,
              //     //   // ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white10),
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white10),
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //     contentPadding: EdgeInsets.only(left: 15),
              //     hintText: "Поиск по наименованию и штрихкоду...",
              //     hintStyle: TextStyle(
              //         fontSize: 14,
              //         color: Palette.textColor1.withOpacity(0.5),
              //         fontStyle: FontStyle.italic),
              //     // suffixIconConstraints: BoxConstraints(
              //     //   minWidth: 25,
              //     //   minHeight: 32,
              //     // ),
              //     prefixIcon: Padding(
              //       padding: const EdgeInsetsDirectional.only(bottom: 12.0),
              //       child: IconButton(
              //         // onPressed: _controllerID.clear(),
              //         onPressed: () => searchingGoods(enteredSearchString),
              //         icon: Icon(Icons.search_outlined, color: Colors.white10),
              //       ), // myIcon is a 48px-wide widget.
              //     )),
              //     //*** */
              onChanged: (String str) {
                {
                  try {
                    enteredSearchString = str;
                  } catch (e) {
                    enteredSearchString = "";
                  }
                }
                ;
              },
              onSubmitted: (text) {
                searchingGoods(text);
              },
            )),
            //   IconButton(
            //     // onPressed: _controllerID.clear(),
            //     onPressed: () => searchingGoods(enteredSearchString),
            //     icon: Icon(
            //       Icons.search,
            //       color: Colors.black26,
            //     ),
            //   ),
          ]),
    ),
  );

  return widget;
}

void searchingGoods(String text) {
  //Widget.
  print(selectedProducts);
}
