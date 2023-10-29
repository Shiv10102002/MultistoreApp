import 'package:ecommerce/MinorScreen/place_order.dart';
import 'package:ecommerce/Screen/customer_screens/wishlist.dart';
import 'package:ecommerce/Screen/customer_screens/main_home_page.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.find();
    // RxDouble price = cartController.totalPrice.obs;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Cart ",
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
              Get.off(() => const WishListScreen());
            },
            icon: const Icon(Icons.favorite_border_outlined),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              cartController.clearCart();
            },
            icon: const Icon(Icons.delete_forever),
            color: Colors.black,
          ),
        ],
      ),
      bottomSheet: GetBuilder<CartController>(
        builder: (cart) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Total:  ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    Text(
                      cart.totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green),
                    ),
                  ],
                ),
                Material(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    child: MaterialButton(
                      height: 35,
                      minWidth: MediaQuery.of(context).size.width * 0.45,
                      onPressed: () {
                        cart.totalPrice <= 0
                            ? null
                            : Get.to(() => const PlaceOrderScreen());
                      },
                      child: const Text("Check Out"),
                    ))
              ],
            ),
          );
        },
      ),
      body: GetBuilder<CartController>(
        builder: (cart) {
          return cart.count > 0 ? const CartItems() : const EmptyCart();
        },
      ),
    );
    //  cartController.count > 0 ? CartItems() : EmptyCart());
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WishController wislistcontroller = Get.find();
    return GetBuilder<CartController>(
      builder: (product) {
        return StaggeredGridView.countBuilder(
          physics: const BouncingScrollPhysics(),
          itemCount: product.count,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.getItems[index].name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    product.getItems[index].price
                                            .toStringAsFixed(2) +
                                        (' \$'),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      product.getItems[index].qty <= 0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showCupertinoModalPopup<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          builder) {
                                                        return CupertinoActionSheet(
                                                          cancelButton:
                                                              TextButton(
                                                            child: const Text(
                                                                'Cancle'),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                          ),
                                                          title: const Text(
                                                              "Remove Item"),
                                                          message: const Text(
                                                              "Are you sure you want to remove item from cartlist"),
                                                          actions: <CupertinoActionSheetAction>[
                                                            CupertinoActionSheetAction(
                                                                onPressed: () {
                                                                  var iswishlist =
                                                                      false;
                                                                  for (var i
                                                                      in wislistcontroller
                                                                          .getItems) {
                                                                    if (i.documentId ==
                                                                        product
                                                                            .getItems[index]
                                                                            .documentId) {
                                                                      iswishlist =
                                                                          true;
                                                                    }
                                                                  }
                                                                  iswishlist ==
                                                                          true
                                                                      ? product.removeItem(
                                                                          product.getItems[
                                                                              index])
                                                                      : wislistcontroller.addwishItem(
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .name,
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .price,
                                                                          1,
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .qntty,
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .imagesUrl,
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .documentId,
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .suppId,
                                                                          product
                                                                              .getItems[
                                                                                  index]
                                                                              .categ,
                                                                          product
                                                                              .getItems[index]
                                                                              .subcateg);

                                                                  Get.back();
                                                                },
                                                                child: const Text(
                                                                    "Move to Wishlist")),
                                                            CupertinoActionSheetAction(
                                                                onPressed: () {
                                                                  product.removeItem(
                                                                      product.getItems[
                                                                          index]);
                                                                  Get.back();
                                                                },
                                                                child: const Text(
                                                                    "Delete Item")),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: const Icon(
                                                  Icons.delete_forever,
                                                  size: 14,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                product.reduceByOne(
                                                    product.getItems[index]);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Icon(
                                                  FontAwesomeIcons.minus,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                      Text(
                                        product.getItems[index].qty.toString(),
                                        textScaleFactor: 1,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            product.getItems[index].qty >=
                                                    product
                                                        .getItems[index].qntty
                                                ? null
                                                : product.increment(
                                                    product.getItems[index]);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Icon(
                                              FontAwesomeIcons.plus,
                                              size: 14,
                                            ),
                                          )),
                                    ]),
                              ),
                            )
                          ],
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

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
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