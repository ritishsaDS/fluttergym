import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

class TrainerPackageDetailCubit extends Cubit<DetailState<TrainerPackage>> {
  TrainerPackageDetailCubit({
    required this.repository,
    required this.trainerPackageId,
    required this.trainerId,
  }) : super(DetailInitial()) {
    _getDetail();
  }

  final TrainerPackageRepository repository;
  final int trainerPackageId;
  final int trainerId;

  Future<void> _getDetail() async {
    emit(DetailWaiting(state: state));
    var data = await repository.getDetail(
      TrainerPackageDetailOption(
        (b) => b
          ..trainerPackageId = trainerPackageId
          ..trainerId = trainerId,
      ),
    );
    if (data != null) {
      emit(DetailSuccess(data: data));
    } else {
      emit(DetailFailure(message: 'Trainer Package not found.'));
    }
  }
}
