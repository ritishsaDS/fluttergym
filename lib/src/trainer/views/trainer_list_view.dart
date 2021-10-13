import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/drawer.dart';
import '../../shared/widgets/filter_drawer.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../shared/widgets/search_text_field.dart';
import '../cubit/trainer_list_cubit.dart';
import '../widgets/trainer_list_tile.dart';
import 'trainer_detail_view.dart';

class TrainerListView extends StatefulWidget {
  const TrainerListView({Key? key}) : super(key: key);

  static const routeName = '/trainer/list';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => TrainerListCubit(
            repository: context.read<TrainerRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const TrainerListView(),
        );
      },
    );
  }

  @override
  _TrainerListViewState createState() => _TrainerListViewState();
}

class _TrainerListViewState extends State<TrainerListView> {
  final _allFilters = {'Weight Loss', 'Muscle Gain', 'Shredding'};
  final _selectedFilters = <String>{};
  String? _searchKeywords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Personal Trainer',
        assetImage: Assets.trainerEggIcon,
      ),
      drawer: const CustomDrawer(),
      // endDrawer: FilterDrawer(
      //   selectedKeys: _selectedFilters,
      //   items: {
      //     for (var filter in _allFilters)
      //       filter: (value) {
      //         setState(
      //           () => value ?? false
      //               ? _selectedFilters.add(filter)
      //               : _selectedFilters.remove(filter),
      //         );
      //         context.read<TrainerListCubit>().getList(
      //               specialities: _selectedFilters,
      //               keywords: _searchKeywords,
      //             );
      //       }
      //   },
      // ),
      body: Column(
        children: [
          Builder(
            builder: (context) {
              return SearchTextField(
                onChanged: (value) {
                  _searchKeywords = value;
                  context.read<TrainerListCubit>().getList(
                        specialities: _selectedFilters,
                        keywords: _searchKeywords,
                      );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilterChipList(
              selectedKeys: _selectedFilters,
              items: {
                for (var filter in _allFilters)
                  filter: (value) {
                    setState(
                      () => value ?? false
                          ? _selectedFilters.add(filter)
                          : _selectedFilters.remove(filter),
                    );
                    context.read<TrainerListCubit>().getList(
                          specialities: _selectedFilters,
                          keywords: _searchKeywords,
                        );
                  }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TrainerListCubit, ListState<Trainer>>(
              builder: (context, state) {
                if (state is ListWaiting || state is ListInitial) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state is ListFailure<Trainer>) {
                  return Center(
                    child: Text(state.message ?? 'An error occurred'),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
