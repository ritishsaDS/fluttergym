import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class SubscribedUserDetailCubit extends Cubit<DetailState<SubscribedUser>> {
  SubscribedUserDetailCubit({
    required this.repository,
    required this.authCubit,
    required this.subscriberId,
  }) : super(DetailInitial()) {
    _getDetail();
  }

  final SubscribedUserRepository repository;
  final AuthCubit authCubit;
  final int subscriberId;

  Future<void> _getDetail() async {
    emit(DetailWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var data = await repository.getDetail(
        SubscribedUserDetailOption(
          (b) => b
            ..trainerId = account.id
            ..subscriberId = subscriberId,
        ),
      );
      if (data != null) {
        emit(DetailSuccess(data: data));
      } else {
        emit(DetailFailure(message: 'Subscriber not found.'));
      }
    } else {
      emit(DetailFailure(message: 'User is not logged in'));
    }
  }
}
