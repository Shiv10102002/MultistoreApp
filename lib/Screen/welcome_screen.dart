import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screen/customer_screens/main_home_page.dart';
import 'package:ecommerce/Widgets/yellow_button.dart';
import 'package:ecommerce/auth/customer_login.dart';
import 'package:ecommerce/auth/customer_signup.dart';
import 'package:ecommerce/auth/supplier_login.dart';
import 'package:ecommerce/auth/supplier_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';

const textColors = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal
];

const textStyle =
    TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  RxBool processing = false.obs;
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bgimage.jpg'), fit: BoxFit.cover)),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'WELCOME',
                    textStyle: textStyle,
                    colors: textColors,
                  ),
                  ColorizeAnimatedText(
                    'Duck Store',
                    textStyle: textStyle,
                    colors: textColors,
                  )
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              const SizedBox(
                height: 120,
                width: 200,
                child: Image(image: AssetImage('assets/logo.jpg')),
              ),
              SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                      fontFamily: 'Acme'),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Buy'),
                      RotateAnimatedText('Shop'),
                      RotateAnimatedText('Duck Store'),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Suppliers only',
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // AnimatedLogo(controller: _controller),
                            YellowButton(
                                label: 'Log In',
                                onPressed: () {
                                  Get.to(() => const SupplierLogin());
                                },
                                width:
                                    MediaQuery.of(context).size.width * 0.25),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: YellowButton(
                                  label: 'Sign Up',
                                  onPressed: () {
                                    Get.to(() => const SupplierRegister());
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.25),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50))),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Customer only',
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: YellowButton(
                                  label: 'Log In',
                                  onPressed: () {
                                    Get.to(() => const CustomerLogin());
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.25),
                            ),
                            YellowButton(
                                label: 'Sign Up',
                                onPressed: () {
                                  Get.to(() => const CustomerRegister());
                                },
                                width:
                                    MediaQuery.of(context).size.width * 0.25),
                            // AnimatedLogo(controller: _controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white38.withOpacity(0.3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GoogleFacebookLogIn(
                        label: 'Google',
                        onPresssed: () {},
                        child:
                            const Image(image: AssetImage('assets/google.jpg')),
                      ),
                      GoogleFacebookLogIn(
                        label: 'Facebook',
                        onPresssed: () {},
                        child: const Image(
                            image: AssetImage('assets/facebook.jpg')),
                      ),
                      processing.value == true
                          ? const CircularProgressIndicator()
                          : GoogleFacebookLogIn(
                              label: 'Guest',
                              onPresssed: () async {
                                processing.value = true;
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  _uid = FirebaseAuth.instance.currentUser!.uid;
                                  await anonymous.doc(_uid).set({
                                    'name': '',
                                    'email': '',
                                    'profileimage': '',
                                    'phone': '',
                                    'address': '',
                                    'cid': _uid
                                  });
                                });
                                Get.off(() => const HomePage());
                              },
                              child: const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.lightBlueAccent,
                              ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(image: AssetImage('assets/logo.jpg')),
    );
  }
}

class GoogleFacebookLogIn extends StatelessWidget {
  final String label;
  final Function() onPresssed;
  final Widget child;
  const GoogleFacebookLogIn(
      {Key? key,
      required this.child,
      required this.label,
      required this.onPresssed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onPresssed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
