import 'dart:convert';
import 'dart:typed_data';

import 'package:consume_api/data/data.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'qr_overlay.dart';
import 'package:http/http.dart' as http;

const bgColor = Color(0xfffafafa);

class QRScannerCopy extends StatefulWidget {
  const QRScannerCopy({super.key});

  @override
  State<QRScannerCopy> createState() => _QRScannerCopyState();
}

class _QRScannerCopyState extends State<QRScannerCopy> {
  Future<List<String>> fetchLinksFromAPI() async {
    final response = await http.get(Uri.parse(
        'https://6283-180-245-53-221.ngrok-free.app/api/access_links'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> links =
          data.map((item) => item['link'].toString()).toList();
      return links;
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  List<String> allowedLinks = [];

  bool isScanCompleted = false;

  void closeScreen() {
    isScanCompleted = false;
  }

  Future<void> _launchURL(String url) async {
    if (!await canLaunch(url)) {
      throw Exception('Could not launch $url');
    }
    await launch(url);
  }

  @override
  void initState() {
    super.initState();
    fetchLinksFromAPI().then((links) {
      setState(() {
        allowedLinks = links;
      });
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
                    'Scanning will be started automatically',
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
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final scannedLink = barcode.rawValue;
                          if (allowedLinks.contains(scannedLink)) {
                            _launchURL(scannedLink!);
                          } else {
                            // Tautan yang dipindai tidak ada dalam daftar yang diizinkan
                            debugPrint('Tautan tidak diizinkan: $scannedLink');
                          }
                        }
                      },
                    ),
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
