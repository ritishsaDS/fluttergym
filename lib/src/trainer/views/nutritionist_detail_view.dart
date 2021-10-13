import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../diet_plan/cubit/diet_plan_list_cubit.dart';
import '../../diet_plan/widgets/diet_plan_list_view.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/trainer_detail_cubit.dart';

class NutritionistDetailView extends StatelessWidget {
  const NutritionistDetailView({Key? key}) : super(key: key);

  static const routeName = '/nutritionist/detail';

  static Route<void> route({
    required int nutritionistId,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DietPlanListCubit(
                repository: context.read<DietPlanRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => TrainerDetailCubit(
                repository: context.read<TrainerRepository>(),
                trainerId: nutritionistId,
              ),
            ),
          ],
          child: const NutritionistDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Nutritionist',
        assetImage: Assets.dietPlanEggIcon,
      ),
      body: BlocBuilder<TrainerDetailCubit, DetailState<Trainer>>(
        builder: (context, state) {
          if (state is DetailWaiting || state is DetailInitial) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is DetailFailure<Trainer>) {
            return Center(
              child: Text(
                state.message ?? 'An error occurred.',
                textAlign: TextAlign.center,
              ),
            );
          }

          var data = state.data!;
          return _buildTrainerProfileCard(context, data: data);
        },
      ),
    );
  }

  Widget _buildTrainerProfileCard(
    BuildContext context, {
    required Trainer data,
  }) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              // ignore: deprecated_member_use
              overflow: Overflow.visible,
              children: [
                Container(
                  height: media.horizontalBlockSize * 35,
                  decoration: const BoxDecoration(
                    color: kPrimaryAppColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(175),
                      bottomRight: Radius.circular(175),
                    ),
                  ),
                ),
                Positioned(
                  top: media.horizontalBlockSize * 18,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: media.horizontalBlockSize * 25,
                    height: media.horizontalBlockSize * 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: data.profileImage != null
                          ? DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(data.profileImage!),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: media.horizontalBlockSize * 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    data.name,
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 4.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0;
                          i < (data.averageRating ?? 0).toInt();
                          i++)
                        Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                          size: media.horizontalBlockSize * 4.5,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: media.horizontalBlockSize * 1,
            ),
            _buildAboutCard(context, data: data),
            const DietPlanListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(
    BuildContext context, {
    required Trainer data,
  }) {
    var media = MediaQuery.of(context);
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: media.horizontalBlockSize * 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(thickness: 3),
                Text(
                  data.description ?? '',
                  style: TextStyle(fontSize: media.horizontalBlockSize * 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
