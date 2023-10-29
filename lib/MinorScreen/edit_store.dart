// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({Key? key, required this.data}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic _pickedImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  final ImagePicker _picker = ImagePicker();

  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickedCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileCover = pickedCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFileLogo!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg-cover');

        await ref2.putFile(File(imageFileCover!.path));

        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async =>
          await uploadCoverImage().whenComplete(() => editStoreData()));
    } else {
      Get.snackbar("Error", "Please fill all field");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon:const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title:const Text(
               'edit store',style: TextStyle(color: Colors.black),
            )),
        body: Form(
          key: formKey,
          child: Column(children: [
            Column(
              children: [
                const Text(
                  'Store Logo',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.data['storelogo']),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            child:const Text( 'Change'),
                            onPressed: () {
                              pickStoreLogo();
                            },
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        imageFileLogo == null
                            ? const SizedBox()
                            : ElevatedButton(
                                child: const Text('Reset'),
                                onPressed: () {
                                  setState(() {
                                    imageFileLogo = null;
                                  });
                                },
                               ),
                      ],
                    ),
                    imageFileLogo == null
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                FileImage(File(imageFileLogo!.path)),
                          ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Divider(
                    color: Colors.yellow,
                    thickness: 2.5,
                  ),
                )
              ],
            ),
            Column(
              children: [
                const Text(
                  'Cover Image',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.data['coverimage']),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            child: const Text('Change'),
                            onPressed: () {
                              pickCoverImage();
                            },
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        imageFileCover == null
                            ? const SizedBox()
                            : ElevatedButton(
                                child:const Text( 'Reset'),
                                onPressed: () {
                                  setState(() {
                                    imageFileCover = null;
                                  });
                                },
                              ),
                      ],
                    ),
                    imageFileCover == null
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                FileImage(File(imageFileCover!.path)),
                          ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Divider(
                    color: Colors.yellow,
                    thickness: 2.5,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please Enter store name';
                  }
                  return null;
                },
                onSaved: (value) {
                  storeName = value!;
                },
                initialValue: widget.data['storename'],
                decoration: textFormDecoration.copyWith(
                    labelText: 'store name', hintText: 'Enter Store name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please Enter phone';
                  }
                  return null;
                },
                onSaved: (value) {
                  phone = value!;
                },
                initialValue: widget.data['phone'],
                decoration: textFormDecoration.copyWith(
                    labelText: 'phone', hintText: 'Enter phone'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                     ),
                  processing == true
                      ? ElevatedButton(
                          child: const Text('please wait ..'),
                          onPressed: () {
                            null;
                          },
                         )
                      : ElevatedButton(
                          child: const Text('Save Changes'),
                          onPressed: () {
                            saveChanges();
                          },
                          )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.yellow, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10)),
);
