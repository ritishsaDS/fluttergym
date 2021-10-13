import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../cubit/carousel_cubit.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarouselCubit(
        repository: context.read<CarouselRepository>(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: BlocBuilder<CarouselCubit, ListState<CarouselInfo>>(
        builder: (context, state) {
          return CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 16 / 6,
              autoPlay: true,
            ),
            items: [
              for (var item in state.data)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
