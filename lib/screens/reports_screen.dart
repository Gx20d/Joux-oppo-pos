import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();
}


class _ReportsScreenState
    extends State<ReportsScreen> {

  double totalSales = 0;
  double totalProfit = 0;
  int salesCount = 0;

  bool loading = true;


  @override
  void initState() {

    super.initState();

    loadReports();

  }



  Future<void> loadReports() async {


    final sales =
        await DatabaseHelper.instance
        .getSales();


    double salesTotal = 0;

    double profit = 0;


    for(var sale in sales){

      salesTotal +=
          sale["total"] ?? 0;

    }



    final products =
        await DatabaseHelper.instance
        .getProducts();



    for(var product in products){


      int quantity =
          product["quantity"] ?? 0;


      double buy =
          product["buy_price"] ?? 0;


      double sell =
          product["sell_price"] ?? 0;


      profit +=
          (sell - buy) *
          quantity;


    }



    setState(() {

      totalSales = salesTotal;

      salesCount = sales.length;

      totalProfit = profit;

      loading = false;

    });


  }





  Widget card(
      String title,
      String value,
      IconData icon) {


    return Card(

      child:
      ListTile(

        leading:
        CircleAvatar(

          child:
          Icon(icon),

        ),


        title:
        Text(title),


        subtitle:
        Text(

          value,

          style:
          const TextStyle(
            fontSize:18,
            fontWeight:
            FontWeight.bold,
          ),

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
          "التقارير",
        ),

      ),


      body:
      loading

          ?

      const Center(
        child:
        CircularProgressIndicator(),
      )


          :

      RefreshIndicator(

        onRefresh:
        loadReports,


        child:
        ListView(

          padding:
          const EdgeInsets.all(10),


          children: [


            card(
              "عدد الفواتير",
              salesCount.toString(),
              Icons.receipt,
            ),


            card(
              "إجمالي المبيعات",
              "$totalSales جنيه",
              Icons.attach_money,
            ),


            card(
              "الأرباح المتوقعة",
              "$totalProfit جنيه",
              Icons.trending_up,
            ),


          ],


        ),

      ),


    );


  }


}