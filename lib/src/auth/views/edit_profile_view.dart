import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../shared/common/assets.dart';
import '../../shared/common/constants.dart';
import '../../shared/common/extensions.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/edit/account';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return const EditProfileView();
      },
    );
  }

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _gender = ['Male', 'Female', 'Others'];
  String? _selectedGender = 'Male';
  String? _fileName;
  String? _previousImage;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    var account = context.read<AuthCubit>().state.data;
    _firstNameController.text = account?.firstName ?? '';
    _lastNameController.text = account?.lastName ?? '';
    _mobileController.text = account?.phone ?? '';
    _weightController.text = (account?.weight ?? 0).toString();
    _heightController.text = (account?.height ?? 0).toString();
    _previousImage = account?.profileImage;
    _birthDate = account?.birthDate;
    if (_birthDate != null) {
      _dobController.text = DateFormat.yMMMd().format(_birthDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Assets.loginScreenBackground,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'My Profile',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      letterSpacing: 10,
                      color: Colors.white,
                      fontSize: media.horizontalBlockSize * 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: _buildImage(media),
                ),
                Stack(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildFirstNameTextField(context),
                          _buildLastNameTextField(context),
                          _buildDobTextField(context),
                          _buildGenderTextField(context),
                          _buildMobileTextField(context),
                          _buildWeightTextField(context),
                          _buildHeightTextField(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildSaveChangesButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(MediaQueryData media) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        image: _fileName != null
            ? DecorationImage(
                image: FileImage(
                  File(_fileName!),
                ),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: NetworkImage(
                  _previousImage != null
                      ? _previousImage!
                      : 'https://via.placeholder.com/150.png?text=Image',
                ),
              ),
      ),
      width: media.size.width * 0.3,
      height: media.size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              var result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );

              if (result != null) {
                setState(() {
                  _fileName = result.files.single.path;
                });
              }
            },
            icon: const Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFirstNameTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'First name',
      iconData: Icons.person,
      textInputType: TextInputType.name,
      controller: _firstNameController,
    );
  }

  Widget _buildLastNameTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Last name',
      iconData: Icons.person,
      textInputType: TextInputType.name,
      controller: _lastNameController,
    );
  }

  Widget _buildMobileTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Phone',
      iconData: Icons.phone,
      controller: _mobileController,
    );
  }

  Widget _buildDobTextField(BuildContext context) {
    return CustomTextField(
      readOnly: true,
      hintText: 'DOB',
      iconData: Icons.date_range,
      textInputType: TextInputType.text,
      controller: _dobController,
      onTap: () async {
        var now = DateTime.now();
        var date = await showDatePicker(
          context: context,
          initialDate: now.subtract(const Duration(days: 365 * 28)),
          firstDate: now.subtract(const Duration(days: 365 * 100)),
          lastDate: now.subtract(const Duration(days: 365 * 18)),
        );
        if (date != null) {
          _dobController.text = DateFormat.yMMMd().format(date);
          _birthDate = date;
        }
      },
    );
  }

  Widget _buildGenderTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const IconButton(
            icon: ImageIcon(
              AssetImage(Assets.gymIcon),
              size: 20,
              color: Colors.white,
            ),
            onPressed: null,
            color: Colors.white,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          hintText: 'Gender',
          fillColor: kAccentAppColor.withOpacity(0.4),
          contentPadding: const EdgeInsets.only(
            left: 10,
            top: 4,
            bottom: 4,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        value: _selectedGender?.toLowerCase(),
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        selectedItemBuilder: (context) {
          return [
            for (var item in _gender)
              Text(
                item,
                style: const TextStyle(color: Colors.white),
              ),
          ];
        },
        items: _gender.map((value) {
          return DropdownMenuItem<String>(
            value: value.toLowerCase(),
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }

  Widget _buildWeightTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Weight (in Kg)',
      iconData: Icons.health_and_safety,
      textInputType: const TextInputType.numberWithOptions(decimal: true),
      controller: _weightController,
      validator: (value) {
        if (int.tryParse(value ?? '') == null) {
          return 'Weight is not in valid format';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildHeightTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Height (in cm)',
      iconData: Icons.health_and_safety,
      textInputType: const TextInputType.numberWithOptions(decimal: true),
      controller: _heightController,
      validator: (value) {
        if (int.tryParse(value ?? '') == null) {
          return 'Height is not in valid format';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildSaveChangesButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return ElevatedButton(
      onPressed: () async {
        var saved = await context.read<AuthCubit>().update(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              dob: _birthDate ?? DateTime.now(),
              gender: _selectedGender?.toLowerCase() ?? 'male',
              mobile: _mobileController.text,
              weight: int.tryParse(_weightController.text),
              height: double.tryParse(_heightController.text),
              image: _fileName,
            );
        if (saved) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        ),
      ),
      child: Text(
        'Save Changes',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: media.horizontalBlockSize * 4.5,
        ),
      ),
    );
  }
}
