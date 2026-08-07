import 'package:flutter/material.dart';
import '../database/database_helper.dart';


class SearchScreen extends StatefulWidget {

  const SearchScreen({super.key});


  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();

}



class _SearchScreenState
    extends State<SearchScreen> {


  List<Map<String,dynamic>> products = [];

  List<Map<String,dynamic>> filtered = [];


  @override
  void initState() {

    super.initState();

    loadProducts();

  }



  Future<void> loadProducts() async {

    products =
        await DatabaseHelper.instance
        .getProducts();

    filtered = products;

    setState(() {});

  }




  void search(String value) {


    setState(() {


      filtered =
          products.where((product){


            final name =
            product["name"]
                .toString()
                .toLowerCase();


            final brand =
            product["brand"]
                .toString()
                .toLowerCase();


            return name.contains(
                value.toLowerCase())
                ||
                brand.contains(
                    value.toLowerCase());


          }).toList();


    });


  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar:
      AppBar(

        title:
        const Text(
          "البحث",
        ),

      ),


      body:
      Column(

        children:[


          Padding(

            padding:
            const EdgeInsets.all(10),


            child:
            TextField(

              onChanged:
              search,


              decoration:
              const InputDecoration(

                hintText:
                "ابحث عن منتج أو ماركة",

                prefixIcon:
                Icon(
                  Icons.search,
                ),

                border:
                OutlineInputBorder(),

              ),

            ),

          ),



          Expanded(

            child:
            ListView.builder(

              itemCount:
              filtered.length,


              itemBuilder:
                  (context,index){


                final product =
                filtered[index];


                return Card(

                  child:
                  ListTile(


                    title:
                    Text(
                      product["name"],
                    ),


                    subtitle:
                    Text(

                      "${product["brand"]} - الكمية: ${product["quantity"]}",

                    ),


                    trailing:
                    Text(

                      "${product["sell_price"]} جنيه",

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