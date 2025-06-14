import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TuorScreen extends StatefulWidget {
  const TuorScreen({super.key});

  @override
  State<TuorScreen> createState() => _TuorScreenState();
}

class _TuorScreenState extends State<TuorScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://www.meutour360.com/tour-360/ccec-praca-da-ciencia',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(child: WebViewWidget(controller: controller)),

        // Botão de voltar no canto superior esquerdo
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(12),
            ),
            onPressed: () {
              // Ao sair volta a tela ao normal
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
