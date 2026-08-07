import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Map<String, dynamic>> customers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    customers = await DatabaseHelper.instance.getCustomers();

    setState(() {
      loading = false;
    });
  }

  Future<void> addCustomer() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("إضافة عميل"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "اسم العميل"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(labelText: "رقم الهاتف"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration:
                      const InputDecoration(labelText: "العنوان"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.insertCustomer({
                  "name": nameController.text,
                  "phone": phoneController.text,
                  "address": addressController.text,
                });

                if (!mounted) return;

                Navigator.pop(context);

                await loadCustomers();
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCustomer(int id) async {
    await DatabaseHelper.instance.deleteCustomer(id);
    await loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("العملاء"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCustomer,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : customers.isEmpty
              ? const Center(
                  child: Text(
                    "لا يوجد عملاء",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(customer["name"] ?? ""),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(customer["phone"] ?? ""),
                            Text(customer["address"] ?? ""),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteCustomer(customer["id"]);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}