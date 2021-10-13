import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/views/custom_document_view.dart';

class DietPlanListTile extends StatefulWidget {
  const DietPlanListTile(
    this.data, {
    this.showBuyButton = true,
    this.buttons = const <Widget>[],
    Key? key,
  }) : super(key: key);

  final DietPlan data;

  final bool showBuyButton;

  final List<Widget> buttons;

  @override
  State<DietPlanListTile> createState() => _DietPlanListTileState();
}

class _DietPlanListTileState extends State<DietPlanListTile> {
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: Column(
        children: [
          if (widget.data.coverImage != null)
            if (['png', 'jpg'].any((e) => widget.data.coverImage!.endsWith(e)))
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierColor: Colors.black38,
                      builder: (context) {
                        return PhotoView(
                          imageProvider: NetworkImage(
                            widget.data.coverImage!,
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    widget.data.coverImage!,
                    height: media.horizontalBlockSize * 30,
                    width: media.horizontalBlockSize * 30,
                  ),
                ),
              )
            else if (widget.data.coverImage!.endsWith('pdf'))
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CustomDocumentView.route(
                          title: 'Document',
                          uri: widget.data.coverImage!,
                        ),
                      );
                    },
                    child: const Text('VIEW PDF'),
                  ),
                ),
              ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.showBuyButton)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 30,
                  ),
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: kPrimaryAppColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: GestureDetector(
                    onTap: _openCheckout,
                    child: Text(
                      '₹ ${widget.data.price ?? 0}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ...widget.buttons,
            ],
          ),
          if (widget.showBuyButton)
            Text(
              'For ${(widget.data.validity ?? 0) ~/ 30} months',
              style: TextStyle(fontSize: media.horizontalBlockSize * 3),
            ),
        ],
      ),
    );
  }

  void _openCheckout() {
    var account = context.read<AuthCubit>().state.data;

    var options = {
      'key': kRazorPayKey,
      'amount': (widget.data.price ?? 100) * 100,
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
    var repository = DietPlanRestRepository();
    var account = context.read<AuthCubit>().state.data;

    if (account != null) {
      repository.purchase(
        PackagePurchaseOption(
          (b) => b
            ..userId = account.id
            ..packageId = widget.data.dietPlanId
            ..transactionId = response.paymentId
            ..paymentStatus = 1,
        ),
      );
    }
  }
}
