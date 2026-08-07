import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/customers_screen.dart';
import 'screens/suppliers_screen.dart';
import 'screens/purchases_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/sales_history_screen.dart';
import 'screens/purchase_history_screen.dart';

void main() {
  runApp(const JouxOppoPOS());
}

class JouxOppoPOS extends StatelessWidget {
  const JouxOppoPOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joux Oppo POS',
            theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),

      initialRoute: "/",

      routes: {

        "/": (context) => const LoginScreen(),

        "/home": (context) =>  HomeScreen(),

        "/products": (context) =>  ProductsScreen(),

        "/customers": (context) =>  CustomersScreen(),

        "/suppliers": (context) =>  SuppliersScreen(),

        "/purchases": (context) =>  PurchasesScreen(),

        "/sales": (context) =>  SalesScreen(),

        "/sales_history": (context) =>
            const SalesHistoryScreen(),

        "/purchase_history": (context) =>
            const PurchaseHistoryScreen(),

      },
          );
  }
}