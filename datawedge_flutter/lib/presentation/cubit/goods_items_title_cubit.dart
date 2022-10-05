import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';

part 'goods_items_title_state.dart';

class GoodsItemsTitleCubit extends Cubit<GoodsItemsTitleState> {
  GoodsItemsTitleCubit() : super(GoodsItemsTitleState(kGoodsItems, 0));

  updateSum() {
    num _sum = 0;
    for (int i = 0; i < kGoodsItems.length; i++) {
      _sum += kGoodsItems[i].quantity * kGoodsItems[i].priceSellNum;
    }
    emit(GoodsItemsTitleState(kGoodsItems, _sum.floor()));
    print('Итого сумма: ${_sum}');
  }
}
