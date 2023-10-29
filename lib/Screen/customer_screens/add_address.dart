import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phone;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';
  late String pincode;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
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
            centerTitle: false,
            title: const Text(
              'Add Address',
              style: TextStyle(color: Colors.black),
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 40, 30, 40),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter your first name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  firstName = value!;
                                },
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'First Name',
                                  hintText: 'Enter your first Name',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter your last name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  lastName = value!;
                                },
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'Last Name',
                                  hintText: 'Enter your last Name',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter your phone';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  phone = value!;
                                },
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'Phone',
                                  hintText: 'Enter your phone',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: SelectState(
                                // style: TextStyle(color: Colors.red),
                                onCountryChanged: (value) {
                                  setState(() {
                                    countryValue = value;
                                  });
                                },
                                onStateChanged: (value) {
                                  setState(() {
                                    stateValue = value;
                                  });
                                },
                                onCityChanged: (value) {
                                  setState(() {
                                    cityValue = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter pin code';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  pincode = value!;
                                },
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'pincode',
                                  hintText: 'Enter your pincode',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SelectState(
                    //   // style: TextStyle(color: Colors.red),
                    //   onCountryChanged: (value) {
                    //     setState(() {
                    //       countryValue = value;
                    //     });
                    //   },
                    //   onStateChanged: (value) {
                    //     setState(() {
                    //       stateValue = value;
                    //     });
                    //   },
                    //   onCityChanged: (value) {
                    //     setState(() {
                    //       cityValue = value;
                    //     });
                    //   },
                    // ),
                    Center(
                      child: ElevatedButton(
                        child: Text('Add New Address'),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (countryValue != 'Choose Country' &&
                                stateValue != 'Choose State' &&
                                cityValue != 'Choose City') {
                              formKey.currentState!.save();
                              CollectionReference addressRef = FirebaseFirestore
                                  .instance
                                  .collection('customers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('address');
                              var addressId = const Uuid().v4();
                              await addressRef.doc(addressId).set({
                                'addressid': addressId,
                                'firstname': firstName,
                                'lastname': lastName,
                                'phone': phone,
                                'country': countryValue,
                                'state': stateValue,
                                'city': cityValue,
                                'pincode': pincode,
                                'default': true
                              }).whenComplete(() => Navigator.pop(context));
                            } else {
                              Get.snackbar('error', 'please set your location');
                            }
                          } else {
                            Get.snackbar('error', 'please fill all fields');
                          }
                        },
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 1),
      borderRadius: BorderRadius.circular(25)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      borderRadius: BorderRadius.circular(25)),
);
