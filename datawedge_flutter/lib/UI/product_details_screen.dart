import 'package:flutter/material.dart';

import '../model/constants.dart';
import '../model/Product.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // each product have a color
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: kDefaultPaddin,
                      right: kDefaultPaddin,
                    ),
                    // height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        // ColorAndSize(product: product),
                        SizedBox(height: kDefaultPaddin / 2),
                        // Description(product: product),
                        SizedBox(height: kDefaultPaddin / 2),
                        // CounterWithFavBtn(),
                        SizedBox(height: kDefaultPaddin / 2),
                        //AddToCart(product: product)
                      ],
                    ),
                  ),
                  //ProductTitleWithImage(product: product)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color,
      elevation: 0,
      // leading: IconButton(
      //   icon: SvgPicture.asset(
      //     'assets/icons/back.svg',
      //     color: Colors.white,
      //   ),
      //   onPressed: () => Navigator.pop(context),
      // ),
      // actions: <Widget>[
      //   IconButton(
      //     icon: SvgPicture.asset("assets/icons/search.svg"),
      //     onPressed: () {},
      //   ),
      //   IconButton(
      //     icon: SvgPicture.asset("assets/icons/cart.svg"),
      //     onPressed: () {},
      //   ),
      //     SizedBox(width: kDefaultPaddin / 2)
      //  ],
    );
  }
}
