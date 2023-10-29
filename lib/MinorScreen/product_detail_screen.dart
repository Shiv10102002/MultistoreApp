import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/MinorScreen/full_screen_view.dart';
import 'package:ecommerce/MinorScreen/visit_store.dart';
import 'package:ecommerce/Screen/customer_screens/cart_screen.dart';
import 'package:ecommerce/Widgets/yellow_button.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailScreen extends StatefulWidget {
  dynamic productdetail;
  ProductDetailScreen({super.key, required this.productdetail});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  CartController cartController = Get.find();
  WishController wishcontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where(
          'maincateg',
          isEqualTo: widget.productdetail['maincateg'],
        )
        .where('subcateg', isEqualTo: widget.productdetail['subcateg'])
        .snapshots();
    
      final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.productdetail['proid'])
      .collection('reviews')
      .snapshots();
    return Scaffold(
      bottomSheet:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(
            onPressed: () {
              Get.to(
                  () => VisitStoreScreen(storeid: widget.productdetail['sid']));
            },
            icon: const Icon(Icons.store)),
        IconButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: Badge(
              label: GetBuilder<CartController>(
                builder: (cart) {
                  return Text(cartController.count.toString());
                },
              ),
              child: const Icon(Icons.shopping_cart_checkout),
            )),
        const SizedBox(
          width: 20,
        ),
        YellowButton(
            label: 'ADD TO CART',
            onPressed: () {
              if (widget.productdetail['instock'] <= 0) {
                Get.snackbar(
                  "Product status",
                  "Out of Stock",
                  colorText: Colors.white,
                  backgroundColor: Colors.orangeAccent,
                );
              } else {
                bool incart = false;
                for (var i in cartController.getItems) {
                  if (i.documentId == widget.productdetail['proid']) {
                    incart = true;
                  }
                }
                incart
                    ? Get.snackbar(
                        "Product status",
                        "Already in cart",
                        backgroundColor: Colors.orangeAccent,
                        colorText: Colors.white,
                      )
                    : cartController.addItem(
                        widget.productdetail['proname'],
                        widget.productdetail['price'],
                        1,
                        widget.productdetail['instock'],
                        widget.productdetail['proimages'],
                        widget.productdetail['proid'],
                        widget.productdetail['sid'],
                        widget.productdetail['maincateg'],
                        widget.productdetail['subcateg']);
              }
            },
            width: MediaQuery.of(context).size.width * 0.5)
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: () {
                Get.to(() => FullScreenView(
                      imaglist: widget.productdetail['proimages'],
                    ));
              },
              child: Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Swiper(
                        itemCount: widget.productdetail['proimages']!.length,
                        pagination: const SwiperPagination(
                            builder: SwiperPagination.dots),
                        itemBuilder: (context, index) {
                          return Image(
                            image: NetworkImage(
                                widget.productdetail['proimages'][index]),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.yellow,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.yellow,
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productdetail['proname'],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'USD ',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            widget.productdetail['price'].toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      GetBuilder<WishController>(
                        builder: (wish) {
                          return wish.iswishlist(widget.productdetail['proid'])
                              ? IconButton(
                                  onPressed: () {
                                    wish.removeItem(
                                        widget.productdetail['proid']);
                                  },
                                  icon: wish.iswishlist(
                                          widget.productdetail['proid'])
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
                                      widget.productdetail['proname'],
                                      widget.productdetail['price'],
                                      1,
                                      widget.productdetail['instock'],
                                      widget.productdetail['proimages'],
                                      widget.productdetail['proid'],
                                      widget.productdetail['sid'],
                                      widget.productdetail['maincateg'],
                                      widget.productdetail['subcateg'],
                                    );
                                  },
                                  icon: wish.iswishlist(
                                          widget.productdetail['proid'])
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
                  ),
                  widget.productdetail['instock'] == 0
                      ? const Text(
                          "Out of Stock",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )
                      : Text(
                          "${widget.productdetail['instock']} picese available in stock",
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                  const ProdDetailLable(
                    lable: "Item Description",
                  ),
                  Text(
                    widget.productdetail['prodesc'],
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                   Stack(children: [
                          const Positioned(
                              right: 50, top: 15, child: Text('total')),
                          ExpandableTheme(
                              data: const ExpandableThemeData(
                                  iconSize: 30, iconColor: Colors.blue),
                              child: reviews(reviewsStream)),
                        ]),
                  const SizedBox(
                    height: 16,
                  ),
                  const ProdDetailLable(
                    lable: "Similar Items",
                  ),
                  StreamBuilder(
                      stream: productStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          );
                        }
                        if (snapshot.data!.docs.length == 1) {
                          return const Center(
                              child: Text(
                            "There is no similar product available",
                            style: TextStyle(
                                fontSize: 20,
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
                              return snapshot.data!.docs[index]['proid'] !=
                                      widget.productdetail['proid']
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.productdetail =
                                              snapshot.data!.docs[index];
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          topRight:
                                                              Radius.circular(
                                                                  12)),
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            minHeight: 100,
                                                            maxHeight: 180,
                                                            minWidth:
                                                                double.infinity,
                                                            maxWidth: double
                                                                .infinity),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['proimages'][0]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['prodesc'],
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'price']
                                                                    .toStringAsFixed(
                                                                        2) +
                                                                (' \$'),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              var inwishlist =
                                                                  false;
                                                              for (var i
                                                                  in wishcontroller
                                                                      .getItems) {
                                                                if (i.documentId ==
                                                                    snapshot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'proid']) {
                                                                  inwishlist =
                                                                      true;
                                                                }
                                                              }
                                                              inwishlist
                                                                  ? wishcontroller.removeItem(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      ['proid'])
                                                                  : wishcontroller.addwishItem(
                                                                      snapshot.data!.docs[index][
                                                                          'proname'],
                                                                      snapshot.data!.docs[index][
                                                                          'price'],
                                                                      1,
                                                                      snapshot.data!.docs[index][
                                                                          'instock'],
                                                                      snapshot.data!
                                                                              .docs[index][
                                                                          'proimages'],
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['proid'],
                                                                      snapshot.data!.docs[index]['sid'],
                                                                      snapshot.data!.docs[index]['maincateg'],
                                                                      snapshot.data!.docs[index]['subcateg']);
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_border_outlined,
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            },
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(1),
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 80,
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

class ProdDetailLable extends StatelessWidget {
  final String lable;
  const ProdDetailLable({
    required this.lable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(
          height: 40,
          width: 50,
          child: Divider(
            height: 40,
            thickness: 3,
            color: Colors.orangeAccent,
          ),
        ),
        Text(
          " $lable ",
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          textScaleFactor: 1,
        ),
        const SizedBox(
          height: 40,
          width: 50,
          child: Divider(
            height: 40,
            thickness: 3,
            color: Colors.orangeAccent,
          ),
        )
      ],
    );
  }
}



Widget reviews(var reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Reviews',
          style: TextStyle(
              color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      collapsed: SizedBox(
        height: 230,
        child: reviewsAll(reviewsStream),
      ),
      expanded: reviewsAll(reviewsStream));
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
            child: Text(
          'This Item \n\n has no Reviews yet !',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontFamily: 'Acme',
              letterSpacing: 1.5),
        ));
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]['profileimage'])),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(snapshot2.data!.docs[index]['name']),
                    Row(
                      children: [
                        Text(snapshot2.data!.docs[index]['rate'].toString()),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        )
                      ],
                    )
                  ]),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
