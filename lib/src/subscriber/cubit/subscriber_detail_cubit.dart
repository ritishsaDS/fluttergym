import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

class SubscriberDetailCubit extends Cubit<DetailState<Subscriber>> {
  SubscriberDetailCubit({
    required this.repository,
    required this.subscriberId,
  }) : super(DetailInitial()) {
    _get();
  }

  final SubscriberRepository repository;
  final int subscriberId;

  Future<void> _get() async {
    emit(DetailWaiting(state: state));
    var data = await repository.getDetail(
      SubscriberDetailOption(
        (b) => b..subscriberId = subscriberId,
      ),
    );
    if (data != null) {
      emit(DetailSuccess(data: data));
    } else {
      emit(DetailFailure(message: 'Subscriber not found'));
    }
  }
}
