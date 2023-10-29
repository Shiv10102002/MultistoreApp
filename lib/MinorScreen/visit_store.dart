import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/MinorScreen/edit_products.dart';
import 'package:ecommerce/MinorScreen/edit_store.dart';
import 'package:ecommerce/MinorScreen/product_detail_screen.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStoreScreen extends StatefulWidget {
  final dynamic storeid;
  const VisitStoreScreen({super.key, required this.storeid});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  RxBool following = false.obs;
  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.storeid)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.storeid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              highlightElevation: 2,
              backgroundColor: const Color.fromARGB(238, 4, 69, 61),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                ),
              ),
            ),
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: Image.asset(
                "assets/coverimage.jpg",
                fit: BoxFit.cover,
              ),
              title: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 4, color: Colors.orangeAccent),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            data['storelogo'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              data['storename'].toUpperCase(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            data['sid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? MaterialButton(
                                    color: Colors.orangeAccent,
                                    height: 40,
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                          color: Colors.orangeAccent,
                                        )),
                                    onPressed: () {
                                      Get.to(() => EditStore(data: data));
                                    },
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Obx(
                                    () => following.value
                                        ? MaterialButton(
                                            color: Colors.orangeAccent,
                                            height: 40,
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: const BorderSide(
                                                  color: Colors.orangeAccent,
                                                )),
                                            onPressed: () {
                                              following.value =
                                                  !following.value;
                                            },
                                            child: const Text(
                                              "FOLLOWING",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : MaterialButton(
                                            // color: Colors.orangeAccent,
                                            height: 40,
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: const BorderSide(
                                                  color: Colors.orangeAccent,
                                                )),
                                            onPressed: () {
                                              following.value =
                                                  !following.value;
                                            },
                                            child: const Text(
                                              "FOLLOW",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                  )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
            backgroundColor: Colors.blueGrey.shade100,
            body: StreamBuilder(
                stream: productStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      "This store has \n\n no item yet!",
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
                          child: Padding(
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
                                                    snapshot.data!.docs[index]
                                                        ['proimages'][0]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              top: 20,
                                              left: 0,
                                              child: snapshot.data!.docs[index]
                                                          ['discount'] !=
                                                      0
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors
                                                                  .orangeAccent
                                                                  .shade200,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          15))),
                                                      child: Text(
                                                        "Save ${snapshot.data!.docs[index]['discount']}%",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : const SizedBox())
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                                ['prodesc'],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      '\$ ',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      snapshot.data!
                                                          .docs[index]['price']
                                                          .toStringAsFixed(2),
                                                      style: snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  'discount'] !=
                                                              0
                                                          ? const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 11,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)
                                                          : const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    snapshot.data!.docs[index]
                                                                ['discount'] !=
                                                            0
                                                        ? Text(
                                                            ((1 - (snapshot.data!.docs[index]['discount'] / 100)) *
                                                                    snapshot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'price'])
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        : const Text(''),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                snapshot.data!.docs[index]
                                                            ['sid'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? IconButton(
                                                        onPressed: () {
                                                          Get.to(() =>
                                                              EditProduct(
                                                                  items: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]));
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.grey,
                                                        ))
                                                    : GetBuilder<
                                                        WishController>(
                                                        builder: (wish) {
                                                          return wish.iswishlist(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['proid'])
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    wish.removeItem(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'proid']);
                                                                  },
                                                                  icon: wish.iswishlist(snapshot
                                                                          .data!
                                                                          .docs[index]['proid'])
                                                                      ? const Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              Colors.red,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .favorite_border_outlined,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                )
                                                              : IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    wish.addwishItem(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['proname'],
                                                                      snapshot.data!.docs[index]['discount'] !=
                                                                              0
                                                                          ? ((1 - (snapshot.data!.docs[index]['discount'] / 100)) *
                                                                              snapshot.data!.docs[index][
                                                                                  'price'])
                                                                          : snapshot
                                                                              .data!
                                                                              .docs[index]['price'],
                                                                      1,
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['instock'],
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['proimages'],
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['proid'],
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['sid'],
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['maincateg'],
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]['subcateg'],
                                                                    );
                                                                  },
                                                                  icon: wish.iswishlist(snapshot
                                                                          .data!
                                                                          .docs[index]['proid'])
                                                                      ? const Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              Colors.red,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .favorite_outline,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                );
                                                        },
                                                      )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (context) =>
                          const StaggeredTile.fit(1),
                    ),
                  );
                }),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          ),
        );
      },
    );
  }
}
