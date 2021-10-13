import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powerdope_models/models.dart';

import '../../shared/common.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../splash/widgets/splash_screen_button.dart';
import '../cubit/auth_cubit.dart';
import 'sign_up_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    required this.roleName,
    Key? key,
  }) : super(key: key);

  static const routeName = '/login';

  final String roleName;

  static Route<void> route({
    required String roleName,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return LoginView(
          roleName: roleName,
        );
      },
    );
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 15),
                Text(
                  'POWER \nDOPE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sawarabiMincho(
                    textStyle: const TextStyle(
                      letterSpacing: 10,
                      color: Colors.white,
                      fontSize: kTextSizeXXLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 82),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildUserNameField(context),
                      _buildPasswordField(context),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                _buildSignInButton(context),
                _buildNoAccountButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserNameField(BuildContext context) {
    return CustomTextField(
      hintText: 'Email',
      iconAsset: Assets.userNameIcon,
      textInputType: TextInputType.emailAddress,
      controller: _emailController,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      hintText: 'Password',
      iconAsset: Assets.passwordIcon,
      textInputType: TextInputType.visiblePassword,
      controller: _passwordController,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return BlocListener<AuthCubit, DetailState<Account>>(
      listener: (context, state) {
        if (state is DetailFailure<Account>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? '')),
          );
        }
      },
      child: SplashScreenButton(
        label: 'Sign in',
        onPressed: () {
          var email = _emailController.text;
          var password = _passwordController.text;
          context.read<AuthCubit>().login(email: email, password: password);
        },
      ),
    );
  }

  Widget _buildNoAccountButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: media.horizontalBlockSize * 3,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              SignUpView.route(roleName: widget.roleName),
            );
          },
          child: Text(
            'Register Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: media.horizontalBlockSize * 3.5,
            ),
          ),
        )
      ],
    );
  }
}
