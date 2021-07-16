import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/details_screen.dart';
import 'package:datawedgeflutter/home_page.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/screens/home/components/body.dart';

import 'constants.dart';
import 'model/palette.dart';

var selectedCategory = categories[0];
var enteredSearchString = "";

class ItemCard extends StatelessWidget {
  final Product product;
  //final Function press;
  final VoidCallback press;
  final VoidCallback longPress;
  final VoidCallback doubleTap;
  const ItemCard(
      {required this.product,
      required this.press,
      required this.longPress,
      required this.doubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      onLongPress: longPress,
      onDoubleTap: doubleTap,
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
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.asset(product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\$${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  CatalogScreen({Key? key, required this.title, required this.selectedUser})
      : super(key: key);
  final String title;
  final User selectedUser;

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  SizedBox(height: 100),
            addEnterSearchField(context),
//SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPaddin, vertical: 0),
              child: SizedBox(
                  width: 230,
                  child: DropdownButton(
                      elevation: 0,
                      isDense: true,
                      isExpanded: true,
                      items: buildDropdownMenuItemsCategories(categories),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500, color: kTextLightColor),
                      value: selectedCategory,
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');

                          selectedCategory = valueSelectedByUser as Category;
                          //saveSettingsHive(context);
                        });
                      })),
            ),
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
                          press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  product: products[index],
                                ),
                              )),
                          longPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                  title: "we are back",
                                ),
                              )),
                          doubleTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                  title: "we are back",
                                ),
                              )),
                        )),
              ),
            ),
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    final isDCT = MediaQuery.of(context).size.height < 600;
    return AppBar(
        //automaticallyImplyLeading: false,
        toolbarHeight: isDCT ? 45 : null,
        title: Text(
          widget.selectedUser.name == ""
              ? "Connector F."
              : "Connector F.: " + widget.selectedUser.name,
          style: TextStyle(fontSize: 15),
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
        )))));
  }
}

// We need satefull widget for our categories

class SubcategoriesWidget extends StatefulWidget {
  @override
  _SubcategoriesWidgetState createState() => _SubcategoriesWidgetState();
}

class _SubcategoriesWidgetState extends State<SubcategoriesWidget> {
  List<String> categories = ["Hand bag", "Jewellery", "Footwear", "Dresses"];
  // By default our first item will be selected
  int selectedIndex = 0;
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

List<DropdownMenuItem<Category>> buildDropdownMenuItemsCategories(List items) {
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
                  color: Colors.black54,
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

Widget addEnterSearchField(BuildContext context) {
  Widget widget = Container(
    // width: 250,
    height: 32,
    // margin: EdgeInsets.all(8.0),
    // padding: EdgeInsets.all(5.0),
    //decoration: BoxDecoration(
    //color: Colors.deepPurple[200],
    // borderRadius: BorderRadius.circular(8.0)),

    child: Container(
      // margin: const EdgeInsets.all(15.0),
      // padding: const EdgeInsets.all(23.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              cursorColor: Colors.pinkAccent,
              // maxLength: 100,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                //   // prefixIcon: Icon(
                //   //   Icons.qr_code_sharp,
                //   //   color: Palette.iconColor,
                //   // ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "Введите код или наименование...",
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: Palette.textColor1,
                    fontStyle: FontStyle.italic),
                // suffixIcon: IconButton(
                //   // onPressed: _controllerID.clear(),
                //   onPressed: () => searchingGoods(enteredSearchString),
                //   icon: Icon(Icons.search_rounded),
                // ),
              ),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: IconButton(
                // onPressed: _controllerID.clear(),
                onPressed: () => searchingGoods(enteredSearchString),
                icon: Icon(
                  Icons.search,
                  color: Colors.black26,
                ),
              ),
            ),
          ]),
    ),
  );

  return widget;
}

void searchingGoods(String text) {}
