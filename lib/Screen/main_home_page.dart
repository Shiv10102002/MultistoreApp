import 'package:ecommerce/Screen/cart_screen.dart';
import 'package:ecommerce/Screen/category_screen.dart';
import 'package:ecommerce/Screen/home_screen.dart';
import 'package:ecommerce/Screen/profile_screen.dart';
import 'package:ecommerce/Screen/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt _selectedindex = 0.obs;
    List tab = [
      HomeScreen(),
      CategoryScreen(),
      StoreScreen(),
      CartScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          currentIndex: _selectedindex.value,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Category",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: "Stores",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          onTap: (index) {
            _selectedindex.value = index;
          }),),
          body: Obx(() => tab[_selectedindex.value],),
    );
  }
}
