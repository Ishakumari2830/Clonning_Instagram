
import 'dart:typed_data';

import 'package:auth/insta/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/auth_method.dart';
import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _PassController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _PassController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_image == null) {
      print('Please select an image');
      return;
    }

    String res = await AuthMethods().signUpUser(
      email: _emailController.text.trim(),
      password: _PassController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      file: _image!,

    );
    setState(() {
      _isLoading = false;
    });

    if (res != "Success") {
      showSnackBar(res, context);
      // Navigate to the home screen or show success message
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
      const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),)
      ),);
    }


  }
  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }




 @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        SvgPicture.asset(
                          'assets/insta.svg',
                          color: primaryColor,
                          height: 64,
                        ),
                        const SizedBox(height: 24),
                        Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                                : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6LXNJFTmLzCoExghcATlCWG85kI8dsnhJng&s",
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFieldInput(
                          textEditingController: _usernameController,
                          hinttext: "Enter Your UserName",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        TextFieldInput(
                          textEditingController: _emailController,
                          hinttext: "Enter Your E-mail",
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        TextFieldInput(
                          textEditingController: _PassController,
                          hinttext: "Enter Your password",
                          isPass: true,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        TextFieldInput(
                          textEditingController: _bioController,
                          hinttext: "Enter Your bio",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: signUpUser,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4)),
                              ),
                              color: blueColor,
                            ),
                            child : _isLoading ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ) : const Text("Sign up"),
                            //child: const Text('Sign Up'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: navigateToLogin,
                              child: const Text(
                                "Login",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}