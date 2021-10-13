import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../trainer/views/my_subscriber_view.dart';
import '../../trainer/widgets/trainer_landing_bottom_bar.dart';
import '../cubit/subscribed_user_list_cubit.dart';
import '../widgets/subscriber_list_tile.dart';

class SubscriberListView extends StatelessWidget {
  const SubscriberListView({Key? key}) : super(key: key);

  static const routeName = '/subscriber/list';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => SubscribedUserListCubit(
            repository: context.read<SubscribedUserRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const SubscriberListView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Subscriber',
        assetImage: Assets.subscriberEggIcon,
      ),
      bottomNavigationBar: const TrainerLandingBottomBar(
        index: 1,
      ),
      body: BlocBuilder<SubscribedUserListCubit, ListState<SubscribedUser>>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return SubscriberListTile(
                state.data[index],
                onTap: () {
                  Navigator.of(context).push(
                    MySubscriberView.route(subscriberId: state.data[index].id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
