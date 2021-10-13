import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../gym_package/cubit/gym_package_list_cubit.dart';
import '../../gym_package/widgets/gym_package_button_bar.dart';
import '../../gym_package/widgets/gym_package_list_view.dart';
import '../../shared/common.dart';
import '../../shared/widgets/cover_media.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/gym_detail_cubit.dart';
import '../widgets/gym_map.dart';

class GymDetailView extends StatefulWidget {
  const GymDetailView({Key? key}) : super(key: key);

  static const routeName = '/gym/detail';

  static Route<void> route({required int gymId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GymDetailCubit(
                repository: context.read<GymRepository>(),
                authCubit: context.read<AuthCubit>(),
                gymId: gymId,
              ),
            ),
            BlocProvider(
              create: (context) => GymPackageListCubit(
                repository: context.read<GymPackageRepository>(),
                authCubit: context.read<AuthCubit>(),
                gymId: gymId,
              ),
            ),
          ],
          child: const GymDetailView(),
        );
      },
    );
  }

  @override
  _GymDetailViewState createState() => _GymDetailViewState();
}

class _GymDetailViewState extends State<GymDetailView> {
  GymPackage? _selected;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return BlocBuilder<GymDetailCubit, DetailState<Gym>>(
      builder: (context, state) {
        if (state is DetailInitial || state is DetailWaiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (state is! DetailSuccess) {
          return const Scaffold(
            appBar: CustomAppBar(
              label: 'Fitness Center',
              assetImage: Assets.gymEggIcon,
            ),
            body: Center(
              child: Text('Gym not found.'),
            ),
          );
        }

        var data = state.data!;

        // TODO(backend): API missing for multiple images and videos.
        var coverMedia = [
          data.coverImage,
          data.coverImage,
          data.coverImage,
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ];

        return Scaffold(
          appBar: const CustomAppBar(
            label: 'Fitness Center',
            assetImage: Assets.gymEggIcon,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CoverMedia(data: coverMedia),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: media.horizontalBlockSize * 3.5,
                              ),
                            ),
                            Text(
                              'Rating ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: media.horizontalBlockSize * 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Location, ${data.city}',
                              style: TextStyle(
                                fontSize: media.horizontalBlockSize * 3,
                              ),
                            ),
                            Text(
                              data.averageRating?.toStringAsFixed(1) ?? '0',
                              style: TextStyle(
                                fontSize: media.horizontalBlockSize * 3,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        maxLines: 9,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: media.horizontalBlockSize * 3.4,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data.description,
                        maxLines: 9,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: media.horizontalBlockSize * 3.3,
                        ),
                      ),
                    ],
                  ),
                ),
                ExpandableNotifier(
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: ScrollOnExpand(
                      scrollOnCollapse: false,
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          hasIcon: false,
                          tapBodyToCollapse: true,
                        ),
                        header: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                Assets.activeTileBackground,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: media.horizontalBlockSize * 3.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        expanded: Container(
                          height: media.horizontalBlockSize * 57,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GymMap(
                              address: '${data.address}, ${data.city}',
                            ),
                          ),
                        ),
                        builder: (context, collapsed, expanded) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 2,
                              right: 2,
                              bottom: 2,
                            ),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              theme: const ExpandableThemeData(
                                crossFadePoint: 0,
                              ),
                            ),
                          );
                        },
                        collapsed: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Select Package',
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: media.horizontalBlockSize * 20,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: GymPackageListView(
                    onSelected: (value) {
                      setState(() {
                        _selected = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _selected != null //
              ? GymPackageButtonBar(_selected!)
              : null,
        );
      },
    );
  }
}
