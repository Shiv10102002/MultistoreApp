
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screen/category_screen.dart';
import 'package:ecommerce/Screen/home_screen.dart';
import 'package:ecommerce/Screen/store_screen.dart';
import 'package:ecommerce/Screen/supplier%20Screen/dashboard.dart';
import 'package:ecommerce/Screen/supplier%20Screen/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierHome extends StatefulWidget {
  const SupplierHome({super.key});

  @override
  State<SupplierHome> createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  @override
  Widget build(BuildContext context) {
    RxInt selectedindex = 0.obs;
    List tab = const [
      HomeScreen(),
      CategoryScreen(),
      StoreScreen(),
      DashboardScreen(),
      UploadProductScreen(),
    ];
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            body: Obx(() => tab[selectedindex.value]),
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w600),
                selectedItemColor: Colors.black,
                currentIndex: selectedindex.value,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Category',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.shop),
                    label: 'Stores',
                  ),
                  BottomNavigationBarItem(
                    icon: Badge(
                        isLabelVisible:
                            snapshot.data!.docs.isEmpty ? false : true,
                        padding: const EdgeInsets.all(2),
                        backgroundColor: Colors.orangeAccent,
                        label: Text(
                          snapshot.data!.docs.length.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        child: const Icon(Icons.dashboard)),
                    label: 'Dashboard',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.upload),
                    label: 'Upload',
                  ),
                ],
                onTap: (index) {
                  selectedindex.value = index;
                }),)
          );
        });
  }
}
