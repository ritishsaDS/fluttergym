import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';
import '../views/gym_detail_view.dart';

class GymListTile extends StatelessWidget {
  const GymListTile(this.data, {Key? key}) : super(key: key);

  final Gym data;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(GymDetailView.route(gymId: data.id));
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: media.size.width,
                height: media.verticalBlockSize * 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data.coverImage,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: media.horizontalBlockSize * 3.5,
                      ),
                    ),
                    Text(
                      'Rating ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: media.horizontalBlockSize * 3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Location, ${data.city} ',
                      style: TextStyle(
                        fontSize: media.horizontalBlockSize * 3,
                      ),
                    ),
                    Text(
                      data.averageRating?.toStringAsFixed(1) ?? '0',
                      style: TextStyle(
                        fontSize: media.horizontalBlockSize * 3,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
