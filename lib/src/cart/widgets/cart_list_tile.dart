import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';
import '../cubit/cart_cubit.dart';

class CartListTile extends StatelessWidget {
  const CartListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final CartItem data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              child: Image.asset(
                Assets.profileBackground,
                height: media.horizontalBlockSize * 25,
                width: media.horizontalBlockSize * 25,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.product.productName,
                          style: TextStyle(
                            fontSize: media.horizontalBlockSize * 4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: media.horizontalBlockSize * 20,
                        ),
                        // Text(
                        //   '2000',
                        //   style: TextStyle(
                        //     fontSize: media.horizontalBlockSize * 3,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                    Text(
                      data.product.brandName,
                      style: TextStyle(
                        fontSize: media.horizontalBlockSize * 3,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${data.product.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: media.horizontalBlockSize * 4,
                      ),
                    ),
                    SizedBox(
                      width: media.horizontalBlockSize * 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: media.horizontalBlockSize * 7,
                          width: media.horizontalBlockSize * 7,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<CartCubit>()
                                  .removeProduct(data.product);
                            },
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text('${data.count}'),
                        const SizedBox(width: 5),
                        Container(
                          height: media.horizontalBlockSize * 7,
                          width: media.horizontalBlockSize * 7,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<CartCubit>()
                                  .addProduct(data.product);
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
