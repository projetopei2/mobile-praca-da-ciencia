import 'package:flutter/material.dart';
import 'dart:async';

class InteractiveMap extends StatefulWidget {
  final String imageAsset;
  final List<MapPoint> points;
  final Function(MapPoint)? onPointTap;
  final Color hitBoxColor;

  const InteractiveMap({
    super.key,
    required this.imageAsset,
    required this.points,
    this.onPointTap,
    this.hitBoxColor = Colors.red,
  });

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Size>(
      future: _getImageSize(widget.imageAsset),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final imageSize = snapshot.data!;
        final imageAspectRatio = imageSize.width / imageSize.height;

        // Altura fixada pela altura da tela
        final displayHeight = screenHeight;
        final displayWidth = displayHeight * imageAspectRatio;

        return Center(
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 0.5,
            maxScale: 5.0,
            boundaryMargin: EdgeInsets.zero,
            constrained: false,
            child: SizedBox(
              height: displayHeight,
              width: displayWidth,
              child: Stack(
                children: [
                  // Mapa
                  Positioned.fill(
                    child: Image.asset(widget.imageAsset, fit: BoxFit.fill),
                  ),

                  // Configurações MapPoints
                  ...widget.points.map((point) {
                    final pointWidth = point.widthFactor * displayWidth;
                    final pointHeight = point.heightFactor * displayHeight;

                    // Posição, Tamanho e icone dos MapPoints
                    return Positioned(
                      left: point.xRel * displayWidth - pointWidth / 2,
                      top: point.yRel * displayHeight - pointHeight / 2,
                      child: GestureDetector(
                        onTap:
                            () => widget.onPointTap?.call(
                              point,
                            ), // Clicar em um MapPoint
                        // Conteúdo do MapPoint
                        child: Stack(
                          alignment:
                              Alignment
                                  .topCenter, // Alinha o icon no topo do Container
                          children: [
                            // Hitbox
                            Container(
                              // Altura e Largura da Hitbox
                              width: pointWidth,
                              height: pointHeight,
                              decoration: BoxDecoration(
                                color: widget.hitBoxColor.withOpacity(0),
                              ),
                            ),

                            Transform.translate(
                              // Posição do icon
                              offset: const Offset(0, -2),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Imagem do mapa
  Future<Size> _getImageSize(String assetPath) async {
    final image = Image.asset(assetPath);
    final completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, _) {
            final myImage = info.image;
            completer.complete(
              Size(myImage.width.toDouble(), myImage.height.toDouble()),
            );
          }),
        );

    return completer.future;
  }
}

// Modelo do ponto do mapa
class MapPoint {
  final String id;
  final String title;
  final double xRel;
  final double yRel;
  final double widthFactor;
  final double heightFactor;
  final String text;
  final String img;
  final String link;

  MapPoint({
    required this.id,
    required this.title,
    required this.xRel,
    required this.yRel,
    required this.text,
    required this.img,
    required this.link,
    this.widthFactor = 0.06,
    this.heightFactor = 0.06,
  });
}
