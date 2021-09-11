import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'selected_products_state.dart';

class SelectedProductsCubit extends Cubit<SelectedProductsState> {
  SelectedProductsCubit()
      : super(SelectedProductsState(selectedProducts: selectedProducts2));

  void updateSelectedProductsState(_selectedProducts2) =>
      emit(SelectedProductsState(
        selectedProducts: _selectedProducts2,
      ));

  addProductToSelected2(ProductInfo product) {
    ProductInfo? result = selectedProducts2
        .firstWhereOrNull((element) => element.id == product.id);
    //print('called addProductToSelected');

    if (result == null) {
      selectedProducts2.add(product);
      emit(SelectedProductsState(
        selectedProducts: selectedProducts2,
      ));
    }
    ;
  }

  removeProductFromSelected2(ProductInfo product) {
    selectedProducts2.remove(product);
    emit(SelectedProductsState(
      selectedProducts: selectedProducts2,
    ));
  }

  clearProductsSelected() {
    selectedProducts2.clear();
    emit(SelectedProductsState(
      selectedProducts: selectedProducts2,
    ));
  }
}
