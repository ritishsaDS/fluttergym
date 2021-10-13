import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class TrainerReviewListCubit extends Cubit<ListState<TrainerReview>> {
  TrainerReviewListCubit({
    required this.repository,
    required this.authCubit,
    required this.trainerId,
  }) : super(ListInitial()) {
    _getList();
  }

  final TrainerReviewRepository repository;
  final AuthCubit authCubit;
  final int trainerId;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        TrainerReviewListOption(
          (b) => b
            ..userId = account.id
            ..trainerId = trainerId,
        ),
      );
      emit(ListSuccess(data: list));
    }
  }
}
