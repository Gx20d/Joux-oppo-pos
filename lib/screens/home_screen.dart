import 'package:flutter/material.dart';

import 'products_screen.dart';
import 'suppliers_screen.dart';
import 'purchases_screen.dart';
import 'sales_screen.dart';
import 'sales_history_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';
import 'stock_screen.dart';
import 'backup_restore_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "title": "المنتجات",
        "icon": Icons.inventory_2,
        "page": const ProductsScreen(),
      },
      {
        "title": "البحث",
        "icon": Icons.search,
        "page": const SearchScreen(),
      },
      {
        "title": "المخزون",
        "icon": Icons.inventory,
        "page": const StockScreen(),
      },
      {
        "title": "الموردين",
        "icon": Icons.local_shipping,
        "page": const SuppliersScreen(),
      },
      {
        "title": "المشتريات",
        "icon": Icons.shopping_cart,
        "page": const PurchasesScreen(),
      },
      {
        "title": "المبيعات",
        "icon": Icons.point_of_sale,
        "page": const SalesScreen(),
      },
      {
        "title": "الفواتير",
        "icon": Icons.receipt_long,
        "page": const SalesHistoryScreen(),
      },
      {
        "title": "التقارير",
        "icon": Icons.bar_chart,
        "page": const ReportsScreen(),
      },
      {
        "title": "الإعدادات",
        "icon": Icons.settings,
        "page": const SettingsScreen(),
      },
      {
        "title": "النسخ الاحتياطي",
        "icon": Icons.backup,
        "page": const BackupRestoreScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 38,
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.store,
                  size: 32,
                );
              },
            ),
            const SizedBox(width: 10),
            const Text(
              "Joux Oppo POS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(15),

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.05,
        ),

        itemCount: items.length,

        itemBuilder: (context, index) {
          final item = items[index];

          return InkWell(
            borderRadius: BorderRadius.circular(18),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => item["page"] as Widget,
                ),
              );
            },

            child: Card(
              elevation: 5,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  CircleAvatar(
                    radius: 32,

                    backgroundColor:
                        Colors.orange.shade100,

                    child: Icon(
                      item["icon"] as IconData,
                      size: 34,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    item["title"] as String,
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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