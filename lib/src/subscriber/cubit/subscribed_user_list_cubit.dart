import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class SubscribedUserListCubit extends Cubit<ListState<SubscribedUser>> {
  SubscribedUserListCubit({
    required this.repository,
    required this.authCubit,
  }) : super(ListInitial()) {
    _getList();
  }

  final SubscribedUserRepository repository;
  final AuthCubit authCubit;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        SubscribedUserListOption(
          (b) => b..trainerId = account.id,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not logged in.'));
    }
  }
}
