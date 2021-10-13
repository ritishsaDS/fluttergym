import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../carousel/widgets/home_carousel.dart';
import '../../gym/cubit/gym_list_cubit.dart';
import '../../product/cubit/product_list_cubit.dart';
import '../../product/views/product_list_view.dart';
import '../../product/widgets/product_list_tile.dart';
import '../../shared/common.dart';
import '../../shared/widgets/drawer.dart';
import '../../shared/widgets/home_app_bar.dart';
import '../../shared/widgets/home_title.dart';
import '../../shared/widgets/see_more_button.dart';
import '../../subscriber/cubit/subscribed_user_list_cubit.dart';
import '../../subscriber/views/subscriber_detail_view.dart';
import '../../subscriber/views/subscriber_list_view.dart';
import '../../subscriber/widgets/subscriber_home_list_tile.dart';
import '../widgets/trainer_home_section_bar.dart';
import '../widgets/trainer_landing_bottom_bar.dart';

class TrainerHomeView extends StatefulWidget {
  const TrainerHomeView({Key? key}) : super(key: key);

  static const routeName = '/trainer';

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
              create: (context) => SubscribedUserListCubit(
                repository: context.read<SubscribedUserRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
            BlocProvider(
              create: (context) => ProductListCubit(
                repository: context.read<ProductRepository>(),
                authCubit: context.read<AuthCubit>(),
              ),
            ),
          ],
          child: const TrainerHomeView(),
        );
      },
    );
  }

  @override
  State<TrainerHomeView> createState() => _TrainerHomeViewState();
}

class _TrainerHomeViewState extends State<TrainerHomeView> {
  final _one = GlobalKey();
  final _two = GlobalKey();
  final _three = GlobalKey();
  final _four = GlobalKey();
  BuildContext? showCaseContext;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      var value = preferences.getBool('trainer_home_showcase') ?? false;
      if (!value) {
        WidgetsBinding.instance?.addPostFrameCallback(
          (_) {
            if (showCaseContext != null) {
              preferences.setBool('trainer_home_showcase', true);
              ShowCaseWidget.of(showCaseContext!)?.startShowCase([
                _one,
                _two,
                _three,
                _four,
              ]);
            }
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          showCaseContext = context;
          return Scaffold(
            appBar: HomeAppBar(
              showCaseKey: _three,
            ),
            drawer: const CustomDrawer(),
            bottomNavigationBar: TrainerLandingBottomBar(
              showcaseKey: _four,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const HomeCarousel(),
                    const SizedBox(height: 20),
                    TrainerHomeSectionBar(
                      showcaseKey1: _two,
                      showcaseKey2: _one,
                    ),
                    SizedBox(
                      height: media.horizontalBlockSize * 2,
                    ),
                    const HomeTitle(title: 'Subscribers'),
                    _buildSubscriberList(context),
                    const SizedBox(height: 10),
                    const HomeTitle(title: 'Top Products'),
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

  Widget _buildSubscriberList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BlocBuilder<SubscribedUserListCubit, ListState<SubscribedUser>>(
        builder: (context, state) {
          return CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return SubscriberHomeListTile(
                      state.data[index],
                      onTap: () {
                        Navigator.of(context).push(
                          SubscriberDetailView.route(
                            subscriberId: state.data[index].id,
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
                      Navigator.of(context).push(SubscriberListView.route());
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
