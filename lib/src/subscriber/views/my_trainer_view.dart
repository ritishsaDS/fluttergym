import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../diet_plan/cubit/diet_plan_list_cubit.dart';
import '../../exercise/cubit/exercise_list_cubit.dart';
import '../../gym/widgets/gym_map.dart';
import '../../shared/common.dart';
import '../../shared/common/functions.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../trainer/cubit/trainer_detail_cubit.dart';
import '../widgets/subscriber_landing_bottom_bar.dart';

class MyTrainerView extends StatefulWidget {
  const MyTrainerView({Key? key}) : super(key: key);

  static const routeName = '/trainer/my';

  static Route<void> route({
    int? trainerId,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TrainerDetailCubit(
                repository: context.read<TrainerRepository>(),
                // TODO(backend): My Trainer API is not implemented.
                trainerId: trainerId ?? 8,
              ),
            ),
            BlocProvider(
              create: (context) => DietPlanListCubit(
                repository: context.read<DietPlanRepository>(),
                authCubit: context.read<AuthCubit>(),
                // TODO(backend): My Trainer Diet Plan API is not implemented.
                trainerId: trainerId ?? 8,
              ),
            ),
            BlocProvider(
              create: (context) => ExerciseListCubit(
                repository: context.read<ExerciseRepository>(),
                authCubit: context.read<AuthCubit>(),
                // TODO(backend): My Trainer Exercise API is not implemented.
                trainerId: trainerId ?? 8,
              ),
            ),
          ],
          child: const MyTrainerView(),
        );
      },
    );
  }

  @override
  State<MyTrainerView> createState() => _MyTrainerViewState();
}

class _MyTrainerViewState extends State<MyTrainerView> {
  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
    FlutterDownloader.loadTasks();
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Personal Trainer',
        assetImage: Assets.trainerEggIcon,
      ),
      body: BlocBuilder<TrainerDetailCubit, DetailState<Trainer>>(
        builder: (context, state) {
          if (state is DetailWaiting || state is DetailInitial) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is DetailFailure<Trainer>) {
            return Center(
              child: Text(
                state.message ?? 'An error occurred.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildTrainerProfileCard(context),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const SubscriberLandingBottomBar(index: 2),
    );
  }

  Widget _buildTrainerProfileCard(BuildContext context) {
    var media = MediaQuery.of(context);
    return BlocBuilder<TrainerDetailCubit, DetailState<Trainer>>(
      builder: (context, state) {
        var data = state.data!;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: DefaultTabController(
            length: 3,
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: [
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
                          decoration: data.profileImage != null
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(data.profileImage!),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.horizontalBlockSize * 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          data.name,
                          style: TextStyle(
                            fontSize: media.horizontalBlockSize * 4.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0;
                                i < (data.averageRating ?? 0).toInt();
                                i++)
                              Icon(
                                Icons.star,
                                color: Colors.amberAccent,
                                size: media.horizontalBlockSize * 4.5,
                              ),
                          ],
                        ),
                        Text(
                          data.specialities.join(', '),
                          style: TextStyle(
                            fontSize: media.horizontalBlockSize * 3.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.horizontalBlockSize * 1,
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
                  SizedBox(
                    height: media.horizontalBlockSize * 1,
                  ),
                  SizedBox(
                    height: media.size.height,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            _buildAboutCardForTrainer(context, trainer: data),
                          ],
                        ),
                        Column(
                          children: [
                            _buildPlanDetailsCard(context),
                          ],
                        ),
                        Column(
                          children: [
                            _buildExeciseVideo(context),
                          ],
                        ),
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
    required Trainer trainer,
  }) {
    var media = MediaQuery.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(
                fontSize: media.horizontalBlockSize * 4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(thickness: 3),
            Text(
              trainer.description ?? '',
              style: TextStyle(fontSize: media.horizontalBlockSize * 3),
            ),
            const SizedBox(height: 20),
            _buildMapLocationCard(context),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          ),
                          Text(
                            '15-04-2021',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 3,
                        color: kAccentAppColor,
                      ),
                      Column(
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          ),
                          Text(
                            '15-05-2021',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        throw UnimplementedError();
                      },
                      child: Text(
                        'Renew Package',
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: kAccentAppColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '1000',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: media.horizontalBlockSize * 4,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetailsCard(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DietPlanListCubit, ListState<DietPlan>>(
        builder: (context, state) {
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
                fileName: data.coverImage,
                enableDownloadButton: true,
                bottomButtonFuntion: () {},
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildExeciseVideo(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ExerciseListCubit, ListState<Exercise>>(
        builder: (context, state) {
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
                fileName: data.videos,
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

  Widget _buildMapLocationCard(BuildContext context) {
    var media = MediaQuery.of(context);
    return Container(
      height: media.horizontalBlockSize * 70,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                  style: TextStyle(fontSize: media.horizontalBlockSize * 3.5),
                ),
                Text(
                  '0.4 Km away',
                  style: TextStyle(fontSize: media.horizontalBlockSize * 3.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              height: media.horizontalBlockSize * 57,
              child: const GymMap(),
            ),
          )
        ],
      ),
    );
  }
}

class TrainerDietExerciseCard extends StatefulWidget {
  const TrainerDietExerciseCard({
    required this.title,
    required this.subtitle,
    required this.showThirdSubtitle,
    required this.enableDownloadButton,
    required this.bottomButtonTitle,
    required this.bottomButtonFuntion,
    this.thridSubtitle,
    this.fileName,
    this.link,
    Key? key,
  }) : super(key: key);

  // ignore: avoid_multiple_declarations_per_line
  final String title, subtitle, bottomButtonTitle;
  final String? thridSubtitle;
  final bool showThirdSubtitle;
  final bool enableDownloadButton;
  final String? link;
  final String? fileName;
  final GestureTapCallback bottomButtonFuntion;

  @override
  State<TrainerDietExerciseCard> createState() =>
      _TrainerDietExerciseCardState();
}

class _TrainerDietExerciseCardState extends State<TrainerDietExerciseCard> {
  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {}

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        if (widget.link != null) {
          launchUrl(url: widget.link!);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3,
                        ),
                      ),
                      if (widget.showThirdSubtitle)
                        Text(
                          widget.thridSubtitle ?? '',
                          style: TextStyle(
                            fontSize: media.horizontalBlockSize * 2.8,
                          ),
                        )
                      else
                        Container(),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.enableDownloadButton)
              Positioned(
                right: 0,
                top: 15,
                child: Container(
                  width: media.horizontalBlockSize * 25,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (widget.fileName != null) {
                        downloadFile(context, uri: widget.fileName!);
                      }
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: kPrimaryAppColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: media.horizontalBlockSize * 5,
                        ),
                        Text(
                          'Download',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: media.horizontalBlockSize * 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Container(),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.bottomButtonFuntion,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: kPrimaryAppColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  height: 30,
                  width: media.horizontalBlockSize * 25,
                  child: Text(
                    widget.bottomButtonTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: media.horizontalBlockSize * 3,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TrainerPackageListTile extends StatelessWidget {
  const TrainerPackageListTile(this.data, {Key? key}) : super(key: key);

  final TrainerPackage data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(data.name),
                      Text(
                        data.description,
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'M.R.P: ₹ ${data.maxPrice}',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.apply(decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      '₹ ${data.price}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kPrimaryAppColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
                height: 30,
                width: 120,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
