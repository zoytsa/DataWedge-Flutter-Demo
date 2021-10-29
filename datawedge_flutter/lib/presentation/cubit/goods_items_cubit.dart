import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';

part 'goods_items_state.dart';

class GoodsItemsCubit extends Cubit<GoodsItemsState> {
  GoodsItemsCubit() : super(GoodsItemsState(goodsItems, 0));

  updateSum() {
    num _sum = 0;
    for (int i = 0; i < goodsItems.length; i++) {
      _sum += goodsItems[i].quantity * goodsItems[i].priceSellNum;
    }
    emit(GoodsItemsState(goodsItems, _sum.floor()));
    print('Итого сумма: ${_sum}');
  }
}
