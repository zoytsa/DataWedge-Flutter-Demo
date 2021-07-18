import 'package:datawedgeflutter/model/Product.dart';
import 'package:collection/collection.dart';

addProductToSelected(Product product, List<Product> selectedProducts) {
  Product? result =
      selectedProducts.firstWhereOrNull((element) => element.id == product.id);
  print('called addProductToSelected');

  if (result == null) {
    selectedProducts.add(product);
  }
  ;
}

removeProductFromSelected(Product product, selectedProducts) {
  selectedProducts.remove(product);
  print('called removeProductFromSelected');
}
