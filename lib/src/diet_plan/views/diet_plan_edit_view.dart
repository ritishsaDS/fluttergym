import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../subscriber/views/my_trainer_view.dart';
import '../cubit/diet_plan_list_cubit.dart';

class DietPlanEditView extends StatefulWidget {
  const DietPlanEditView({Key? key}) : super(key: key);

  static const routeName = '/dietPlan/edit';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => DietPlanListCubit(
            repository: context.read<DietPlanRepository>(),
            authCubit: context.read<AuthCubit>(),
          ),
          child: const DietPlanEditView(),
        );
      },
    );
  }

  @override
  State<DietPlanEditView> createState() => _DietPlanEditViewState();
}

class _DietPlanEditViewState extends State<DietPlanEditView> {
  final _nameController = TextEditingController();
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Diet Plan',
        assetImage: Assets.dietPlanEggIcon,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
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
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: media.horizontalBlockSize * 10,
                      horizontal: media.horizontalBlockSize * 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      image: _fileName != null && !_fileName!.endsWith('pdf')
                          ? DecorationImage(
                              image: FileImage(
                                File(_fileName!),
                              ),
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                var result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'pdf',
                                    'jpg',
                                    'png',
                                  ],
                                );

                                if (result != null) {
                                  setState(() {
                                    _fileName = result.files.single.path;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  kPrimaryAppColor,
                                ),
                              ),
                              child: Text(
                                '  from Phone  ',
                                style: TextStyle(
                                  fontSize: media.horizontalBlockSize * 3,
                                ),
                              ),
                            ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     throw UnimplementedError();
                            //   },
                            //   style: ButtonStyle(
                            //     backgroundColor: MaterialStateProperty.all(
                            //       kPrimaryAppColor,
                            //     ),
                            //   ),
                            //   child: Text(
                            //     'from Diet Plan',
                            //     style: TextStyle(
                            //       fontSize: media.horizontalBlockSize * 3,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Diet Plan Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    minLines: 1,
                    controller: _nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isSaving ? null : () => _save(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kPrimaryAppColor,
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
                    child: Text(_isSaving ? 'Saving' : 'Save Now'),
                  ),
                ],
              ),
            ),
            BlocBuilder<DietPlanListCubit, ListState<DietPlan>>(
              builder: (context, state) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    var data = state.data[index];
                    return TrainerDietExerciseCard(
                      title: data.name,
                      subtitle: 'Basic Diet Plan',
                      fileName: data.coverImage,
                      showThirdSubtitle: false,
                      bottomButtonTitle: 'Delete',
                      enableDownloadButton: true,
                      bottomButtonFuntion: () {
                        context
                            .read<DietPlanListCubit>()
                            .delete(data.dietPlanId);
                      },
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

  var _isSaving = false;
  void _save(BuildContext context) {
    setState(() {
      _isSaving = true;
    });

    context
        .read<DietPlanListCubit>()
        .create(name: _nameController.text, fileName: _fileName)
        .then((value) {
      _isSaving = false;
      if (mounted) {
        setState(() {
          _nameController.clear();
          _fileName = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your diet plan is uploaded.'),
          ),
        );
      }
    });
  }
}
