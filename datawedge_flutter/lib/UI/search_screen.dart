import 'package:datawedgeflutter/UI/widgets/widget_appbar_search_screen.dart';
import 'package:datawedgeflutter/UI/widgets/widget_product_card.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/constants.dart';
import '../model/palette.dart';
import 'package:http/http.dart' as http;
import 'widgets/widget_product_category_and_child_category.dart';

class CatalogScreen extends StatefulWidget {
  CatalogScreen({Key? key, required this.onProductSelection}) : super(key: key);

  final VoidCallback onProductSelection;

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
  AnimationController?
      _animationController; // = AnimationController(vsync: vsync);
  bool isGridView = true;
  List<ProductInfo> _products = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  late int _totalPages;
  int _lastElementId = 0;
  int _maxElementId = 0;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  bool useGridView = false;

  @override
  void initState() {
    if (productCategories.length == 0) _getProductCategoriesList();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
    _scrollController.dispose(); // dispose the controller
    _refreshController.dispose(); // added by me
  }

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
            fontWeight: category == selectedProductCategory
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ));
    }
    //print('items${items.length}');
    return items;
  }

  Widget buildDropDownMenuProductCategory(BuildContext context) {
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

  void _changeGridState(BuildContext context) {
    isGridView = !isGridView;
    setState(() {
      isGridView
          ? _animationController!.forward()
          : _animationController!.reverse();
    });
    // BlocProvider.of<SelectedProductsCubit>(context)
    //     .changeGridView(isGridView)();
    // BlocProvider.of<SelectedProductsCubit>(context)
    //     .changeGridView(isGridView)();
    //       setState(() {
    //     isPlaying = !isPlaying;
    //     isPlaying
    //         ? _animationController.forward()
    //         : _animationController.reverse();
    //   });
    // }
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
            // key: _keyAppbar,
            // appBarSearchTitle: addGoodsTitle2,
            onSelectedProductsAppBar: () => onSelectedProductsSearch()),
        body:
            // useGridView
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           addEnterSearchField2(context),

            //           Row(
            //               // padding: const EdgeInsets.symmetric(
            //               //     horizontal: kDefaultPaddin, vertical: 0),
            //               children: [
            //                 SizedBox(width: kDefaultPaddin),
            //                 SizedBox(
            //                   width: 250,
            //                   child: buildDropDown(context),
            //                   // child: DropdownButton(
            //                   //     elevation: 0,
            //                   //     isDense: true,
            //                   //     isExpanded: true,
            //                   //     //items: buildDropdownMenuItemsCategories(categories),
            //                   //     items: buildDropdownMenuItemsCategories2(),
            //                   //     style: Theme.of(context).textTheme.headline6!.copyWith(
            //                   //         fontWeight: FontWeight.w500,
            //                   //         color: kTextLightColor),
            //                   //     value: selectedCategory,
            //                   //     onChanged: (valueSelectedByUser) {
            //                   //       setState(() {
            //                   //         debugPrint('User selected $valueSelectedByUser');

            //                   //         selectedCategory = valueSelectedByUser as Category;
            //                   //         //saveSettingsHive(context);
            //                   //       });
            //                   //     })
            //                 ),
            //                 Container(
            //                     child: Expanded(
            //                         child: SizedBox(
            //                             // width: 165,
            //                             ))),
            //                 Container(
            //                   child: Center(
            //                     child: IconButton(
            //                       icon: Icon(
            //                         Icons.grid_view_outlined,
            //                         size: 17,
            //                       ),
            //                       onPressed: () => {},
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   child: Center(
            //                     child: IconButton(
            //                       icon: Icon(Icons.list),
            //                       onPressed: () => {},
            //                     ),
            //                   ),
            //                 ),
            //               ]),

            //           // Padding(
            //           //   padding: const EdgeInsets.symmetric(
            //           //       horizontal: kDefaultPaddin, vertical: 10),
            //           //   child: Text(
            //           //     "Кулинария",
            //           //     style: Theme.of(context)
            //           //         .textTheme
            //           //         .headline6!
            //           //         .copyWith(fontWeight: FontWeight.bold),
            //           //   ),
            //           // ),
            //           ProductChildCategoryWidget(
            //               onSelectedChildCategory: () =>
            //                   _refreshBodyOnSelectedProductCategory()),
            //           // SingleChildScrollView(
            //           //   controller: _scrollController,
            //           //   child: ConstrainedBox(
            //           //     constraints: BoxConstraints(maxHeight: 380),
            //           //     child:

            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: kDefaultPaddin),
            //               child: GridView.builder(
            //                   itemCount: products.length,
            //                   gridDelegate:
            //                       SliverGridDelegateWithFixedCrossAxisCount(
            //                     crossAxisCount: 2,
            //                     mainAxisSpacing: kDefaultPaddin,
            //                     crossAxisSpacing: kDefaultPaddin,
            //                     childAspectRatio: 0.75,
            //                   ),
            //                   itemBuilder: (context, index) => ItemCard(
            //                         product: products[index],
            //                         // press: () => Navigator.push(
            //                         //     context,
            //                         //     MaterialPageRoute(
            //                         //       builder: (context) => DetailsScreen(
            //                         //         product: products[index],
            //                         //       ),
            //                         //     )),
            //                         // longPress: () => products[index].check = false,

            //                         doubleTap: () => {}, //Navigator.push(
            //                         //     context,
            //                         //     MaterialPageRoute(
            //                         //       builder: (context) => MyHomePage(
            //                         //         title: "we are back",
            //                         //       ),
            //                         //     )),
            //                         vcbOnTap: () => _updateSelectedProductsTitle(),
            //                         vcbOnlongPress: () =>
            //                             _updateSelectedProductsTitle(),
            //                       )),
            //             ),
            //           )

            //           //  ),
            //           //),
            //         ],
            //       )
            //     :
            CustomScrollView(slivers: [
          SliverAppBar(
              backgroundColor: Colors.indigo,
              automaticallyImplyLeading: false,
              toolbarHeight: 48, //59 с кол. товаров,  //80 с поиском,
              // collapsedHeight: 56,
              primary: false,
              floating: false,
              // pinned: true,
              // brightness: Brightness.light,
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
                    child: buildDropDownMenuProductCategory(context),
                  ),
                  Container(
                      child: Expanded(
                          child: SizedBox(
                              // width: 165,
                              ))),
                  IconButton(
                    iconSize: 20,
                    splashColor: Colors.greenAccent,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.list_view,
                      progress: _animationController!,
                      color: Colors.green,
                    ),
                    onPressed: () => {
                      _changeGridState(context),
                    },
                  ),
                ]),
              ])),
          SliverAppBar(
              backgroundColor: Colors.indigo,
              automaticallyImplyLeading: false,
              toolbarHeight: 46,
              // collapsedHeight: 56,
              primary: false,
              floating: false,
              pinned: true,
              // brightness: Brightness.light,
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
                            color: Colors.grey, fontStyle: FontStyle.italic));
                  } else if (mode == LoadStatus.loading) {
                    body = Container();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Окончание показа...");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("Показать еще.", // "release to load more"
                        style: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic));
                  } else {
                    body = Text("Вывод завершен.", // "No more Data"
                        style: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic));
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
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     backgroundColor: Colors.green[200],
                  //     content: Text('Список товаров обновлен!'),
                  //   ),
                  // );
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
                  final productInfo = _products[index];
                  // return productInfoTile_unused(product, index, isDCT);
                  return ProductCardGestureDetectorForCatalogScreen(
                      refreshBodyOnSelectedProductCategory:
                          _refreshBodyOnSelectedProductCategory,
                      productInfo: productInfo,
                      isDCT: isDCT,
                      isGridView: isGridView,
                      index: index);
                },
                itemCount: _products.length,
                controller: _scrollController,
                //  physics: BouncingScrollPhysics(),
              ),
            ),
          ),
        ]),
        floatingActionButton: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: Colors.green.withOpacity(0.75),
              foregroundColor: Colors.white,
              onPressed: () {
                onSelectedProductsSearch();
                Navigator.pop(context);
              },
              child: Icon(Icons.add),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SpeedDial(
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
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
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
                          _scrollController.jumpTo(
                              _scrollController.position.minScrollExtent);
                        }
                      }),
                  // SpeedDialChild(
                  //   child: Icon(Icons.chat),
                  //   label: 'Message',
                  //   backgroundColor: Colors.amberAccent,
                  //   onTap: () {/* Do something */},
                  // ),
                ]),
          ),
        ]));
  }
}
