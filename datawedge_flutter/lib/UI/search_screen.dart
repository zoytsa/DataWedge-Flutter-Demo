import 'dart:convert';
import 'dart:math';

import 'package:datawedgeflutter/UI/product_details_screen.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/dataloader.dart';
import 'package:datawedgeflutter/UI/product_details_screen_unused.dart';
import 'package:datawedgeflutter/UI/home_screen.dart';
import 'package:datawedgeflutter/model/Product.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
import 'package:datawedgeflutter/selected_products_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:transparent_image/transparent_image.dart';
import '../extra_widgets.dart';
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
  List<ProductInfo> _products = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastElementId = 0;
  int _maxElementId = 0;
  late int _totalPages;

  final GlobalKey<_AppBarSearchWidgetState> _keyAppbar = GlobalKey();
  var addGoodsTitle2 = "Выбрано: " + selectedProducts.length.toString();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  bool useGridView = false;

  Future<bool> getListOfProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _lastElementId = 0;
    } else {
      // print('_lastElementId:${_lastElementId}');
      //print('_maxElementId:${_maxElementId}');
      if (_lastElementId >= _maxElementId) {
        _refreshController.loadNoData();
        return false;
      }
    }

    var uri = Uri.parse(
        "http://212.112.116.229:7788/weblink/hs/api/products?last_element_id=$_lastElementId&size=50");

    if (selectedProductChildCategory != null) {
      var _category_id = selectedProductChildCategory!.id;
      var _category_level = selectedProductChildCategory!.level;
      uri = Uri.parse(
          "http://212.112.116.229:7788/weblink/hs/api/products?last_element_id=$_lastElementId&category_id=$_category_id&category_level=$_category_level&size=50");
    }

    final response = await http.get(uri, headers: dct_headers);

    if (response.statusCode == 200) {
      final result = listOfProductsFromJsonBytes(response.bodyBytes);

      if (isRefresh) {
        _products = result.data;
      } else {
        _products.addAll(result.data);
      }

      _currentPage++;
      _lastElementId = result.lastElementId;
      _totalPages = result.totalPages;
      _maxElementId = result.maxElementId;

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Widget productInfoTile(ProductInfo productInfo, int index, bool isDCT) {
    // print('builded ${productInfo.title}');
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
        setState(() {
          productInfo.isSelected = !productInfo.isSelected;

          if (productInfo.isSelected) {
            BlocProvider.of<SelectedProductsCubit>(context)
                .addProductToSelected2(productInfo);
          } else
            BlocProvider.of<SelectedProductsCubit>(context)
                .removeProductFromSelected2(productInfo);
        });
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              // decoration: new BoxDecoration(
              //     color: productInfo.isSelected
              //         //? Colors.blue.withOpacity(0.4)
              //         //? Palette.facebookColor.withOpacity(0.55)
              //         //? Palette.blue.withOpacity(0.45)
              //         ? Palette.lightBlue.withOpacity(0.6)
              //         : null),
              child: ListTile(
                  // backgroundColor: Colors.Green,
                  title: Text('${index + 1}) ${productInfo.title}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
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
                              ? Colors.black54
                              : Palette.textColor1),
                      //color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: productInfo.inner_extra_code,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: productInfo.isSelected
                                    ? Colors.green[800]
                                    : Colors.green)),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert,
                          color: productInfo.isSelected
                              ? Colors.white
                              : Colors.indigo),
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
                            actionPopUpItemSelected(
                                context, value, productInfo),
                            if (value == 'add_to_list' ||
                                value == 'remove_from_list')
                              {setState(() {})}

                            // setState(
                            //   () {
                            //     actionPopUpItemSelected(
                            //         context, value, productInfo);
                            //   },
                            // )
                          })),
            ),
            Container(
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
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100.0,
                              height: 50.0,
                              child: Image.asset('assets/icons/no-photo.png'),
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
                        // child: Image.network(
                        //   productInfo.image_url,
                        //   width: 100,
                        //   height: 50,
                        //   fit: BoxFit.fitHeight,
                        //   errorBuilder: (BuildContext? context,
                        //       Object? exception, StackTrace? stackTrace) {
                        //     // return Text('NO PHOTO');
                        //     return Image.asset(
                        //       'assets/icons/no-photo.png',
                        //       width: 100,
                        //       height: 50,
                        //       //   fit: BoxFit.fitHeight,
                        //     );
                        //   },
                        // ),
                      )
                    : Image.asset(
                        'assets/icons/no-photo.png',
                        width: 100,
                        height: 50,
                        //   fit: BoxFit.fitHeight,
                      ),
                //Icon(Icons.picture_in_picture),
                title: Text('${productInfo.barcode}'),
                subtitle: Text('Цена: ${productInfo.price_sell}'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

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
          productChildCategories = [];
          selectedProductChildCategory = null;
          if (productCategories.length > 0) {
            selectedProductCategory = productCategories[0];
            if (selectedProductCategory!.children!.length > 0) {
              productChildCategories = selectedProductCategory!.children!;
              selectedProductChildCategory = productChildCategories[0];
            }
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
            color: category == selectedProductCategory
                ? Colors.white
                : Palette.textColor1,
            // fontStyle: FontStyle.italic,
            fontSize: category == selectedProductCategory ? 15 : 14,
          ),
        ),
      ));
    }
    //print('items${items.length}');
    return items;
  }

  Widget buildDropDown(BuildContext context) {
    if (selectedProductCategory == null) {
      return Row(
        children: [Expanded(child: Container()), CircularProgressIndicator()],
      );
    } else {
      return SizedBox(
        // width: 110,
        child: DropdownButton<ProductCategory>(
          isExpanded: true,
          value: selectedProductCategory,
          iconSize: 20,
          iconEnabledColor: Colors.green.withOpacity(0.5),
          // IconSizefocusColor: Colors.red,
          dropdownColor: Colors.indigo.withOpacity(0.8),
          icon: (null),
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          hint: Text('Выберите категорию...'),
          onChanged: (ProductCategory? newValue) {
            setState(() {
              selectedProductCategory = newValue;
              if (selectedProductCategory!.children!.length > 0) {
                productChildCategories = selectedProductCategory!.children!;
                selectedProductChildCategory = productChildCategories[0];
                selectedProductChildCategoryIndex = 0;
              }
            });
            _refreshBodyOnSelectedProductCategory();
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
    //_keyAppbar.currentState!.widget.appBarSearchTitle = addGoodsTitle2;
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

  Future<void> _refreshBodyOnSelectedProductCategory() async {
    // print('refreshing body');
    //  async {
    final result = await getListOfProducts(isRefresh: true);
    if (result) {
      _refreshController.refreshCompleted();
      BlocProvider.of<SelectedProductsCubit>(context).clearProductsSelected();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.green[200],
      //     // behavior: SnackBarBehavior.floating,
      //     content: Text('Список товаров обновлен!'),
      //   ),
      // );
    } else {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDCT = MediaQuery.of(context).size.height < 600;
    //print(selectedUser.name); // = users[0];
    // print(selectedMarket.name); //  = markets[0];
    // print(selectedDocumentType.name); //  = documentTypes[0];
    // print(
    //     selectedProfile.name); //  = profiles[0]; //Profile.getDefaultProfile();
    // print(selectedReport.name); //  = null;

    return Scaffold(
        appBar: AppBarSearchWidget(
            key: _keyAppbar,
            appBarSearchTitle: addGoodsTitle2,
            onSelectedProductsAppBar: () => onSelectedProductsSearch()),
        body: useGridView
            ? Column(
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
                  ProductChildCategoryWidget(
                      onSelectedChildCategory: () =>
                          _refreshBodyOnSelectedProductCategory()),
                  // SingleChildScrollView(
                  //   controller: _scrollController,
                  //   child: ConstrainedBox(
                  //     constraints: BoxConstraints(maxHeight: 380),
                  //     child:

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddin),
                      child: GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                vcbOnlongPress: () =>
                                    _updateSelectedProductsTitle(),
                              )),
                    ),
                  )

                  //  ),
                  //),
                ],
              )
            : CustomScrollView(slivers: [
                SliverAppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 48, //59 с кол. товаров,  //80 с поиском,
                    // collapsedHeight: 56,
                    primary: false,
                    floating: false,
                    // pinned: true,
                    brightness: Brightness.light,
                    elevation: 0.0,
                    flexibleSpace: Column(children: [
                      //    addEnterSearchField2(context), // ВРЕМЕННО!!!
                      // SizedBox(
                      //   height: 11,
                      //   child: Row(children: [
                      //     Text(' ${productChildCategories.length} товаров',
                      //         style: TextStyle(fontSize: 11, color: Colors.grey)),
                      //   ]),
                      // ),
                      Row(children: [
                        SizedBox(width: kDefaultPaddin),
                        SizedBox(
                          width: 249,
                          child: buildDropDown(context),
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
                    ])),
                SliverAppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 46,
                    // collapsedHeight: 56,
                    primary: false,
                    floating: false,
                    pinned: true,
                    brightness: Brightness.light,
                    elevation: 0.0,
                    flexibleSpace: Column(children: [
                      ProductChildCategoryWidget(
                          onSelectedChildCategory: () =>
                              _refreshBodyOnSelectedProductCategory()),
                    ])),
                SliverFillRemaining(
                  child: SmartRefresher(
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("Потяните вверх, чтобы загрузить еще...",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic));
                        } else if (mode == LoadStatus.loading) {
                          body = Container();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Окончание показа...");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("Показать еще.", // "release to load more"
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic));
                        } else {
                          body = Text("Вывод завершен.", // "No more Data"
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic));
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async {
                      final result = await getListOfProducts(isRefresh: true);
                      if (result) {
                        _refreshController.refreshCompleted();
                        BlocProvider.of<SelectedProductsCubit>(context)
                            .clearProductsSelected();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green[200],
                            content: Text('Список товаров обновлен!'),
                          ),
                        );
                      } else {
                        _refreshController.refreshFailed();
                      }
                    },
                    onLoading: () async {
                      final result = await getListOfProducts();
                      if (result) {
                        _refreshController.loadComplete();
                      } else {
                        _refreshController.loadFailed();
                      }
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return productInfoTile(product, index, isDCT);
                      },
                      itemCount: _products.length,
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
              ]),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            shape: CircleBorder(),
            //  childPadding: const EdgeInsets.symmetric(vertical: 5),
            overlayOpacity: 0,
            //childrenButtonSize: 60,
            spacing: 6,
            animationSpeed: 200, // openCloseDial: isDialOpen,
            childPadding: EdgeInsets.all(5),
            spaceBetweenChildren: 4,
            //  icon: Icons.share,
            backgroundColor: Colors.indigo[400],
            children: [
              SpeedDialChild(
                  //child: Icon(Icons.arrow_downward_sharp,
                  child: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.indigo[400]),
                  // label: 'Social Network',
                  backgroundColor: Colors.white,
                  onTap: () {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  }
                  //  foregroundColor: Colors.white70,
                  // onTap: () {/* Do someting */},
                  ),
              SpeedDialChild(
                  child: Icon(Icons.keyboard_arrow_up_outlined,
                      color: Colors.indigo[400]),
                  // label: 'Social Network',
                  backgroundColor: Colors.white,
                  onTap: () {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.minScrollExtent);
                    }
                  }),
              // SpeedDialChild(
              //   child: Icon(Icons.chat),
              //   label: 'Message',
              //   backgroundColor: Colors.amberAccent,
              //   onTap: () {/* Do something */},
              // ),
            ]));
  }
}

//  : ListView.builder(
//                     itemBuilder: (context, index) {
//                       final product = _products[index];
//                       return productInfoTile(product, index);
//                       // return ListTile(
//                       //   title: Text(document.number),
//                       //   subtitle: Text(document.date),
//                       //   trailing: Text(
//                       //     document.editedDate,
//                       //     style: TextStyle(color: Colors.green),
//                       //   ),
//                       // );
//                     },
//                     //  separatorBuilder: (context, index) => Divider(),
//                     itemCount: _products.length,
//                     controller: _scrollController,
//                   ),

class AppBarSearchWidget extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(40);
  //Function(List<Product>) onSelectedProductsAppBar;
  final Function() onSelectedProductsAppBar;

  //const AppBarSearchWidget({Key? key, required this.appBarSearchTitle})
  AppBarSearchWidget(
      {Key? key,
      required this.appBarSearchTitle,
      required this.onSelectedProductsAppBar})
      : super(key: key);

  final String appBarSearchTitle;
  @override
  _AppBarSearchWidgetState createState() => _AppBarSearchWidgetState();

  //final title = "";
}

class _AppBarSearchWidgetState extends State<AppBarSearchWidget> {
  void updateAppbarWidget() {
    setState(() {});
  }

  void _addNewGoodsFromSearch() {
    // print('go to items 1');
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
      title: Column(children: [
        Container(
          //padding: const EdgeInsets.only(right: 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(
                width: 131,
                child: Container(
                  child:
                      BlocBuilder<SelectedProductsCubit, SelectedProductsState>(
                    buildWhen: (previous, current) =>
                        previous.selectedProducts.length !=
                        current.selectedProducts.length,
                    builder: (context, state) {
                      return
                          // Text(
                          //     //padding: const EdgeInsets.
                          //     'Выбрано товаров: ${selectedProducts2.length}',
                          //     style: TextStyle(fontSize: isDCT ? 12 : 13));

                          RichText(
                        text: TextSpan(
                          text: 'Выбрано товаров: ',
                          style: TextStyle(
                              fontSize: isDCT ? 12 : 13,
                              color: Palette.textColor1),
                          //color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: selectedProducts2.length.toString(),
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
                  " +   В СПИСОК  ",
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
                        'Выбрано: ${selectedProducts2.length}',
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

class ProductChildCategoryWidget extends StatefulWidget {
  Function() onSelectedChildCategory;

  ProductChildCategoryWidget({Key? key, required this.onSelectedChildCategory})
      : super(key: key);

  @override
  _ProductChildCategoryWidgetState createState() =>
      _ProductChildCategoryWidgetState();
}

class _ProductChildCategoryWidgetState
    extends State<ProductChildCategoryWidget> {
  //List<String> categories = ["Hand bag", "Jewellery", "Footwear", "Dresses"];
  final ItemScrollController _scrollControllerChildCategory =
      ItemScrollController();
  void _refreshBodyOnChildCategorySelected() {
    widget.onSelectedChildCategory();
  }

  Future _scrollToPosition(_index) async {
    // if (_scrollControllerChildCategory.hasClients) {
    //   _scrollControllerChildCategory.animateTo(
    //       _scrollControllerChildCategory.position.minScrollExtent,
    //       duration: Duration(milliseconds: 1000),
    //       curve: Curves.ease);
    // }
    _scrollControllerChildCategory.scrollTo(
      index: _index,
      alignment: 0.2,
      duration: Duration(milliseconds: 800),
    );
  }

  // By default our first item will be selected
  //int selectedProductChildCategoryIndex = 0;
  //var _searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectedProductsCubit, SelectedProductsState>(
        listenWhen: (previous, current) {
          return previous.selectedProductChildCategoryIndex !=
              current.selectedProductChildCategoryIndex;
        },
        listener: (context, state) {
          _scrollToPosition(state.selectedProductChildCategoryIndex);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 2),
          child: SizedBox(
            height: 30,
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollControllerChildCategory,
              scrollDirection: Axis.horizontal,
              itemCount: productChildCategories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ));
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProductChildCategoryIndex = index;
          selectedProductChildCategory = productChildCategories[index];
        });
        _refreshBodyOnChildCategorySelected();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: productChildCategories[index].level == 1
                  ? null
                  : BoxDecoration(
                      border: Border.all(color: kTextLightColor),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                    ),
              // color: productChildCategories[index].level == 1
              //     ? Colors.transparent
              //     : Colors.yellow[50],
              child: Text(
                '${productChildCategories[index].title!} (${productChildCategories[index].total_elements.toString()})',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: productChildCategories[index].level == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selectedProductChildCategoryIndex == index
                      ? Colors.white70
                      : kTextLightColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 45,
              color: selectedProductChildCategoryIndex == index
                  ? Colors.white70
                  : Colors.transparent,
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
