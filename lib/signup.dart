import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/welcome.dart';

import '../widgets.dart';
import 'authentication.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName, _lastName, _email, _password;
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
          // The InkWell requesting focus enables that possibility that when
          // the keyboard is open you can click anywhere in the screen to dismiss it.
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Sign up and get started on tracking your daily water intake.",
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
                      children: <Widget>[
                        WaterTextFormField(
                            label: "First Name",
                            hint: "Enter your first name",
                            required: true,
                            validator: (String? input) =>
                                input == null || input.trim().isEmpty
                                    ? 'Please enter your first name'
                                    : null,
                            onSaved: (String? input) => _firstName = input,
                            onChanged: (input) {
                              _firstName = input;
                              _checkContinueStatus();
                            }),
                        WaterTextFormField(
                            label: "Last Name",
                            hint: "Enter your last name",
                            required: true,
                            validator: (String? input) =>
                                input == null || input.trim().isEmpty
                                    ? 'Please enter your last name'
                                    : null,
                            onSaved: (String? input) => _lastName = input,
                            onChanged: (input) {
                              _lastName = input;
                              _checkContinueStatus();
                            }),
                        WaterTextFormField(
                            label: "UMich Email",
                            hint: "Enter your email ending in @umich.edu",
                            required: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (input) => input != null &&
                                    !input.contains('@umich.edu')
                                ? 'Please enter an email ending in @umich.edu'
                                : null,
                            onSaved: (input) => _email = input,
                            onChanged: (input) {
                              _email = input;
                              _checkContinueStatus();
                            }),
                        WaterTextFormField(
                            label: "Create Password",
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  KTPPrimaryLargeButton(
                      text: "Continue",
                      active: _continueButtonActive,
                      onPressed: () async {
                        setState(() {
                          _isProcessing = true;
                        });
                        Map<String, String> userInfo = {
                          'firstName': _firstName!,
                          'lastName': _lastName!,
                          'email': _email!,
                          'password': _password!,
                        };
                        User? user;
                        String error = "";
                        try {
                          user = await WaterAuth.registerUsingEmailPassword(
                            userInfo: userInfo,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              getKTPWarningBanner(context,
                                  'The password provided is too weak.'),
                            );
                            error = e.code;
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              getKTPWarningBanner(context,
                                  'An account already exists for that email.'),
                            );
                            error = e.code;
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            getKTPWarningBanner(context, e.toString()),
                          );
                          error = e.toString();
                        }
                        setState(() {
                          _isProcessing = false;
                        });
                        if (user != null) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) {
                                return const WelcomePage();
                              },
                            ),
                          );
                        }
                      }),
                  const SizedBox(height: 30),
                  const KTPSignupProgressBar(completed: 0),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _goToPage(BuildContext context, Widget destination) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
    return result;
  }

  void _checkContinueStatus() {
    if (!_continueButtonActive &&
        _email != null &&
        _firstName != null &&
        _firstName!.isNotEmpty &&
        _lastName != null &&
        _lastName!.isNotEmpty &&
        _email!.isNotEmpty &&
        _password != null &&
        _password!.isNotEmpty) {
      setState(() => _continueButtonActive = true);
    } else if (_continueButtonActive &&
        (_email == null ||
            _email!.isEmpty ||
            _firstName!.isEmpty ||
            _firstName == null ||
            _lastName!.isEmpty ||
            _lastName == null ||
            _password == null ||
            _password!.isEmpty)) {
      setState(() => _continueButtonActive = false);
    }
  }
}
