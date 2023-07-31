import 'package:flutter/material.dart';
import 'package:new_app/pages/products_page.dart';
import 'add_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('WooCommerce App')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddProduct,
          label: const Text(
            "Add product",
          ),
          backgroundColor: Colors.black,
        ),
        body: ProductsPage(),
      ),
    );
  }

  void navigateToAddProduct() {
    final route = MaterialPageRoute(
      builder: (context) => const AddProduct(),
    );
    Navigator.push(context, route);
  }
}
