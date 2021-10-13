import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/trainer_list_cubit.dart';
import '../widgets/trainer_list_tile.dart';
import 'nutritionist_detail_view.dart';

class NutritionistListView extends StatelessWidget {
  const NutritionistListView({Key? key}) : super(key: key);

  static const routeName = '/nutritionist/list';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => TrainerListCubit(
            repository: context.read<TrainerRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const NutritionistListView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Diet Plan',
        assetImage: Assets.dietPlanEggIcon,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(Assets.dietPlanBanner),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TrainerListCubit, ListState<Trainer>>(
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return TrainerListTile(
                      state.data[index],
                      onTap: () {
                        Navigator.of(context).push(
                          NutritionistDetailView.route(
                            nutritionistId: state.data[index].id,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
