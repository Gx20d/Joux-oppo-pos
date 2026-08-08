import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../database/database_helper.dart';

class SaleDetailsScreen extends StatefulWidget {
  final int saleId;

  const SaleDetailsScreen({
    super.key,
    required this.saleId,
  });

  @override
  State<SaleDetailsScreen> createState() =>
      _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends State<SaleDetailsScreen> {
  List<Map<String, dynamic>> items = [];

  bool loading = true;

  double total = 0;
  double discount = 0;
  double paid = 0;
  double remaining = 0;

  String saleDate = "";

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final loadedItems =
          await DatabaseHelper.instance.getSaleItems(
        widget.saleId,
      );

      final sales =
          await DatabaseHelper.instance.getSales();

      Map<String, dynamic>? sale;

      for (final item in sales) {
        if (item["id"] == widget.saleId) {
          sale = item;
          break;
        }
      }

      if (!mounted) return;

      setState(() {
        items = loadedItems;

        if (sale != null) {
          total = (sale!["total"] as num?)?.toDouble() ?? 0;
          discount =
              (sale!["discount"] as num?)?.toDouble() ?? 0;
          paid = (sale!["paid"] as num?)?.toDouble() ?? 0;
          remaining =
              (sale!["remaining"] as num?)?.toDouble() ?? 0;

          saleDate = sale!["date"]?.toString() ?? "";
        }

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "حدث خطأ أثناء تحميل الفاتورة: $e",
          ),
        ),
      );
    }
  }

  Future<void> printInvoice() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.stretch,
              children: [
                pw.Center(
                  child: pw.Text(
                    "Joux Oppo",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Center(
                  child: pw.Text(
                    "فاتورة بيع",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),

                pw.SizedBox(height: 15),

                pw.Divider(),

                pw.Text(
                  "رقم الفاتورة: ${widget.saleId}",
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.Text(
                  "التاريخ: $saleDate",
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),

                pw.SizedBox(height: 15),

                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey,
                  ),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children: [
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            "المنتج",
                            textAlign:
                                pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            "الكمية",
                            textAlign:
                                pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            "السعر",
                            textAlign:
                                pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            "الإجمالي",
                            textAlign:
                                pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    ...items.map(
                      (item) {
                        final quantity =
                            (item["quantity"] as num?)
                                    ?.toDouble() ??
                                0;

                        final price =
                            (item["sell_price"] as num?)
                                    ?.toDouble() ??
                                0;

                        final itemTotal =
                            quantity * price;

                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                item["product_name"]
                                        ?.toString() ??
                                    "منتج",
                                textAlign:
                                    pw.TextAlign.center,
                              ),
                            ),

                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                quantity
                                    .toStringAsFixed(0),
                                textAlign:
                                    pw.TextAlign.center,
                              ),
                            ),

                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                "${price.toStringAsFixed(2)} جنيه",
                                textAlign:
                                    pw.TextAlign.center,
                              ),
                            ),

                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                "${itemTotal.toStringAsFixed(2)} جنيه",
                                textAlign:
                                    pw.TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                pw.Divider(),

                pw.Align(
                  alignment:
                      pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "الخصم: ${discount.toStringAsFixed(2)} جنيه",
                        style: const pw.TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Text(
                        "الإجمالي: ${total.toStringAsFixed(2)} جنيه",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight:
                              pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Text(
                        "المدفوع: ${paid.toStringAsFixed(2)} جنيه",
                        style: const pw.TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Text(
                        "المتبقي: ${remaining.toStringAsFixed(2)} جنيه",
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight:
                              pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Spacer(),

                pw.Center(
                  child: pw.Text(
                    "شكراً لتعاملكم مع Joux Oppo",
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async {
        return pdf.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "فاتورة بيع رقم ${widget.saleId}",
        ),

        actions: [
          IconButton(
            tooltip: "طباعة الفاتورة",
            icon: const Icon(
              Icons.print,
            ),
            onPressed: loading || items.isEmpty
                ? null
                : printInvoice,
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد منتجات",
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder:
                      (context, index) {
                    final item = items[index];

                    final quantity =
                        (item["quantity"] as num?)
                                ?.toDouble() ??
                            0;

                    final price =
                        (item["sell_price"] as num?)
                                ?.toDouble() ??
                            0;

                    final itemTotal =
                        quantity * price;

                    return Card(
                      margin:
                          const EdgeInsets.all(8),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              item["product_name"]
                                      ?.toString() ??
                                  "منتج",

                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              "الماركة: ${item["brand"] ?? "-"}",
                            ),

                            Text(
                              "الكمية: ${quantity.toStringAsFixed(0)}",
                            ),

                            Text(
                              "سعر البيع: ${price.toStringAsFixed(2)} جنيه",
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              "الإجمالي: ${itemTotal.toStringAsFixed(2)} جنيه",

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      floatingActionButton: items.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: printInvoice,
              icon: const Icon(
                Icons.print,
              ),
              label: const Text(
                "طباعة الفاتورة",
              ),
            ),
    );
  }
}