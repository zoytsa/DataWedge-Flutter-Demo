import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/presentation/cubit/selected_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
