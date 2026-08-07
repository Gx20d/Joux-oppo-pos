import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() =>
      _BackupRestoreScreenState();
}

class _BackupRestoreScreenState
    extends State<BackupRestoreScreen> {

  bool loading = false;

  Future<void> createBackup() async {

    setState(() {
      loading = true;
    });

    try {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "سيتم إضافة النسخ الاحتياطي بعد ربط قاعدة البيانات",
          ),

        ),

      );

    } finally {

      setState(() {
        loading = false;
      });

    }

  }

  Future<void> restoreBackup() async {

    final result =
        await FilePicker.platform.pickFiles();

    if (result == null) return;

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(
          "سيتم استعادة النسخة الاحتياطية بعد ربط قاعدة البيانات",
        ),

      ),

    );

  }

  Future<void> shareBackup() async {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(
          "سيتم مشاركة ملف النسخة الاحتياطية لاحقًا",
        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "النسخ الاحتياطي",
        ),

      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : ListView(

              padding:
                  const EdgeInsets.all(16),

              children: [                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.backup,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      "إنشاء نسخة احتياطية",
                    ),
                    subtitle: const Text(
                      "حفظ قاعدة البيانات في ملف",
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: createBackup,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.restore,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "استعادة نسخة احتياطية",
                    ),
                    subtitle: const Text(
                      "استرجاع البيانات من ملف",
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: restoreBackup,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.share,
                      color: Colors.orange,
                    ),
                    title: const Text(
                      "مشاركة النسخة الاحتياطية",
                    ),
                    subtitle: const Text(
                      "إرسال النسخة عبر واتساب أو أي تطبيق",
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: shareBackup,
                  ),
                ),

                const SizedBox(height: 20),

                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "ملاحظة:\n"
                      "سيتم ربط هذه الشاشة بقاعدة البيانات الفعلية بعد إنشاء مشروع Flutter النهائي، "
                      "وسيتم إنشاء ملف النسخة الاحتياطية واستعادته تلقائيًا.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}