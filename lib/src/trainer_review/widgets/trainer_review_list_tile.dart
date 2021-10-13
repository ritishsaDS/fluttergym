import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';

class TrainerReviewListTile extends StatelessWidget {
  const TrainerReviewListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final TrainerReview data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  data.subscriberImage,
                ),
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        data.subscriberName,
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.commentedOn,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: media.horizontalBlockSize * 3,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.horizontalBlockSize * 2,
                ),
                Row(
                  children: [
                    for (var i = 0; i < data.rating.toInt(); i++)
                      Icon(
                        Icons.star,
                        color: const Color(0xffF0CA03),
                        size: media.horizontalBlockSize * 3.5,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  data.comment,
                  style: TextStyle(fontSize: media.horizontalBlockSize * 3.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
