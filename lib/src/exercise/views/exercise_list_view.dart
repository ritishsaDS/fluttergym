import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../shared/widgets/search_text_field.dart';
import '../cubit/exercise_list_cubit.dart';
import '../widgets/exercise_list_tile.dart';

class ExerciseListView extends StatelessWidget {
  const ExerciseListView({Key? key}) : super(key: key);

  static const routeName = 'exercise/list';

  static Route<void> route({
    int? trainerId,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => ExerciseListCubit(
            repository: context.read<ExerciseRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const ExerciseListView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Exercise Video',
        assetImage: Assets.videoEggIcon,
      ),
      body: Column(
        children: [
          SearchTextField(
            onChanged: (value) {
              context.read<ExerciseListCubit>().getList(keywords: value);
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child: BlocBuilder<ExerciseListCubit, ListState<Exercise>>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return ExerciseListTile(state.data[index]);
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
