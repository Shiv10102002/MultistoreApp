import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/MinorScreen/product_detail_screen.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class GallaryScreen extends StatefulWidget {
 final String cat;
 const GallaryScreen({super.key, required this.cat});

  @override
  State<GallaryScreen> createState() => _GallaryScreenState();
}

class _GallaryScreenState extends State<GallaryScreen> {
  late final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.cat)
      .snapshots();
  RxBool iswishlist = false.obs;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text(
              "This category has \n\n no item yet!",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ));
          }

          return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => ProductDetailScreen(
                        productdetail: snapshot.data!.docs[index]));
                  },
                  child: ProductContainer(product: snapshot.data!.docs[index]),
                );
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            ),
          );
        });
  }
}

class ProductContainer extends StatefulWidget {
 final dynamic product;
 const ProductContainer({
    super.key,
    required this.product,
  });

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.product['discount'];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    constraints: const BoxConstraints(
                        minHeight: 100,
                        maxHeight: 180,
                        minWidth: double.infinity,
                        maxWidth: double.infinity),
                    child: Image(
                      image: NetworkImage(widget.product['proimages'][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                widget.product['discount'] != 0
                    ? Positioned(
                        top: 20,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.shade200,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          child: Text(
                            "Save ${widget.product['discount']}%",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    : Positioned(
                        top: 20,
                        left: 0,
                        child: Container(
                          color: Colors.transparent,
                        ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['prodesc'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '\$ ',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.product['price'].toStringAsFixed(2),
                          style: onSale != 0
                              ? const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w600)
                              : const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        onSale != 0
                            ? Text(
                                ((1 - (widget.product['discount'] / 100)) *
                                        widget.product['price'])
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )
                            : const Text(''),
                      ],
                    ),
                    GetBuilder<WishController>(
                      builder: (wish) {
                        return wish.iswishlist(widget.product['proid'])
                            ? IconButton(
                                onPressed: () {
                                  wish.removeItem(widget.product['proid']);
                                },
                                icon: wish.iswishlist(widget.product['proid'])
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.red,
                                      ),
                              )
                            : IconButton(
                                onPressed: () {
                                  wish.addwishItem(
                                    widget.product['proname'],
                                    onSale != 0
                                        ? ((1 -
                                                (widget.product['discount'] /
                                                    100)) *
                                            widget.product['price'])
                                        : widget.product['price'],
                                    1,
                                    widget.product['instock'],
                                    widget.product['proimages'],
                                    widget.product['proid'],
                                    widget.product['sid'],
                                    widget.product['maincateg'],
                                    widget.product['subcateg'],
                                  );
                                },
                                icon: wish.iswishlist(widget.product['proid'])
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                      ),
                              );
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
