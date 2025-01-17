import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  BarcodeCapture? result;
  MobileScannerController scannerController = MobileScannerController();
  bool isTorchOn = false; // Add a variable to keep track of the torch state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe the app lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    scannerController.dispose(); // Dispose of the scanner controller
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Pause the camera when the app goes into background
      scannerController.stop();
    } else if (state == AppLifecycleState.resumed) {
      // Resume the camera when the app comes to foreground
      scannerController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Login', showMenuButton: true),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: scannerController,
              onDetect: (barcodeCapture) {
                setState(() {
                  result = barcodeCapture;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (result != null)
                    Text(
                      'Barcode Type: ${result?.barcodes.first.type.name ?? "Unknown"}\nData: ${result?.barcodes.first.rawValue ?? "No Data"}',
                    )
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          scannerController.toggleTorch();
                          setState(() {
                            isTorchOn = !isTorchOn; // Update the torch state
                          });
                        },
                        child: Text(
                          isTorchOn ? 'Flash: ON' : 'Flash: OFF',
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          scannerController.stop(); // Pause the scanner
                        },
                        child: const Text('Pause'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          scannerController.start(); // Resume the scanner
                        },
                        child: const Text('Resume'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
