import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';
import '../model/product_model.dart';

class TodoView extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> _showBottomSheet({Product? product}) async {
    if (product != null) {
      nameController.text = product.name;
      priceController.text = product.price.toString();
    } else {
      nameController.clear();
      priceController.clear();
    }

    Get.bottomSheet(
      backgroundColor: Colors.white,
      Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(product == null ? 'Create' : 'Update'),
              onPressed: () {
                final String name = nameController.text;
                final double? price = double.tryParse(priceController.text);
                if (name.isNotEmpty && price != null) {
                  productController.addOrUpdateProduct(
                    id: product?.id,
                    name: name,
                    price: price,
                  );
                  Get.back();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final Product product = productController.products[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(product.price.toString()),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showBottomSheet(product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          productController.deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }
}