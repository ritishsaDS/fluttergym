import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../carousel/widgets/home_carousel.dart';
import '../../gym/cubit/gym_list_cubit.dart';
import '../../gym/views/gym_list_view.dart';
import '../../gym/widgets/gym_home_list_tile.dart';
import '../../product/cubit/product_list_cubit.dart';
import '../../product/views/product_list_view.dart';
import '../../product/widgets/product_list_tile.dart';
import '../../shared/common.dart';
import '../../shared/widgets/drawer.dart';
import '../../shared/widgets/home_app_bar.dart';
import '../../shared/widgets/home_title.dart';
import '../../shared/widgets/see_more_button.dart';
import '../../trainer/cubit/trainer_list_cubit.dart';
import '../../trainer/views/trainer_detail_view.dart';
import '../../trainer/views/trainer_list_view.dart';
import '../../trainer/widgets/trainer_list_tile.dart';
import '../cubit/subscription_list_cubit.dart';
import '../widgets/subscriber_home_section_bar.dart';
import '../widgets/subscriber_landing_bottom_bar.dart';

class SubscriberHomeView extends StatefulWidget {
  const SubscriberHomeView({Key? key}) : super(key: key);

  static const routeName = '/subscriber';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GymListCubit(
                repository: context.read<GymRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => TrainerListCubit(
                repository: context.read<TrainerRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => ProductListCubit(
                repository: context.read<ProductRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => SubscriptionListCubit(
                repository: context.read<SubscriptionRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
          ],
          child: const SubscriberHomeView(),
        );
      },
    );
  }

  @override
  State<SubscriberHomeView> createState() => _SubscriberHomeViewState();
}

class _SubscriberHomeViewState extends State<SubscriberHomeView> {
  final _one = GlobalKey();
  final _two = GlobalKey();
  final _three = GlobalKey();

  BuildContext? showCaseContext;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      var value = preferences.getBool('subscriber_home_showcase') ?? false;
      if (!value) {
        WidgetsBinding.instance?.addPostFrameCallback(
          (_) {
            if (showCaseContext != null) {
              preferences.setBool('subscriber_home_showcase', true);
              ShowCaseWidget.of(showCaseContext!)?.startShowCase([
                _one,
                _two,
                _three,
              ]);
            }
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          showCaseContext = context;
          return Scaffold(
            appBar: HomeAppBar(
              showCaseKey: _two,
            ),
            drawer: const CustomDrawer(),
            bottomNavigationBar: SubscriberLandingBottomBar(
              showcaseKey: _three,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const HomeCarousel(),
                    const SizedBox(height: 20),
                    Showcase(
                      key: _one,
                      description: 'Find gyms and trainers near you.',
                      overlayPadding: const EdgeInsets.all(8),
                      child: const SubscriberHomeSectionBar(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).horizontalBlockSize * 2,
                    ),
                    const HomeTitle(
                      title: 'Recommended for You',
                    ),
                    _buildGymList(context),
                    const SizedBox(height: 16),
                    const HomeTitle(title: 'Top Trainers'),
                    _buildTrainerList(context),
                    const SizedBox(height: 16),
                    const HomeTitle(title: 'Top Buying'),
                    _buildProductList(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGymList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: BlocBuilder<GymListCubit, ListState<Gym>>(
          builder: (context, state) {
            return CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GymHomeListTile(state.data[index]);
                    },
                    childCount: state.data.length,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(left: 16),
                  sliver: SliverToBoxAdapter(
                    child: SeeMoreButton(
                      onPressed: () {
                        Navigator.of(context).push(GymListView.route());
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrainerList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BlocBuilder<TrainerListCubit, ListState<Trainer>>(
        builder: (context, state) {
          return CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TrainerListTile(
                      state.data[index],
                      onTap: () {
                        Navigator.of(context).push(
                          TrainerDetailView.route(
                            trainerId: state.data[index].id,
                          ),
                        );
                      },
                    );
                  },
                  childCount: state.data.length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 16),
                sliver: SliverToBoxAdapter(
                  child: SeeMoreButton(
                    onPressed: () {
                      Navigator.of(context).push(TrainerListView.route());
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BlocBuilder<ProductListCubit, ListState<Product>>(
        builder: (context, state) {
          return CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductListTile(state.data[index]);
                  },
                  childCount: state.data.length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 16),
                sliver: SliverToBoxAdapter(
                  child: SeeMoreButton(
                    onPressed: () {
                      Navigator.of(context).push(ProductListView.route());
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
