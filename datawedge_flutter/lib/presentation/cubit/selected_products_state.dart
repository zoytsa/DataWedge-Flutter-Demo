part of 'selected_products_cubit.dart';

class SelectedProductsState {
  List<ProductInfo> selectedProducts;
  int selectedProductChildCategoryIndex;
  bool isGridView;

  SelectedProductsState(this.selectedProducts,
      this.selectedProductChildCategoryIndex, this.isGridView);
}
