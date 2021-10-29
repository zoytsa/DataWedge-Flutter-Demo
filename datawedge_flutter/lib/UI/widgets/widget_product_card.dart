import 'package:datawedgeflutter/UI/product_details_screen.dart';
import 'package:datawedgeflutter/UI/widgets/extra_widgets.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:datawedgeflutter/presentation/cubit/goods_items_cubit.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCardWidget extends StatefulWidget {
  final int index;
  final bool isDCT;
  final bool isGridView;
  final ProductInfo productInfo;
  final VoidCallback refreshBodyOnSelectedProductCategory;
  final bool showBottomField;
  const ProductCardWidget(
      {Key? key,
      required this.index,
      required this.isDCT,
      required this.isGridView,
      required this.productInfo,
      required this.refreshBodyOnSelectedProductCategory,
      required this.showBottomField})
      : super(key: key);

  @override
  _ProductCardWidgetState createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  _setStateProductCardWidget() {
    setState(() {});
  }

  void _setStateProductCardWidgetOnSelection() {
    setState(() {
      widget.productInfo.isSelected = !widget.productInfo.isSelected;

      if (widget.productInfo.isSelected) {
        BlocProvider.of<SelectedProductsCubit>(context)
            .addProductToSelected2(widget.productInfo);
      } else
        BlocProvider.of<SelectedProductsCubit>(context)
            .removeProductFromSelected2(widget.productInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(widget.isDCT ? 1 : 2),
      child: widget.isGridView // grid
          ? widget.productInfo.image_url == ''
              ? ProductCardGridNoPhotoWidget(
                  setStateProductCardWidget: _setStateProductCardWidget,
                  isDCT: widget.isDCT,
                  productInfo: widget.productInfo,
                  index: widget.index,
                  showBottomField: widget.showBottomField,
                )
              : ProductCardGridWithPhotoWidget(
                  setStateProductCardWidget: _setStateProductCardWidget,
                  isDCT: widget.isDCT,
                  productInfo: widget.productInfo,
                  index: widget.index,
                  showBottomField: widget.showBottomField)
          : ProductCardListViewWidget(
              // list
              isDCT: widget.isDCT,
              productInfo: widget.productInfo,
              index: widget.index,
              setStateProductCardWidget: _setStateProductCardWidget,
            ),
    );
  }
}

class ProductCardGridWidget extends StatelessWidget {
  final VoidCallback setStateProductCardWidget;
  final bool isDCT;
  final ProductInfo productInfo;
  final int index;
  const ProductCardGridWidget(
      {Key? key,
      required this.setStateProductCardWidget,
      required this.isDCT,
      required this.productInfo,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          margin: EdgeInsets.all(isDCT ? 0 : 0.0),
          child: ListTile(
            isThreeLine: productInfo.image_url == '' ? true : false,
            title: Text('${index + 1}) ${productInfo.title}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: !productInfo.isSelected
                        ? Colors.black54
                        : Colors.white)),
            //subtitle: Text('Группа: ${productInfo.parent0_Title}'),
            tileColor: productInfo.isSelected
                ? Palette.lightBlue.withOpacity(0.6)
                : null,
            subtitle: productInfo.image_url != ''
                ? RichText(
                    text: TextSpan(
                      text: 'Артикул: ',
                      style: TextStyle(
                          fontSize: isDCT ? 12 : 13,
                          color: productInfo.isSelected
                              ? Colors.yellow[100]
                              : Palette.textColor1),
                      children: <TextSpan>[
                        TextSpan(
                            text: productInfo.inner_extra_code,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[400]
                                    : Colors.green)),
                        TextSpan(text: "     Остаток: "),
                        TextSpan(
                            text: productInfo.stock_quantity.toString(),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[400]
                                    : productInfo.stock_quantity > 0
                                        ? Colors.green
                                        : null)),
                        if (productInfo.selected_quantity > 0)
                          TextSpan(text: "     В списке: "),
                        if (productInfo.selected_quantity > 0)
                          TextSpan(
                              text: productInfo.selected_quantity.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: productInfo.isSelected
                                      ? Colors.yellow[400]
                                      : Colors.green)),
                      ],
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      text: 'Артикул: ',
                      style: TextStyle(
                          fontSize: isDCT ? 12 : 13,
                          color: productInfo.isSelected
                              ? Colors.yellow[100]
                              : Palette.textColor1),
                      //color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: productInfo.inner_extra_code,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[400]
                                    : Colors.green)),
                        TextSpan(text: "     Остаток: "),
                        TextSpan(
                            text: productInfo.stock_quantity.toString(),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[400]
                                    : productInfo.stock_quantity > 0
                                        ? Colors.green
                                        : null)),
                        if (productInfo.selected_quantity > 0)
                          TextSpan(text: "     В списке: "),
                        if (productInfo.selected_quantity > 0)
                          TextSpan(
                              text: productInfo.selected_quantity.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: productInfo.isSelected
                                      ? Colors.yellow[400]
                                      : Colors.green)),
                        TextSpan(
                            text:
                                '\n${productInfo.barcode}', //productInfo.inner_extra_code,
                            style: TextStyle(
                                fontSize: 13,
                                //  fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[400]
                                    : Colors.black87)),
                        TextSpan(
                            text:
                                '     Цена: ${productInfo.price_sell}', //productInfo.inner_extra_code,
                            style: TextStyle(
                                fontSize: 13,
                                //  fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[400]
                                    : Colors.black87)),
                      ],
                    ),
                  ),

            trailing: PopupMenuWidget(
                productInfo: productInfo,
                setStateOnPopUpItemSelected: setStateProductCardWidget),
          ),
        ),
        if (productInfo.image_url != '')
          Container(
            decoration: new BoxDecoration(
                color: productInfo.isSelected
                    ? Palette.lightBlue.withOpacity(0.6)
                    : null),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FadeInImage.memoryNetwork(
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100.0,
                      height: 50.0,
                      child: Image.asset('assets/icons/no-photo.png'),
                    );
                  },
                  placeholder: kTransparentImage,
                  image: productInfo.image_url,
                  fit: BoxFit.fitHeight,
                  width: 100.0,
                  height: 50.0,
                ),
              ),
              // :

              // Image.asset(
              //     'assets/icons/no-photo.png',
              //     width: 100,
              //     height: 40,
              //     //   fit: BoxFit.fitHeight,
              //   ),

              title: Text(
                '${productInfo.barcode}',
                style: TextStyle(
                    fontSize: 13,
                    color: productInfo.isSelected
                        ? Colors.yellow[100]
                        : Colors.black),
              ),
              subtitle: Text('Цена: ${productInfo.price_sell}',
                  style: TextStyle(
                      fontSize: 13,
                      color: productInfo.isSelected
                          ? Colors.yellow[100]
                          : Colors.black)),
            ),
          )
      ],
    );
  }
}

class ProductCardGridWithPhotoWidget extends StatelessWidget {
  final VoidCallback setStateProductCardWidget;
  final bool isDCT;
  final ProductInfo productInfo;
  final int index;
  final bool showBottomField;
  const ProductCardGridWithPhotoWidget(
      {Key? key,
      required this.setStateProductCardWidget,
      required this.isDCT,
      required this.productInfo,
      required this.index,
      required this.showBottomField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('index built ${index}');
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          margin: EdgeInsets.all(isDCT ? 0 : 0.0),
          child: ListTile(
            isThreeLine: false,
            title: Text('${index + 1}) ${productInfo.title}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: !productInfo.isSelected
                        ? Colors.black54
                        : Colors.white)),
            //subtitle: Text('Группа: ${productInfo.parent0_Title}'),
            tileColor: productInfo.isSelected
                ? Palette.lightBlue.withOpacity(0.6)
                : null,
            subtitle: RichText(
              text: TextSpan(
                text: 'Артикул: ',
                style: TextStyle(
                    fontSize: isDCT ? 12 : 13,
                    color: productInfo.isSelected
                        ? Colors.yellow[100]
                        : Palette.textColor1),
                children: <TextSpan>[
                  TextSpan(
                      text: productInfo.inner_extra_code,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: productInfo.isSelected
                              ? Colors.yellow[400]
                              : Colors.green)),
                  TextSpan(text: "     Остаток: "),
                  TextSpan(
                      text: productInfo.stock_quantity.toString(),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: productInfo.isSelected
                              ? Colors.yellow[400]
                              : productInfo.stock_quantity > 0
                                  ? Colors.green
                                  : null)),
                  if (productInfo.selected_quantity > 0)
                    TextSpan(text: "     В списке: "),
                  if (productInfo.selected_quantity > 0)
                    TextSpan(
                        text: productInfo.selected_quantity.toString(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: productInfo.isSelected
                                ? Colors.yellow[400]
                                : Colors.green)),
                ],
              ),
            ),
            trailing: showBottomField
                ? null
                : PopupMenuWidget(
                    productInfo: productInfo,
                    setStateOnPopUpItemSelected: setStateProductCardWidget),
          ),
        ),
        Container(
          decoration: new BoxDecoration(
              color: productInfo.isSelected
                  ? Palette.lightBlue.withOpacity(0.6)
                  : null),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FadeInImage.memoryNetwork(
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100.0,
                    height: 50.0,
                    child: Image.asset('assets/icons/no-photo.png'),
                  );
                },
                placeholder: kTransparentImage,
                image: productInfo.image_url,
                fit: BoxFit.fitHeight,
                width: 100.0,
                height: 50.0,
              ),
            ),
            // :

            // Image.asset(
            //     'assets/icons/no-photo.png',
            //     width: 100,
            //     height: 40,
            //     //   fit: BoxFit.fitHeight,
            //   ),

            title: Text(
              '${productInfo.barcode}',
              style: TextStyle(
                  fontSize: 13,
                  color: productInfo.isSelected
                      ? Colors.yellow[100]
                      : Colors.black),
            ),
            subtitle: Text('Цена: ${productInfo.price_sell}',
                style: TextStyle(
                    fontSize: 13,
                    color: productInfo.isSelected
                        ? Colors.yellow[100]
                        : Colors.black)),
          ),
        ),
        showBottomField
            ? SizedBox(
                // height: 20,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _removeQuantity(index, false, context);
                      },
                      onLongPress: () {
                        _removeQuantity(index, true, context);
                      },
                      child: Container(
                        margin: isDCT
                            ? EdgeInsets.only(
                                top: 6, bottom: 6, left: 10, right: 10)
                            : EdgeInsets.all(6),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 7, bottom: 7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.75),
                              Colors.red.withOpacity(0.75)
                            ],
                            begin: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isDCT ? 13 : 13),
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.black.withOpacity(.3),
                          //       spreadRadius: 1,
                          //       blurRadius: 2,
                          //       offset: Offset(0, 1))
                          // ]
                        ),
                        child: Text(
                          " - ",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: isDCT ? 13 : 13),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _changeQuantity(index, context);
                      },
                      child: Container(
                        margin: isDCT
                            ? EdgeInsets.only(
                                top: 6, bottom: 6, left: 10, right: 10)
                            : EdgeInsets.all(6),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 7, bottom: 7),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue],
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(isDCT ? 13 : 13),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.3),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1))
                            ]),
                        child: Text(
                          goodsItems[index].quantity.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: isDCT ? 12 : 13),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _addQuantity(index, false, context);
                      },
                      onLongPress: () {
                        _addQuantity(index, true, context);
                      },
                      child: Container(
                        margin: isDCT
                            ? EdgeInsets.only(
                                top: 6, bottom: 6, left: 10, right: 10)
                            : EdgeInsets.all(6),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 7, bottom: 7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.75),
                              Colors.lightGreen.withOpacity(0.75)
                            ],
                            begin: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isDCT ? 13 : 13),
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.black.withOpacity(.3),
                          //       spreadRadius: 1,
                          //       blurRadius: 2,
                          //       offset: Offset(0, 1))
                          // ]
                        ),
                        child: Text(
                          " + ",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: isDCT ? 13 : 13),
                        ),
                      ),
                    ),
                    SizedBox(),
                  ],
                )),
              )
            : SizedBox()
      ],
    );
  }

  void _addQuantity(int index, bool longPress, BuildContext context) {
    longPress
        ? goodsItems[index].quantity = (goodsItems[index].quantity + 10).ceil()
        : ++goodsItems[index].quantity;
    BlocProvider.of<GoodsItemsCubit>(context).updateSum();
    setStateProductCardWidget();
  }

  void _removeQuantity(int index, bool longPress, BuildContext context) {
    goodsItems[index].quantity > 0
        ? longPress
            ? goodsItems[index].quantity =
                (goodsItems[index].quantity - 10).floor()
            : --goodsItems[index].quantity
        : goodsItems[index].quantity = 0;
    BlocProvider.of<GoodsItemsCubit>(context).updateSum();
    setStateProductCardWidget();
  }

  void _changeQuantity(int index, context) {
    var alert = AlertDialog(
      title: Text("Введите количество товара"),
      content: TextField(
        style: TextStyle(decoration: TextDecoration.none),
        maxLines: 1,
        //maxLengthEnforced: false,
        autofocus: true,
        enabled: true,
        keyboardType: TextInputType.number,
        onSubmitted: (String text) {
          double? number_input = double.tryParse(text);
          // Do something with your number like pass it to the next material page route
          if (number_input != null) {
            goodsItems[index].quantity = number_input;
            callBloc = true;
            //  BlocProvider.of<GoodsItemsCubit>(context).updateSum();
          }
        },
        // controller: _controller,
        decoration: new InputDecoration(
          errorStyle: TextStyle(color: Colors.redAccent),
          border: new UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(40, 40, 40, 1.0),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(40, 40, 40, 1.0),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(40, 40, 40, 1.0),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: new Icon(
            Icons.add_task_sharp,
            size: 22.0,
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
    // print('number_input');
  }
}

class ProductCardGridNoPhotoWidget extends StatelessWidget {
  final VoidCallback setStateProductCardWidget;
  final bool isDCT;
  final ProductInfo productInfo;
  final int index;
  final bool showBottomField;
  const ProductCardGridNoPhotoWidget(
      {Key? key,
      required this.setStateProductCardWidget,
      required this.isDCT,
      required this.productInfo,
      required this.index,
      required this.showBottomField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          margin: EdgeInsets.all(isDCT ? 0 : 0.0),
          child: ListTile(
            isThreeLine: true,
            title: Text('${index + 1}) ${productInfo.title}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: !productInfo.isSelected
                        ? Colors.black54
                        : Colors.white)),
            //subtitle: Text('Группа: ${productInfo.parent0_Title}'),
            tileColor: productInfo.isSelected
                ? Palette.lightBlue.withOpacity(0.6)
                : null,
            subtitle: RichText(
              text: TextSpan(
                text: 'Артикул: ',
                style: TextStyle(
                    fontSize: isDCT ? 12 : 13,
                    color: productInfo.isSelected
                        ? Colors.yellow[100]
                        : Palette.textColor1),
                //color: Colors.grey),
                children: <TextSpan>[
                  TextSpan(
                      text: productInfo.inner_extra_code,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: productInfo.isSelected
                              ? Colors.yellow[400]
                              : Colors.green)),
                  TextSpan(text: "     Остаток: "),
                  TextSpan(
                      text: productInfo.stock_quantity.toString(),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: productInfo.isSelected
                              ? Colors.yellow[400]
                              : productInfo.stock_quantity > 0
                                  ? Colors.green
                                  : null)),
                  if (productInfo.selected_quantity > 0)
                    TextSpan(text: "     В списке: "),
                  if (productInfo.selected_quantity > 0)
                    TextSpan(
                        text: productInfo.selected_quantity.toString(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: productInfo.isSelected
                                ? Colors.yellow[400]
                                : Colors.green)),
                  TextSpan(
                      text:
                          '\n${productInfo.barcode}', //productInfo.inner_extra_code,
                      style: TextStyle(
                          fontSize: 13,
                          //  fontWeight: FontWeight.bold,
                          color: productInfo.isSelected
                              ? Colors.yellow[400]
                              : Colors.black87)),
                  TextSpan(
                      text:
                          '     Цена: ${productInfo.price_sell}', //productInfo.inner_extra_code,
                      style: TextStyle(
                          fontSize: 13,
                          //  fontWeight: FontWeight.bold,
                          color: productInfo.isSelected
                              ? Colors.yellow[400]
                              : Colors.black87)),
                ],
              ),
            ),

            trailing: showBottomField
                ? null
                : PopupMenuWidget(
                    productInfo: productInfo,
                    setStateOnPopUpItemSelected: setStateProductCardWidget),
          ),
        ),
        showBottomField
            ? SizedBox(
                // height: 20,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _removeQuantity(index, false, context);
                      },
                      onLongPress: () {
                        _removeQuantity(index, true, context);
                      },
                      child: Container(
                        margin: isDCT
                            ? EdgeInsets.only(
                                top: 6, bottom: 6, left: 10, right: 10)
                            : EdgeInsets.all(6),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 7, bottom: 7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.75),
                              Colors.red.withOpacity(0.75)
                            ],
                            begin: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isDCT ? 13 : 13),
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.black.withOpacity(.3),
                          //       spreadRadius: 1,
                          //       blurRadius: 2,
                          //       offset: Offset(0, 1))
                          // ]
                        ),
                        child: Text(
                          " - ",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: isDCT ? 13 : 13),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _changeQuantity(index, context);
                      },
                      child: Container(
                        margin: isDCT
                            ? EdgeInsets.only(
                                top: 6, bottom: 6, left: 10, right: 10)
                            : EdgeInsets.all(6),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 7, bottom: 7),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue],
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(isDCT ? 12 : 12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1))
                            ]),
                        child: Text(
                          goodsItems[index].quantity.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: isDCT ? 12 : 13),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _addQuantity(index, false, context);
                      },
                      onLongPress: () {
                        _addQuantity(index, true, context);
                      },
                      child: Container(
                        margin: isDCT
                            ? EdgeInsets.only(
                                top: 6, bottom: 6, left: 10, right: 10)
                            : EdgeInsets.all(6),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 7, bottom: 7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.75),
                              Colors.lightGreen.withOpacity(0.75)
                            ],
                            begin: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isDCT ? 13 : 13),
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.black.withOpacity(.3),
                          //       spreadRadius: 1,
                          //       blurRadius: 2,
                          //       offset: Offset(0, 1))
                          // ]
                        ),
                        child: Text(
                          " + ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: isDCT ? 13 : 13),
                        ),
                      ),
                    ),
                    SizedBox(),
                  ],
                )),
              )
            : SizedBox()
      ],
    );
  }

  void _addQuantity(int index, bool longPress, BuildContext context) {
    longPress
        ? goodsItems[index].quantity = (goodsItems[index].quantity + 10).ceil()
        : ++goodsItems[index].quantity;
    BlocProvider.of<GoodsItemsCubit>(context).updateSum();
    setStateProductCardWidget();
  }

  void _removeQuantity(int index, bool longPress, BuildContext context) {
    goodsItems[index].quantity > 0
        ? longPress
            ? goodsItems[index].quantity =
                (goodsItems[index].quantity - 10).floor()
            : --goodsItems[index].quantity
        : goodsItems[index].quantity = 0;
    BlocProvider.of<GoodsItemsCubit>(context).updateSum();
    setStateProductCardWidget();
  }

  void _changeQuantity(int index, context) {
    var alert = AlertDialog(
      title: Text("Введите количество товара"),
      content: TextField(
        style: TextStyle(decoration: TextDecoration.none),
        maxLines: 1,
        //maxLengthEnforced: false,
        autofocus: true,
        enabled: true,
        keyboardType: TextInputType.number,
        onSubmitted: (String text) {
          double? number_input = double.tryParse(text);
          // Do something with your number like pass it to the next material page route
          if (number_input != null) {
            goodsItems[index].quantity = number_input;
            callBloc = true;
          }
        },
        // controller: _controller,
        decoration: new InputDecoration(
          errorStyle: TextStyle(color: Colors.redAccent),
          border: new UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(40, 40, 40, 1.0),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(40, 40, 40, 1.0),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(40, 40, 40, 1.0),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: new Icon(
            Icons.confirmation_number,
            size: 18.0,
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
    //  print(number_input);
  }
}

class ProductCardListViewWidget extends StatelessWidget {
  final VoidCallback setStateProductCardWidget;
  final bool isDCT;
  final ProductInfo productInfo;
  final int index;
  const ProductCardListViewWidget(
      {Key? key,
      required this.isDCT,
      required this.productInfo,
      required this.index,
      required this.setStateProductCardWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      margin: EdgeInsets.all(isDCT ? 0 : 0.0),
      child: ListTile(
        title: Text(
            productInfo.image_url == ''
                ? '${index + 1}) ${productInfo.title}'
                : ' 📷 ${index + 1}) ${productInfo.title}',
            style: TextStyle(
                fontSize: 14,
                color:
                    !productInfo.isSelected ? Colors.black87 : Colors.white)),
        //subtitle: Text('Группа: ${productInfo.parent0_Title}'),
        tileColor:
            productInfo.isSelected ? Palette.lightBlue.withOpacity(0.6) : null,
        subtitle: RichText(
          text: TextSpan(
            text: 'Артикул: ',
            style: TextStyle(
                fontSize: isDCT ? 12 : 13,
                color: productInfo.isSelected
                    ? Colors.yellow[100]
                    : Palette.textColor1),
            children: <TextSpan>[
              TextSpan(
                  text: productInfo.inner_extra_code,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: productInfo.isSelected
                          ? Colors.yellow[400]
                          : Colors.green)),
              TextSpan(text: "     Остаток: "),
              TextSpan(
                  text: productInfo.stock_quantity.toString(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: productInfo.isSelected
                          ? Colors.yellow[400]
                          : productInfo.stock_quantity > 0
                              ? Colors.green
                              : null)),
              if (productInfo.selected_quantity > 0)
                TextSpan(text: "     В списке: "),
              if (productInfo.selected_quantity > 0)
                TextSpan(
                    text: productInfo.selected_quantity.toString(),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: productInfo.isSelected
                            ? Colors.yellow[400]
                            : Colors.green)),
            ],
          ),
        ),
        //trailing: popupMenuButton(widget.productInfo),
        trailing: PopupMenuWidget(
            productInfo: productInfo,
            setStateOnPopUpItemSelected: setStateProductCardWidget),
      ),
    );
  }
}

class PopupMenuWidget extends StatelessWidget {
  final VoidCallback setStateOnPopUpItemSelected;
  final ProductInfo productInfo;
  const PopupMenuWidget(
      {Key? key,
      required this.productInfo,
      required this.setStateOnPopUpItemSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert,
            color: productInfo.isSelected ? Colors.white : Colors.indigo),
        itemBuilder: (context) {
          return [
            if (!productInfo.isSelected)
              PopupMenuItem(
                value: 'add_to_list',
                child: RichText(
                    text: TextSpan(
                        text: '✅ Выбрать',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                      TextSpan(
                          text: '  Двойной клик',
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontStyle: FontStyle.italic))
                    ])),
              ),
            if (productInfo.isSelected)
              PopupMenuItem(
                  value: 'remove_from_list',
                  child: RichText(
                      text: TextSpan(
                          text: '❕ Отменить выбор ',
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: '  Двойной клик',
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontStyle: FontStyle.italic))
                      ]))),

            PopupMenuItem(
              value: 'add_quantity',
              child: Text('🔢 Добавить количество'),
            ),
            // PopupMenuItem(
            //   value: 'report',
            //   child: Text('📈 Отчет'),

            // ),

            if (productInfo.image_url != '')
              PopupMenuItem(
                value: 'photo',
                child: RichText(
                    text: TextSpan(
                        text: '📷 Фото',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                      TextSpan(
                          text: '  Клик',
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontStyle: FontStyle.italic))
                    ])),
              ),
            PopupMenuItem(
              value: 'find_in_list',
              child: Text('📜 Найти в списке'),
            ),
            // PopupMenuItem(
            //   value: 'add_to_starred',
            //   child: Text('📌 Закрепить'),
            // ),

            PopupMenuItem(
              value: 'open',
              child: RichText(
                  text: TextSpan(
                      text: 'ℹ Подробно',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: '  Длительное нажатие',
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontStyle: FontStyle.italic))
                  ])),
            )
          ];
        },
        onSelected: (String value) => {
              _actionPopUpItemSelected(context, value, productInfo),
              if (value == 'add_to_list' || value == 'remove_from_list')
                {setStateOnPopUpItemSelected()}

              // setState(
              //   () {
              //     actionPopUpItemSelected(
              //         context, value, productInfo);
              //   },
              // )
            });
  }
}

void _actionPopUpItemSelected(
    BuildContext context, String value, ProductInfo productInfo) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  String message;
  if (value == 'add_to_list') {
    BlocProvider.of<SelectedProductsCubit>(context)
        .addProductToSelected2(productInfo);
    message = 'Товар выбран';
    productInfo.isSelected = true;
  } else if (value == 'add_quantity') {
    message = 'Введите количество товара';
  } else if (value == 'remove_from_list') {
    BlocProvider.of<SelectedProductsCubit>(context)
        .removeProductFromSelected2(productInfo);
    message = 'Удален из выбранных';
    productInfo.isSelected = false;
  } else if (value == 'photo') {
    message = 'Фото товара';

    if (productInfo.image_url != '') {
      Navigator.of(context).push(
        HeroDialogRoute(
          builder: (context) => Center(
            child: PopupImageCard(
                image_url: productInfo.image_url, title: productInfo.title),
          ),
        ),
      );
    }
  } else if (value == 'find_in_list') {
    message = 'Товар найден в списке!';
  } else if (value == 'add_to_starred') {
    message = 'Товар закреплен!';
  } else if (value == 'open') {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDeatailsPage(product: productInfo),
        ));

    message = 'Карточка товара.';
  } else {
    message = 'Нет действий!';
  }
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     backgroundColor: Colors.deepOrange[100],
  //     content: Text(message),
  //   ),
  //);
}

class ProductCardGestureDetectorForCatalogScreen extends StatelessWidget {
  final int index;
  final bool isDCT;
  final bool isGridView;
  final ProductInfo productInfo;
  final VoidCallback refreshBodyOnSelectedProductCategory;
  const ProductCardGestureDetectorForCatalogScreen(
      {Key? key,
      required this.refreshBodyOnSelectedProductCategory,
      required this.productInfo,
      required this.isDCT,
      required this.isGridView,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<_ProductCardWidgetState> _keyProductCardWidget =
        GlobalKey();
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          //   print('User swiped Left');
          if (selectedProductCategory!.children!.length > 0 &&
              selectedProductChildCategoryIndex > 0) {
            selectedProductChildCategoryIndex--;
            selectedProductChildCategory = selectedProductCategory!
                .children![selectedProductChildCategoryIndex];

            BlocProvider.of<SelectedProductsCubit>(context)
                .selectedProductChildCategoryChanged(
                    selectedProductChildCategoryIndex);
            refreshBodyOnSelectedProductCategory();
          }
        } else if (details.primaryVelocity! < 0) {
          //   print('User swiped Right');
          if (selectedProductCategory!.children!.length > 0 &&
              selectedProductChildCategoryIndex <
                  (selectedProductCategory!.children!.length - 1)) {
            selectedProductChildCategoryIndex++;
            selectedProductChildCategory = selectedProductCategory!
                .children![selectedProductChildCategoryIndex];

            BlocProvider.of<SelectedProductsCubit>(context)
                .selectedProductChildCategoryChanged(
                    selectedProductChildCategoryIndex);

            refreshBodyOnSelectedProductCategory();
          }
        }
      },
      onTap: () {
        if (productInfo.image_url != '') {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) => Center(
                child: PopupImageCard(
                    image_url: productInfo.image_url, title: productInfo.title),
              ),
            ),
          );
        }
      },
      onLongPress: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDeatailsPage(product: productInfo),
            ))
      },
      onDoubleTap: () {
        _keyProductCardWidget.currentState!
            ._setStateProductCardWidgetOnSelection();
        // setState(() {
        //   productInfo.isSelected = !productInfo.isSelected;

        //   if (productInfo.isSelected) {
        //     BlocProvider.of<SelectedProductsCubit>(context)
        //         .addProductToSelected2(productInfo);
        //   } else
        //     BlocProvider.of<SelectedProductsCubit>(context)
        //         .removeProductFromSelected2(productInfo);
        // }
        //
        //);
      },
      child: ProductCardWidget(
        key: _keyProductCardWidget,
        index: index,
        isDCT: isDCT,
        isGridView: isGridView,
        productInfo: productInfo,
        refreshBodyOnSelectedProductCategory:
            refreshBodyOnSelectedProductCategory,
        showBottomField: false,
      ),
    );
  }
}

class ProductCardForGoodsItemsScreen extends StatelessWidget {
  final int index;
  final bool isDCT;
  final bool isGridView;
  final ProductInfo productInfo;
  final VoidCallback refreshBodyOnSelectedProductCategory;
  const ProductCardForGoodsItemsScreen(
      {Key? key,
      required this.refreshBodyOnSelectedProductCategory,
      required this.productInfo,
      required this.isDCT,
      required this.isGridView,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<_ProductCardWidgetState> _keyProductCardWidget =
        GlobalKey();
    return ProductCardWidget(
      key: _keyProductCardWidget,
      index: index,
      isDCT: isDCT,
      isGridView: isGridView,
      productInfo: productInfo,
      refreshBodyOnSelectedProductCategory:
          refreshBodyOnSelectedProductCategory,
      showBottomField: true,
    );
  }
}
