import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../cubit/trainer_review_list_cubit.dart';
import 'trainer_review_list_tile.dart';

class TrainerReviewListView extends StatelessWidget {
  const TrainerReviewListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainerReviewListCubit, ListState<TrainerReview>>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            return TrainerReviewListTile(state.data[index]);
          },
        );
      },
    );
  }
}
