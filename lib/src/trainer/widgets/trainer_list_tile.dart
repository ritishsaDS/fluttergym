import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';

class TrainerListTile extends StatelessWidget {
  const TrainerListTile(
    this.data, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Trainer data;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: kPrimaryAppColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(80),
                            bottomRight: Radius.circular(80),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -32,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundImage: data.profileImage != null
                              ? NetworkImage(data.profileImage!)
                              : null,
                          child: Text(
                            data.firstName.isNotEmpty
                                ? data.firstName.toUpperCase()[0]
                                : '',
                            style: theme.primaryTextTheme.headline4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          data.name,
                          style: theme.textTheme.bodyText1,
                        ),
                        Text(
                          '${data.experience ?? 0} years',
                          style: theme.textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
