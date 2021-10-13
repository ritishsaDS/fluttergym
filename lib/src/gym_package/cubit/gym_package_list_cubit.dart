import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class GymPackageListCubit extends Cubit<ListState<GymPackage>> {
  GymPackageListCubit({
    required this.repository,
    required this.authCubit,
    required this.gymId,
  }) : super(ListInitial()) {
    _getList();
  }

  final GymPackageRepository repository;
  final AuthCubit authCubit;
  final int gymId;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        GymPackageListOption(
          (b) => b
            ..gymId = gymId
            ..userId = account.id,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in'));
    }
  }
}
