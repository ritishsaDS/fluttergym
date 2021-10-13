import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/subscription_list_cubit.dart';
import '../widgets/subscriber_landing_bottom_bar.dart';
import '../widgets/subscription_list_view.dart';

class SubscriberDashboardView extends StatelessWidget {
  const SubscriberDashboardView({Key? key}) : super(key: key);

  static const routeName = '/subscriber/dashboard';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => SubscriptionListCubit(
            repository: context.read<SubscriptionRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const SubscriberDashboardView(),
        );
      },
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return BlocBuilder<AuthCubit, DetailState<Account>>(
      builder: (context, state) {
        var data = state.data;
        if (data == null || data is! Subscriber) {
          return const Center(
            child: Text('User not logged in'),
          );
        }

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
                    if (data.profileImage != null) {
                      showDialog<void>(
                        context: context,
                        barrierColor: Colors.black38,
                        builder: (context) {
                          return PhotoView(
                            imageProvider: NetworkImage(
                              data.profileImage!,
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
                      backgroundImage: data.profileImage != null
                          ? NetworkImage(data.profileImage!)
                          : null,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                bottom: 0,
                left: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${data.firstName} ${data.lastName ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: media.horizontalBlockSize * 4.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (data.birthDate != null)
                      Text(
                        'Age: ${DateTime.now().year - data.birthDate!.year}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: media.horizontalBlockSize * 3.5,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Text(
                      'Weight: ${data.weight ?? 0} kg',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Height: ${data.height ?? 0} cm',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Dashboard',
        assetImage: Assets.dashboardEggIcon,
      ),
      bottomNavigationBar: const SubscriberLandingBottomBar(index: 1),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildProfileSection(context),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TabBar(
                indicatorColor: kPrimaryAppColor,
                labelColor: Colors.white,
                unselectedLabelColor: kPrimaryAppColor,
                labelPadding: EdgeInsets.zero,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kPrimaryAppColor,
                ),
                tabs: const [
                  Tab(text: 'Active Plans'),
                  Tab(text: 'Expired Plans'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SubscriptionListView(),
                  SubscriptionListView(
                    showActivePlansOnly: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
