import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

class TrainerDetailCubit extends Cubit<DetailState<Trainer>> {
  TrainerDetailCubit({
    required this.repository,
    required this.trainerId,
  }) : super(DetailInitial()) {
    _get();
  }

  final TrainerRepository repository;
  final int trainerId;

  Future<void> _get() async {
    emit(DetailWaiting(state: state));
    try {
      var data = await repository.getDetail(
        TrainerDetailOption((b) => b..trainerId = trainerId),
      );
      if (data != null) {
        emit(DetailSuccess(data: data));
      }
    } on Exception catch (e) {
      emit(DetailFailure(message: e.toString()));
    }
  }
}
