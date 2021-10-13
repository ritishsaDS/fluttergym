import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../payment/widgets/earnings_list_tile.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../subscriber/cubit/subscription_list_cubit.dart';
import '../widgets/trainer_landing_bottom_bar.dart';

class TrainerEarningsView extends StatelessWidget {
  const TrainerEarningsView({Key? key}) : super(key: key);

  static const routeName = '/trainer/earnings';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => SubscriptionListCubit(
            repository: context.read<SubscriptionRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const TrainerEarningsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, DetailState<Account>>(
      builder: (context, state) {
        if (state.data is! Trainer) {
          return const Scaffold(
            body: Center(
              child: Text('User is not a trainer.'),
            ),
          );
        }

        var data = state.data! as Trainer;
        return Scaffold(
          appBar: const CustomAppBar(
            label: 'Dashboard',
            assetImage: Assets.dashboardEggIcon,
          ),
          body: Column(
            children: [
              const SizedBox(height: 30),
              _buildHeader(context, trainer: data),
              const SizedBox(height: 30),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Payment History'),
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<SubscriptionListCubit, ListState<Subscription>>(
                  builder: (context, state) {
                    if (state is ListWaiting || state is ListInitial) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (state is ListFailure<Subscription>) {
                      return Center(
                        child: Text(state.message ?? 'An error occurred.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        return TrainerEarningsListTile(state.data[index]);
                      },
                    );
                  },
                ),
              )
            ],
          ),
          bottomNavigationBar: const TrainerLandingBottomBar(
            index: 2,
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, {required Trainer trainer}) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Stack(
        children: [
          Image.asset(Assets.profileBackground),
          Positioned(
            top: 0,
            bottom: 0,
            left: 30,
            child: GestureDetector(
              onTap: () {
                if (trainer.profileImage != null) {
                  showDialog<void>(
                    context: context,
                    barrierColor: Colors.black38,
                    builder: (context) {
                      return PhotoView(
                        imageProvider: NetworkImage(
                          trainer.profileImage!,
                        ),
                      );
                    },
                  );
                }
              },
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white.withOpacity(0.5),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: trainer.profileImage != null
                      ? NetworkImage(trainer.profileImage!)
                      : null,
                ),
              ),
            ),
          ),
          Positioned(
            top: 25,
            bottom: 0,
            left: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${trainer.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: media.horizontalBlockSize * 4.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Total Earnings:',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w700,
                        fontSize: media.horizontalBlockSize * 3,
                      ),
                    ),
                    const SizedBox(width: 20),
                    BlocBuilder<SubscriptionListCubit, ListState<Subscription>>(
                      builder: (context, state) {
                        return Text(
                          '₹ ${_sumSubscriptions(state.data)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: media.verticalBlockSize * 3,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int _sumSubscriptions(BuiltList<Subscription> subscriptions) {
    var sum = 0;
    for (var item in subscriptions) {
      sum += item.amount;
    }
    return sum;
  }
}
