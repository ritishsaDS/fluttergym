import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/common.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/google_sign_in_button.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({
    required this.roleName,
    Key? key,
  }) : super(key: key);

  static const routeName = '/signup';

  final String roleName;

  static Route<void> route({
    required String roleName,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return SignUpView(
          roleName: roleName,
        );
      },
    );
  }

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _firstNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Welcome',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sawarabiMincho(
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
                      Stack(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildFirstNameTextField(context),
                                _buildUserNameTextField(context),
                                _buildEmailTextField(context),
                                _buildMobileTextField(context),
                                _buildPasswordTextField(context),
                                _buildConfirmPasswordTextField(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildRegisteredButton(context),
                      _buildAlreadyHaveAccount(context),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGoogleSignUpButton(context),
                    _buildFacebookSignUpButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Name',
      iconData: Icons.person,
      textInputType: TextInputType.name,
      controller: _firstNameController,
    );
  }

  Widget _buildUserNameTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Username',
      iconData: Icons.verified_user,
      textInputType: TextInputType.text,
      controller: _userNameController,
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Email',
      iconData: Icons.email,
      textInputType: TextInputType.emailAddress,
      controller: _emailController,
    );
  }

  Widget _buildMobileTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Phone',
      iconData: Icons.phone,
      controller: _phoneController,
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Password',
      iconData: Icons.password,
      textInputType: TextInputType.visiblePassword,
      controller: _passwordController,
    );
  }

  Widget _buildConfirmPasswordTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Confirm password',
      iconData: Icons.password,
      textInputType: TextInputType.visiblePassword,
      controller: _confirmPasswordController,
    );
  }

  // Widget _buildGenderTextField(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  //     child: DropdownButtonFormField<String>(
  //       decoration: InputDecoration(
  //         filled: true,
  //         prefixIcon: const IconButton(
  //           icon: ImageIcon(
  //             AssetImage(Assets.gymIcon),
  //             size: 20,
  //             color: Colors.white,
  //           ),
  //           onPressed: null,
  //           color: Colors.white,
  //         ),
  //         hintStyle: const TextStyle(color: Colors.white),
  //         hintText: 'Gender',
  //         fillColor: kAccentAppColor.withOpacity(0.4),
  //         contentPadding: const EdgeInsets.only(
  //           left: 10,
  //           top: 4,
  //           bottom: 4,
  //         ),
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         border: const OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //         enabledBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //         focusedBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //       ),
  //       value: selectedGender,
  //       dropdownColor: Colors.white,
  //       iconEnabledColor: Colors.white,
  //       //style: const TextStyle(color: Colors.white),
  //       items: gender.map((value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(
  //             value,
  //             style: const TextStyle(color: Colors.black),
  //           ),
  //         );
  //       }).toList(),
  //       onChanged: (newValue) {
  //         setState(() {
  //           selectedGender = newValue;
  //         });
  //       },
  //     ),
  //   );
  // }

  // Widget _buildWeightTextField(BuildContext context) {
  //   return CustomTextField(
  //     hintText: 'Weight',
  //     iconAsset: Assets.gymIcon,
  //     textInputType: const TextInputType.numberWithOptions(decimal: true),
  //     controller: _weightController,
  //   );
  // }

  // Widget _buildHeightTextField(BuildContext context) {
  //   return CustomTextField(
  //     hintText: 'Height',
  //     iconAsset: Assets.gymIcon,
  //     textInputType: const TextInputType.numberWithOptions(decimal: true),
  //     controller: _heightController,
  //   );
  // }

  // Widget _buildImageTextField(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  //     child: TextFormField(
  //       textInputAction: TextInputAction.next,
  //       controller: _imageController,
  //       style: const TextStyle(color: Colors.white),
  //       decoration: InputDecoration(
  //         filled: true,
  //         prefixIcon: const IconButton(
  //           icon: ImageIcon(
  //             AssetImage(Assets.gymIcon),
  //             size: 20,
  //             color: Colors.white,
  //           ),
  //           onPressed: null,
  //           color: Colors.white,
  //         ),
  //         suffixIcon: Padding(
  //           padding: const EdgeInsets.all(8),
  //           child: Container(
  //             width: 80,
  //             height: 10,
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //             child: const Text(
  //               'Image',
  //               style: TextStyle(color: Colors.black),
  //             ),
  //           ),
  //         ),
  //         hintStyle: const TextStyle(color: Colors.white),
  //         hintText: 'Image',
  //         fillColor: kAccentAppColor.withOpacity(0.4),
  //         contentPadding: const EdgeInsets.only(
  //           left: 10,
  //           top: 4,
  //           bottom: 4,
  //         ),
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         border: const OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //         enabledBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //         focusedBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.all(Radius.circular(30)),
  //         ),
  //       ),
  //       cursorColor: Colors.white,
  //     ),
  //   );
  // }

  Widget _buildRegisteredButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return ElevatedButton(
      onPressed: () async {
        try {
          await context.read<AuthCubit>().register(
                role: widget.roleName,
                name: _firstNameController.text,
                userName: _userNameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text,
              );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Thank you for joining Power Dope. Please sign in again.',
                ),
              ),
            );
            Navigator.of(context).pop();
          }
        } on HttpException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message)),
          );
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
        'Register Now',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: media.horizontalBlockSize * 4.5,
        ),
      ),
    );
  }

  Widget _buildAlreadyHaveAccount(BuildContext context) {
    var media = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have account',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: media.horizontalBlockSize * 3,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(LoginView.route(roleName: widget.roleName));
          },
          child: Text(
            'Login Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: media.horizontalBlockSize * 3.5,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGoogleSignUpButton(BuildContext context) {
    return const GoogleSignInButton();
  }

  Widget _buildFacebookSignUpButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        throw UnimplementedError();
      },
      child: Image.asset(
        Assets.facebookSignInButton,
        width: media.size.width * 0.4,
      ),
    );
  }
}
