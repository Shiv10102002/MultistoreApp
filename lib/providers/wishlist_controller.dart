import 'package:ecommerce/providers/product_class.dart';
import 'package:get/get.dart';

class WishController extends GetxController {
  final List<Product> _list = [];

  List<Product> get getItems => _list;

  int get count => _list.length;

  void addwishItem(
      String name,
      double price,
      int qty,
      int qntty,
      List imagesUrl,
      String documentId,
      String suppId,
      String categ,
      String subcateg) {
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

  bool iswishlist(String productid) {
    for (var item in _list) {
      if (item.documentId == productid) {
        return true;
      }
    }
    return false;
  }
  // void increment(Product product) {
  //   product.increase();
  //   update(); // Replaces notifyListeners()
  // }

  // void reduceByOne(Product product) {
  //   product.decrease();
  //   update(); // Replaces notifyListeners()
  // }

  void removeItem(String productid) {
    for (var item in _list) {
      if (item.documentId == productid) {
        _list.remove(item);
      }
    }
    update(); // Replaces notifyListeners()
  }

  void clearwishlist() {
    _list.clear();
    update(); // Replaces notifyListeners()
  }
}
