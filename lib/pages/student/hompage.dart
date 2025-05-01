import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:beauporientation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Importez la bibliothèque pour scanner les QR codes
import 'package:provider/provider.dart';
import '../../providers/runner_provider.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final runner = Provider.of<RunnerProvider>(context, listen: false).runner;

    if (runner == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Erreur', showMenuButton: true),
        body: Center(child: Text('Aucun coureur trouvé')),
      );
    }

    final courseNumber = runner.course;
    final runnerNumber = runner.name;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Coureur: $runnerNumber',
        showMenuButton: true,
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? rawValue = barcodes.first.rawValue;
                if (rawValue != null) {
                  print('QR Code scanné : $rawValue');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('QR Code scanné : $rawValue')),
                  );
                }
              }
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Placez le QR Code dans le cadre pour scanner',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
