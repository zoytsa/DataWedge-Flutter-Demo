import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'selected_products_state.dart';

class SelectedProductsCubit extends Cubit<SelectedProductsState> {
  SelectedProductsCubit()
      : super(SelectedProductsState(
            selectedProducts2, selectedProductChildCategoryIndex));

  void updateSelectedProductsState(_selectedProducts2) =>
      emit(SelectedProductsState(
          _selectedProducts2, state.selectedProductChildCategoryIndex));

  addProductToSelected2(ProductInfo product) {
    ProductInfo? result = selectedProducts2
        .firstWhereOrNull((element) => element.id == product.id);

    if (result == null) {
      selectedProducts2.add(product);
      emit(SelectedProductsState(
          selectedProducts2, state.selectedProductChildCategoryIndex));
    }
    ;
  }

  removeProductFromSelected2(ProductInfo product) {
    selectedProducts2.remove(product);
    emit(SelectedProductsState(
        selectedProducts2, state.selectedProductChildCategoryIndex));
  }

  clearProductsSelected() {
    selectedProducts2.clear();
    emit(SelectedProductsState(
        selectedProducts2, state.selectedProductChildCategoryIndex));
  }

  selectedProductChildCategoryChanged(_selectedProductChildCategoryIndex) {
    emit(SelectedProductsState(
        state.selectedProducts, _selectedProductChildCategoryIndex));
  }
}
