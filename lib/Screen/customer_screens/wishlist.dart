import 'package:ecommerce/Screen/customer_screens/cart_screen.dart';
import 'package:ecommerce/Screen/customer_screens/main_home_page.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WishController wislistcontroller = Get.find();
    // RxDouble price = cartController.totalPrice.obs;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "WishList ",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          IconButton(
            onPressed: () {
              Get.off(const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart_checkout),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              wislistcontroller.clearwishlist();
            },
            icon: const Icon(Icons.delete_forever),
            color: Colors.black,
          ),
        ],
      ),
      body: GetBuilder<WishController>(
        builder: (wish) {
          return wish.count > 0 ? const CartItems() : const EmptyWishList();
        },
      ),
    );
    //  cartController.count > 0 ? CartItems() : EmptyCart());
  }
}

class CartItems extends StatefulWidget {
 const CartItems({
    super.key,
  });

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  CartController cartcontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishController>(
      builder: (product) {
        return StaggeredGridView.countBuilder(
          itemCount: product.count,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
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
                                  image: NetworkImage(
                                    product.getItems[index].imagesUrl[0],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //  Positioned(
                            //                   top: 20,
                            //                   left: 0,
                            //                   child: Container(
                            //                     padding:
                            //                         const EdgeInsets.all(4),
                            //                     decoration: BoxDecoration(
                            //                         color: Colors
                            //                             .orangeAccent.shade200,
                            //                         borderRadius:
                            //                             const BorderRadius.only(
                            //                                 topRight:
                            //                                     Radius.circular(
                            //                                         15),
                            //                                 bottomRight:
                            //                                     Radius.circular(
                            //                                         15))),
                            //                     child: Text(
                            //                       "Save ${ product.getItems[index].}%",
                            //                       style: const TextStyle(
                            //                           color: Colors.white),
                            //                     ),
                            //                   ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                product.getItems[index].name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.getItems[index].price
                                            .toStringAsFixed(2) +
                                        (' \$'),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        cartcontroller.addItem(
                                            product.getItems[index].name,
                                            product.getItems[index].price,
                                            product.getItems[index].qty,
                                            product.getItems[index].qntty,
                                            product.getItems[index].imagesUrl,
                                            product.getItems[index].documentId,
                                            product.getItems[index].suppId,
                                            product.getItems[index].categ,
                                            product.getItems[index].subcateg);
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart_checkout_outlined,
                                        color: Colors.black54,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            );
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          crossAxisCount: 2,
        );
      },
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your WishList Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Get.offAll(() => const HomePage());
              },
              child: const Text(
                'continue shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// context.watch<Cart>().getItems.isNotEmpty