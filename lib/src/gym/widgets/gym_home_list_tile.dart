import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../views/gym_detail_view.dart';

class GymHomeListTile extends StatelessWidget {
  const GymHomeListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final Gym data;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(GymDetailView.route(gymId: data.id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(data.coverImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            style: theme.primaryTextTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.amberAccent,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${data.averageRating ?? 0}',
                          style: theme.primaryTextTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
