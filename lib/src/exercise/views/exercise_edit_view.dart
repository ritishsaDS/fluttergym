import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common/assets.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../cubit/exercise_list_cubit.dart';
import '../widgets/exercise_list_tile.dart';

class ExerciseEditView extends StatefulWidget {
  const ExerciseEditView({Key? key}) : super(key: key);

  static const routeName = '/exercise/edit';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => ExerciseListCubit(
            repository: context.read<ExerciseRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const ExerciseEditView(),
        );
      },
    );
  }

  @override
  State<ExerciseEditView> createState() => _ExerciseEditViewState();
}

class _ExerciseEditViewState extends State<ExerciseEditView> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _detailsControler = TextEditingController();
  final _timeController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Exercise Video',
        assetImage: Assets.videoEggIcon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildField(
                      context,
                      title: 'YouTube Link',
                      controller: _urlController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a YouTube video link';
                        }
                        return null;
                      },
                    ),
                    _buildField(
                      context,
                      title: 'Exercise Name',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a exercise name';
                        }
                        return null;
                      },
                    ),
                    _buildField(
                      context,
                      title: 'Repetition Description',
                      controller: _detailsControler,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a repetition description';
                        }
                        return null;
                      },
                    ),
                    _buildField(
                      context,
                      title: 'Rest Time Description',
                      controller: _timeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a rest time description';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _save(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor,
                        ),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 70),
                        ),
                      ),
                      child: const Text('Save Now'),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ExerciseListCubit, ListState<Exercise>>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.data.length,
                  primary: false,
                  itemBuilder: (context, index) {
                    var data = state.data[index];
                    return ExerciseListTile(
                      data,
                      buttons: [
                        IconButton(
                          onPressed: () {
                            context
                                .read<ExerciseListCubit>()
                                .delete(data.exerciseId);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(title),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          minLines: 1,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          validator: validator,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void _save(BuildContext context) {
    context.read<ExerciseListCubit>().create(
          url: _urlController.text,
          name: _nameController.text,
          details: _detailsControler.text,
          restTime: _timeController.text,
          fileName: _fileName,
        );
  }
}
