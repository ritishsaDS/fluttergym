import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class ProductListCubit extends Cubit<ListState<Product>> {
  ProductListCubit({
    required this.repository,
    required this.authCubit,
  }) : super(ListInitial()) {
    _getList();
  }

  final ProductRepository repository;
  final AuthCubit authCubit;

  Future<void> _getList({String? keywords}) async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        ProductListOption(
          (b) => b
            ..userId = account.id
            ..keywords = keywords,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in.'));
    }
  }
}
