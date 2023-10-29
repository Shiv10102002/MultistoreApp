import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/MinorScreen/product_detail_screen.dart';
import 'package:ecommerce/Widgets/appbar_widgets.dart';
import 'package:ecommerce/providers/wishlist_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ManageProducts extends StatelessWidget {
  ManageProducts({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppbarBackButton(),
        title: const AppbarTitle(
          title: 'ManageProducts',
        ),
      ),
      body: StreamBuilder(
          stream: _productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                          image: NetworkImage(snapshot.data!
                                              .docs[index]['proimages'][0]),
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
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .orangeAccent.shade200,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: Text(
                                                  "Save ${snapshot.data!.docs[index]['discount']}%",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : const SizedBox())
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['prodesc'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]['price']
                                                  .toStringAsFixed(2) +
                                              (' \$'),
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        snapshot.data!.docs[index]['sid'] ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.grey,
                                                ))
                                            : GetBuilder<WishController>(
                                                builder: (wish) {
                                                  return wish.iswishlist(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['proid'])
                                                      ? IconButton(
                                                          onPressed: () {
                                                            wish.removeItem(
                                                                snapshot.data!
                                                                            .docs[
                                                                        index]
                                                                    ['proid']);
                                                          },
                                                          icon: wish.iswishlist(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['proid'])
                                                              ? const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .favorite_border_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            wish.addwishItem(
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['proname'],
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['price'],
                                                              1,
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['instock'],
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['proimages'],
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['proid'],
                                                              snapshot.data!
                                                                      .docs[
                                                                  index]['sid'],
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['maincateg'],
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['subcateg'],
                                                            );
                                                          },
                                                          icon: wish.iswishlist(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['proid'])
                                                              ? const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .favorite_outline,
                                                                  color: Colors
                                                                      .red,
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
                    ),
                  );
                },
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
              ),
            );
          }),
    );
  }
}
