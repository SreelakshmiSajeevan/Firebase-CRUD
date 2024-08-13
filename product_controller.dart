import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';

class ProductController extends GetxController {
  final CollectionReference _productsCollection =
  FirebaseFirestore.instance.collection('products');

  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    products.bindStream(getProductsStream());
  }

  Stream<List<Product>> getProductsStream() {
    return _productsCollection.snapshots().map((QuerySnapshot query) {
      List<Product> retVal = [];
      for (var element in query.docs) {
        retVal.add(Product.fromDocument(element));
      }
      return retVal;
    });
  }

  Future<void> addOrUpdateProduct({String? id, required String name, required double price}) async {
    if (id == null) {
      // Add new product
      await _productsCollection.add({'name': name, 'price': price});
    } else {
      // Update existing product
      await _productsCollection.doc(id).update({'name': name, 'price': price});
    }
  }

  Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }
}
