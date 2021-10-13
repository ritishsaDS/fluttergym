import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../cubit/subscription_list_cubit.dart';
import 'subscription_list_tile.dart';

class SubscriptionListView extends StatelessWidget {
  const SubscriptionListView({
    this.showActivePlansOnly = true,
    Key? key,
  }) : super(key: key);

  final bool showActivePlansOnly;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionListCubit, ListState<Subscription>>(
      builder: (context, state) {
        // var list = state.data
        //     .where((e) =>
        //         !showActivePlansOnly ||
        //         showActivePlansOnly && e.finalDate.isAfter(DateTime.now()))
        //     .toList();

        if (state.data.isEmpty) {
          return const Center(
            child: Text('Subscription list not found.'),
          );
        }

        return ListView.builder(
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            var data = state.data[index];

            if (data is GymPackageSubscription) {
              return GymPackageSubscriptionListTile(data);
            }
            if (data is DietPlanSubscription) {
              return DietPlanSubscriptionListTile(data);
            }
            if (data is TrainerPackageSubscription) {
              return TrainerPackageSubscriptionListTile(data);
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
