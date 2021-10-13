import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../trainer_package/cubit/trainer_package_list_cubit.dart';
import '../../trainer_package/widgets/trainer_package_button_bar.dart';
import '../../trainer_package/widgets/trainer_package_list_view.dart';
import '../../trainer_review/cubit/trainer_review_list_cubit.dart';
import '../../trainer_review/widgets/trainer_review_list_view.dart';
import '../cubit/trainer_detail_cubit.dart';

class TrainerDetailView extends StatefulWidget {
  const TrainerDetailView({Key? key}) : super(key: key);

  static const routeName = '/trainer/detail';

  static Route<void> route({required int trainerId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TrainerDetailCubit(
                repository: context.read<TrainerRepository>(),
                trainerId: trainerId,
              ),
            ),
            BlocProvider(
              create: (context) => TrainerPackageListCubit(
                repository: context.read<TrainerPackageRepository>(),
                authCubit: context.read<AuthCubit>(),
                trainerId: trainerId,
              ),
            ),
            BlocProvider(
              create: (context) => TrainerReviewListCubit(
                repository: context.read<TrainerReviewRepository>(),
                authCubit: context.read<AuthCubit>(),
                trainerId: trainerId,
              ),
            ),
          ],
          child: const TrainerDetailView(),
        );
      },
    );
  }

  @override
  _TrainerDetailViewState createState() => _TrainerDetailViewState();
}

class _TrainerDetailViewState extends State<TrainerDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  TrainerPackage? _selected;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Trainer',
        assetImage: Assets.trainerEggIcon,
      ),
      bottomNavigationBar: _selected != null //
          ? TrainerPackageButtonBar(_selected!)
          : null,
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

          var data = state.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 5),
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
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: data.profileImage != null
                      ? NetworkImage(data.profileImage!)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                data.name,
                style: TextStyle(
                  fontSize: media.horizontalBlockSize * 4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rating ',
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 3.5,
                    ),
                  ),
                  Text('${data.averageRating ?? 0}'),
                ],
              ),
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        indicatorColor: kAccentAppColor,
                        labelColor: kAccentAppColor,
                        controller: _controller,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(text: 'About'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              ListView(
                                children: [
                                  _buildOverview(context, data: data),
                                ],
                              ),
                              Column(
                                children: const [
                                  Expanded(
                                    child: TrainerReviewListView(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverview(BuildContext context, {required Trainer data}) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
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
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.description ?? '',
                maxLines: 3,
                style: TextStyle(
                  fontSize: media.horizontalBlockSize * 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Select Package',
            style: TextStyle(
              fontSize: media.horizontalBlockSize * 4,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: media.verticalBlockSize * 20,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: TrainerPackageListView(
              onSelected: (value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                Assets.minimizeIcon,
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speciality',
                      style: TextStyle(
                        color: kAccentAppColor,
                        fontWeight: FontWeight.w600,
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.specialities.join(', '),
                      style: TextStyle(
                        color: kAccentAppColor,
                        fontSize: media.horizontalBlockSize * 3,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                Assets.minimizeIcon,
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experience',
                    style: TextStyle(
                      color: kAccentAppColor,
                      fontWeight: FontWeight.w600,
                      fontSize: media.horizontalBlockSize * 3.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${data.experience ?? 0}',
                    style: TextStyle(
                      color: kAccentAppColor,
                      fontSize: media.horizontalBlockSize * 3,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                Assets.minimizeIcon,
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Languages',
                    style: TextStyle(
                      color: kAccentAppColor,
                      fontWeight: FontWeight.w600,
                      fontSize: media.horizontalBlockSize * 3.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.languages.join(', '),
                    style: TextStyle(
                      color: kAccentAppColor,
                      fontSize: media.horizontalBlockSize * 3,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
