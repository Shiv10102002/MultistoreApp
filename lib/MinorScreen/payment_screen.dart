// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  const PaymentScreen(
      {Key? key,
      required this.name,
      required this.phone,
      required this.address})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  RxInt selectedValue = RxInt(1);

  late String orderId;

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait ..', progressBgColor: Colors.red);
  }

  CartController cartcontroller = Get.find();

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Get.back();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Successfull'),
            actions: [
              ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    for (var item in cartcontroller.getItems) {
                      CollectionReference orderRef =
                          FirebaseFirestore.instance.collection('orders');
                      orderId = const Uuid().v4();
                      await orderRef.doc(orderId).set({
                        'cid': FirebaseAuth.instance.currentUser!.uid,
                        'custname': widget.name,
                        'email': FirebaseAuth.instance.currentUser!.email,
                        'address': widget.address,
                        'phone': widget.phone,
                        'profileimage':
                            FirebaseAuth.instance.currentUser!.photoURL,
                        'sid': item.suppId,
                        'proid': item.documentId,
                        'orderid': orderId,
                        'ordername': item.name,
                        'orderimage': item.imagesUrl.first,
                        'orderqty': item.qty,
                        'orderprice': item.qty * item.price,
                        'deliverystatus': 'preparing',
                        'deliverydate': '',
                        'orderdate': DateTime.now(),
                        'paymentstatus': 'cash on delivery',
                        'orderreview': false,
                      }).whenComplete(() async {
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(item.documentId);
                          DocumentSnapshot snapshot2 =
                              await transaction.get(documentReference);
                          transaction.update(documentReference,
                              {'instock': snapshot2['instock'] - item.qty});
                        });
                      });
                    }
                    cartcontroller.clearCart();
                    Get.until((route) => route.isFirst);
                  }),
            ],
          );
        });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showAlertDialog(context, "paymentstatus", "failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showAlertDialog(context, "paymentstatus", "failed");
  }

  var _razorpay = Razorpay();

  Future<void> razorpayPayment(double totalpaid) async {
    var options = {
      'key': 'rzp_test_TlKhx8W1VjXtVC',
      'amount': 100 * totalpaid,
      'name': 'Ecommerce',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8539838633', 'email': 'nikeshiv2050@gmail.com'},
      'timeout': 200,
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartcontroller.totalPrice;
    double totalPaid = cartcontroller.totalPrice + 10;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    title: const Text(
                      "Payment",
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: false,
                  ),
                  body: GetBuilder<CartController>(
                    builder: (cart) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '${totalPaid.toStringAsFixed(2)} USD',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total order',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Text(
                                          '${totalPrice.toStringAsFixed(2)} USD',
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Shipping Coast',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Text(
                                          '10.00 USD',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Obx(
                                  () => Column(
                                    children: [
                                      RadioListTile(
                                        value: 1,
                                        groupValue: selectedValue.value,
                                        onChanged: (int? value) {
                                          selectedValue.value = value!;
                                        },
                                        title: const Text('Cash On Delivery'),
                                        subtitle:
                                            const Text('Pay Cash At Home'),
                                      ),
                                      RadioListTile(
                                        value: 2,
                                        groupValue: selectedValue.value,
                                        onChanged: (int? value) {
                                          selectedValue.value = value!;
                                        },
                                        title: const Text('Online Payment'),
                                        subtitle: const Row(
                                          children: [
                                            Icon(Icons.payment,
                                                color: Colors.blue),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: Icon(
                                                  FontAwesomeIcons.ccMastercard,
                                                  color: Colors.blue),
                                            ),
                                            Icon(FontAwesomeIcons.ccVisa,
                                                color: Colors.blue)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: MaterialButton(
                          color: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'Confirm $totalPaid USD',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          onPressed: () async {
                            if (selectedValue.value == 1) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 50),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'Pay At Home ${totalPaid.toStringAsFixed(2)} \$',
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    onPressed: () async {
                                                      showProgress();
                                                      for (var item
                                                          in cartcontroller
                                                              .getItems) {
                                                        CollectionReference
                                                            orderRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders');
                                                        orderId =
                                                            const Uuid().v4();
                                                        await orderRef
                                                            .doc(orderId)
                                                            .set({
                                                          'cid': data['cid'],
                                                          'custname':
                                                              widget.name,
                                                          'email':
                                                              data['email'],
                                                          'address':
                                                              widget.address,
                                                          'phone': widget.phone,
                                                          'profileimage': data[
                                                              'profileimage'],
                                                          'sid': item.suppId,
                                                          'proid':
                                                              item.documentId,
                                                          'orderid': orderId,
                                                          'ordername':
                                                              item.name,
                                                          'orderimage': item
                                                              .imagesUrl.first,
                                                          'orderqty': item.qty,
                                                          'orderprice':
                                                              item.qty *
                                                                  item.price,
                                                          'deliverystatus':
                                                              'preparing',
                                                          'deliverydate': '',
                                                          'orderdate':
                                                              DateTime.now(),
                                                          'paymentstatus':
                                                              'cash on delivery',
                                                          'orderreview': false,
                                                        }).whenComplete(
                                                                () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .runTransaction(
                                                                  (transaction) async {
                                                            DocumentReference
                                                                documentReference =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'products')
                                                                    .doc(item
                                                                        .documentId);
                                                            DocumentSnapshot
                                                                snapshot2 =
                                                                await transaction
                                                                    .get(
                                                                        documentReference);
                                                            transaction.update(
                                                                documentReference,
                                                                {
                                                                  'instock':
                                                                      snapshot2[
                                                                              'instock'] -
                                                                          item.qty
                                                                });
                                                          });
                                                        });
                                                      }
                                                      cartcontroller
                                                          .clearCart();
                                                      Get.until((route) =>
                                                          route.isFirst);
                                                    },
                                                    color: Colors.orangeAccent,
                                                    child: Text(
                                                      'Confirm $totalPaid USD',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ));
                            } else {
                              razorpayPayment(
                                totalPaid,
                              );

                              // for (var item in cartcontroller.getItems) {
                              //   CollectionReference orderRef = FirebaseFirestore
                              //       .instance
                              //       .collection('orders');
                              //   orderId = const Uuid().v4();
                              //   await orderRef.doc(orderId).set({
                              //     'cid': data['cid'],
                              //     'custname': data['name'],
                              //     'email': data['email'],
                              //     'address': data['address'],
                              //     'phone': data['phone'],
                              //     'profileimage': data['profileimage'],
                              //     'sid': item.suppId,
                              //     'proid': item.documentId,
                              //     'orderid': orderId,
                              //     'ordername': item.name,
                              //     'orderimage': item.imagesUrl.first,
                              //     'orderqty': item.qty,
                              //     'orderprice': item.qty * item.price,
                              //     'deliverystatus': 'preparing',
                              //     'deliverydate': '',
                              //     'orderdate': DateTime.now(),
                              //     'paymentstatus': 'cash on delivery',
                              //     'orderreview': false,
                              //   }).whenComplete(() async {
                              //     await FirebaseFirestore.instance
                              //         .runTransaction((transaction) async {
                              //       DocumentReference documentReference =
                              //           FirebaseFirestore.instance
                              //               .collection('products')
                              //               .doc(item.documentId);
                              //       DocumentSnapshot snapshot2 =
                              //           await transaction
                              //               .get(documentReference);
                              //       transaction.update(documentReference, {
                              //         'instock': snapshot2['instock'] - item.qty
                              //       });
                              //     });
                              //   });
                              // }
                              // cartcontroller.clearCart();
                              // Get.until((route) => route.isFirst);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }
}
