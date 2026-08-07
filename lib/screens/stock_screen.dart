import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() =>
      _StockScreenState();
}

class _StockScreenState
    extends State<StockScreen> {

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];

  bool loading = true;

  final searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {

    products =
        await DatabaseHelper.instance
            .getProducts();

    filteredProducts =
        List.from(products);

    if (!mounted) return;

    setState(() {
      loading = false;
    });

  }

  void search(String value) {

    setState(() {

      filteredProducts =
          products.where((product) {

        return product["name"]
            .toString()
            .toLowerCase()
            .contains(
              value.toLowerCase(),
            );

      }).toList();

    });

  }

  Color getStockColor(int quantity) {

    if (quantity <= 5) {
      return Colors.red;
    }

    if (quantity <= 10) {
      return Colors.orange;
    }

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "المخزون",
        ),
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                Padding(

                  padding:
                      const EdgeInsets.all(12),

                  child: TextField(

                    controller:
                        searchController,

                    onChanged: search,

                    decoration:
                        const InputDecoration(

                      hintText:
                          "ابحث عن منتج...",

                      prefixIcon:
                          Icon(Icons.search),

                      border:
                          OutlineInputBorder(),

                    ),

                  ),

                ),

                Expanded(                  child: filteredProducts.isEmpty

                      ? const Center(

                          child: Text(
                            "لا توجد منتجات",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),

                        )

                      : ListView.builder(

                          itemCount:
                              filteredProducts.length,

                          itemBuilder:
                              (context, index) {

                            final product =
                                filteredProducts[index];

                            final quantity =
                                product["quantity"] ?? 0;

                            return Card(

                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              child: ListTile(

                                leading: CircleAvatar(

                                  backgroundColor:
                                      getStockColor(quantity),

                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                ),

                                title: Text(
                                  product["name"],
                                ),

                                subtitle: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(
                                      "الماركة: ${product["brand"]}",
                                    ),

                                    Text(
                                      "سعر الشراء: ${product["buy_price"]}",
                                    ),

                                    Text(
                                      "سعر البيع: ${product["sell_price"]}",
                                    ),

                                  ],

                                ),

                                trailing: quantity <= 5

                                    ? const Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                      )

                                    : const Icon(
                        Icons.check_circle,
                                        color: Colors.green,
                                      ),

                              ),

                            );

                          },

                        ),

                ),

              ],

            ),

    );

  }

}
