import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SaleDetailsScreen extends StatefulWidget {

  final int saleId;

  const SaleDetailsScreen({
    super.key,
    required this.saleId,
  });

  @override
  State<SaleDetailsScreen> createState() =>
      _SaleDetailsScreenState();
}

class _SaleDetailsScreenState
    extends State<SaleDetailsScreen> {

  List<Map<String, dynamic>> items = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {

    items = await DatabaseHelper.instance
        .getSaleItems(widget.saleId);

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
          "فاتورة بيع رقم ${widget.saleId}",
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
                              "سعر البيع: ${item["sell_price"]} جنيه",
                            ),

                            const SizedBox(height: 8),

                            Text(

                              "الإجمالي: ${((item["quantity"] as num).toDouble() * (item["sell_price"] as num).toDouble()).toStringAsFixed(2)} جنيه",

                              style: const TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                              ),

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