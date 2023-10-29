import 'package:ecommerce/MinorScreen/subcat_products.dart';
import 'package:ecommerce/Utilites/category_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenCategories extends StatelessWidget {
  final String catnam;
  final int catindex;
  const MenCategories(
      {super.key, required this.catnam, required this.catindex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50)),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "<<",
                          style: TextStyle(
                              color: Colors.brown,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          catnam.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.brown,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        catnam == "men"
                            ? const Text("")
                            : const Text(
                                ">>",
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.70,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      catnam,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount: 2,
                      children: List.generate(catsubcatlist[catindex].length,
                          (index) {
                        return index + 1 < catsubcatlist[catindex].length
                            ? GestureDetector(
                                onTap: () => Get.to(() => SubcatProducts(
                                      subcatname: catsubcatlist[catindex]
                                          [index + 1],
                                      maincatname: catnam.toLowerCase(),
                                    )),
                                child: FittedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(1, 1)),
                                          BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(0, 0)),
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          child: Container(
                                            height: 140,
                                            width: 140,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    topRight:
                                                        Radius.circular(12)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      "assets/and.png",
                                                    ),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            catsubcatlist[catindex][index + 1],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
