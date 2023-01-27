import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PDFScreen(),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String name;
  final String location;
  final String description;

  PDFScreen({
    this.name = 'Tolu',
    this.location = '2, Alabama Drive, Kingston.',
    this.description = 'Receipt for outfits purchased on Stylebitt.com'
  });

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate your PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Click the button to generate the PDF'),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.cyan[200],
              child: Text('Generate PDF'),
              onPressed: () async {
                // Get the directory where the PDF will be saved
                final directory = await getApplicationDocumentsDirectory();
                final path = directory.path;
                final date = DateFormat('yMMMd').format(DateTime.now());
                final file = File('$path/${widget.name}-$date.pdf');
                final font = await rootBundle.load('assets/DidactGothic-Regular.ttf');
                final ttf = pdf.Font.ttf(font);

                // Create the PDF document
                final pdf.Document doc = pdf.Document();
                doc.addPage(pdf.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pdf.Context context) {
                      return pdf.Container(
                        alignment: pdf.Alignment.topCenter,
                        child: pdf.Column(
                            mainAxisAlignment: pdf.MainAxisAlignment.center,
                            children: <pdf.Widget>[
                              pdf.Text("Name: ${widget.name}",
                                  style: pdf.TextStyle(
                                    font: ttf,
                                    fontSize: 24,
                                  )),
                              pdf.SizedBox(height: 50),
                              pdf.Text("Location: ${widget.location}",
                                style: pdf.TextStyle(
                                font: ttf,
                                fontSize: 18,
                              )),
                              pdf.SizedBox(height: 50),
                              pdf.Text("Description: ${widget.description}",
                                  style: pdf.TextStyle(
                                    font: ttf,
                                    fontSize: 18,
                              )),
                              pdf.SizedBox(height: 50),
                              pdf.Text("Sent from Stylebitt",
                                  style: pdf.TextStyle(
                                    font: ttf,
                                      fontSize: 18,
                                      fontWeight: pdf.FontWeight.bold))
                            ]),
                      );
                    }));

                // Save the PDF to the file
                file.writeAsBytesSync(await doc.save());

                // Open the PDF document
                OpenFile.open(file.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}
