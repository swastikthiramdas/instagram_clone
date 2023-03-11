import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/colores.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/mobilescreenlayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webscreenlayout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoding = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void NavigateToSign() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void loginUser() async {
    setState(() {
      isLoding = true;
    });
    String ref = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (ref == 'Success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
                  webScreenLayout: WebScreeLayout(),
                  mobileScreeLayout: MobileScreenLayout(),
                )),
      );
    } else {
      showSnakBar(ref, context);
    }
    setState(() {
      isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              SizedBox(height: 60),
              TextFieldInput(
                hinText: 'Enter Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              SizedBox(height: 20),
              TextFieldInput(
                hinText: 'Enter Password',
                textInputType: TextInputType.text,
                isPass: true,
                textEditingController: _passwordController,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                  child: isLoding
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Text('Log in'),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              GestureDetector(
                onTap: NavigateToSign,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text('Don\'t you have a account?'),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    Container(
                      child: const Text(
                        'Sign up.',
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
