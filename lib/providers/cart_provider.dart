


import 'package:get/get.dart';

import 'product_class.dart';
// Import your Product class

class CartController extends GetxController {
  final List<Product> _list = [];

  List<Product> get getItems => _list;

  double get totalPrice {
    var total = 0.0.obs;
    for (var item in _list) {
      total.value += item.price * item.qty;
    }
    return total.value;
  }

  int get count => _list.length;

  void addItem(String name, double price, int qty, int qntty, List imagesUrl,
      String documentId, String suppId, String categ, String subcateg) {
    final product = Product(
        name: name,
        price: price,
        qty: qty,
        qntty: qntty,
        imagesUrl: imagesUrl,
        documentId: documentId,
        suppId: suppId,
        categ: categ,
        subcateg: subcateg);
    _list.add(product);
    update(); // Replaces notifyListeners()
  }

  void increment(Product product) {
    product.increase();
    update(); // Replaces notifyListeners()
  }

  void reduceByOne(Product product) {
    product.decrease();
    update(); // Replaces notifyListeners()
  }

  void removeItem(Product product) {
    _list.remove(product);
    update(); // Replaces notifyListeners()
  }

  void clearCart() {
    _list.clear();
    update(); // Replaces notifyListeners()
  }


}
