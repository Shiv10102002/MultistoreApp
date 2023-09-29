// import 'package:ecommerce/Screen/main_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon:const Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
            title:const CupertinoSearchTextField(),
      ),
      body:const  Center(
        child: Text("search Screen"),
      ),
    );
  }
}
