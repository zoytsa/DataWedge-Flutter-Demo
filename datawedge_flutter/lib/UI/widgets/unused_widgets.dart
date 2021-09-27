import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
import 'package:datawedgeflutter/selected_products_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class AppBarSearchWidget2_unused extends StatelessWidget
    implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(40);

  const AppBarSearchWidget2_unused({Key? key}) : super(key: key);

  void _addNewGoodsFromSearch2(BuildContext context) {
    // print('go to items 1');
    // print(selectedProducts);
    //widget.onSelectedProductsAppBar(selectedProducts);
    // onSelectedProductsSearch();
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
                child:
                    BlocBuilder<SelectedProductsCubit, SelectedProductsState>(
                  builder: (context, state) {
                    return Text(
                        //padding: const EdgeInsets.
                        //  'Выбрано: ${selectedProducts2.length}',
                        'Выбрано: ${state.selectedProducts.length}',
                        style: TextStyle(fontSize: isDCT ? 12 : 13));
                  },
                ),
              )),
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
            child: Container(
          margin: isDCT
              ? EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10)
              : EdgeInsets.all(6),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
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
                _addNewGoodsFromSearch2(context);
              },
              child: Row(children: [
                // Icon(Icons.list, size: 14),
                //  Icon(Icons.document_scanner_outlined, size: 11),
                Text(
                  " +  В СПИСОК ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: isDCT ? 10 : 10),
                ),
              ])),
        ))
      ],
    );
  }
}
