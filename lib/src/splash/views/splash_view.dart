import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/views/ask_subscriber_login_view.dart';
import '../../auth/views/ask_trainer_login_view.dart';
import '../../shared/common.dart';
import '../../subscriber/views/subscriber_home_view.dart';
import '../../trainer/views/trainer_home_view.dart';
import '../widgets/splash_screen_button.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  static const routeName = '/';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocListener<AuthCubit, DetailState<Account>>(
          listener: (context, state) {
            if (state.data is Subscriber) {
              Navigator.of(context).popUntil((route) => false);
              Navigator.of(context).push(SubscriberHomeView.route());
            }
            if (state.data is Trainer) {
              Navigator.of(context).popUntil((route) => false);
              Navigator.of(context).push(TrainerHomeView.route());
            }
          },
          child: const SplashView(),
        );
      },
    );
  }

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      var account = context.read<AuthCubit>().state.data;
      var route = ModalRoute.of(context)?.settings;
      if (account is Subscriber &&
          route?.name != SubscriberHomeView.routeName) {
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context).push(SubscriberHomeView.route());
      }
      if (account is Trainer && //
          route?.name != TrainerHomeView.routeName) {
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context).push(TrainerHomeView.route());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: const AssetImage(Assets.splashScreenBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(64),
                child: Image.asset(Assets.brandLogoTextIcon),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  _buildFindYourGymButton(context),
                  const SizedBox(height: 16),
                  _builJoinAsTrainerButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindYourGymButton(BuildContext context) {
    return SplashScreenButton(
      label: '   Find Your Gym  ',
      onPressed: () {
        Navigator.of(context).push(AskSubscriberLoginView.route());
      },
    );
  }

  Widget _builJoinAsTrainerButton(BuildContext context) {
    return SplashScreenButton(
      label: 'Join As A Trainer',
      onPressed: () {
        Navigator.of(context).push(AskTrainerLoginView.route());
      },
    );
  }
}
