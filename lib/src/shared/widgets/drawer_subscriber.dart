import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/views/edit_profile_view.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/views/cart_view.dart';
import '../../gym/views/gym_list_view.dart';
import '../../help/views/help_view.dart';
import '../../notifications/views/notifications_view.dart';
import '../../subscriber/views/my_trainer_view.dart';
import '../../subscriber/views/subscriber_dashboard_view.dart';
import '../../trainer/views/nutritionist_list_view.dart';
import '../common.dart';
import 'drawer.dart';

class SubscriberDrawer extends StatelessWidget {
  const SubscriberDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthCubit, DetailState<Account>>(
                builder: (context, state) {
                  if (state.data == null) {
                    return const SizedBox.shrink();
                  }

                  var data = state.data!;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: media.horizontalBlockSize * 8,
                              backgroundImage: data.profileImage != null
                                  ? NetworkImage(data.profileImage!)
                                  : null,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Hi, ${data.firstName} ${data.lastName ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: kTextSizeMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text(
                        'Notification',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.notificationIcon,
                        height: 30,
                        width: 30,
                      ),
                      trailing: _buildNotificationCount(context, count: 0),
                      onTap: () {
                        Navigator.of(context).push(NotificationsView.route());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'DashBoard',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.dashboardIcon,
                        height: 30,
                        width: 30,
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(SubscriberDashboardView.route());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Gym',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.myGymIcon,
                        height: 30,
                        width: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(GymListView.route());
                      },
                    ),
                    // ListTile(
                    //   title: const Text(
                    //     'Music',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   leading: Image.asset(
                    //     Assets.musicIcon,
                    //     height: 30,
                    //     width: 30,
                    //   ),
                    //   onTap: () {},
                    // ),
                    ListTile(
                      title: const Text(
                        'Trainer Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.trainerIcon,
                        height: 30,
                        width: 30,
                      ),
                      trailing: _buildNotificationCount(context, count: 0),
                      onTap: () {
                        Navigator.of(context).push(MyTrainerView.route());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Diet Plan',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.myDietPlanIcon,
                        height: 30,
                        width: 30,
                      ),
                      trailing: _buildNotificationCount(context, count: 0),
                      onTap: () {
                        Navigator.of(context)
                            .push(NutritionistListView.route());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.cartEggIcon,
                        height: 30,
                        width: 30,
                      ),
                      trailing: BlocBuilder<CartCubit, ListState<CartItem>>(
                        builder: (context, state) {
                          return _buildNotificationCount(
                            context,
                            count: state.data.length,
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(CartView.route());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Help & Support',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.helpIcon,
                        height: 30,
                        width: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(HelpView.route());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Profile Settings',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.subscriberEggIcon,
                        height: 30,
                        width: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(EditProfileView.route());
                      },
                    ),
                    const LogoutDrawerTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCount(BuildContext context, {required int count}) {
    return Container(
      height: 50,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
