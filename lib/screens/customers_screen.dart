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

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> loadCustomers() async {
    final data =
        await DatabaseHelper.instance.getCustomers();

    if (!mounted) return;

    setState(() {
      customers = data;
      loading = false;
    });
  }

  Future<void> addCustomer() async {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    notesController.clear();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("إضافة عميل"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم العميل",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "رقم الهاتف",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "العنوان",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "ملاحظات",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("إلغاء"),
            ),

            ElevatedButton(
              onPressed: () async {
                final name =
                    nameController.text.trim();

                final phone =
                    phoneController.text.trim();

                final address =
                    addressController.text.trim();

                final notes =
                    notesController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                await DatabaseHelper.instance
                    .insertCustomer({
                  "name": name,
                  "phone": phone,
                  "address": address,
                  "notes": notes,
                });

                if (!mounted) return;

                Navigator.pop(dialogContext);

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
    await DatabaseHelper.instance
        .deleteCustomer(id);

    await loadCustomers();
  }

  Future<void> editCustomer(
      Map<String, dynamic> customer) async {
    nameController.text =
        customer["name"]?.toString() ?? "";

    phoneController.text =
        customer["phone"]?.toString() ?? "";

    addressController.text =
        customer["address"]?.toString() ?? "";

    notesController.text =
        customer["notes"]?.toString() ?? "";

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("تعديل العميل"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم العميل",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "رقم الهاتف",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "العنوان",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "ملاحظات",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("إلغاء"),
            ),

            ElevatedButton(
              onPressed: () async {
                final name =
                    nameController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                await DatabaseHelper.instance
                    .updateCustomer(
                  customer["id"],
                  {
                    "name": name,
                    "phone":
                        phoneController.text.trim(),
                    "address":
                        addressController.text.trim(),
                    "notes":
                        notesController.text.trim(),
                  },
                );

                if (!mounted) return;

                Navigator.pop(dialogContext);

                await loadCustomers();
              },
              child: const Text("حفظ التعديل"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("العملاء"),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: addCustomer,
        child: const Icon(Icons.person_add),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : customers.isEmpty
              ? const Center(
                  child: Text(
                    "لا يوجد عملاء",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadCustomers,
                  child: ListView.builder(
                    itemCount: customers.length,
                    itemBuilder:
                        (context, index) {
                      final customer =
                          customers[index];

                      final name =
                          customer["name"]
                                  ?.toString() ??
                              "";

                      final phone =
                          customer["phone"]
                                  ?.toString() ??
                              "";

                      return Card(
                        margin:
                            const EdgeInsets.all(8),

                        child: ListTile(
                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.person,
                            ),
                          ),

                          title: Text(name),

                          subtitle: Text(
                            phone.isNotEmpty
                                ? phone
                                : "لا يوجد رقم هاتف",
                          ),

                          onTap: () {
                            editCustomer(
                              customer,
                            );
                          },

                          trailing: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  editCustomer(
                                    customer,
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteCustomer(
                                    customer["id"],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}