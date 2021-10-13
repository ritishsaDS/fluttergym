import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class SubscriberListCubit extends Cubit<ListState<Subscriber>> {
  SubscriberListCubit({
    required this.repository,
    required this.authCubit,
  }) : super(ListInitial()) {
    _getList();
  }

  final SubscriberRepository repository;
  final AuthCubit authCubit;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      var list = await repository.getList(
        SubscriberListOption(
          (b) => b..trainerId = account.id,
        ),
      );
      emit(ListSuccess(data: list));
    } else {
      emit(ListFailure(message: 'User is not a trainer.'));
    }
  }
}
