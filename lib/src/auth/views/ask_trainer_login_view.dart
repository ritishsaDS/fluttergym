import 'package:flutter/material.dart';

import '../../shared/common.dart';
import '../../splash/widgets/splash_screen_button.dart';
import 'login_view.dart';
import 'sign_up_view.dart';

class AskTrainerLoginView extends StatelessWidget {
  const AskTrainerLoginView({Key? key}) : super(key: key);

  static const routeName = '/login/trainer';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return const AskTrainerLoginView();
      },
    );
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              _buildLoginButton(context),
              const SizedBox(height: 20),
              _buildRegisterButton(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGoogleSignUpButton(context),
                  _buildFacebookSignUpButton(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SplashScreenButton(
      label: '      Sign in      ',
      onPressed: () {
        Navigator.of(context).push(LoginView.route(roleName: 'trainer'));
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SplashScreenButton(
      label: 'Register Now',
      onPressed: () {
        Navigator.of(context).push(SignUpView.route(roleName: 'trainer'));
      },
    );
  }

  Widget _buildGoogleSignUpButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {},
      child: Image.asset(
        Assets.googleSignInButton,
        width: media.size.width * 0.4,
        height: media.size.height * 0.4,
      ),
    );
  }

  Widget _buildFacebookSignUpButton(BuildContext context) {
    var media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {},
      child: Image.asset(
        Assets.facebookSignInButton,
        width: media.size.width * 0.4,
        height: media.size.height * 0.4,
      ),
    );
  }
}
