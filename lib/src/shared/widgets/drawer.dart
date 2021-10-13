import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../splash/views/splash_view.dart';
import '../common.dart';
import 'drawer_subscriber.dart';
import 'drawer_trainer.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, DetailState<Account>>(
      builder: (context, state) {
        if (state.data is Trainer) {
          return const TrainerDrawer();
        } else {
          return const SubscriberDrawer();
        }
      },
    );
  }
}

class LogoutDrawerTile extends StatelessWidget {
  const LogoutDrawerTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.white),
      ),
      leading: Image.asset(
        Assets.logoutIcon,
        height: 30,
        width: 30,
      ),
      onTap: () {
        context.read<AuthCubit>().logOut();
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context).push(SplashView.route());
      },
    );
  }
}
