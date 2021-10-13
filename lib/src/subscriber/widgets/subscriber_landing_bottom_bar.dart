import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../product/views/product_list_view.dart';
import '../../shared/common.dart';
import '../../shared/widgets/bottom_bar_item.dart';
import '../views/my_trainer_view.dart';
import '../views/subscriber_dashboard_view.dart';
import '../views/subscriber_home_view.dart';

class SubscriberLandingBottomBar extends StatelessWidget {
  const SubscriberLandingBottomBar({
    this.showcaseKey,
    this.index = 0,
    Key? key,
  }) : super(key: key);

  final GlobalKey? showcaseKey;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kPrimaryAppColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomBarItem(
            label: 'Home',
            image: Assets.homeIcon,
            active: index == 0,
            onTap: () {
              if (index == 0) {
                return;
              }
              Navigator.of(context).pushReplacement(SubscriberHomeView.route());
            },
          ),
          if (showcaseKey != null)
            Showcase(
              key: showcaseKey,
              description: 'Find your current plans.',
              overlayPadding: const EdgeInsets.all(8),
              child: _buildDashboard(context),
            )
          else
            _buildDashboard(context),
          _buildMyTrainer(context),
          BottomBarItem(
            label: 'Shop',
            image: Assets.gymIcon,
            active: index == 3,
            onTap: () {
              if (index == 3) {
                return;
              }
              Navigator.of(context).pushReplacement(ProductListView.route());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyTrainer(BuildContext context) {
    return BottomBarItem(
      label: 'My Trainer',
      image: Assets.trainerIcon,
      active: index == 2,
      onTap: () {
        if (index == 2) {
          return;
        }
        Navigator.of(context).pushReplacement(MyTrainerView.route());
      },
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return BottomBarItem(
      label: 'Dashboard',
      image: Assets.dashboardIcon,
      active: index == 1,
      onTap: () {
        if (index == 1) {
          return;
        }
        Navigator.of(context).pushReplacement(SubscriberDashboardView.route());
      },
    );
  }
}
