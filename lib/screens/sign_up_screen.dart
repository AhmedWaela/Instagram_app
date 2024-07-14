
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../methods/auth_methods.dart';
import '../methods/storages_methods.dart';
import '../widgets/custom_text-form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  Uint8List? image;
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    username.dispose();
  }

  selectImage() async {
    Uint8List file = await StoragesMethods().pickImage(ImageSource.gallery);
    setState(() {
      image = file;
    });
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
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xff0e0554),
                      fontSize: 35,
                    ),
                  ),
                  image == null
                      ? Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffdddbde),
                        borderRadius: BorderRadius.circular(8)),
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upload),
                        TextButton(
                            onPressed: () {
                              selectImage();
                            },
                            child: const Text('Upload your photo'))
                      ],
                    ),
                  )
                      : Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: MemoryImage(image!))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  CustomTextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please Enter your Username';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        username.text = value ?? '';
                      },
                      icon: Icons.person,
                      controller: username,
                      hintText: 'Username',
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 10,
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
                    'Create Password',
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
                    height: 10,
                  ),
                  const Text(
                    'Must be at least 6 characters',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (formKey.currentState!.validate() && image != null) {
                        if (!email.text.endsWith('@gmail.com')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid Email')));
                          setState(() {
                            isLoading = false;
                          });
                        } else if (password.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('weak password')));
                          setState(() {
                            isLoading = false;
                          });
                        }
                        await AuthMethods().signUp(
                            email: email,
                            password: password,
                            username: username,
                            image: image!);
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('success')));
                        setState(() {
                          image = null;
                          email.clear();
                          username.clear();
                          password.clear();
                        });
                      } else {
                        if (!formKey.currentState!.validate()) {
                          autoValidateMode = AutovalidateMode.always;
                        } else if (image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('select image')));
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff0e0554),
                          borderRadius: BorderRadius.circular(8)),
                      height: 44,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: !isLoading
                          ? const Text(
                        'Sign Up now!',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member?',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Sign in now!'))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}