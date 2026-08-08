import 'package:flutter/material.dart';

import '../theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final shopName = TextEditingController(
    text: "Joux Oppo",
  );

  final phone = TextEditingController();

  @override
  void dispose() {
    shopName.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الإعدادات",
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),

        children: [
          TextField(
            controller: shopName,
            decoration: const InputDecoration(
              labelText: "اسم المحل",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "رقم الهاتف",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          AnimatedBuilder(
            animation: ThemeController.instance,

            builder: (context, _) {
              return SwitchListTile(
                title: const Text(
                  "الوضع الليلي",
                ),

                subtitle: Text(
                  ThemeController.instance.isDark
                      ? "الوضع الليلي مفعل"
                      : "الوضع النهاري مفعل",
                ),

                value:
                    ThemeController.instance.isDark,

                onChanged: (value) async {
                  await ThemeController.instance
                      .setDarkMode(value);
                },
              );
            },
          ),

          const SizedBox(
            height: 20,
          ),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "تم حفظ الإعدادات",
                  ),
                ),
              );
            },

            icon: const Icon(
              Icons.save,
            ),

            label: const Text(
              "حفظ",
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "سيتم إضافة النسخ الاحتياطي لاحقًا",
                  ),
                ),
              );
            },

            icon: const Icon(
              Icons.backup,
            ),

            label: const Text(
              "نسخ احتياطي",
            ),
          ),
        ],
      ),
    );
  }
}