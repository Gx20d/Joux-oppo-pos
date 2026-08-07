import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'purchase_details_screen.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() =>
      _PurchasesScreenState();
}

class _PurchasesScreenState
    extends State<PurchasesScreen> {

  List<Map<String, dynamic>> purchases = [];
  List<Map<String, dynamic>> suppliers = [];
  List<Map<String, dynamic>> products = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    purchases = await DatabaseHelper.instance
        .getPurchases();

    suppliers = await DatabaseHelper.instance
        .getSuppliers();

    products = await DatabaseHelper.instance
        .getProducts();

    if (!mounted) return;

    setState(() {
      loading = false;
    });

  }

  Future<void> addPurchase() async {

    int? selectedSupplier;
    int? selectedProduct;

    final quantityController =
        TextEditingController();

    final priceController =
        TextEditingController();

    final notesController =
        TextEditingController();

    await showDialog(

      context: context,

      builder: (_) {

        return StatefulBuilder(

          builder: (context, setDialogState) {

            return AlertDialog(

              title: const Text(
                "إضافة عملية شراء",
              ),

              content: SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [                    DropdownButtonFormField<int>(
                      value: selectedSupplier,
                      decoration: const InputDecoration(
                        labelText: "المورد",
                        border: OutlineInputBorder(),
                      ),
                      items: suppliers.map((supplier) {
                        return DropdownMenuItem<int>(
                          value: supplier["id"],
                          child: Text(
                            supplier["name"],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedSupplier = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<int>(
                      value: selectedProduct,
                      decoration: const InputDecoration(
                        labelText: "المنتج",
                        border: OutlineInputBorder(),
                      ),
                      items: products.map((product) {
                        return DropdownMenuItem<int>(
                          value: product["id"],
                          child: Text(
                            product["name"],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedProduct = value;
                        });
                      },
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
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "سعر الشراء",
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

              actions: [                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("إلغاء"),
                ),

                ElevatedButton(
                  onPressed: () async {

                    if (selectedSupplier == null ||
                        selectedProduct == null) {
                      return;
                    }

                    final quantity = int.tryParse(
                          quantityController.text,
                        ) ??
                        0;

                    final price = double.tryParse(
                          priceController.text,
                        ) ??
                        0;

                    final purchaseId =
                        await DatabaseHelper.instance
                            .insertPurchase({

                      "supplier_id": selectedSupplier,

                      "date": DateTime.now()
                          .toIso8601String(),

                      "total": quantity * price,

                      "notes": notesController.text,

                    });

                    await DatabaseHelper.instance
                        .insertPurchaseItem({

                      "purchase_id": purchaseId,

                      "product_id": selectedProduct,

                      "quantity": quantity,

                      "buy_price": price,

                    });

                    await DatabaseHelper.instance
                        .increaseProductQuantity(
                      selectedProduct!,
                      quantity,
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    await loadData();

                  },

                  child: const Text(
                    "حفظ",
                  ),
                ),

              ],

            );

          },

        );

      },

    );

  }

  Future<void> deletePurchase(
      int id) async {

    await DatabaseHelper.instance
        .deletePurchase(id);

    await loadData();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(      appBar: AppBar(
        title: const Text("المشتريات"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addPurchase,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : purchases.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد مشتريات",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {

                    final purchase = purchases[index];

                    return Card(
                      margin: const EdgeInsets.all(8),

                      child: ListTile(

                        onTap: () async {

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PurchaseDetailsScreen(
                                purchaseId:
                                    purchase["id"],
                              ),
                            ),
                          );

                          await loadData();

                        },

                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.shopping_cart,
                          ),
                        ),

                        title: Text(
                          "فاتورة شراء رقم ${purchase["id"]}",
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "الإجمالي: ${purchase["total"]} جنيه",
                            ),

                            Text(
                              "التاريخ: ${purchase["date"]}",
                            ),

                            if ((purchase["notes"] ?? "")
                                .toString()
                                .isNotEmpty)
                              Text(
                                "ملاحظات: ${purchase["notes"]}",
                              ),

                          ],
                        ),

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {

                            await deletePurchase(
                              purchase["id"],
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