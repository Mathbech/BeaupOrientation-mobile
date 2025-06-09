import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:beauporientation/services/scan_service.dart';

class QRCodeService {
  bool isProcessing = false;
  final ScanService scanService = ScanService();

  void handleQRCodeDetection(
      BuildContext context, BarcodeCapture capture, String runnerId) async {
    if (isProcessing) return; // Si un traitement est en cours, ne rien faire

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? rawValue = barcodes.first.rawValue;
      if (rawValue != null) {
        isProcessing = true; // Bloque le traitement des QR codes
        try {
          // Vérifiez et demandez les permissions de localisation
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Le service de localisation est désactivé.')),
            );
            isProcessing = false; // Libère le traitement
            return;
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Permission de localisation refusée.')),
              );
              isProcessing = false; // Libère le traitement
              return;
            }
          }

          if (permission == LocationPermission.deniedForever) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Permission de localisation refusée de façon permanente.')),
            );
            isProcessing = false; // Libère le traitement
            return;
          }

          // Récupérez la position actuelle
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          // Bloquez la caméra et affichez une boîte de dialogue de confirmation
          bool? confirm = await showDialog<bool>(
            context: context,
            barrierDismissible:
                false, // Empêche de fermer la boîte de dialogue en cliquant à l'extérieur
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text(
                    'Envoyer les données : $rawValue, Position : ${position.latitude}, ${position.longitude} ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false), // Non
                    child: Text('Non'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true), // Oui
                    child: Text('Oui'),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            try {
              await scanService.sendScan(
                runnerId: runnerId,
                markerCode: rawValue,
                position: position,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Scan envoyé avec succès !')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur lors de l\'envoi : $e')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Envoi annulé.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de la récupération de la localisation : $e')),
          );
        } finally {
          isProcessing = false; // Libère le traitement après la fin
        }
      }
    }
  }
}
