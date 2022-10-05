import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/categories_data.dart';
import 'package:datawedgeflutter/model/constants.dart';

part 'goods_items_state.dart';

class GoodsItemsCubit extends Cubit<GoodsItemsState> {
  GoodsItemsCubit() : super(GoodsItemsState(0));

  updateState() {
    emit(GoodsItemsState(1));
    // print('Итого сумма: ${_sum}');
  }
}
