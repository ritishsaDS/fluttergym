import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

class DietPlanDetailCubit extends Cubit<DetailState<DietPlan>> {
  DietPlanDetailCubit({
    required this.repository,
    required this.dietPlanId,
    required this.trainerId,
  }) : super(DetailInitial()) {
    _getDetail();
  }

  final DietPlanRepository repository;
  final int dietPlanId;
  final int trainerId;

  Future<void> _getDetail() async {
    emit(DetailWaiting(state: state));
    var data = await repository.getDetail(
      DietPlanDetailOption(
        (b) => b
          ..dietPlanId = dietPlanId
          ..trainerId = trainerId,
      ),
    );
    if (data != null) {
      emit(DetailSuccess(data: data));
    } else {
      emit(DetailFailure(message: 'Diet Plan not found.'));
    }
  }
}
