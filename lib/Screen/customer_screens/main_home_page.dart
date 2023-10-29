import 'package:ecommerce/Screen/customer_screens/cart_screen.dart';
import 'package:ecommerce/Screen/category_screen.dart';
import 'package:ecommerce/Screen/home_screen.dart';
import 'package:ecommerce/Screen/profile_screen.dart';
import 'package:ecommerce/Screen/store_screen.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt selectedindex = 0.obs;
    List tab = [
      const HomeScreen(),
      const CategoryScreen(),
      const StoreScreen(),
      const CartScreen(),
      ProfileScreen(
        documentId: FirebaseAuth.instance.currentUser!.uid,
      )
    ];
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            currentIndex: selectedindex.value,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Category",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: "Stores",
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: GetBuilder<CartController>(
                    builder: (cart) {
                      return Text(cart.count.toString());
                    },
                  ),
                  child: const Icon(Icons.shopping_cart_checkout),
                ),
                label: "Cart",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            onTap: (index) {
              selectedindex.value = index;
            }),
      ),
      body: Obx(
        () => tab[selectedindex.value],
      ),
    );
  }
}
