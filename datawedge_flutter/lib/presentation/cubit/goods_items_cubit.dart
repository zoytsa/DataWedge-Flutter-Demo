import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';

part 'goods_items_state.dart';

class GoodsItemsCubit extends Cubit<GoodsItemsState> {
  GoodsItemsCubit() : super(GoodsItemsState(kGoodsItems, 0));

  updateSum() {
    num _sum = 0;
    for (int i = 0; i < kGoodsItems.length; i++) {
      _sum += kGoodsItems[i].quantity * kGoodsItems[i].priceSellNum;
    }
    emit(GoodsItemsState(kGoodsItems, _sum.floor()));
    print('Итого сумма: ${_sum}');
  }
}
