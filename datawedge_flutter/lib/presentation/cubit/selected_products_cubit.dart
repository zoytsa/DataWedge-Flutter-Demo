import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:collection/collection.dart';

part 'selected_products_state.dart';

class SelectedProductsCubit extends Cubit<SelectedProductsState> {
  SelectedProductsCubit()
      : super(SelectedProductsState(
            selectedProducts2, selectedProductChildCategoryIndex, true));

  void updateSelectedProductsState(_selectedProducts2) =>
      emit(SelectedProductsState(_selectedProducts2,
          state.selectedProductChildCategoryIndex, state.isGridView));

  addProductToSelected2(ProductInfo product) {
    // print('we are on blok-1');
    ProductInfo? result = selectedProducts2
        .firstWhereOrNull((element) => element.id == product.id);

    if (result == null) {
      selectedProducts2.add(product);
      // print(
      //     'selectedProducts2.length on block-1: ${selectedProducts2.length} ');
      emit(SelectedProductsState(selectedProducts2,
          state.selectedProductChildCategoryIndex, state.isGridView));
    }
    ;
  }

  removeProductFromSelected2(ProductInfo product) {
    // print('we are on blok-2');
    selectedProducts2.remove(product);
    //state.selectedProducts.remove(product);
    // print(
    //     'selectedProducts2.length on block-2: ${state.selectedProducts.length} ');
    emit(SelectedProductsState(selectedProducts2,
        state.selectedProductChildCategoryIndex, state.isGridView));
  }

  clearProductsSelected() {
    selectedProducts2.clear();
    //state.selectedProducts.clear();
    emit(SelectedProductsState(selectedProducts2,
        state.selectedProductChildCategoryIndex, state.isGridView));
  }

  selectedProductChildCategoryChanged(_selectedProductChildCategoryIndex) {
    emit(SelectedProductsState(state.selectedProducts,
        _selectedProductChildCategoryIndex, state.isGridView));
  }

  changeGridView(bool _isGridView) {
    emit(SelectedProductsState(state.selectedProducts,
        state.selectedProductChildCategoryIndex, _isGridView));
  }
}
