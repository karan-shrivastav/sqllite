import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sqllite/models/sql_data_model.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class CartScreen extends StatefulWidget {
  final List<SqlDataModel> cartItems;
  final double totalPrice;

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Future<File> generateCartPdf(
      List<SqlDataModel> cartItems,
      double totalPrice,
      ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Cart Details',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Item Name', 'Price'],
              data: cartItems.map((item) => [item.name, item.price]).toList(),
            ),
            pw.Divider(),
            pw.Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/cart_details.pdf");
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsBytes(await pdf.save());
    return file;
  }


  Future<void> downloadPdf(BuildContext context) async {
    try {
      final pdfFile =
          await generateCartPdf(widget.cartItems, widget.totalPrice);

      await OpenFile.open(pdfFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to ${pdfFile.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => downloadPdf(context),
          ),
        ],
      ),
      body: Column(
        children: [
          widget.cartItems.isNotEmpty
              ? Text(
                  'You have added ${widget.cartItems.length} items in the cart',
                )
              : const SizedBox.shrink(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.price),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: \$${widget.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
