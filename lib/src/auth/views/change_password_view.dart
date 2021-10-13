import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/common/assets.dart';
import '../../shared/common/extensions.dart';
import '../../shared/widgets/custom_text_field.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({
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
        return ChangePasswordView(
          roleName: roleName,
        );
      },
    );
  }

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _newPassword = TextEditingController();
  final _oldPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> gender = ['Male', 'Female', 'Others'];
  String? selectedGender = 'Male';

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
                SizedBox(
                  height: media.size.height * 0.15,
                ),
                Text(
                  'Change Password',
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
                SizedBox(
                  height: media.size.height * 0.1,
                ),
                Stack(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildOldPasswordTextField(context),
                          _buildNewPasswordTextField(context),
                          _buildConfirmPwdTextField(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildChangePasswordButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOldPasswordTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Old Password',
      iconAsset: Assets.gymIcon,
      textInputType: TextInputType.name,
      controller: _oldPassword,
    );
  }

  Widget _buildNewPasswordTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'New Password',
      iconAsset: Assets.gymIcon,
      textInputType: TextInputType.name,
      controller: _newPassword,
    );
  }

  Widget _buildConfirmPwdTextField(BuildContext context) {
    return CustomTextField(
      hintText: 'Confirm Password',
      iconAsset: Assets.gymIcon,
      textInputType: TextInputType.name,
      controller: _confirmPassword,
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return ElevatedButton(
      onPressed: () {},
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
        'Change Password',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: media.horizontalBlockSize * 4.5,
        ),
      ),
    );
  }
}
