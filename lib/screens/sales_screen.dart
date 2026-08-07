import 'package:flutter/material.dart';
import 'sale_details_screen.dart';
import '../database/database_helper.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() =>
      _SalesScreenState();
}

class _SalesScreenState
    extends State<SalesScreen> {

  List<Map<String, dynamic>> sales = [];
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> products = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    sales = await DatabaseHelper.instance
        .getSales();

    customers =
        await DatabaseHelper.instance
            .getCustomers();

    products =
        await DatabaseHelper.instance
            .getProducts();

    if (!mounted) return;

    setState(() {
      loading = false;
    });

  }

  Future<void> addSale() async {

    int? selectedCustomer;
    int? selectedProduct;

    final quantityController =
        TextEditingController();

    final priceController =
        TextEditingController();

    final discountController =
        TextEditingController();

    final paidController =
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
                "فاتورة بيع جديدة",
              ),

              content: SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [                    DropdownButtonFormField<int>(
                      value: selectedCustomer,
                      decoration: const InputDecoration(
                        labelText: "العميل",
                        border: OutlineInputBorder(),
                      ),
                      items: customers.map((customer) {
                        return DropdownMenuItem<int>(
                          value: customer["id"],
                          child: Text(customer["name"]),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCustomer = value;
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
                          child: Text(product["name"]),
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
                        labelText: "سعر البيع",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "الخصم",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: paidController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "المبلغ المدفوع",
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

                    if (selectedCustomer == null ||
                        selectedProduct == null) {
                      return;
                    }

                    final quantity =
                        int.tryParse(
                          quantityController.text,
                        ) ??
                        0;

                    final price =
                        double.tryParse(
                          priceController.text,
                        ) ??
                        0;

                    final discount =
                        double.tryParse(
                          discountController.text,
                        ) ??
                        0;

                    final paid =
                        double.tryParse(
                          paidController.text,
                        ) ??
                        0;

                    final total =
                        (quantity * price) - discount;

                    final saleId =
                        await DatabaseHelper.instance
                            .insertSale({

                      "customer_id":
                          selectedCustomer,

                      "date":
                          DateTime.now()
                              .toIso8601String(),

                      "total":
                          total,

                      "discount":
                          discount,

                      "paid":
                          paid,

                      "remaining":
                          total - paid,

                      "notes":
                          notesController.text,

                    });

                    await DatabaseHelper.instance
                        .insertSaleItem({

                      "sale_id":
                          saleId,

                      "product_id":
                          selectedProduct,

                      "quantity":
                          quantity,

                      "sell_price":
                          price,

                    });

                    await DatabaseHelper.instance
                        .decreaseProductQuantity(
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

  Future<void> deleteSale(
      int id) async {

    await DatabaseHelper.instance
        .deleteSale(id);

    await loadData();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(      appBar: AppBar(
        title: const Text("المبيعات"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addSale,
        child: const Icon(Icons.add),
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

                        leading: const CircleAvatar(
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
                                saleId: sale["id"],
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
                              Icons.arrow_forward_ios,
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





