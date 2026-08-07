import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class PurchaseDetailsScreen extends StatefulWidget {

  final int purchaseId;

  const PurchaseDetailsScreen({
    super.key,
    required this.purchaseId,
  });

  @override
  State<PurchaseDetailsScreen> createState() =>
      _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState
    extends State<PurchaseDetailsScreen> {

  List<Map<String, dynamic>> items = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {

    items = await DatabaseHelper.instance
        .getPurchaseItems(
      widget.purchaseId,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "فاتورة شراء رقم ${widget.purchaseId}",
        ),

      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : items.isEmpty

              ? const Center(
                  child: Text(
                    "لا توجد منتجات",
                  ),
                )

              : ListView.builder(

                  itemCount: items.length,

                  itemBuilder:
                      (context, index) {

                    final item = items[index];                    return Card(

                      margin: const EdgeInsets.all(8),

                      child: Padding(

                        padding: const EdgeInsets.all(12),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              item["product_name"] ??
                                  "منتج",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "الماركة: ${item["brand"] ?? "-"}",
                            ),

                            Text(
                              "الكمية: ${item["quantity"]}",
                            ),

                            Text(
                              "سعر الشراء: ${item["buy_price"]} جنيه",
                            ),

                            Text(
                              "الإجمالي: ${((item["quantity"] as num).toDouble() * (item["buy_price"] as num).toDouble()).toStringAsFixed(2)} جنيه",
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