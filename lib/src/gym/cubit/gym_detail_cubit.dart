import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class GymDetailCubit extends Cubit<DetailState<Gym>> {
  GymDetailCubit({
    required this.repository,
    required this.authCubit,
    required this.gymId,
  }) : super(DetailInitial()) {
    _getDetail();
  }

  final GymRepository repository;
  final AuthCubit authCubit;
  final int gymId;

  Future<void> _getDetail() async {
    emit(DetailWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var data = await repository.getDetail(
        GymDetailOption(
          (b) => b
            ..gymId = gymId
            ..userId = account.id,
        ),
      );
      if (data != null) {
        emit(DetailSuccess(data: data));
      } else {
        emit(DetailFailure(message: 'Gym not found.'));
      }
    } else {
      emit(DetailFailure(message: 'User is not logged in'));
    }
  }
}
