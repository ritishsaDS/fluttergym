import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';

class TrainerPackageButtonBar extends StatefulWidget {
  const TrainerPackageButtonBar(
    this.data, {
    Key? key,
  }) : super(key: key);

  final TrainerPackage data;

  @override
  State<TrainerPackageButtonBar> createState() =>
      _TrainerPackageButtonBarState();
}

class _TrainerPackageButtonBarState extends State<TrainerPackageButtonBar> {
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kAccentAppColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹ ${widget.data.price} / session',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: kTextSizeMedium,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryAppColor),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                ),
              ),
              onPressed: _openCheckout,
              child: const Text('Pay Now'),
            )
          ],
        ),
      ),
    );
  }

  void _openCheckout() {
    var account = context.read<AuthCubit>().state.data;

    var options = {
      'key': kRazorPayKey,
      'amount': widget.data.price * 100,
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
    // Just made it work somehow.
    var repository = TrainerPackageRestRepository();
    var account = context.read<AuthCubit>().state.data;

    if (account != null) {
      repository.purchase(
        PackagePurchaseOption(
          (b) => b
            ..userId = account.id
            ..packageId = widget.data.trainerPackageId
            ..transactionId = response.paymentId
            ..paymentStatus = 1,
        ),
      );
    }
  }
}
