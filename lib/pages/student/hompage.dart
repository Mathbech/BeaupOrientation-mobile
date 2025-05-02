import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:beauporientation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Importez la bibliothèque pour scanner les QR codes
import 'package:provider/provider.dart';
import '../../providers/runner_provider.dart';
import '../../services/qr_code_service.dart';

class StudentHomePage extends StatelessWidget {
  final QRCodeService _qrCodeService = QRCodeService();

  @override
  Widget build(BuildContext context) {
    final runner = Provider.of<RunnerProvider>(context, listen: false).runner;

    if (runner == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Erreur', showMenuButton: true),
        body: Center(child: Text('Aucun coureur trouvé')),
      );
    }

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
              _qrCodeService.handleQRCodeDetection(context, capture);
            },
          ),
          // Les coins du cadre
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  // Coin supérieur gauche
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.red, width: 3),
                          left: BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                    ),
                  ),
                  // Coin supérieur droit
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.red, width: 3),
                          right: BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                    ),
                  ),
                  // Coin inférieur gauche
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.red, width: 3),
                          left: BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                    ),
                  ),
                  // Coin inférieur droit
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.red, width: 3),
                          right: BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                    ),
                  ),
                ],
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
