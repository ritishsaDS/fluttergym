import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';

class SubscriberListTile extends StatelessWidget {
  const SubscriberListTile(
    this.data, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  final SubscribedUser data;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  if (data.userImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        data.userImage!,
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: media.horizontalBlockSize * 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   data.city ?? 'India',
                      //   style: TextStyle(
                      //     fontSize: media.horizontalBlockSize * 3.4,
                      //   ),
                      // ),
                      const SizedBox(height: 3),
                      Text(
                        'Pack Name',
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3.4,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kPrimaryAppColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
                height: media.horizontalBlockSize * 9,
                width: media.horizontalBlockSize * 30,
                child: GestureDetector(
                  onTap: () {
                    throw UnimplementedError();
                  },
                  child: Text(
                    'Start Now',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: media.horizontalBlockSize * 3.4,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
