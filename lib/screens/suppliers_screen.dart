import 'package:flutter/material.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final List<Map<String, String>> suppliers = [];

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void addSupplier() {
    nameController.clear();
    phoneController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("إضافة مورد"),
          content: Column(
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  suppliers.add({
                    "name": nameController.text.trim(),
                    "phone": phoneController.text.trim(),
                  });
                });

                Navigator.pop(context);
              },
              child: const Text("حفظ"),
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
        title: const Text("الموردين"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSupplier,
        child: const Icon(Icons.add),
      ),
      body: suppliers.isEmpty
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
                      child: Icon(Icons.business),
                    ),
                    title: Text(supplier["name"] ?? ""),
                    subtitle: Text(
                      supplier["phone"]?.isNotEmpty == true
                          ? supplier["phone"]!
                          : "لا يوجد رقم هاتف",
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          suppliers.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}