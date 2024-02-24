
import 'package:consume_api/data/data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'qr_overlay.dart';

const bgColor = Color(0xfffafafa);

class QRScanner extends StatefulWidget {
  final link;
  const QRScanner({super.key, required this.link});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String allowedLinks = '';
  bool isScanCompleted = false;

  void closeScreen() {
    isScanCompleted = false;
  }

  Future<void> _launchURL(String code) async {
    if (code == widget.link) {
      await launch(code);
      print('launched : ' + widget.link);
      print('Widget Link : ${code}');
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Could not launch $code'),
              title: Text('Failed to launch'),
            );
          });
    }
  }

  @override
  void initState() {
    final link = widget.link;
    print('Link awal Resource Sub Bab: ' + link);
    super.initState();
    setState(() {
      allowedLinks = link;
      print('Allow: ${allowedLinks}');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: blueText,
        centerTitle: true,
        title: const Text('Pemindai',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pindai Universitas Islam Nusantara',
                      style: TextStyle(
                          color: greenSolid,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  const SizedBox(height: 10),
                  const Text(
                    'Scan will be started automatically',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                // Scanner QR Code
                child: Stack(
                  children: [
                    MobileScanner(
                        allowDuplicates: true,
                        // pendeteksi
                        onDetect: (barcode, args) {
                          if (!isScanCompleted) {
                            String code = barcode.rawValue ?? '';
                            isScanCompleted = true;
                            if (code.startsWith('https://www.instagram.com/ar/')) {
                              print('Instagram: ' + code + ' !${widget.link}');
                              _launchURL(code);
                            } else if (code
                                .startsWith('https://www.youtube.com/')) {
                              print('Youtube: ' + code);
                              _launchURL(code);
                            } else if (code
                                .startsWith('https://drive.google.com/')) {
                              print('Gdrive: ' + code);
                              _launchURL(code);
                            } else {
                              print('Error Link' + code);
                              // Tautan tidak diizinkan
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Tautan Tidak Diizinkan'),
                                    content:
                                        const Text('Tautan tidak terdaftar.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            ;
                          }
                        }),
                    const QRScannerOverlay(overlayColour: bgColor)
                  ],
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text('Uninus AR Scanner',
                  style: TextStyle(
                      color: greenSolid,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1)),
            )),
          ],
        ),
      ),
    );
  }
}
