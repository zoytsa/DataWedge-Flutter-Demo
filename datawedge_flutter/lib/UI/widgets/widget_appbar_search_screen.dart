import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarSearchWidget extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(40);

  final Function() onSelectedProductsAppBar;

  AppBarSearchWidget(
      {Key? key,
      //  required this.appBarSearchTitle,
      required this.onSelectedProductsAppBar})
      : super(key: key);

  //final String appBarSearchTitle;
  @override
  _AppBarSearchWidgetState createState() => _AppBarSearchWidgetState();
}

class _AppBarSearchWidgetState extends State<AppBarSearchWidget> {
  void updateAppbarWidget() {
    setState(() {});
  }

  void _addNewGoodsFromSearch() {
    print('go to items 11111');
    print(selectedProducts);
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
      title: Column(children: [
        Container(
          //padding: const EdgeInsets.only(right: 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(
                width: 131,
                child: Container(
                  child:
                      BlocBuilder<SelectedProductsCubit, SelectedProductsState>(
                    // buildWhen: (previous, current) =>
                    //     previous.selectedProducts.length !=
                    //     current.selectedProducts.length,
                    builder: (context, state) {
                      return
                          // Text(
                          //     //padding: const EdgeInsets.
                          //     'Выбрано товаров: ${selectedProducts2.length}',
                          //     style: TextStyle(fontSize: isDCT ? 12 : 13));

                          RichText(
                        text: TextSpan(
                          text: 'Выбрано товаров для списка: ',
                          style: TextStyle(
                              fontSize: isDCT ? 12 : 13,
                              color: Palette.iconColor),
                          //color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                //text: selectedProducts2.length.toString(),
                                text: state.selectedProducts.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                )),
          ]),
          //SizedBox(width: 10)
        ),
        //  ProductChildCategoryWidget(),
      ]),

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
              ? EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10)
              : EdgeInsets.all(6),
          padding: EdgeInsets.only(left: 10, right: 10),
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
              borderRadius: BorderRadius.circular(isDCT ? 12 : 12),
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
                //  Icon(Icons.document_scanner_outlined, size: 11),
                Text(
                  " +   В СПИСОК!  ",
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
