import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class DietPlanListCubit extends Cubit<ListState<DietPlan>> {
  DietPlanListCubit({
    required this.repository,
    required this.authCubit,
    this.trainerId,
    this.subscriberId,
  }) : super(ListInitial()) {
    _getList();
  }

  final DietPlanRepository repository;
  final AuthCubit authCubit;
  final int? trainerId;
  final int? subscriberId;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var trainerId = account is Trainer ? account.id : this.trainerId;
      var list = await repository.getList(
        DietPlanListOption(
          (b) => b
            ..trainerId = trainerId
            ..subscriberId = subscriberId,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in'));
    }
  }

  Future<void> create({
    required String name,
    String? fileName,
  }) async {
    var account = authCubit.state.data;
    if (account != null) {
      var success = await repository.create(
        DietPlanCreateOption(
          (b) => b
            ..userId = account.id
            ..name = name
            ..image = fileName,
        ),
      );
      if (success) {
        await _getList();
      }
    }
  }

  Future<void> delete(int id) async {
    var account = authCubit.state.data;
    if (account != null) {
      var success = await repository.delete(
        DietPlanDeleteOption(
          (b) => b
            ..trainerId = account.id
            ..dietPlanId = id,
        ),
      );
      if (success) {
        await _getList();
      }
    }
  }
}
