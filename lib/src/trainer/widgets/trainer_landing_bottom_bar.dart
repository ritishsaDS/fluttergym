import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../product/views/product_list_view.dart';
import '../../shared/common.dart';
import '../../shared/widgets/bottom_bar_item.dart';
import '../../subscriber/views/subscriber_list_view.dart';
import '../views/trainer_earnings_view.dart';
import '../views/trainer_home_view.dart';

class TrainerLandingBottomBar extends StatelessWidget {
  const TrainerLandingBottomBar({
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
              Navigator.of(context).pushReplacement(TrainerHomeView.route());
            },
          ),
          if (showcaseKey != null)
            Showcase(
              key: showcaseKey,
              description: 'See your earnings',
              overlayPadding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: _buildEarnings(context),
            )
          else
            _buildEarnings(context),
          BottomBarItem(
            label: 'Subscribers',
            icon: Icons.computer_outlined,
            active: index == 1,
            onTap: () {
              if (index == 1) {
                return;
              }
              Navigator.of(context).pushReplacement(SubscriberListView.route());
            },
          ),
          BottomBarItem(
            label: 'Shop',
            icon: Icons.shopping_basket,
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

  Widget _buildEarnings(BuildContext context) {
    return BottomBarItem(
      label: 'Earnings',
      icon: Icons.people,
      active: index == 2,
      onTap: () {
        if (index == 2) {
          return;
        }
        Navigator.of(context).pushReplacement(TrainerEarningsView.route());
      },
    );
  }
}
