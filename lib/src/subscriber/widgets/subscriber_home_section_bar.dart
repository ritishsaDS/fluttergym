import 'package:flutter/material.dart';

import '../../exercise/views/exercise_list_view.dart';
import '../../gym/views/gym_list_view.dart';
import '../../shared/common.dart';
import '../../shared/widgets/section_bar_item.dart';
import '../../trainer/views/nutritionist_list_view.dart';
import '../../trainer/views/trainer_list_view.dart';

class SubscriberHomeSectionBar extends StatelessWidget {
  const SubscriberHomeSectionBar({Key? key}) : super(key: key);

  Widget _buildRow1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HomeSectionBarItem(
          assetImage: Assets.homeFitnessCentersButton,
          onTap: () {
            Navigator.of(context).push(GymListView.route());
          },
        ),
        HomeSectionBarItem(
          assetImage: Assets.dietPlanBanner,
          onTap: () {
            Navigator.of(context).push(NutritionistListView.route());
          },
        ),
      ],
    );
  }

  Widget _buildRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HomeSectionBarItem(
          assetImage: Assets.homePersonalTrainersButton,
          onTap: () {
            Navigator.of(context).push(TrainerListView.route());
          },
        ),
        HomeSectionBarItem(
          assetImage: Assets.homeExerciseVideosButton,
          onTap: () {
            Navigator.of(context).push(ExerciseListView.route());
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow1(context),
        const SizedBox(height: 20),
        _buildRow2(context),
      ],
    );
  }
}
