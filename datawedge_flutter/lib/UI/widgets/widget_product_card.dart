import 'package:datawedgeflutter/UI/product_details_screen.dart';
import 'package:datawedgeflutter/extra_widgets.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/palette.dart';
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
  const ProductCardWidget(
      {Key? key,
      required this.index,
      required this.isDCT,
      required this.isGridView,
      required this.productInfo,
      required this.refreshBodyOnSelectedProductCategory})
      : super(key: key);

  @override
  _ProductCardWidgetState createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  _setStateProductCardWidget() {
    setState(() {});
  }

  void setStateProductCardWidgetOnSelection() {
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
      child: !widget.isGridView // grid
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(0.0),
                  margin: EdgeInsets.all(widget.isDCT ? 0 : 0.0),
                  child: ListTile(
                    isThreeLine:
                        widget.productInfo.image_url == '' ? true : false,
                    title: Text(
                        '${widget.index + 1}) ${widget.productInfo.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: !widget.productInfo.isSelected
                                ? Colors.black54
                                : Colors.white)),
                    //subtitle: Text('Группа: ${productInfo.parent0_Title}'),
                    tileColor: widget.productInfo.isSelected
                        ? Palette.lightBlue.withOpacity(0.6)
                        : null,
                    subtitle: widget.productInfo.image_url != ''
                        ? RichText(
                            text: TextSpan(
                              text: 'Артикул: ',
                              style: TextStyle(
                                  fontSize: widget.isDCT ? 12 : 13,
                                  color: widget.productInfo.isSelected
                                      ? Colors.yellow[100]
                                      : Palette.textColor1),
                              //color: Colors.grey),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.productInfo.inner_extra_code,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: widget.productInfo.isSelected
                                            ? Colors.yellow[400]
                                            : Colors.green)),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              text: 'Артикул: ',
                              style: TextStyle(
                                  fontSize: widget.isDCT ? 12 : 13,
                                  color: widget.productInfo.isSelected
                                      ? Colors.yellow[100]
                                      : Palette.textColor1),
                              //color: Colors.grey),
                              children: <TextSpan>[
                                TextSpan(
                                    text: widget.productInfo.inner_extra_code,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: widget.productInfo.isSelected
                                            ? Colors.yellow[400]
                                            : Colors.green)),
                                TextSpan(
                                    text:
                                        '\n${widget.productInfo.barcode}', //productInfo.inner_extra_code,
                                    style: TextStyle(
                                        fontSize: 13,
                                        //  fontWeight: FontWeight.bold,
                                        color: widget.productInfo.isSelected
                                            ? Colors.yellow[400]
                                            : Colors.black87)),
                                TextSpan(
                                    text:
                                        '     Цена: ${widget.productInfo.price_sell}', //productInfo.inner_extra_code,
                                    style: TextStyle(
                                        fontSize: 13,
                                        //  fontWeight: FontWeight.bold,
                                        color: widget.productInfo.isSelected
                                            ? Colors.yellow[400]
                                            : Colors.black87)),
                              ],
                            ),
                          ),
                    //   Text("Second One Text \nThis is Line Third Text"),

                    //trailing: popupMenuButton(widget.productInfo),
                    trailing: PopupMenuWidget(
                        productInfo: widget.productInfo,
                        setStateOnPopUpItemSelected:
                            _setStateProductCardWidget),
                  ),
                ),
                widget.productInfo.image_url == ''
                    ? Container()
                    : Container(
                        decoration: new BoxDecoration(
                            color: widget.productInfo.isSelected
                                // ? Colors.blue.withOpacity(0.4)
                                //? Palette.facebookColor.withOpacity(0.55)
                                //? Palette.blue.withOpacity(0.45)
                                ? Palette.lightBlue.withOpacity(0.6)
                                : null),
                        child: ListTile(
                          leading: widget.productInfo.image_url != ''
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
                                    image: widget.productInfo.image_url,
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
                            '${widget.productInfo.barcode}',
                            style: TextStyle(
                                fontSize: 13,
                                //fontWeight: FontWeight.bold,
                                color: widget.productInfo.isSelected
                                    ? Colors.yellow[100]
                                    : Colors.black),
                          ),
                          subtitle: Text(
                              'Цена: ${widget.productInfo.price_sell}',
                              style: TextStyle(
                                  fontSize: 13,
                                  //fontWeight: FontWeight.bold,
                                  color: widget.productInfo.isSelected
                                      ? Colors.yellow[100]
                                      : Colors.black)),
                        ),
                      )
              ],
            )
          : Container(
              // list non-grid
              padding: const EdgeInsets.all(0.0),
              margin: EdgeInsets.all(widget.isDCT ? 0 : 0.0),

              child: ListTile(
                title: Text(
                    widget.productInfo.image_url == ''
                        ? '${widget.index + 1}) ${widget.productInfo.title}'
                        : ' 📷 ${widget.index + 1}) ${widget.productInfo.title}',
                    //         productInfo.image_url ==
                    //     ''
                    // ? '📷'
                    // : '',
                    style: TextStyle(
                        //fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: !widget.productInfo.isSelected
                            ? Colors.black87
                            : Colors.white)),
                //subtitle: Text('Группа: ${productInfo.parent0_Title}'),
                tileColor: widget.productInfo.isSelected
                    ? Palette.lightBlue.withOpacity(0.6)
                    : null,
                subtitle: RichText(
                  text: TextSpan(
                    text: 'Артикул: ',
                    style: TextStyle(
                        fontSize: widget.isDCT ? 12 : 13,
                        color: widget.productInfo.isSelected
                            ? Colors.yellow[100]
                            : Palette.textColor1),
                    //color: Colors.grey),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.productInfo.inner_extra_code,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.productInfo.isSelected
                                  ? Colors.yellow[400]
                                  : Colors.green)),
                      TextSpan(text: "     Остаток: "),
                      TextSpan(
                          text: widget.productInfo.stock_quantity.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.productInfo.isSelected
                                  ? Colors.yellow[400]
                                  : widget.productInfo.stock_quantity > 0
                                      ? Colors.green
                                      : null)),
                      if (widget.productInfo.selected_quantity > 0)
                        TextSpan(text: "     В списке: "),
                      TextSpan(
                          text: widget.productInfo.selected_quantity.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.productInfo.isSelected
                                  ? Colors.yellow[400]
                                  : Colors.green)),
                    ],
                  ),
                ),
                //trailing: popupMenuButton(widget.productInfo),
                trailing: PopupMenuWidget(
                    productInfo: widget.productInfo,
                    setStateOnPopUpItemSelected: _setStateProductCardWidget),
              ),
            ),
    );
  }
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
            .setStateProductCardWidgetOnSelection();
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
              refreshBodyOnSelectedProductCategory),
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
