import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/watertracker.dart';
import 'package:water_tracker/widgets.dart';

import 'authentication.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  bool _continueButtonActive = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141b52),
      appBar: AppBar(
        backgroundColor: Color(0xff3B6ABA).withOpacity(.8),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.water_drop_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Water Tracker.",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Welcome back! Let's track your water intake today.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF999EA1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        WaterTextFormField(
                            label: "Email",
                            hint: "Enter your email",
                            required: true,
                            validator: (String? input) =>
                                input == null || input.trim().isEmpty
                                    ? 'Please enter your email'
                                    : null,
                            onSaved: (String? input) => _email = input,
                            onChanged: (input) {
                              _email = input;
                              _checkContinueStatus();
                            }),
                        WaterTextFormField(
                            label: "Password",
                            hint: "Enter your password",
                            obscureText: true,
                            required: true,
                            validator: (input) =>
                                input != null && input.length < 6
                                    ? 'Must be at least 6 characters'
                                    : null,
                            onSaved: (input) => _password = input,
                            onChanged: (input) {
                              _password = input;
                              _checkContinueStatus();
                            }),
                        SizedBox(
                          height: 50,
                        ),
                        WaterPrimaryLargeButton(
                            text: "Continue",
                            active: _continueButtonActive,
                            isProcessing: _isProcessing,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              }
                              setState(() {
                                _isProcessing = true;
                              });
                              User? user;
                              try {
                                user = await WaterAuth.signInUsingEmailPassword(
                                  email: _email!,
                                  password: _password!,
                                  context: context,
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    getKTPWarningBanner(context,
                                        'That email does not exist. Try again.'),
                                  );
                                } else if (e.code == 'wrong-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    getKTPWarningBanner(
                                        context, 'Incorrect password'),
                                  );
                                } else if (e.code == 'invalid-email') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    getKTPWarningBanner(context,
                                        'Enter email ending in @umich.edu'),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  getKTPWarningBanner(context, e.toString()),
                                );
                              }
                              setState(() {
                                _isProcessing = false;
                              });
                              if (user != null) {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return const WaterTracker();
                                    },
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkContinueStatus() {
    if (!_continueButtonActive &&
        _email != null &&
        _email!.isNotEmpty &&
        _password != null &&
        _password!.isNotEmpty) {
      setState(() => _continueButtonActive = true);
    } else if (_continueButtonActive &&
        (_email == null ||
            _email!.isEmpty ||
            _password == null ||
            _password!.isEmpty)) {
      setState(() => _continueButtonActive = false);
    }
  }
}
