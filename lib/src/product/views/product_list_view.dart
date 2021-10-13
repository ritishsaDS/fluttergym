import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../shared/widgets/search_text_field.dart';
import '../../subscriber/widgets/subscriber_landing_bottom_bar.dart';
import '../../trainer/widgets/trainer_landing_bottom_bar.dart';
import '../cubit/product_list_cubit.dart';
import '../widgets/product_list_tile.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({Key? key}) : super(key: key);

  static const routeName = '/product';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => ProductListCubit(
            repository: context.read<ProductRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const ProductListView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Shop',
        assetImage: Assets.cartEggIcon,
      ),
      body: Column(
        children: [
          SearchTextField(
            onChanged: (value) {
              throw UnimplementedError();
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<ProductListCubit, ListState<Product>>(
              builder: (context, state) {
                if (state is ListWaiting || state is ListInitial) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state is ListFailure<Product>) {
                  return Center(
                    child: Text(state.message ?? 'An error occurred.'),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return ProductListTile(state.data[index]);
                  },
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BlocBuilder<AuthCubit, DetailState<Account>>(
        builder: (context, state) {
          if (state.data is Trainer) {
            return const TrainerLandingBottomBar(index: 3);
          } else {
            return const SubscriberLandingBottomBar(index: 3);
          }
        },
      ),
    );
  }
}
