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
import '../cubit/gym_list_cubit.dart';
import '../widgets/gym_list_tile.dart';

class GymListView extends StatefulWidget {
  const GymListView({Key? key}) : super(key: key);

  static const routeName = '/gym/list';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => GymListCubit(
            repository: context.read<GymRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const GymListView(),
        );
      },
    );
  }

  @override
  _GymListViewState createState() => _GymListViewState();
}

class _GymListViewState extends State<GymListView> {
  final _allFilters = {'Fitness', 'Yoga', 'Dance', 'Kick Boxing'};
  final _selectedFilters = <String>{};
  String? _searchKeywords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Fitness Center',
        assetImage: Assets.gymEggIcon,
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
      //         context.read<GymListCubit>().getList(
      //               specialities: _selectedFilters,
      //               keywords: _searchKeywords,
      //             );
      //       }
      //   },
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) {
              return SearchTextField(
                onChanged: (value) {
                  _searchKeywords = value;
                  context.read<GymListCubit>().getList(
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
                    context.read<GymListCubit>().getList(
                          specialities: _selectedFilters,
                          keywords: _searchKeywords,
                        );
                  }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<GymListCubit, ListState<Gym>>(
              builder: (context, state) {
                if (state is ListWaiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return GymListTile(state.data[index]);
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
