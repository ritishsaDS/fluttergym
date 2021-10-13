import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class ProductDetailCubit extends Cubit<DetailState<Product>> {
  ProductDetailCubit({
    required this.repository,
    required this.productId,
    required this.authCubit,
  }) : super(DetailInitial()) {
    _getDetail();
  }

  final ProductRepository repository;
  final AuthCubit authCubit;
  final int productId;

  Future<void> _getDetail() async {
    emit(DetailWaiting(state: state));
    var account = authCubit.state.data;
    Product? data;
    if (account != null) {
      data = await repository.getDetail(
        ProductDetailOption(
          (b) => b
            ..productId = productId
            ..userId = account.id,
        ),
      );
    } else {
      emit(DetailFailure(message: 'User is not logged in.'));
    }

    if (data != null) {
      emit(DetailSuccess(data: data));
    } else {
      emit(DetailFailure(message: 'Product not found'));
    }
  }

  Future<void> purchase({
    required int price,
    required String transactionId,
    required int paymentStatus,
  }) async {
    var account = authCubit.state.data;

    if (account != null) {
      var product = state.data;
      if (product != null) {
        await repository.purchase(
          ProductPurchaseOption(
            (b) => b
              ..userId = account.id
              ..productId = product.id
              ..transactionId = transactionId
              ..paymentStatus = 1
              ..price = price
              ..paymentStatus = paymentStatus,
          ),
        );
      }
    }
  }
}
