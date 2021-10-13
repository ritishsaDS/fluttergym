import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';
import '../cubit/gym_package_list_cubit.dart';

class GymPackageListView extends StatefulWidget {
  const GymPackageListView({
    this.onSelected,
    Key? key,
  }) : super(key: key);

  final ValueChanged<GymPackage>? onSelected;

  @override
  _GymPackageListViewState createState() => _GymPackageListViewState();
}

class _GymPackageListViewState extends State<GymPackageListView> {
  var _selected = -1;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return BlocBuilder<GymPackageListCubit, ListState<GymPackage>>(
      builder: (context, state) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 150,
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(1),
              child: InkWell(
                splashColor: Colors.white,
                onTap: () {
                  setState(() => _selected = index);
                  widget.onSelected?.call(state.data[index]);
                },
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selected == index
                        ? kPrimaryAppColor
                        : kPrimaryAppColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.data[index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: media.horizontalBlockSize * 3,
                      color: _selected == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
