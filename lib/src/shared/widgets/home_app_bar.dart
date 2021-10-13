import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../subscriber/views/subscriber_detail_view.dart';
import '../../trainer/views/trainer_detail_view.dart';
import '../common.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    this.showCaseKey,
    Key? key,
  }) : super(key: key);

  final GlobalKey? showCaseKey;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                Assets.drawerIcon,
                height: 20,
                width: 20,
              ),
            ),
          );
        },
      ),
      leadingWidth: MediaQuery.of(context).horizontalBlockSize * 12,
      actions: [
        GestureDetector(
          onTap: () {
            var account = context.read<AuthCubit>().state.data;
            if (account != null) {
              if (account is Subscriber) {
                Navigator.of(context).push(
                  SubscriberDetailView.route(subscriberId: account.id),
                );
              } else if (account is Trainer) {
                Navigator.of(context).push(
                  TrainerDetailView.route(trainerId: account.id),
                );
              }
            }
          },
          child: BlocBuilder<AuthCubit, DetailState<Account>>(
            builder: (context, state) {
              var account = state.data;
              if (account == null) {
                return const SizedBox.shrink();
              }

              if (showCaseKey == null) {
                return _buildBody(context, account: account);
              }

              return Showcase(
                key: showCaseKey,
                description: 'See your profile.',
                overlayPadding: const EdgeInsets.all(8),
                child: _buildBody(context, account: account),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, {required Account account}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hi, ${account.firstName} ${account.lastName ?? ''}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: kTextSizeMedium,
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            radius: MediaQuery.of(context).horizontalBlockSize * 5,
            backgroundImage: account.profileImage != null
                ? NetworkImage(account.profileImage!)
                : null,
            child: account.profileImage == null
                ? Text(
                    account.firstName.isNotEmpty
                        ? account.firstName[0].toUpperCase()
                        : 'U',
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
