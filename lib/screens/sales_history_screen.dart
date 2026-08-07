import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'sale_details_screen.dart';

class SalesHistoryScreen extends StatefulWidget {

  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() =>
      _SalesHistoryScreenState();

}

class _SalesHistoryScreenState
    extends State<SalesHistoryScreen> {

  List<Map<String, dynamic>> sales = [];

  bool loading = true;

  @override
  void initState() {

    super.initState();

    loadSales();

  }

  Future<void> loadSales() async {

    sales =
        await DatabaseHelper.instance
            .getSales();

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }  Future<void> deleteSale(int id) async {

    await DatabaseHelper.instance
        .deleteSale(id);

    await loadSales();

  }

  Future<void> openDetails(
      int saleId) async {

    await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => SaleDetailsScreen(
          saleId: saleId,
        ),

      ),

    );

    await loadSales();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "سجل الفواتير",
        ),

      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : sales.isEmpty

              ? const Center(

                  child: Text(

                    "لا توجد فواتير",

                    style: TextStyle(
                      fontSize: 20,
                    ),

                  ),

                )

              : ListView.builder(

                  itemCount: sales.length,

                  itemBuilder:
                      (context, index) {

                    final sale =
                        sales[index];                    return Card(

                      margin:
                          const EdgeInsets.all(8),

                      child: ListTile(

                        leading: CircleAvatar(

                          child: Text(
                            sale["id"].toString(),
                          ),

                        ),

                        title: Text(
                          "فاتورة رقم ${sale["id"]}",
                        ),

                        subtitle: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              "الإجمالي: ${sale["total"]} جنيه",
                            ),

                            Text(
                              sale["date"] ?? "",
                            ),

                            if ((sale["notes"] ?? "")
                                .toString()
                                .isNotEmpty)

                              Text(
                                "ملاحظات: ${sale["notes"]}",
                              ),

                          ],

                        ),

                        onTap: () {

                          openDetails(
                            sale["id"],
                          );

                        },

                        trailing: IconButton(

                          icon: const Icon(

                            Icons.delete,

                            color: Colors.red,

                          ),

                          onPressed: () async {

                            final confirm =
                                await showDialog<bool>(

                              context: context,

                              builder: (_) => AlertDialog(

                                title: const Text(
                                  "حذف الفاتورة",
                                ),

                                content: const Text(
                                  "هل أنت متأكد من حذف هذه الفاتورة؟",
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("إلغاء"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("حذف"),
                                  ),
                                ],

                              ),

                            );

                            if (confirm == true) {

                              await deleteSale(
                                sale["id"],
                              );

                            }

                          },

                        ),

                      ),

                    );                  },

                ),

    );

  }

}