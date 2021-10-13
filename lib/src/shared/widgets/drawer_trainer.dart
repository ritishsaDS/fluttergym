import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/views/edit_profile_view.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/views/cart_view.dart';
import '../../help/views/help_view.dart';
import '../../notifications/views/notifications_view.dart';
import '../../subscriber/views/my_trainer_view.dart';
import '../common.dart';
import 'drawer.dart';

class TrainerDrawer extends StatelessWidget {
  const TrainerDrawer({Key? key}) : super(key: key);

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
                  if (state is DetailFailure) {
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
                              'Hi, ${data.firstName} ${data.lastName}',
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
                        'My Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Image.asset(
                        Assets.trainerIcon,
                        height: 30,
                        width: 30,
                      ),
                      trailing: _buildNotificationCount(context, count: 0),
                      onTap: () {
                        var id = context.read<AuthCubit>().state.data?.id;
                        Navigator.of(context).push(
                          MyTrainerView.route(
                            trainerId: id,
                          ),
                        );
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
                        'Settings',
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
