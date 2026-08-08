import 'package:flutter/material.dart';

import 'sale_details_screen.dart';
import '../database/database_helper.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Map<String, dynamic>> sales = [];
  List<Map<String, dynamic>> products = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final loadedSales =
          await DatabaseHelper.instance.getSales();

      final loadedProducts =
          await DatabaseHelper.instance.getProducts();

      if (!mounted) return;

      setState(() {
        sales = loadedSales;
        products = loadedProducts;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "حدث خطأ أثناء تحميل المبيعات: $e",
          ),
        ),
      );
    }
  }

  Future<void> addSale() async {
    int? selectedProduct;

    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    final discountController =
        TextEditingController(text: "0");
    final paidController =
        TextEditingController(text: "0");
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("فاتورة بيع جديدة"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // =========================
                    // PRODUCT
                    // =========================

                    DropdownButtonFormField<int>(
                      value: selectedProduct,
                      decoration: const InputDecoration(
                        labelText: "المنتج",
                        border: OutlineInputBorder(),
                      ),
                      items: products.map((product) {
                        return DropdownMenuItem<int>(
                          value: product["id"] as int,
                          child: Text(
                            product["name"].toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedProduct = value;

                          if (value != null) {
                            final product =
                                products.firstWhere(
                              (p) => p["id"] == value,
                            );

                            final sellPrice =
                                product["sell_price"];

                            if (sellPrice != null) {
                              priceController.text =
                                  sellPrice.toString();
                            }
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // QUANTITY
                    // =========================

                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "الكمية",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // SELL PRICE
                    // =========================

                    TextField(
                      controller: priceController,
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

                    // =========================
                    // DISCOUNT
                    // =========================

                    TextField(
                      controller: discountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "الخصم",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // PAID
                    // =========================

                    TextField(
                      controller: paidController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "المبلغ المدفوع",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // NOTES
                    // =========================

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

                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("حفظ"),

                  onPressed: () async {
                    // =========================
                    // CHECK PRODUCT
                    // =========================

                    if (selectedProduct == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "من فضلك اختر المنتج",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // READ DATA
                    // =========================

                    final quantity = int.tryParse(
                          quantityController.text.trim(),
                        ) ??
                        0;

                    final price = double.tryParse(
                          priceController.text.trim(),
                        ) ??
                        0;

                    final discount = double.tryParse(
                          discountController.text.trim(),
                        ) ??
                        0;

                    final paid = double.tryParse(
                          paidController.text.trim(),
                        ) ??
                        0;

                    // =========================
                    // CHECK QUANTITY
                    // =========================

                    if (quantity <= 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "من فضلك أدخل كمية صحيحة",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // CHECK PRICE
                    // =========================

                    if (price <= 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "من فضلك أدخل سعر البيع",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // CHECK DISCOUNT
                    // =========================

                    if (discount < 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "الخصم غير صحيح",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // CALCULATE TOTAL
                    // =========================

                    final subtotal =
                        quantity * price;

                    final total =
                        subtotal - discount;

                    if (total < 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "الخصم أكبر من إجمالي الفاتورة",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // CHECK PAID
                    // =========================

                    if (paid < 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "المبلغ المدفوع غير صحيح",
                          ),
                        ),
                      );
                      return;
                    }

                    if (paid > total) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "المبلغ المدفوع أكبر من إجمالي الفاتورة",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // CHECK STOCK
                    // =========================

                    final selectedProductData =
                        products.firstWhere(
                      (product) =>
                          product["id"] ==
                          selectedProduct,
                    );

                    final stock =
                        (selectedProductData["quantity"] ??
                                0)
                            as int;

                    if (quantity > stock) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "الكمية غير متوفرة في المخزون. المتاح: $stock",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================
                    // SAVE SALE
                    // =========================

                    try {
                      final saleId =
                          await DatabaseHelper.instance
                              .insertSale({
                        "date":
                            DateTime.now()
                                .toIso8601String(),

                        "total": total,

                        "discount": discount,

                        "paid": paid,

                        "remaining":
                            total - paid,

                        "notes":
                            notesController.text
                                .trim(),
                      });

                      // =========================
                      // SAVE SALE ITEM
                      // =========================

                      await DatabaseHelper.instance
                          .insertSaleItem({
                        "sale_id": saleId,

                        "product_id":
                            selectedProduct,

                        "quantity": quantity,

                        "sell_price": price,
                      });

                      // =========================
                      // DECREASE STOCK
                      // =========================

                      await DatabaseHelper.instance
                          .decreaseProductQuantity(
                        selectedProduct!,
                        quantity,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pop(context);

                      // =========================
                      // REFRESH
                      // =========================

                      await loadData();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "تم حفظ فاتورة البيع رقم $saleId بنجاح ✅",
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "حدث خطأ أثناء حفظ الفاتورة: $e",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    quantityController.dispose();
    priceController.dispose();
    discountController.dispose();
    paidController.dispose();
    notesController.dispose();
  }

  Future<void> deleteSale(int id) async {
    try {
      await DatabaseHelper.instance.deleteSale(id);

      await loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف الفاتورة"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "حدث خطأ أثناء الحذف: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المبيعات"),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: addSale,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text("فاتورة بيع"),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : sales.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد مبيعات",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: sales.length,

                  itemBuilder: (context, index) {
                    final sale = sales[index];

                    return Card(
                      margin: const EdgeInsets.all(8),

                      child: ListTile(
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.point_of_sale,
                          ),
                        ),

                        title: Text(
                          "فاتورة بيع رقم ${sale["id"]}",
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              "الإجمالي: ${sale["total"]} جنيه",
                            ),

                            Text(
                              "المدفوع: ${sale["paid"]} جنيه",
                            ),

                            Text(
                              "المتبقي: ${sale["remaining"]} جنيه",
                            ),

                            Text(
                              "التاريخ: ${sale["date"]}",
                            ),

                            if ((sale["notes"] ?? "")
                                .toString()
                                .isNotEmpty)
                              Text(
                                "ملاحظات: ${sale["notes"]}",
                              ),
                          ],
                        ),

                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SaleDetailsScreen(
                                saleId:
                                    sale["id"],
                              ),
                            ),
                          );

                          await loadData();
                        },

                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [
                            const Icon(
                              Icons
                                  .arrow_forward_ios,
                              size: 16,
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),

                              onPressed: () async {
                                await deleteSale(
                                  sale["id"],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}