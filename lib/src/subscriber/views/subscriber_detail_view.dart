import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../diet_plan/cubit/diet_plan_list_cubit.dart';
import '../../diet_plan/widgets/diet_plan_list_tile.dart';
import '../../exercise/cubit/exercise_list_cubit.dart';
import '../../exercise/widgets/exercise_list_tile.dart';
import '../../gym/widgets/gym_map.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/subscriber_detail_cubit.dart';

class SubscriberDetailView extends StatelessWidget {
  const SubscriberDetailView({Key? key}) : super(key: key);

  static const routeName = '/subscriber/detail';

  static Route<void> route({
    required int subscriberId,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => SubscriberDetailCubit(
            repository: context.read<SubscriberRepository>(),
            subscriberId: subscriberId,
          ),
          child: const SubscriberDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Subscriber',
        assetImage: Assets.subscriberEggIcon,
      ),
      body: BlocBuilder<SubscriberDetailCubit, DetailState<Subscriber>>(
        builder: (context, state) {
          if (state is DetailWaiting || state is DetailInitial) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is DetailFailure<Subscriber>) {
            return Center(
              child: Text(state.message ?? 'An error occurred.'),
            );
          }

          var data = state.data!;
          return DefaultTabController(
            length: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          GestureDetector(
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
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: media.horizontalBlockSize * 55,
                                ),
                                Container(
                                  height: media.horizontalBlockSize * 35,
                                  decoration: const BoxDecoration(
                                    color: kPrimaryAppColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(175),
                                      bottomRight: Radius.circular(175),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: media.horizontalBlockSize * 18,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: media.horizontalBlockSize * 25,
                                    height: media.horizontalBlockSize * 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: data.profileImage != null
                                          ? DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: NetworkImage(
                                                data.profileImage!,
                                              ),
                                            )
                                          : null,
                                    ),
                                    child: data.profileImage == null
                                        ? CircleAvatar(
                                            child: Text(
                                              data.firstName.isNotEmpty
                                                  ? data.firstName[0]
                                                      .toUpperCase()
                                                  : 'U',
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Column(
                              children: [
                                Text(
                                  data.name,
                                  style: TextStyle(
                                    fontSize: media.horizontalBlockSize * 4.2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  data.city ?? 'India',
                                  style: TextStyle(
                                    fontSize: media.horizontalBlockSize * 3.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: kPrimaryAppColor,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: kAccentAppColor,
                              ),
                              tabs: const [
                                Tab(text: 'About'),
                                Tab(text: 'Diet Plan'),
                                Tab(text: 'Exercise'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: media.size.height,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildAboutCard(context, data: data),
                                _buildDietPlansCard(context),
                                _buildExerciseCard(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context, {required Subscriber data}) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Age',
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 3.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (data.birthDate != null)
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: media.horizontalBlockSize * 7.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${DateTime.now().year - data.birthDate!.year}',
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3.5,
                        ),
                      ),
                    )
                ],
              ),
              Column(
                children: [
                  Text(
                    'Height',
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 3.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: media.horizontalBlockSize * 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${data.height}',
                      style: TextStyle(
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    'Weight',
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 3.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: media.horizontalBlockSize * 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${data.weight} kg',
                      style: TextStyle(
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Fitness Center',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: media.horizontalBlockSize * 3.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gym Name',
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3.5,
                        ),
                      ),
                      Text(
                        '0.4 Km away',
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  height: 180,
                  child: GymMap(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDietPlansCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BlocBuilder<AuthCubit, DetailState<Account>>(
          builder: (context, userState) {
            if (userState.data is! Trainer) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => DietPlanListCubit(
                          repository: context.read<DietPlanRepository>(),
                          authCubit: context.read<AuthCubit>(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Your Uploaded Diet Plans',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            BlocBuilder<DietPlanListCubit, ListState<DietPlan>>(
                              builder: (context, state) {
                                return Expanded(
                                  child: GridView.builder(
                                    itemCount: state.data.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      return DietPlanListTile(
                                        state.data[index],
                                        showBuyButton: false,
                                        buttons: [
                                          IconButton(
                                            onPressed: () {
                                              // TODO(backend): API not implemented to upload diet plans.
                                            },
                                            color: Colors.green,
                                            icon: const Icon(Icons.upload),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.upload),
                label: const Text('UPLOAD DIET PLANS'),
              ),
            );
          },
        ),
        // TODO(backend): API not implemented to show subscribers diet plans.
        BlocProvider(
          create: (context) => DietPlanListCubit(
            repository: context.read<DietPlanRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: BlocBuilder<AuthCubit, DetailState<Account>>(
            builder: (context, userState) {
              return BlocBuilder<DietPlanListCubit, ListState<DietPlan>>(
                builder: (context, state) {
                  var data = state.data
                      .where(
                        (p0) =>
                            p0.coverImage != null && p0.coverImage!.isNotEmpty,
                      )
                      .toList();

                  if (data.isEmpty) {
                    return const Center(
                      child: Text('Diet Plans not found.'),
                    );
                  }

                  return Expanded(
                    child: GridView.builder(
                      primary: false,
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return DietPlanListTile(
                          data[index],
                          showBuyButton: false,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BlocBuilder<AuthCubit, DetailState<Account>>(
          builder: (context, userState) {
            if (userState.data is! Trainer) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => ExerciseListCubit(
                          repository: context.read<ExerciseRepository>(),
                          authCubit: context.read<AuthCubit>(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Your Uploaded Exercises',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            BlocBuilder<ExerciseListCubit, ListState<Exercise>>(
                              builder: (context, state) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: state.data.length,
                                    itemBuilder: (context, index) {
                                      return ExerciseListTile(
                                        state.data[index],
                                        buttons: [
                                          IconButton(
                                            onPressed: () {
                                              // TODO(backend): API not implemented to upload exercise.
                                            },
                                            color: Colors.green,
                                            icon: const Icon(Icons.upload),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.upload),
                label: const Text('UPLOAD EXERCISE'),
              ),
            );
          },
        ),
        // TODO(backend): API not implemented to show subscribers exercises.
        BlocProvider(
          create: (context) => ExerciseListCubit(
            repository: context.read<ExerciseRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: BlocBuilder<AuthCubit, DetailState<Account>>(
            builder: (context, userState) {
              return BlocBuilder<ExerciseListCubit, ListState<Exercise>>(
                builder: (context, state) {
                  if (state.data.isEmpty) {
                    return const Center(
                      child: Text('Exercises not found.'),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      primary: false,
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        return ExerciseListTile(
                          state.data[index],
                          buttons: [
                            if (userState.data is Trainer)
                              IconButton(
                                onPressed: () {
                                  // TODO(backend): API not implemented to upload exercise.
                                },
                                color: Colors.green,
                                icon: const Icon(Icons.upload),
                              ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
