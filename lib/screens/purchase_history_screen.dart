import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() =>
      _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState
    extends State<PurchaseHistoryScreen> {
  final List<Map<String, dynamic>> purchases = [];

  void addPurchase() {
    setState(() {
      purchases.add({
        "id": purchases.length + 1,
        "supplier": "مورد جديد",
        "total": 0,
        "date": DateTime.now().toString().substring(0, 16),
      });
    });
  }

  void deletePurchase(int index) {
    setState(() {
      purchases.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل المشتريات"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addPurchase,
        child: const Icon(Icons.add),
      ),

      body: purchases.isEmpty
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
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_cart),
                    ),

                    title: Text(
                      "فاتورة شراء رقم ${purchase["id"]}",
                    ),

                    subtitle: Text(
                      "المورد: ${purchase["supplier"]}\n"
                      "الإجمالي: ${purchase["total"]} جنيه\n"
                      "التاريخ: ${purchase["date"]}",
                    ),

                    isThreeLine: true,

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deletePurchase(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}