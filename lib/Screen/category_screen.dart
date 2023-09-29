import 'package:ecommerce/Widgets/category_screen.dart';
import 'package:ecommerce/Widgets/demo_search.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const DemoSearch(),
        ),
        body:  Stack(
          children: [
            Positioned(left: 0, bottom: 0, child: Sidenavigator()),
            Positioned(right: 0, bottom: 0, child: CatView()),
          ],
        ));
  }
}

