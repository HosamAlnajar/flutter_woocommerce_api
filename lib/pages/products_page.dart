import 'package:flutter/material.dart';
import 'package:new_app/pages/add_product.dart';

import '../services/product_service.dart';
import 'product_details.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List products = [];

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getAllProducts,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          String imageUrl = "";
          if (product['images'].isEmpty) {
            imageUrl = 'https://placehold.co/600x400/000000/FFFFFF/png';
          } else {
            imageUrl = product['images'][0]['src'];
          }

          return Center(
            child: Column(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => navigateToProductPage(product),
                    child: Hero(
                      tag: "${product['id']}",
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "\$${product['price']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(product['name']),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 80, height: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Edit'),
                        onPressed: () {
                          navigateToEditProduct(product);
                        },
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 80, height: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          deleteProduct(product['id']);
                        },
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void navigateToProductPage(product) {
    final route = MaterialPageRoute(
      builder: (context) => ProductDetails(product: product),
    );
    Navigator.push(context, route);
  }

  void navigateToEditProduct(product) {
    final route = MaterialPageRoute(
      builder: (context) => AddProduct(product: product),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteProduct(int productId) async {
    final success = await ProductService.deleteProduct(productId);
    if (success) {
      final filteredProducts = products.where((element) => element['id'] != productId).toList();
      setState(() {
        products = filteredProducts;
      });
    } else {
      print('Failed to get product.');
    }
  }

  Future<void> getAllProducts() async {
    final response = await ProductService.getAllProducts();

    if (response != null) {
      setState(() {
        products = response;
      });
    } else {
      print('Response: $response');
    }
  }
}
