import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../cubit/diet_plan_list_cubit.dart';
import 'diet_plan_list_tile.dart';

class DietPlanListView extends StatelessWidget {
  const DietPlanListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DietPlanListCubit, ListState<DietPlan>>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < state.data.length; i++)
                DietPlanListTile(state.data[i])
            ],
          ),
        );
      },
    );
  }
}
