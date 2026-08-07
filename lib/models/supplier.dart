import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<Map<String, dynamic>> suppliers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    suppliers = await DatabaseHelper.instance.getSuppliers();

    setState(() {
      loading = false;
    });
  }

  Future<void> addSupplier() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("إضافة مورد"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المورد",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "رقم الهاتف",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "العنوان",
                  ),
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
                await DatabaseHelper.instance.insertSupplier({
                  "name": nameController.text,
                  "phone": phoneController.text,
                  "address": addressController.text,
                });

                if (!mounted) return;

                Navigator.pop(context);

                await loadSuppliers();
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSupplier(int id) async {
    await DatabaseHelper.instance.deleteSupplier(id);
    await loadSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الموردين"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSupplier,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : suppliers.isEmpty
              ? const Center(
                  child: Text(
                    "لا يوجد موردين",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = suppliers[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.local_shipping),
                        ),
                        title: Text(supplier["name"] ?? ""),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(supplier["phone"] ?? ""),
                            Text(supplier["address"] ?? ""),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteSupplier(supplier["id"]);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}