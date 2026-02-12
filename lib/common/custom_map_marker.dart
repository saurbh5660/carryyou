import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../generated/assets.dart';

Future<BitmapDescriptor> getMarkerIcon({
  required String userImage,
  required Size size,
  double borderWidth = 4.0,
  Color borderColor = Colors.blue,
}) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final double radius = size.width / 2;
  final Offset center = Offset(radius, radius);

  final Paint backgroundPaint = Paint()..color = Colors.white;
  canvas.drawCircle(center, radius - borderWidth, backgroundPaint);

  ui.Image userImageToDraw;

  if (_isValidUrl(userImage)) {
    try {
      userImageToDraw = await _fetchAndResizeNetworkImage(
        userImage,
        Size(size.width - borderWidth * 2, size.height - borderWidth * 2),
      );
    } catch (e) {
      debugPrint("Failed to load user image from network: $e");
      userImageToDraw = await _loadDefaultUserImage();
    }
  } else {
    userImageToDraw = await _loadDefaultUserImage();
  }

  // Create circular clip for the user image
  final Path clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius - borderWidth));
  canvas.save();
  canvas.clipPath(clipPath);

  // Draw the user image
  final Rect imageRect = Rect.fromCircle(center: center, radius: radius - borderWidth);
  paintImage(
    canvas: canvas,
    image: userImageToDraw,
    rect: imageRect,
    fit: BoxFit.cover,
  );

  canvas.restore();

  // Draw border circle
  final Paint borderPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth;
  canvas.drawCircle(center, radius - borderWidth / 2, borderPaint);

  // Optional: Add a subtle shadow
  final Paint shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
  canvas.drawCircle(center, radius, shadowPaint);

  // Compose final image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  final ByteData? markerByteData =
  await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = markerByteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

/// Helper: load and resize network image
Future<ui.Image> _fetchAndResizeNetworkImage(String url, Size size) async {
  final Uint8List imageData =
  (await NetworkAssetBundle(Uri.parse(url)).load(url))
      .buffer
      .asUint8List();

  final ui.Codec codec = await ui.instantiateImageCodec(
    imageData,
    targetWidth: size.width.toInt(),
    targetHeight: size.height.toInt(),
  );

  final ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

/// Helper: fallback user photo
Future<ui.Image> _loadDefaultUserImage() async {
  final ByteData userImageByteData =
  await rootBundle.load(Assets.imagesImagePlaceholder);
  final Uint8List userImageBytes = userImageByteData.buffer.asUint8List();
  final ui.Codec userImageCodec =
  await ui.instantiateImageCodec(userImageBytes);
  final ui.FrameInfo userImageFrame = await userImageCodec.getNextFrame();
  return userImageFrame.image;
}

/// Validate URL
bool _isValidUrl(String url) {
  Uri? uri = Uri.tryParse(url);
  return uri != null &&
      uri.hasAbsolutePath &&
      (uri.isScheme('http') || uri.isScheme('https'));
}