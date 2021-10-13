import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';

class SubscriberHomeListTile extends StatelessWidget {
  const SubscriberHomeListTile(
    this.data, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  final SubscribedUser data;

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
                          foregroundImage: data.userImage != null
                              ? NetworkImage(data.userImage!)
                              : null,
                          child: Text(
                            data.userName.isNotEmpty
                                ? data.userName.toUpperCase()[0]
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
                          data.userName,
                          style: theme.textTheme.bodyText1,
                        ),
                        Text(
                          'Age: ${data.age ?? 18}',
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
