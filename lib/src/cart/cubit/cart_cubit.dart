import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

class CartCubit extends Cubit<ListState<CartItem>> {
  CartCubit() : super(ListInitial());

  Future<void> addProduct(Product product) async {
    var list = state.data.toList();
    var index = list.indexWhere((e) => e.id == product.id);
    if (index >= 0) {
      list[index] = list[index].rebuild((p0) => p0.count = p0.count! + 1);
    } else {
      list.add(
        CartItem(
          (b) => b
            ..id = product.id
            ..count = 1
            ..product.replace(product),
        ),
      );
    }

    emit(ListSuccess(data: list));
  }

  Future<void> removeProduct(Product product) async {
    var list = state.data.toList();
    var index = list.indexWhere((e) => e.id == product.id);
    if (index >= 0) {
      list[index] = list[index].rebuild((p0) => p0.count = p0.count! - 1);
      if (list[index].count <= 0) {
        list.removeAt(index);
      }
    }

    emit(ListSuccess(data: list));
  }

  Future<void> buy() async {}
}
