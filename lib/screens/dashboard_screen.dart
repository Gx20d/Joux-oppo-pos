import 'package:flutter/material.dart';

import 'products_screen.dart';
import 'customers_screen.dart';
import 'suppliers_screen.dart';
import 'purchases_screen.dart';
import 'sales_screen.dart';
import 'reports_screen.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});

  Widget dashboardItem({

    required BuildContext context,

    required String title,

    required IconData icon,

    required Widget page,

    required Color color,

  }) {

    return InkWell(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) => page,

          ),

        );

      },

      borderRadius: BorderRadius.circular(20),

      child: Card(

        elevation: 6,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(20),

        ),

        child: Container(

          height: 140,

          padding: const EdgeInsets.all(16),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Icon(

                icon,

                size: 45,

                color: color,

              ),

              const SizedBox(height: 12),

              Text(

                title,

                style: const TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Joux Oppo",
        ),

        centerTitle: true,

      ),

      body: Padding(

        padding: const EdgeInsets.all(12),

        child: GridView.count(

          crossAxisCount: 2,

          crossAxisSpacing: 12,

          mainAxisSpacing: 12,

          children: [            dashboardItem(
              context: context,
              title: "المنتجات",
              icon: Icons.inventory_2,
              page: const ProductsScreen(),
              color: Colors.blue,
            ),

            dashboardItem(
              context: context,
              title: "العملاء",
              icon: Icons.people,
              page: const CustomersScreen(),
              color: Colors.green,
            ),

            dashboardItem(
              context: context,
              title: "الموردين",
              icon: Icons.local_shipping,
              page: const SuppliersScreen(),
              color: Colors.orange,
            ),

            dashboardItem(
              context: context,
              title: "المشتريات",
              icon: Icons.shopping_cart,
              page: const PurchasesScreen(),
              color: Colors.deepPurple,
            ),

            dashboardItem(
              context: context,
              title: "المبيعات",
              icon: Icons.point_of_sale,
              page: const SalesScreen(),
              color: Colors.red,
            ),

            dashboardItem(
              context: context,
              title: "التقارير",
              icon: Icons.bar_chart,
              page: const ReportsScreen(),
              color: Colors.teal,
            ),

          ],

        ),

      ),

    );

  }

}