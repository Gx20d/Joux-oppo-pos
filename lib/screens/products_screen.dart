import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> products = [];

  bool loading = true;

  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final quantityController = TextEditingController();
  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();
  final barcodeController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    quantityController.dispose();
    buyPriceController.dispose();
    sellPriceController.dispose();
    barcodeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    final data =
        await DatabaseHelper.instance.getProducts();

    if (!mounted) return;

    setState(() {
      products = data;
      loading = false;
    });
  }

  Future<void> addProduct() async {
    nameController.clear();
    brandController.clear();
    quantityController.clear();
    buyPriceController.clear();
    sellPriceController.clear();
    barcodeController.clear();
    notesController.clear();

    await showDialog(
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
                  controller: brandController,
                  decoration: const InputDecoration(
                    labelText: "الماركة",
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

                const SizedBox(height: 12),

                TextField(
                  controller: buyPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "سعر الشراء",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: sellPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "سعر البيع",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: barcodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "الباركود",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "ملاحظات",
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
              onPressed: () async {
                final name =
                    nameController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                final brand =
                    brandController.text.trim();

                final quantity =
                    int.tryParse(
                          quantityController.text.trim(),
                        ) ??
                        0;

                final buyPrice =
                    double.tryParse(
                          buyPriceController.text.trim(),
                        ) ??
                        0;

                final sellPrice =
                    double.tryParse(
                          sellPriceController.text.trim(),
                        ) ??
                        0;

                final barcode =
                    barcodeController.text.trim();

                final notes =
                    notesController.text.trim();

                await DatabaseHelper.instance
                    .insertProduct({
                  "name": name,
                  "brand": brand,
                  "quantity": quantity,
                  "buy_price": buyPrice,
                  "sell_price": sellPrice,
                  "barcode": barcode,
                  "notes": notes,
                });

                if (!mounted) return;

                Navigator.pop(context);

                await loadProducts();
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper.instance
        .deleteProduct(id);

    await loadProducts();
  }

  Future<void> editProduct(
    Map<String, dynamic> product,
  ) async {
    nameController.text =
        product["name"]?.toString() ?? "";

    brandController.text =
        product["brand"]?.toString() ?? "";

    quantityController.text =
        product["quantity"]?.toString() ?? "0";

    buyPriceController.text =
        product["buy_price"]?.toString() ?? "0";

    sellPriceController.text =
        product["sell_price"]?.toString() ?? "0";

    barcodeController.text =
        product["barcode"]?.toString() ?? "";

    notesController.text =
        product["notes"]?.toString() ?? "";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("تعديل المنتج"),

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
                  controller: brandController,
                  decoration: const InputDecoration(
                    labelText: "الماركة",
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

                const SizedBox(height: 12),

                TextField(
                  controller: buyPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "سعر الشراء",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: sellPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "سعر البيع",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: barcodeController,
                  decoration: const InputDecoration(
                    labelText: "الباركود",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "ملاحظات",
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
              onPressed: () async {
                final name =
                    nameController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                await DatabaseHelper.instance
                    .updateProduct(
                  product["id"],
                  {
                    "name": name,
                    "brand":
                        brandController.text.trim(),
                    "quantity":
                        int.tryParse(
                              quantityController.text
                                  .trim(),
                            ) ??
                            0,
                    "buy_price":
                        double.tryParse(
                              buyPriceController.text
                                  .trim(),
                            ) ??
                            0,
                    "sell_price":
                        double.tryParse(
                              sellPriceController.text
                                  .trim(),
                            ) ??
                            0,
                    "barcode":
                        barcodeController.text.trim(),
                    "notes":
                        notesController.text.trim(),
                  },
                );

                if (!mounted) return;

                Navigator.pop(context);

                await loadProducts();
              },
              child: const Text("حفظ التعديل"),
            ),
          ],
        );
      },
    );
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

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
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
                    final product =
                        products[index];

                    return Card(
                      margin:
                          const EdgeInsets.all(8),

                      child: ListTile(
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.inventory_2,
                          ),
                        ),

                        title: Text(
                          product["name"]?.toString() ??
                              "",
                        ),

                        subtitle: Text(
                          "الماركة: ${product["brand"] ?? ""}\n"
                          "الكمية: ${product["quantity"] ?? 0}\n"
                          "سعر البيع: ${product["sell_price"] ?? 0} جنيه",
                        ),

                        isThreeLine: true,

                        onTap: () {
                          editProduct(product);
                        },

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteProduct(
                              product["id"],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}