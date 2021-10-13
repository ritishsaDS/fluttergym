import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class TrainerPackageListCubit extends Cubit<ListState<TrainerPackage>> {
  TrainerPackageListCubit({
    required this.repository,
    required this.authCubit,
    required this.trainerId,
  }) : super(ListInitial()) {
    _getList();
  }

  final TrainerPackageRepository repository;
  final AuthCubit authCubit;
  final int trainerId;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        TrainerPackageListOption(
          (b) => b
            ..userId = account.id
            ..trainerId = trainerId,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in.'));
    }
  }

  Future<void> create({
    required String name,
    required int price,
    required int sellingPrice,
    required int packageDuration,
    required String packageType,
    required String description,
  }) async {
    var account = authCubit.state.data;
    if (account != null) {
      var success = await repository.create(
        TrainerPackageCreateOption(
          (b) => b
            ..userId = account.id
            ..name = name
            ..price = price
            ..sellingPrice = sellingPrice
            ..packageDuration = packageDuration
            ..packageType = packageType
            ..description = description,
        ),
      );
      if (success) {
        await _getList();
      }
    }
  }
}
