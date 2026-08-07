import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState
    extends State<AddProductScreen> {

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final brandController = TextEditingController();
  final imei1Controller = TextEditingController();
  final imei2Controller = TextEditingController();
  final serialController = TextEditingController();
  final quantityController = TextEditingController();
  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();

  Future<void> saveProduct() async {

    await DatabaseHelper.instance.insertProduct({

      "name": nameController.text,

      "category": categoryController.text,

      "brand": brandController.text,

      "imei1": imei1Controller.text,

      "imei2": imei2Controller.text,

      "serial_number": serialController.text,

      "quantity":
          int.tryParse(
                  quantityController.text) ??
              0,

      "buy_price":
          double.tryParse(
                  buyPriceController.text) ??
              0,

      "sell_price":
          double.tryParse(
                  sellPriceController.text) ??
              0,

      "created_at":
          DateTime.now().toIso8601String(),

      "updated_at":
          DateTime.now().toIso8601String(),

    });

    if (!mounted) return;

    Navigator.pop(context);

  }

  Widget buildField(
    TextEditingController controller,
    String label,
  ) {
      return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
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
          "إضافة منتج",
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(10),

        child: Column(

          children: [

            buildField(
              nameController,
              "اسم المنتج",
            ),

            buildField(
              categoryController,
              "النوع",
            ),

            buildField(
              brandController,
              "الماركة",
            ),

            buildField(
              imei1Controller,
              "IMEI 1",
            ),

            buildField(
              imei2Controller,
              "IMEI 2",
            ),

            buildField(
              serialController,
              "Serial Number",
            ),

            buildField(
              quantityController,
              "الكمية",
            ),
                        buildField(
              buyPriceController,
              "سعر الشراء",
            ),

            buildField(
              sellPriceController,
              "سعر البيع",
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                onPressed: saveProduct,

                child: const Text(
                  "حفظ المنتج",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

              ),
            ),

            const SizedBox(
              height: 20,
            ),

          ],

        ),

      ),

    );

  }

}