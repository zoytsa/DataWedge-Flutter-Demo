import 'package:datawedgeflutter/UI/product_details_screen.dart';
import 'package:datawedgeflutter/UI/widgets/extra_widgets.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
//import 'package:datawedgeflutter/selected_products_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

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

  addProductToSelected(Product product, List<Product> selectedProducts) {}

  removeProductFromSelected(Product product, List<Product> selectedProducts) {}
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

Widget productInfoTile_unused(
    ProductInfo productInfo, int index, bool isDCT, BuildContext context) {
  // print('builded ${productInfo.title}');
  bool isGridView = true;
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
          _refreshBodyOnSelectedProductCategory();
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

          _refreshBodyOnSelectedProductCategory();
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
      // setState(() {
      //   productInfo.isSelected = !productInfo.isSelected;

      //   if (productInfo.isSelected) {
      //     BlocProvider.of<SelectedProductsCubit>(context)
      //         .addProductToSelected2(productInfo);
      //   } else
      //     BlocProvider.of<SelectedProductsCubit>(context)
      //         .removeProductFromSelected2(productInfo);
      // });
    },
    child: Card(
      margin: EdgeInsets.all(isDCT ? 1 : 2),
      child: !isGridView // grid
          ? Column(
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
                    //   Text("Second One Text \nThis is Line Third Text"),

                    trailing: popupMenuButton(productInfo, context),
                  ),
                ),
                productInfo.image_url == ''
                    ? Container()
                    : Container(
                        decoration: new BoxDecoration(
                            color: productInfo.isSelected
                                // ? Colors.blue.withOpacity(0.4)
                                //? Palette.facebookColor.withOpacity(0.55)
                                //? Palette.blue.withOpacity(0.45)
                                ? Palette.lightBlue.withOpacity(0.6)
                                : null),
                        child: ListTile(
                          leading: productInfo.image_url != ''
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FadeInImage.memoryNetwork(
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: 100.0,
                                        height: 50.0,
                                        child: Image.asset(
                                            'assets/icons/no-photo.png'),
                                      );
                                    },

                                    // (BuildContext? context,
                                    //     Object? exception, StackTrace? stackTrace) {
                                    //   // print('Error Handler');
                                    //   return Container(
                                    //     width: 100.0,
                                    //     height: 50.0,
                                    //     child: Image.asset('assets/icons/no-photo.png'),
                                    //   );
                                    // },
                                    placeholder: kTransparentImage,
                                    // AssetImage('assets/icons/nophoto.gif'),
                                    image: productInfo.image_url,
                                    fit: BoxFit.fitHeight,
                                    width: 100.0,
                                    height: 50.0,
                                  ),
                                )
                              : Image.asset(
                                  'assets/icons/no-photo.png',
                                  width: 100,
                                  height: 40,
                                  //   fit: BoxFit.fitHeight,
                                ),
                          //Icon(Icons.picture_in_picture),
                          title: Text(
                            '${productInfo.barcode}',
                            style: TextStyle(
                                fontSize: 13,
                                //fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.yellow[100]
                                    : Colors.black),
                          ),
                          subtitle: Text('Цена: ${productInfo.price_sell}',
                              style: TextStyle(
                                  fontSize: 13,
                                  //fontWeight: FontWeight.bold,
                                  color: productInfo.isSelected
                                      ? Colors.yellow[100]
                                      : Colors.black)),
                        ),
                      )
              ],
            )
          : Container(
              // list non-grid
              padding: const EdgeInsets.all(0.0),
              margin: EdgeInsets.all(isDCT ? 0 : 0.0),

              child: ListTile(
                title: Text(
                    productInfo.image_url == ''
                        ? '${index + 1}) ${productInfo.title}'
                        : ' 📷 ${index + 1}) ${productInfo.title}',
                    //         productInfo.image_url ==
                    //     ''
                    // ? '📷'
                    // : '',
                    style: TextStyle(
                        //fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: !productInfo.isSelected
                            ? Colors.black87
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
                trailing: popupMenuButton(productInfo, context),
              ),
            ),
    ),
  );
}

void _refreshBodyOnSelectedProductCategory() {}

Widget popupMenuButton(ProductInfo productInfo, BuildContext context) {
  return PopupMenuButton(
      icon: Icon(Icons.more_vert,
          color: productInfo.isSelected ? Colors.white : Colors.indigo),
      itemBuilder: productInfo.isSelected
          ? (context) {
              return [
                //  PopupMenuItem(
                //   value: 'add_to_list',
                //   child: Text('✅ Выбрать'),
                // ),
                PopupMenuItem(
                  value: 'remove_from_list',
                  child: Text('❕ Отменить выбор'),
                ),

                PopupMenuItem(
                  value: 'add_quantity',
                  child: Text('🔢 Добавить количество'),
                ),
                // PopupMenuItem(
                //   value: 'report',
                //   child: Text('📈 Отчет'),

                // ),

                PopupMenuItem(
                  value: 'photo',
                  child: Text('📷 Фото'),
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
                  child: Text('ℹ Подробно'),
                )
              ];
            }
          : (context) {
              return [
                PopupMenuItem(
                  value: 'add_to_list',
                  child: Text('✅ Выбрать'),
                ),
                PopupMenuItem(
                  value: 'add_quantity',
                  child: Text('🔢 Добавить количество'),
                ),
                // PopupMenuItem(
                //   value: 'remove_from_list',
                //   child: Text('❕ Отменить выбор'),
                // ),
                PopupMenuItem(
                  value: 'photo',
                  child: Text('📷 Фото'),
                ),
                //    PopupMenuItem(
                //   value: 'report',
                //   child: Text('📈 Отчет'),
                // ),
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
                  child: Text('ℹ Подробно'),
                )
              ];
            },
      onSelected: (String value) => {
            // actionPopUpItemSelected(context, value, productInfo),
            // if (value == 'add_to_list' || value == 'remove_from_list')
            //   {setState(() {})}

            // // setState(
            // //   () {
            // //     actionPopUpItemSelected(
            // //         context, value, productInfo);
            // //   },
            // // )
          });
}

void actionPopUpItemSelected(
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
