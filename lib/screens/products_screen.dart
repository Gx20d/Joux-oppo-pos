import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Map<String, dynamic>> products = [];

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void addProduct() {
    nameController.clear();
    priceController.clear();
    quantityController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("إضافة منتج"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المنتج",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "السعر",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "الكمية",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("إلغاء"),
            ),

            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();

                final price =
                    double.tryParse(priceController.text.trim()) ?? 0;

                final quantity =
                    int.tryParse(quantityController.text.trim()) ?? 0;

                if (name.isEmpty) {
                  return;
                }

                setState(() {
                  products.add({
                    "name": name,
                    "price": price,
                    "quantity": quantity,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المنتجات"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.add),
      ),

      body: products.isEmpty
          ? const Center(
              child: Text(
                "لا توجد منتجات",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.all(8),

                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory_2),
                    ),

                    title: Text(
                      product["name"] ?? "",
                    ),

                    subtitle: Text(
                      "السعر: ${product["price"]} جنيه\n"
                      "الكمية: ${product["quantity"]}",
                    ),

                    isThreeLine: true,

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteProduct(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}