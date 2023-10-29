import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Screen/customer_screens/address_book.dart';
import 'package:ecommerce/Screen/customer_screens/cart_screen.dart';
import 'package:ecommerce/Screen/customer_screens/customer_orders.dart';
import 'package:ecommerce/Screen/welcome_screen.dart';
import 'package:ecommerce/Widgets/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customer_screens/wishlist.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({super.key, required this.documentId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');
    CollectionReference anonymous =
        FirebaseFirestore.instance.collection('anonymous');
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseAuth.instance.currentUser!.isAnonymous
            ? anonymous.doc(widget.documentId).get()
            : customers.doc(widget.documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.yellow, Colors.brown])),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        centerTitle: true,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        expandedHeight: 140,
                        flexibleSpace:
                            LayoutBuilder(builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(
                              duration: const Duration(microseconds: 200),
                              opacity:
                                  constraints.biggest.height <= 120 ? 1 : 0,
                              child: const Text(
                                "Account",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.yellow, Colors.brown])),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(data['profileimage']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        data['name'] == ''
                                            ? 'guest'.toUpperCase()
                                            : data['name'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30))),
                                      child: TextButton(
                                          onPressed: () {
                                            Get.to(() => const CartScreen());
                                          },
                                          child: SizedBox(
                                            child: SizedBox(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: const Center(
                                                    child: Text(
                                                  "Cart",
                                                  style: TextStyle(
                                                      color: Colors.yellow),
                                                ))),
                                          )),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                      ),
                                      child: TextButton(
                                          onPressed: () {
                                            Get.to(
                                                () => const CustomerOrders());
                                          },
                                          child: SizedBox(
                                            child: SizedBox(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: const Center(
                                                    child: Text(
                                                  "Orders",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ))),
                                          )),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight:
                                                  Radius.circular(30))),
                                      child: TextButton(
                                          onPressed: () {
                                            Get.to(
                                                () => const WishListScreen());
                                          },
                                          child: SizedBox(
                                            child: SizedBox(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: const Center(
                                                    child: Text(
                                                  "Wishlist",
                                                  style: TextStyle(
                                                      color: Colors.yellow),
                                                ))),
                                          )),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            const SizedBox(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 50,
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                                Text(
                                  "   Account Info   ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 50,
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            )),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.mail,
                                        color: Colors.grey,
                                      ),
                                      title: const Text(
                                        "Email Address",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        data['email'] == ''
                                            ? 'example@email.com'
                                            : data['email'],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.phone,
                                        color: Colors.grey,
                                      ),
                                      title: const Text(
                                        "Phone No",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        data['phone'] == ''
                                            ? 'example: +911111111'
                                            : data['phone'],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Divider(),
                                    InkWell(
                                      onTap: () {
                                        FirebaseAuth.instance.currentUser!
                                                .isAnonymous
                                            ? null
                                            : Get.to(() => const AddressBook());
                                      },
                                      child:  ListTile(
                                        leading: const Icon(
                                          Icons.location_pin,
                                          color: Colors.grey,
                                        ),
                                        title: const Text(
                                          "Address",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                         userAddress(data),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 50,
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                                Text(
                                  "   Account Setting   ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 50,
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            )),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                      title: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        "",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Divider(),
                                    const ListTile(
                                      leading: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      title: Text(
                                        "Change Password",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        "",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Divider(),
                                    InkWell(
                                      onTap: () {
                                        MyAlertDilaog.showMyDialog(
                                            context: context,
                                            title: 'Log Out',
                                            content:
                                                'Are you sure to log out ?',
                                            tabNo: () {
                                              Get.back();
                                            },
                                            tabYes: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Get.back();
                                              Get.offAll(
                                                  () => const WelcomeScreen());
                                            });
                                      },
                                      child: const ListTile(
                                        leading: Icon(
                                          Icons.logout,
                                          color: Colors.grey,
                                        ),
                                        title: Text(
                                          "Log Out",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
  String userAddress(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous == true) {
      return 'example: New Jersey - USA';
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data['address'] == '') {
      return 'Set Your Address';
    }
    return data['address'];
  }
}
