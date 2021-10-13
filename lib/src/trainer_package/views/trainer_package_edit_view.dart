import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_models/models.dart';
import 'package:powerdope_services/services.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../shared/common/assets.dart';
import '../../shared/widgets/gym_app_bar.dart';
import '../../subscriber/views/my_trainer_view.dart';
import '../cubit/trainer_package_list_cubit.dart';

class TrainerPackageEditView extends StatefulWidget {
  const TrainerPackageEditView({Key? key}) : super(key: key);

  static const routeName = '/trainer/package/edit';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (context) => TrainerPackageListCubit(
            repository: context.read<TrainerPackageRepository>(),
            authCubit: context.read<AuthCubit>(),
            trainerId: context.read<AuthCubit>().state.data?.id ?? 0,
          ),
          child: const TrainerPackageEditView(),
        );
      },
    );
  }

  @override
  State<TrainerPackageEditView> createState() => _TrainerPackageEditViewState();
}

class _TrainerPackageEditViewState extends State<TrainerPackageEditView> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _packageType;
  int? _packageDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Trainer Package',
        assetImage: Assets.trainerEggIcon,
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
              child: Column(
                children: [
                  _buildField(
                    context,
                    title: 'Package Name',
                    controller: _nameController,
                    textInputType: TextInputType.text,
                  ),
                  _buildField(
                    context,
                    title: 'Price',
                    controller: _priceController,
                    textInputType: TextInputType.number,
                  ),
                  _buildField(
                    context,
                    title: 'Selling Price',
                    controller: _sellingPriceController,
                    textInputType: TextInputType.number,
                  ),
                  _buildDropdownField(
                    context,
                    title: 'Package Type',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_packageType != null)
                    Slider(
                      value: _packageDurationValue(),
                      onChanged: (value) {
                        setState(() {
                          _packageDuration = value.toInt();
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor:
                          Theme.of(context).primaryColor.withOpacity(0.3),
                      label: _packageDuration.toString(),
                      divisions: 10,
                      min: 1,
                      max: _packageType == 'Days' ? 30 : 12,
                    ),
                  _buildField(
                    context,
                    title: 'Description',
                    controller: _descriptionController,
                    maxLines: 8,
                    maxLength: 150,
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
            BlocBuilder<TrainerPackageListCubit, ListState<TrainerPackage>>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    var data = state.data[index];
                    return TrainerPackageListTile(data);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    int? maxLines,
    int? maxLength,
    TextInputType? textInputType,
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
        TextField(
          minLines: 1,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String title,
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
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'Months',
              child: Text('Months'),
            ),
            DropdownMenuItem(
              value: 'Days',
              child: Text('Days'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _packageType = value;
            });
          },
        ),
      ],
    );
  }

  double _packageDurationValue() {
    if (_packageType == 'Months') {
      return (_packageDuration ?? 12).clamp(1, 12).toDouble();
    } else if (_packageType == 'Days') {
      return (_packageDuration ?? 30).clamp(1, 30).toDouble();
    }
    return 1;
  }

  void _save(BuildContext context) {
    context.read<TrainerPackageListCubit>().create(
          name: _nameController.text,
          price: int.parse(_priceController.text),
          sellingPrice: int.parse(_sellingPriceController.text),
          packageDuration: _packageDuration ?? 1,
          packageType: _packageType ?? 'Months',
          description: _descriptionController.text,
        );
  }
}
