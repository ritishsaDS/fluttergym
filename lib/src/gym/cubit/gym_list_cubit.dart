import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class GymListCubit extends Cubit<ListState<Gym>> {
  GymListCubit({
    required this.repository,
    required this.authCubit,
  }) : super(ListInitial()) {
    getList();
  }

  final GymRepository repository;
  final AuthCubit authCubit;

  Future<void> getList({
    Set<String> specialities = const {},
    String? keywords,
  }) async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        GymListOption(
          (b) => b
            ..userId = account.id
            ..specialities.addAll(specialities)
            ..keywords = keywords,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in.'));
    }
  }
}
