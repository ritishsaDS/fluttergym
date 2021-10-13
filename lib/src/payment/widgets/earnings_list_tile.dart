import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';

class TrainerEarningsListTile extends StatelessWidget {
  const TrainerEarningsListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final Subscription data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name ?? 'Package',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: media.horizontalBlockSize * 3.8,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Transaction no.',
                  style: TextStyle(
                    fontSize: media.horizontalBlockSize * 3.2,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  data.transactionId,
                  style: TextStyle(
                    fontSize: media.horizontalBlockSize * 3.2,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                data.startDate,
                style: TextStyle(
                  fontSize: media.horizontalBlockSize * 3,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryAppColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Price: ${data.amount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: media.horizontalBlockSize * 3.5,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
