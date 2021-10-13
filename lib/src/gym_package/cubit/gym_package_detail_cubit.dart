import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

class GymPackageDetailCubit extends Cubit<DetailState<GymPackage>> {
  GymPackageDetailCubit({
    required this.repository,
    required this.gymPackageId,
    required this.gymId,
  }) : super(DetailInitial()) {
    _getDetail();
  }

  final GymPackageRepository repository;
  final int gymPackageId;
  final int gymId;

  Future<void> _getDetail() async {
    emit(DetailWaiting(state: state));
    var data = await repository.getDetail(
      GymPackageDetailOption(
        (b) => b
          ..gymPackageId = gymPackageId
          ..gymId = gymId,
      ),
    );
    if (data != null) {
      emit(DetailSuccess(data: data));
    } else {
      emit(DetailFailure(message: 'Gym Package not found.'));
    }
  }
}
