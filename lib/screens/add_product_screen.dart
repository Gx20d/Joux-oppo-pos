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


  final name = TextEditingController();
  final type = TextEditingController();
  final brand = TextEditingController();
  final imei1 = TextEditingController();
  final imei2 = TextEditingController();
  final quantity = TextEditingController();
  final buyPrice = TextEditingController();
  final sellPrice = TextEditingController();



  Future<void> saveProduct() async {


    await DatabaseHelper.instance
        .insertProduct({

      "name": name.text,

      "type": type.text,

      "brand": brand.text,

      "imei1": imei1.text,

      "imei2": imei2.text,

      "quantity":
      int.tryParse(quantity.text) ?? 0,

      "buy_price":
      double.tryParse(buyPrice.text) ?? 0,

      "sell_price":
      double.tryParse(sellPrice.text) ?? 0,

    });



    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content:
        Text(
          "تم إضافة المنتج",
        ),

      ),

    );


    Navigator.pop(context);


  }




  Widget field(
      String title,
      TextEditingController controller) {


    return Padding(

      padding:
      const EdgeInsets.all(8),


      child:
      TextField(

        controller:
        controller,


        decoration:
        InputDecoration(

          labelText:title,

          border:
          const OutlineInputBorder(),

        ),

      ),

    );

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar:
      AppBar(

        title:
        const Text(
          "إضافة منتج",
        ),

      ),


      body:
      SingleChildScrollView(

        child:
        Column(

          children:[


            field(
              "اسم المنتج",
              name,
            ),


            field(
              "النوع",
              type,
            ),


            field(
              "الماركة",
              brand,
            ),


            field(
              "IMEI 1",
              imei1,
            ),


            field(
              "IMEI 2",
              imei2,
            ),


            field(
              "الكمية",
              quantity,
            ),


            field(
              "سعر الشراء",
              buyPrice,
            ),


            field(
              "سعر البيع",
              sellPrice,
            ),



            const SizedBox(
              height:20,
            ),



            ElevatedButton(

              onPressed:
              saveProduct,


              child:
              const Text(
                "حفظ المنتج",
              ),

            ),


          ],

        ),

      ),

    );


  }


}