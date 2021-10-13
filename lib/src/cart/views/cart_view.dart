import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_list_tile.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  static const routeName = '/cart';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return const CartView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Cart',
        assetImage: Assets.cartEggIcon,
      ),
      body: BlocBuilder<CartCubit, ListState<CartItem>>(
        builder: (context, state) {
          if (state.data.isEmpty) {
            return Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Your Power Dope cart is empty.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              var data = state.data[index];
              return CartListTile(data);
            },
          );
        },
      ),
    );
  }
}
