import 'package:ecommerce/Screen/gallary_screen.dart';
import 'package:ecommerce/Widgets/demo_search.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
          backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const DemoSearch(),
            bottom: const TabBar(
                isScrollable: true,
                indicatorColor: Colors.orangeAccent,
                unselectedLabelStyle: TextStyle(
                  color: Colors.red,
                ),
                labelStyle: TextStyle(
                    color: Colors.amberAccent, fontWeight: FontWeight.bold),
                indicatorWeight: 4,
                tabs: [
                  RepeatTab(
                    label: "men",
                  ),
                  RepeatTab(
                    label: 'women',
                  ),
                  RepeatTab(
                    label: 'shoes',
                  ),
                  RepeatTab(
                    label: 'Bags',
                  ),
                  RepeatTab(
                    label: 'electronic',
                  ),
                  RepeatTab(
                    label: 'kids',
                  ),
                  RepeatTab(
                    label: 'fashion',
                  ),
                  RepeatTab(
                    label: 'women tfashion',
                  ),
                  RepeatTab(
                    label: 'jewellery',
                  ),
                ]),
          ),
          body: const TabBarView(
            children: [
              GallaryScreen(cat: 'men'),
              GallaryScreen(cat: 'women'),
              GallaryScreen(cat: 'shoes'),
              GallaryScreen(cat: 'bags'),
              GallaryScreen(cat: 'electronics'),
              GallaryScreen(cat: 'kids'),
              GallaryScreen(cat: 'fashion'),
              GallaryScreen(cat: 'womenfashion'),
              GallaryScreen(cat: 'jewellery'),
            ],
          )),
    );
  }
}

class RepeatTab extends StatelessWidget {
  final String label;
  const RepeatTab({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
