import 'package:datawedgeflutter/dataloader.dart';
import 'package:datawedgeflutter/details_screen.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shop_app/constants.dart';
// import 'package:shop_app/screens/home/components/body.dart';

import 'constants.dart';

var selectedCategory = categories[0];

class ItemCard extends StatelessWidget {
  final Product product;
  final Function press;
  const ItemCard({
    required this.product,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: press,
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPaddin, vertical: 8),
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
                  color: kTextLightColor,
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
