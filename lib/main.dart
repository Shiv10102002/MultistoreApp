import 'package:ecommerce/Screen/welcome_screen.dart';
import 'package:ecommerce/Utilites/constant.dart';
import 'package:ecommerce/Widgets/category_screen.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = stripePublishableKey;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CategoryController());
  Get.put(CartController());
  Get.put(WishController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
