import 'package:flutter/material.dart';

import 'theme_controller.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/customers_screen.dart';
import 'screens/suppliers_screen.dart';
import 'screens/purchases_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/sales_history_screen.dart';
import 'screens/purchase_history_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThemeController.instance.load();

  runApp(const JouxOppoPOS());
}

class JouxOppoPOS extends StatelessWidget {
  const JouxOppoPOS({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,

      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Joux Oppo POS',

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          themeMode:
              ThemeController.instance.themeMode,

          initialRoute: "/",

          routes: {
            "/": (context) => const LoginScreen(),

            "/home": (context) =>
                const HomeScreen(),

            "/products": (context) =>
                const ProductsScreen(),

            "/customers": (context) =>
                const CustomersScreen(),

            "/suppliers": (context) =>
                const SuppliersScreen(),

            "/purchases": (context) =>
                const PurchasesScreen(),

            "/sales": (context) =>
                const SalesScreen(),

            "/sales_history": (context) =>
                const SalesHistoryScreen(),

            "/purchase_history": (context) =>
                const PurchaseHistoryScreen(),
          },
        );
      },
    );
  }
}