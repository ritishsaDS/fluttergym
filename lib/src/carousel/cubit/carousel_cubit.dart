import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class CarouselCubit extends Cubit<ListState<CarouselInfo>> {
  CarouselCubit({
    required this.repository,
    required this.authCubit,
  }) : super(ListInitial()) {
    _getList();
  }

  final CarouselRepository repository;
  final AuthCubit authCubit;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        CarouselListOption((b) => b..userId = account.id),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in.'));
    }
  }
}
