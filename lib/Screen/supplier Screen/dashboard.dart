import 'package:ecommerce/MinorScreen/visit_store.dart';
import 'package:ecommerce/Screen/supplier%20Screen/dashboard_components/edit_business.dart';
import 'package:ecommerce/Screen/supplier%20Screen/dashboard_components/supplier_orders.dart';
import 'package:ecommerce/Screen/welcome_screen.dart';
import 'package:ecommerce/Widgets/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_components/manage_products.dart';
import 'dashboard_components/supplier_balance.dart';
import 'dashboard_components/supplier_statics.dart';

List<String> label = [
  'My Store',
  'Orders',
  'edit Profile',
  'manage product',
  'balance',
  'static'
];
List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings_accessibility,
  Icons.attach_money,
  Icons.show_chart
];
List<Widget> pages = [
  VisitStoreScreen(storeid: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
   ManageProducts(),
  const Balance(),
  const Statics()
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
              onPressed: () {
                MyAlertDilaog.showMyDialog(
                    context: context,
                    title: 'Log Out',
                    content: 'Are you sure to log out ?',
                    tabNo: () {
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      await FirebaseAuth.instance.signOut();

                      Get.offAll(() => const WelcomeScreen());
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                Get.to(() => pages[index]);
              },
              child: Card(
                shadowColor: Colors.greenAccent,
                elevation: 20,
                color: Colors.blueGrey.withOpacity(0.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      color: Colors.orangeAccent,
                      size: 50,
                    ),
                    Text(
                      label[index],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
