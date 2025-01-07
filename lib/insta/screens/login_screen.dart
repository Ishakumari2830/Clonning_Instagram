import 'package:auth/insta/screens/Signup_screen.dart';
import 'package:auth/resources/auth_method.dart';
import 'package:auth/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
import '../../utils/colors.dart';
import '../../widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _PassController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();

    _emailController.dispose();
    _PassController.dispose();
  }

  void loginUser() async {
    setState(() {

      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _PassController.text);
    if(res == "success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
      const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),)
      ),);
    }
    else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //svg image
            SvgPicture.asset(
              'assets/insta.svg',
              color: primaryColor,
              height: 64,
            ),

            const SizedBox(
              height: 64,
            ),

            ///text field for email
            TextFieldInput(
                textEditingController: _emailController,
                hinttext: "Enter Your E-mail",
                textInputType: TextInputType.emailAddress),

            const SizedBox(height: 24,),

            ///textfield input for password
            TextFieldInput(
                textEditingController: _PassController,
                hinttext: "Enter Your password",
                isPass: true,
                textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24,),
            ///button login
            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                color: blueColor),
                child: _isLoading ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ) :const Text('Log In'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),

            ///transition to sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: const Text("Don't have an account ? "),

                ),
                GestureDetector(
                  onTap: navigateToSignup,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: const Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold),),

                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
