import 'dart:math';
import 'dart:ui' as ui;

import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ImageTile extends StatefulWidget {
  final ImageProvider image;
  final Rect part;
  final BorderRadius radius;
  final bool greyScale;

  const ImageTile(
      {Key? key, required this.image, required this.part, required this.greyScale, required this.radius})
      : super(key: key);

  factory ImageTile.fromTile(ImageProvider image, Tile tile, int sides, bool greyScale, BorderRadius radius) {
    return ImageTile(
        image: image,
        radius: radius,
        greyScale: greyScale,
        part: Rect.fromLTWH(
          tile.x.toDouble() / sides.toDouble(),
          tile.y.toDouble() / sides.toDouble(),
          1.0 / sides.toDouble(),
          1.0 / sides.toDouble(),
        ));
  }

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  ImageStream? stream;
  ui.Image? _image;

  late ImageStreamListener listener;

  @override
  void initState() {
    super.initState();
    listener = ImageStreamListener(onImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resetStream();
  }

  void resetStream() {
    stream?.removeListener(listener);
    stream = widget.image.resolve(createLocalImageConfiguration(context))
      ..addListener(listener);
  }

  @override
  void didUpdateWidget(ImageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetStream();
  }

  void onImage(ImageInfo image, bool synchronousCall) {
    if(mounted) {
      setState(() {
        _image = image.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return AbsorbPointer(
          child: _ImagePart(
            radius: widget.radius,
        image: _image!,
        part: widget.part,
        tintColor: widget.greyScale ? greyScale : null,
      ));
    }
    return const SizedBox.shrink();
  }

  static const greyScale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
  ]);
}

class _ImagePart extends SingleChildRenderObjectWidget {
  final ui.Image image;
  final Rect part;
  final BorderRadius radius;
  final ColorFilter? tintColor;

  _ImagePart({required this.image, required this.part, this.tintColor, required this.radius})
      : super();

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ImagePartRenderer(image: image, part: part, radius: radius)
      ..tint = tintColor;
  }

  @override
  void updateRenderObject(
      BuildContext context, _ImagePartRenderer renderObject) {
    renderObject
      ..image = image
      ..part = part
      ..radius = radius
      ..tint = tintColor;
    renderObject.markNeedsPaint();
  }
}

class _ImagePartRenderer extends RenderProxyBox {
  ui.Image image;
  Rect part;
  BorderRadius radius;
  Paint painter = Paint();

  set tint(ColorFilter? filter) {
    if (painter.colorFilter != filter) {
      painter.colorFilter = filter;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final side = min(image.width, image.height);
    final imgRect = Rect.fromLTWH(part.left * side, part.top * side,
        part.width * side, part.height * side);

    context.canvas.clipRRect(radius.toRRect(paintBounds.shift(offset)));
    context.canvas
        .drawImageRect(image, imgRect, paintBounds.shift(offset), painter);
  }

  _ImagePartRenderer({required this.image, required this.part, required this.radius}) : super();
}
