import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class ExerciseListCubit extends Cubit<ListState<Exercise>> {
  ExerciseListCubit({
    required this.repository,
    required this.authCubit,
    this.trainerId,
    this.subscriberId,
  }) : super(ListInitial()) {
    getList();
  }

  final ExerciseRepository repository;
  final AuthCubit authCubit;
  final int? trainerId;
  final int? subscriberId;

  Future<void> getList({String? keywords}) async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var trainerId = account is Trainer ? account.id : this.trainerId;
      var list = await repository.getList(
        ExerciseListOption(
          (b) => b
            ..userId = account.id
            ..keywords = keywords
            ..trainerId = trainerId
            ..subscriberId = subscriberId,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in.'));
    }
  }

  Future<void> create({
    required String url,
    required String name,
    required String details,
    required String restTime,
    String? fileName,
  }) async {
    var account = authCubit.state.data;
    if (account != null) {
      var success = await repository.create(
        ExerciseCreateOption(
          (b) => b
            ..trainerId = account.id
            ..name = name
            ..details = details
            ..restTime = restTime
            ..externalLink = url
            ..image = fileName,
        ),
      );
      if (success) {
        await getList();
      }
    }
  }

  Future<void> delete(int id) async {
    var account = authCubit.state.data;
    if (account != null) {
      var success = await repository.delete(
        ExerciseDeleteOption(
          (b) => b
            ..trainerId = account.id
            ..exerciseId = id,
        ),
      );
      if (success) {
        await getList();
      }
    }
  }
}
