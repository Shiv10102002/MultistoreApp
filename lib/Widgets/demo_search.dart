import 'package:ecommerce/MinorScreen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemoSearch extends StatelessWidget {
  const DemoSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() =>const SearchScreen());
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Search',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                  child: Text(
                'Search',
                style: TextStyle(color: Colors.white, fontSize: 14),
              )),
            )
          ],
        ),
      ),
    );
  }
}