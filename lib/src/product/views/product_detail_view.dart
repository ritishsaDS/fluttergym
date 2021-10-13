import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/product_detail_cubit.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  static const routeName = '/product/detail';

  static Route<void> route({required int productId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => ProductDetailCubit(
            repository: context.read<ProductRepository>(),
            productId: productId,
            authCubit: context.read<AuthCubit>(),
          ),
          child: const ProductDetailView(),
        );
      },
    );
  }

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Shop',
        assetImage: Assets.cartEggIcon,
      ),
      body: BlocBuilder<ProductDetailCubit, DetailState<Product>>(
        builder: (context, state) {
          if (state is DetailWaiting || state is DetailInitial) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is DetailFailure<Product>) {
            return Center(
              child: Text(state.message ?? 'An error occurred.'),
            );
          }

          var data = state.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 5,
                    right: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: media.size.width,
                        height: media.verticalBlockSize * 25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data.productImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: media.horizontalBlockSize * 3.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  data.brandName,
                                  style: TextStyle(
                                    fontSize: media.horizontalBlockSize * 3.5,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: media.horizontalBlockSize * 3.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '₹ ${data.price}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: media.horizontalBlockSize * 3.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: media.horizontalBlockSize * 3.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data.description,
                              style: TextStyle(
                                fontSize: media.horizontalBlockSize * 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.horizontalBlockSize * 10,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 16,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              context.read<CartCubit>().addProduct(data);
                            },
                            color: kPrimaryAppColor,
                            elevation: 3,
                            child: GestureDetector(
                              onTap: () {
                                var cubit = context.read<CartCubit>();
                                if (cubit.state.data
                                    .any((p0) => p0.id == data.id)) {
                                  cubit.removeProduct(data);
                                } else {
                                  cubit.addProduct(data);
                                }
                              },
                              child:
                                  BlocBuilder<CartCubit, ListState<CartItem>>(
                                builder: (context, state) {
                                  if (state.data
                                      .any((p0) => p0.id == data.id)) {
                                    return Text(
                                      '  Remove from Cart  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: media.horizontalBlockSize * 4,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      '  Add to Cart  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: media.horizontalBlockSize * 4,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              context.read<CartCubit>().addProduct(data);
                            },
                            color: kPrimaryAppColor,
                            elevation: 3,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                '   Save To List   ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: media.horizontalBlockSize * 4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              _openCheckout(data);
                            },
                            color: kPrimaryAppColor,
                            elevation: 3,
                            child: Text(
                              '  Buy Now  ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: media.horizontalBlockSize * 4,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openCheckout(Product data) {
    var account = context.read<AuthCubit>().state.data;

    var options = {
      'key': kRazorPayKey,
      'amount': data.price * 100,
      'currency': 'INR',
      // TODO(backend): Orders API not implemented.
      // 'order_id': ___,
      'prefill': {
        'contact': account?.phone,
        'email': account?.email,
      }
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var cubit = context.read<ProductDetailCubit>();
    context.read<ProductDetailCubit>().purchase(
          price: (cubit.state.data?.price ?? 0) * 100,
          transactionId: response.paymentId ?? '',
          paymentStatus: 1,
        );
  }
}
