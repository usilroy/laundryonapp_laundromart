import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:laundryonapp_laundromat/API_calls/auth_service.dart';
import 'package:laundryonapp_laundromat/Models/authData.dart';
import 'package:laundryonapp_laundromat/Models/authResponse.dart';
import 'package:laundryonapp_laundromat/Provider/authData_provider.dart';

import 'package:laundryonapp_laundromat/Screens/dashboard_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  _login() async {
    if (_loginformKey.currentState!.validate()) {
      _loginformKey.currentState!.save();

      AuthData? responseAuthData =
          await authenticateUser(_enteredEmail, _enteredPassword, ref);

      if (responseAuthData != null) {
        ref.read(authDataProvider.notifier).setAuthData(responseAuthData);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFFD7F0FF)),
                    height: screenHeight * 0.45,
                  ),
                  Positioned(
                    width: 154,
                    right: 0,
                    top: 32,
                    child: Image.asset(
                      'assets/bubbles.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/laundryonapp_logo.svg'),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Laundromat Login',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Please enter your details',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                  const Gap(64),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E5E5),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(25, 0, 0, 0),
                              blurRadius: 25,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 32),
                          child: Form(
                            key: _loginformKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Email / Username',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                                const Gap(8),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child:
                                          SvgPicture.asset('assets/mail.svg'),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                38, 16, 16, 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E5E5),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredEmail = value!;
                                      },
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                Text(
                                  'Password',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                                const Gap(8),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/password.svg'),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.visibility_off),
                                            ),
                                          ],
                                        )),
                                    TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                38, 16, 16, 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E5E5),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      autocorrect: false,
                                      onSaved: (value) {
                                        _enteredPassword = value!;
                                      },
                                    ),
                                  ],
                                ),
                                const Gap(16),
                                Row(
                                  children: [
                                    Text(
                                      'Forgot password?',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xFF6A6C71),
                                      ),
                                    ),
                                    const Gap(3),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0.0),
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      onPressed: () {},
                                      child: Text(
                                        'Reset it',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF2A2D34),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4C95EF),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: _login,
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account?',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xFF6A6C71),
                                      ),
                                    ),
                                    const Gap(3),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0.0),
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      onPressed: () {},
                                      child: Text(
                                        'Register Now',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF409CFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
