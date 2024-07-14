import 'package:flutter/material.dart';
import 'package:project/screens/home_view.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../provider/provider.dart';
import '../widgets/custom_text-form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  login() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      if (email.text.isEmpty) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('user not found')));
      }
      await AuthMethods().login(email: email, password: password);
      setState(() {
        isLoading = false;
      });
      UserProvider userProvider = Provider.of(context, listen: false);
      await userProvider.refreshUser();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const HomeView();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              autovalidateMode: autoValidateMode,
              child: ListView(
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/belo (1).png',
                    ),
                    height: 300,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    'Login',
                    style: TextStyle(
                      color: Color(0xff0e0554),
                      fontSize: 35,
                    ),
                  ),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  CustomTextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please Enter your Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        email.text = value ?? '';
                      },
                      icon: Icons.email_outlined,
                      controller: email,
                      hintText: 'Jhonsmith@gmail.com',
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  CustomTextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please Enter your Password';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      email.text = value ?? '';
                    },
                    icon: Icons.lock,
                    controller: password,
                    hintText: 'Password',
                    keyboardType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                    onTap: login,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff0e0554),
                          borderRadius: BorderRadius.circular(8)),
                      height: 44,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: isLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : const Text(
                        'Login now!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not yet a member?',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignUpScreen();
                              },
                            ));
                          },
                          child: const Text('Sign up now!'))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}