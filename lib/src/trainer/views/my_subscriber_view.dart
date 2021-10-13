import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../diet_plan/cubit/diet_plan_list_cubit.dart';
import '../../exercise/cubit/exercise_list_cubit.dart';
import '../../gym/widgets/gym_map.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../subscriber/cubit/subscribed_user_detail_cubit.dart';
import '../../subscriber/cubit/subscriber_detail_cubit.dart';
import '../../subscriber/views/my_trainer_view.dart';

class MySubscriberView extends StatelessWidget {
  const MySubscriberView({Key? key}) : super(key: key);

  static const routeName = '/subscriber/my/detail';

  static Route<void> route({
    required int subscriberId,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SubscribedUserDetailCubit(
                repository: context.read<SubscribedUserRepository>(),
                authCubit: context.read<AuthCubit>(),
                subscriberId: subscriberId,
              ),
            ),
            BlocProvider(
              create: (context) => SubscriberDetailCubit(
                repository: context.read<SubscriberRepository>(),
                subscriberId: subscriberId,
              ),
            ),
            BlocProvider(
              create: (context) => DietPlanListCubit(
                repository: context.read<DietPlanRepository>(),
                authCubit: context.read<AuthCubit>(),
                subscriberId: subscriberId,
              ),
            ),
            BlocProvider(
              create: (context) => ExerciseListCubit(
                repository: context.read<ExerciseRepository>(),
                authCubit: context.read<AuthCubit>(),
                subscriberId: subscriberId,
              ),
            ),
          ],
          child: const MySubscriberView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Subscriber',
        assetImage: Assets.subscriberEggIcon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            trainerProfileCard(context),
          ],
        ),
      ),
    );
  }

  Widget trainerProfileCard(BuildContext context) {
    var media = MediaQuery.of(context);
    return BlocBuilder<SubscriberDetailCubit, DetailState<Subscriber>>(
      builder: (context, state) {
        if (state is! DetailSuccess) {
          return const Center(
            child: Text('Subscriber not found.'),
          );
        }

        var data = state.data!;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            elevation: 5,
            child: DefaultTabController(
              length: 3,
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
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
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
                                      image: NetworkImage(data.profileImage!),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
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
                          data.phone ?? '',
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
                      unselectedLabelColor: Theme.of(context).primaryColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColorDark,
                      ),
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Diet Plan'),
                        Tab(text: 'Exercise'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildAboutCardForTrainer(context, subscriber: data),
                        _buildDietPlanDetailsCard(context),
                        _buildExerciseCard(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutCardForTrainer(
    BuildContext context, {
    required Subscriber subscriber,
  }) {
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
                  const SizedBox(
                    height: 10,
                  ),
                  if (subscriber.birthDate != null)
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
                        '${DateTime.now().year - subscriber.birthDate!.year}',
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
                  const SizedBox(
                    height: 10,
                  ),
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
                      '${subscriber.height}',
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
                  const SizedBox(
                    height: 10,
                  ),
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
                      '${subscriber.weight} KG',
                      style: TextStyle(
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Fitness Center',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: media.horizontalBlockSize * 3.5,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
                const SizedBox(
                  height: 10,
                ),
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

  Widget _buildDietPlanDetailsCard(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Container(
        //   padding: const EdgeInsets.all(15),
        //   margin: const EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.2),
        //         spreadRadius: 3,
        //         blurRadius: 2,
        //         offset: const Offset(0, 2),
        //       ),
        //     ],
        //   ),
        //   child: Column(
        //     children: [
        //       Container(
        //         padding: const EdgeInsets.all(10),
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Colors.grey,
        //           ),
        //         ),
        //         child: Column(
        //           children: [
        //             Text(
        //               'Upload New Diet Plan',
        //               style: TextStyle(
        //                 fontSize: media.horizontalBlockSize * 4,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 ElevatedButton(
        //                   onPressed: () {},
        //                   style: ButtonStyle(
        //                     backgroundColor: MaterialStateProperty.all(
        //                       Theme.of(context).primaryColor,
        //                     ),
        //                   ),
        //                   child: const Text(
        //                     '  from Phone  ',
        //                   ),
        //                 ),
        //                 ElevatedButton(
        //                   onPressed: () {},
        //                   style: ButtonStyle(
        //                     backgroundColor: MaterialStateProperty.all(
        //                       Theme.of(context).primaryColor,
        //                     ),
        //                   ),
        //                   child: const Text('from Diet Plan'),
        //                 )
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 10,
        //       ),
        //       Align(
        //         alignment: Alignment.topLeft,
        //         child: Text(
        //           'Diet Plan Name',
        //           style: TextStyle(
        //             fontSize: media.horizontalBlockSize * 3.5,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 10,
        //       ),
        //       TextField(
        //         minLines: 1,
        //         decoration: InputDecoration(
        //           contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(5),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 10,
        //       ),
        //       ElevatedButton(
        //         onPressed: () {},
        //         style: ButtonStyle(
        //           backgroundColor: MaterialStateProperty.all(
        //             Theme.of(context).primaryColor,
        //           ),
        //           textStyle: MaterialStateProperty.all(
        //             const TextStyle(
        //               fontWeight: FontWeight.w800,
        //               fontSize: 15,
        //             ),
        //           ),
        //           padding: MaterialStateProperty.all(
        //             const EdgeInsets.symmetric(horizontal: 70),
        //           ),
        //         ),
        //         child: const Text('Save Now'),
        //       ),
        //     ],
        //   ),
        // ),
        BlocBuilder<DietPlanListCubit, ListState<DietPlan>>(
          builder: (context, state) {
            if (state.data.isEmpty) {
              return const Center(
                child: Text('No diet plans found.'),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                var data = state.data[index];
                return TrainerDietExerciseCard(
                  title: data.name,
                  subtitle: data.description ?? 'Basic Diet Plan',
                  showThirdSubtitle: false,
                  bottomButtonTitle: 'Delete',
                  enableDownloadButton: true,
                  bottomButtonFuntion: () {},
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildExerciseCard(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ExerciseListCubit, ListState<Exercise>>(
        builder: (context, state) {
          if (state.data.isEmpty) {
            return const Align(
              alignment: Alignment.topCenter,
              child: Text('No exercises found.'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.data.length,
            primary: false,
            itemBuilder: (context, index) {
              var data = state.data[index];
              return TrainerDietExerciseCard(
                title: data.name,
                subtitle: data.details,
                showThirdSubtitle: true,
                thridSubtitle: data.restTime,
                enableDownloadButton: false,
                bottomButtonTitle: 'Delete',
                bottomButtonFuntion: () {
                  context.read<ExerciseListCubit>().delete(data.exerciseId);
                },
              );
            },
          );
        },
      ),
    );
  }

  /*
  Widget _buildExerciseCard1(BuildContext context) {
    var media = MediaQuery.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
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
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Upload New Diet Plan',
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 4.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildExerciseUploadForm(context, title: 'Video URL Link'),
                _buildExerciseUploadForm(context, title: 'Exercise Name'),
                Wrap(
                  children: [
                    _buildExerciseUploadForm(context, title: 'Rep Details'),
                    _buildExerciseUploadForm(context, title: 'Rest Time'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 70),
                    ),
                  ),
                  child: const Text('Save Now'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return TrainerDietExerciseCard(
                  title: 'Exercise Name',
                  subtitle: 'Rep. Details',
                  showThirdSubtitle: true,
                  thridSubtitle: 'Rest Time',
                  enableDownloadButton: false,
                  bottomButtonFuntion: () {},
                  bottomButtonTitle: 'Delete',
                );
              },
            ),
          )
        ],
      ),
    );
  }
  */

  /*
  Widget _buildExerciseUploadForm(
    BuildContext context, {
    required String title,
    ValueChanged<String>? onChanged,
  }) {
    var media = MediaQuery.of(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: media.horizontalBlockSize * 3.5,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          minLines: 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
  */
}
