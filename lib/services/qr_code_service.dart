import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';

class QRCodeService {
  bool isProcessing = false; // Drapeau pour bloquer le traitement multiple

  void handleQRCodeDetection(BuildContext context, BarcodeCapture capture) async {
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
              SnackBar(content: Text('Le service de localisation est désactivé.')),
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
              SnackBar(content: Text('Permission de localisation refusée de façon permanente.')),
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
            barrierDismissible: false, // Empêche de fermer la boîte de dialogue en cliquant à l'extérieur
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text('Envoyer les données : $rawValue, Position : ${position.latitude}, ${position.longitude} ?'),
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
            // Envoyez les données à votre API
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Données envoyées : $rawValue')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Envoi annulé.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la récupération de la localisation : $e')),
          );
        } finally {
          isProcessing = false; // Libère le traitement après la fin
        }
      }
    }
  }
}