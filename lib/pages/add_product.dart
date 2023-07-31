import 'package:flutter/material.dart';
import '../services/product_service.dart';

class AddProduct extends StatefulWidget {
  final Map? product;

  const AddProduct({super.key, this.product});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool isEdit = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      isEdit = true;
      nameController.text = product['name'];
      descriptionController.text = product['description'];
      priceController.text = product['price'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit product" : "Add product"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 30),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(hintText: 'Price'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: isEdit ? updateProduct : createProduct,
            child: Text(isEdit ? "Save" : "Create"),
          ),
        ],
      ),
    );
  }

  Future<void> createProduct() async {
    // Get the data from form
    final name = nameController.text;
    final description = descriptionController.text;
    final price = priceController.text;

    if (name.isEmpty || price.isEmpty) {
      showErrorMessage('Product name and price are required');
    } else {
      final data = {
        'name': name,
        'type': 'simple',
        'regular_price': price,
        'description': description,
      };
      // Send request to the server (API request)
      final success = await ProductService.createProduct(data);

      // Handle the response (success or error)
      if (success) {
        nameController.text = '';
        priceController.text = '';
        descriptionController.text = '';
        showSuccessMessage('Product created successfully.');
      } else {
        showErrorMessage('Failed to create product.');
      }
    }
  }

  Future<void> updateProduct() async {
    final product = widget.product as Map;
    final productId = product["id"];

    // Get the data from form
    final name = nameController.text;
    final description = descriptionController.text;
    final price = priceController.text;

    if (name.isEmpty || price.isEmpty) {
      showErrorMessage('Product name and price are required');
    } else {
      final data = {
        'name': name,
        'regular_price': price,
        'description': description,
      };
      // Send request to the server (API request)
      final success = await ProductService.updateProduct(productId, data);

      // Handle the response (success or error)
      if (success) {
        nameController.text = '';
        priceController.text = '';
        descriptionController.text = '';
        showSuccessMessage('Product updated successfully.');
      } else {
        showErrorMessage('Failed to update product.');
      }
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
