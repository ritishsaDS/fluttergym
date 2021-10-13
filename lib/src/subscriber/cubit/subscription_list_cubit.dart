import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';

class SubscriptionListCubit extends Cubit<ListState<Subscription>> {
  SubscriptionListCubit({
    required this.repository,
    required this.authCubit,
  }) : super(ListInitial()) {
    _getList();
  }

  final SubscriptionRepository repository;
  final AuthCubit authCubit;

  Future<void> _getList() async {
    emit(ListWaiting(state: state));
    var account = authCubit.state.data;
    if (account != null) {
      if (account is Subscriber) {
        var list = await repository.getList(
          SubscriptionListOption((b) => b..subscriberId = account.id),
        );
        emit(ListSuccess(data: list));
      } else if (account is Trainer) {
        var list = await repository.getList(
          SubscriptionListOption((b) => b..trainerId = account.id),
        );
        emit(ListSuccess(data: list));
      }
    } else {
      emit(
        ListFailure(message: 'User is not logged in.'),
      );
    }
  }
}
