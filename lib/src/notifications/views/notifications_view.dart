import 'package:flutter/material.dart';

import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  static const routeName = '/notifications';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return const NotificationsView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        label: 'Notifications',
        assetImage: Assets.gymEggIcon,
      ),
      body: Center(
        child: Text('Coming soon...'),
      ),
    );
  }
}
