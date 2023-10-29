import 'package:ecommerce/Screen/categories/men_categ.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemData {
  String label;
  RxBool isSelected;

  ItemData({required this.label, bool isSelected = false})
      : isSelected = isSelected.obs;
}

class CategoryController extends GetxController {
   RxInt selectedIndex = 0.obs;
  RxList<ItemData> items = [
    ItemData(label: "Men", isSelected: true),
    ItemData(label: "Women"),
    ItemData(label: "Shoes"),
    ItemData(label: "Bags"),
    ItemData(label: "Electronics"),
    ItemData(label: "Accessories"),
    ItemData(label: "Home & Garden"),
    ItemData(label: "Kids"),
    ItemData(label: "Beauty"),
  ].obs;

  PageController pageController = PageController();
  // ScrollController scrollController = ScrollController();

  void selectCategory(int index) {
    selectedIndex.value = index;
    for (var item in items) {
      item.isSelected.value = false;
    }
    items[index].isSelected.value = true;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

class CatView extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

   CatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: categoryController.pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          categoryController.selectCategory(index);
        },
        children: List.generate(categoryController.items.length, (index) {
          return MenCategories(
            catnam: categoryController.items[index].label,
            catindex:index,
          );
        }),
      ),
    );
  }
}

class Sidenavigator extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

   Sidenavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.2,
      child: ListView.builder(
        itemCount: categoryController.items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              categoryController.selectCategory(index);
            },
            child: Obx(
              () => Container(
                height: 100,
                decoration: BoxDecoration(
                  color: categoryController.items[index].isSelected.value
                      ? Colors.white
                      : Colors.grey.shade300,
                ),
                child: Center(
                  child: Text(categoryController.items[index].label),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
