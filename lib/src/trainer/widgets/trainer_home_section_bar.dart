import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../diet_plan/views/diet_plan_edit_view.dart';
import '../../exercise/views/exercise_edit_view.dart';
import '../../shared/common.dart';
import '../../shared/widgets/section_bar_item.dart';
import '../../trainer_package/views/trainer_package_edit_view.dart';
import '../views/trainer_earnings_view.dart';

class TrainerHomeSectionBar extends StatelessWidget {
  const TrainerHomeSectionBar({
    this.showcaseKey1,
    this.showcaseKey2,
    Key? key,
  }) : super(key: key);

  final GlobalKey? showcaseKey1;

  final GlobalKey? showcaseKey2;

  Widget _buildRow1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Showcase(
          key: showcaseKey1,
          description: 'Create your diet plans here.',
          overlayPadding: const EdgeInsets.all(8),
          child: HomeSectionBarItem(
            assetImage: Assets.dietPlanBanner,
            onTap: () {
              Navigator.of(context).push(DietPlanEditView.route());
            },
          ),
        ),
        HomeSectionBarItem(
          assetImage: Assets.earningsBanner,
          onTap: () {
            Navigator.push(context, TrainerEarningsView.route());
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
          assetImage: Assets.exerciseBanner,
          onTap: () {
            Navigator.of(context).push(ExerciseEditView.route());
          },
        ),
        Showcase(
          key: showcaseKey2,
          description: 'Create your packages here',
          overlayPadding: const EdgeInsets.all(8),
          child: HomeSectionBarItem(
            assetImage: Assets.trainerPackageBanner,
            onTap: () {
              Navigator.push(context, TrainerPackageEditView.route());
            },
          ),
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
