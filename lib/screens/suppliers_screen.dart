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

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> loadSuppliers() async {
    final data =
        await DatabaseHelper.instance.getSuppliers();

    if (!mounted) return;

    setState(() {
      suppliers = data;
      loading = false;
    });
  }

  Future<void> addSupplier() async {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    notesController.clear();

    await showDialog(
      context: context,
      builder: (dialogContext) {
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
                    .insertSupplier({
                  "name": name,
                  "phone":
                      phoneController.text.trim(),
                  "address":
                      addressController.text.trim(),
                  "notes":
                      notesController.text.trim(),
                });

                if (!mounted) return;

                Navigator.pop(dialogContext);

                await loadSuppliers();
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  Future<void> editSupplier(
      Map<String, dynamic> supplier) async {
    nameController.text =
        supplier["name"]?.toString() ?? "";

    phoneController.text =
        supplier["phone"]?.toString() ?? "";

    addressController.text =
        supplier["address"]?.toString() ?? "";

    notesController.text =
        supplier["notes"]?.toString() ?? "";

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("تعديل المورد"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المورد",
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
                    .updateSupplier(
                  supplier["id"],
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

                await loadSuppliers();
              },
              child: const Text("حفظ التعديل"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSupplier(int id) async {
    await DatabaseHelper.instance
        .deleteSupplier(id);

    await loadSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الموردين"),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: addSupplier,
        child: const Icon(Icons.business),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : suppliers.isEmpty
              ? const Center(
                  child: Text(
                    "لا يوجد موردين",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadSuppliers,
                  child: ListView.builder(
                    itemCount: suppliers.length,
                    itemBuilder:
                        (context, index) {
                      final supplier =
                          suppliers[index];

                      final name =
                          supplier["name"]
                                  ?.toString() ??
                              "";

                      final phone =
                          supplier["phone"]
                                  ?.toString() ??
                              "";

                      return Card(
                        margin:
                            const EdgeInsets.all(8),

                        child: ListTile(
                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.business,
                            ),
                          ),

                          title: Text(name),

                          subtitle: Text(
                            phone.isNotEmpty
                                ? phone
                                : "لا يوجد رقم هاتف",
                          ),

                          onTap: () {
                            editSupplier(
                              supplier,
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
                                  editSupplier(
                                    supplier,
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteSupplier(
                                    supplier["id"],
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