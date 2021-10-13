import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../diet_plan/cubit/diet_plan_detail_cubit.dart';
import '../../gym/cubit/gym_detail_cubit.dart';
import '../../gym_package/cubit/gym_package_detail_cubit.dart';
import '../../shared/common.dart';
import '../../trainer/cubit/trainer_detail_cubit.dart';
import '../../trainer_package/cubit/trainer_package_detail_cubit.dart';

class GymPackageSubscriptionListTile extends StatelessWidget {
  const GymPackageSubscriptionListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final GymPackageSubscription data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GymDetailCubit(
            repository: context.read<GymRepository>(),
            authCubit: context.read<AuthCubit>(),
            gymId: data.gymId,
          ),
        ),
        BlocProvider(
          create: (context) => GymPackageDetailCubit(
            repository: context.read<GymPackageRepository>(),
            gymPackageId: data.gymPackageId,
            gymId: data.gymId,
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: media.horizontalBlockSize * 1,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: kPrimaryAppColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              color: kPrimaryAppColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: media.horizontalBlockSize * 1,
                    ),
                    child: BlocBuilder<GymDetailCubit, DetailState<Gym>>(
                      builder: (context, state) {
                        if (state is! DetailSuccess) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          height: media.horizontalBlockSize * 30,
                          width: media.horizontalBlockSize * 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(state.data!.coverImage),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.black26.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: media.horizontalBlockSize * 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<GymDetailCubit, DetailState<Gym>>(
                            builder: (context, state) {
                              return Text(
                                state.data?.name ?? 'Gym',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: media.horizontalBlockSize * 3.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: media.horizontalBlockSize * 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Rating',
                                style: TextStyle(
                                  color: Colors.black26.withOpacity(0.5),
                                  fontSize: media.horizontalBlockSize * 2.5,
                                ),
                              ),
                              SizedBox(
                                width: media.horizontalBlockSize * 2,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              ),
                              BlocBuilder<GymDetailCubit, DetailState<Gym>>(
                                builder: (context, state) {
                                  return Text(
                                    '${state.data?.averageRating ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: kTextSizeMedium,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      BlocBuilder<GymDetailCubit, DetailState<Gym>>(
                        builder: (context, state) {
                          return Text(
                            state.data?.city ?? 'City',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 2.5,
                              color: Colors.black26.withOpacity(0.6),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: media.horizontalBlockSize * 2,
                                  color: Colors.black26.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                data.startDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: media.horizontalBlockSize * 2.5,
                                  color: Colors.black38.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: media.horizontalBlockSize * 15,
                          ),
                          Text(
                            '₹ ${data.amount}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38.withOpacity(0.7),
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 2,
                              color: Colors.black26.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            data.finalDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: media.horizontalBlockSize * 2.5,
                              color: Colors.black38.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kAccentAppColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                height: media.horizontalBlockSize * 12,
                width: media.horizontalBlockSize * 30,
                child: Text(
                  'Renew Package',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: media.horizontalBlockSize * 3,
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

class TrainerPackageSubscriptionListTile extends StatelessWidget {
  const TrainerPackageSubscriptionListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final TrainerPackageSubscription data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TrainerDetailCubit(
            repository: context.read<TrainerRepository>(),
            trainerId: data.trainerId,
          ),
        ),
        BlocProvider(
          create: (context) => TrainerPackageDetailCubit(
            repository: context.read<TrainerPackageRepository>(),
            trainerPackageId: data.trainerPackageId,
            trainerId: data.trainerId,
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: media.horizontalBlockSize * 1,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: kPrimaryAppColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              color: kPrimaryAppColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: media.horizontalBlockSize * 1,
                    ),
                    child:
                        BlocBuilder<TrainerDetailCubit, DetailState<Trainer>>(
                      builder: (context, state) {
                        if (state is! DetailSuccess) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          height: media.horizontalBlockSize * 30,
                          width: media.horizontalBlockSize * 30,
                          decoration: BoxDecoration(
                            image: state.data!.profileImage != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      state.data!.profileImage!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.black26.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: media.horizontalBlockSize * 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<TrainerDetailCubit, DetailState<Trainer>>(
                            builder: (context, state) {
                              return Text(
                                state.data?.name ?? 'Trainer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: media.horizontalBlockSize * 3.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: media.horizontalBlockSize * 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Rating',
                                style: TextStyle(
                                  color: Colors.black26.withOpacity(0.5),
                                  fontSize: media.horizontalBlockSize * 2.5,
                                ),
                              ),
                              SizedBox(
                                width: media.horizontalBlockSize * 2,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              ),
                              BlocBuilder<TrainerDetailCubit,
                                  DetailState<Trainer>>(
                                builder: (context, state) {
                                  return Text(
                                    '${state.data?.averageRating ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: kTextSizeMedium,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      BlocBuilder<TrainerDetailCubit, DetailState<Trainer>>(
                        builder: (context, state) {
                          return Text(
                            state.data?.city ?? 'India',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 2.5,
                              color: Colors.black26.withOpacity(0.6),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: media.horizontalBlockSize * 2,
                                  color: Colors.black26.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                data.startDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: media.horizontalBlockSize * 2.5,
                                  color: Colors.black38.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: media.horizontalBlockSize * 15,
                          ),
                          Text(
                            '₹ ${data.amount}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38.withOpacity(0.7),
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 2,
                              color: Colors.black26.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            data.finalDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: media.horizontalBlockSize * 2.5,
                              color: Colors.black38.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kAccentAppColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                height: media.horizontalBlockSize * 12,
                width: media.horizontalBlockSize * 30,
                child: Text(
                  'Renew Package',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: media.horizontalBlockSize * 3,
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

class DietPlanSubscriptionListTile extends StatelessWidget {
  const DietPlanSubscriptionListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final DietPlanSubscription data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DietPlanDetailCubit(
            repository: context.read<DietPlanRepository>(),
            dietPlanId: data.dietPlanId,
            trainerId: data.trainerId,
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: media.horizontalBlockSize * 1,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: kPrimaryAppColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 7),
            ),
            BoxShadow(
              color: kPrimaryAppColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: media.horizontalBlockSize * 1,
                    ),
                    child:
                        BlocBuilder<DietPlanDetailCubit, DetailState<DietPlan>>(
                      builder: (context, state) {
                        if (state is! DetailSuccess) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          height: media.horizontalBlockSize * 30,
                          width: media.horizontalBlockSize * 30,
                          decoration: BoxDecoration(
                            image: state.data!.coverImage != null
                                ? DecorationImage(
                                    image:
                                        NetworkImage(state.data!.coverImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Colors.black26.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: media.horizontalBlockSize * 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<DietPlanDetailCubit,
                              DetailState<DietPlan>>(
                            builder: (context, state) {
                              return Text(
                                state.data?.name ?? 'Diet Plan',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: media.horizontalBlockSize * 3.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: media.horizontalBlockSize * 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Rating',
                                style: TextStyle(
                                  color: Colors.black26.withOpacity(0.5),
                                  fontSize: media.horizontalBlockSize * 2.5,
                                ),
                              ),
                              SizedBox(
                                width: media.horizontalBlockSize * 2,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: media.horizontalBlockSize * 2,
                                  color: Colors.black26.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                data.startDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: media.horizontalBlockSize * 2.5,
                                  color: Colors.black38.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: media.horizontalBlockSize * 15,
                          ),
                          Text(
                            '₹ ${data.amount}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38.withOpacity(0.7),
                              fontSize: media.horizontalBlockSize * 3,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: media.horizontalBlockSize * 2,
                              color: Colors.black26.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            data.finalDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: media.horizontalBlockSize * 2.5,
                              color: Colors.black38.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kAccentAppColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                height: media.horizontalBlockSize * 12,
                width: media.horizontalBlockSize * 30,
                child: Text(
                  'Renew Package',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: media.horizontalBlockSize * 3,
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
