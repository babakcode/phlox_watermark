library phlox_watermark;

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:phlox_watermark/src/extensions/hex.dart';
import 'package:phlox_watermark/src/extensions/img.dart';

part './src/enums/phlox_watermark_text_size.dart';

part './src/components/phlox_watermark_file_provider.dart';

part './src/components/phlox_watermarks.dart';

/// A PhloxWatermark.
class PhloxWatermark {

  /// [gallery] for get image from gallery
  Future<File?> gallery({
    int? imageQuality,
    double? height,
    double? width,
  }) async {
    final XFile? image = await ImagePicker.platform.getImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
      maxHeight: height,
      maxWidth: width,
    );
    return image == null ? null : File(image.path);
  }

  /// [camera] for get image from camera
  Future<File?> camera({
    int? imageQuality,
    double? height,
    double? width,
    bool frontFaceCamera = false,
  }) async {
    final XFile? image = await ImagePicker.platform.getImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxHeight: height,
        maxWidth: width,
        preferredCameraDevice:
            frontFaceCamera ? CameraDevice.front : CameraDevice.rear);
    return image == null ? null : File(image.path);
  }

  /// [create] for create watermark as [File]
  Future<File> create(File selectFile,
      {required List<PhloxWatermarks> watermarks}) async {

    // decode selected original image
    img.Image? originalImage = img.decodeImage(selectFile.readAsBytesSync());

    // add watermarks over the original selected image
    for (PhloxWatermarks watermarkFile in watermarks) {
      if (watermarkFile is PhloxWatermarkAssetImage) {
        img.Image? watermarkImage = img.decodeImage(
            await getUint8ListImageFileFromAssets(watermarkFile.path!));

        // add watermark over originalImage
        // initialize width and height of watermark image
        img.Image image = img.Image(
          watermarkImage!.width,
          watermarkImage.height,
        );
        img.drawImage(image, watermarkImage);

        // give position to watermark over image
        _copyImage(
          watermarkFile.alignment,
          watermarkImage.width,
          watermarkImage.height,
          originalImage!,
          image,
        );
      } else if (watermarkFile is PhloxWatermarkText) {

        // for adding text over image
        // Draw some text using 24pt arial font
        // height / 9 is position from x-axis and y-axis
        img.drawString(
          originalImage!,
          watermarkFile.watermarkTextSize!
              .bitmapFont(watermarkFile.watermarkTextSize!.index),
          watermarkFile.x ?? 0,
          watermarkFile.y ?? 0,
          watermarkFile.text,
          color: (watermarkFile.textColor ?? Colors.blueAccent).hex,
        );

      }
      else if (watermarkFile is PhloxWatermarkNetworkImage) {

        // add watermark over the original selected image from internet
        File? watermark = await downloadFile(watermarkFile.url);

        img.Image? watermarkImage = img.decodeImage(watermark!.readAsBytesSync());

        // add watermark over originalImage
        // initialize width and height of watermark image
        img.Image image = img.Image(
          watermarkFile.width?.toInt() ?? watermarkImage!.width,
          watermarkFile.height?.toInt() ?? watermarkImage!.height,
        );
        img.drawImage(image, watermarkImage!);

        // give position to watermark over image
        _copyImage(
          watermarkFile.alignment,
          watermarkImage.width,
          watermarkImage.height,
          originalImage!,
          image,
        );

      }
    }

    final documentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Directory watermarkDir = Directory('${documentDirectory.path}/phlox/');
    if (await watermarkDir.exists() == false) {
      await watermarkDir.create(recursive: true);
    }
    int? fileName = DateTime.now().millisecondsSinceEpoch;
    final file = File("${watermarkDir.path}/phlox_watermark_$fileName.jpg");
    print(file.uri.toString());
    file.writeAsBytesSync(img.encodeJpg(originalImage!));
    return file;
  }

  /// [createAsUint8List] for create watermark as [Uint8List]
  Future<Uint8List> createAsUint8List(Uint8List selectFile,
      {required List<PhloxWatermarks> watermarks}) async {

    // decode selected original image
    img.Image? originalImage = img.decodeImage(selectFile);

    // add watermarks over the original selected image
    for (PhloxWatermarks watermarkFile in watermarks) {
      if (watermarkFile is PhloxWatermarkAssetImage) {
        img.Image? watermarkImage = img.decodeImage(
            await getUint8ListImageFileFromAssets(watermarkFile.path!));

        // add watermark over originalImage
        // initialize width and height of watermark image
        img.Image image = img.Image(
          watermarkImage!.width,
          watermarkImage.height,
        );
        img.drawImage(image, watermarkImage);

        // give position to watermark over image
        _copyImage(
          watermarkFile.alignment,
          watermarkImage.width,
          watermarkImage.height,
          originalImage!,
          image,
        );
      } else if (watermarkFile is PhloxWatermarkText) {

        // for adding text over image
        // Draw some text using 24pt arial font
        // height / 9 is position from x-axis and y-axis
        img.drawString(
          originalImage!,
          watermarkFile.watermarkTextSize!
              .bitmapFont(watermarkFile.watermarkTextSize!.index),
          watermarkFile.x ?? 0,
          watermarkFile.y ?? 0,
          watermarkFile.text,
          color: (watermarkFile.textColor ?? Colors.blueAccent).hex,
        );

      }
      else if (watermarkFile is PhloxWatermarkNetworkImage) {

        // add watermark over the original selected image from internet
        File? watermark = await downloadFile(watermarkFile.url);

        img.Image? watermarkImage = img.decodeImage(watermark!.readAsBytesSync());

        // add watermark over originalImage
        // initialize width and height of watermark image
        img.Image image = img.Image(
          watermarkFile.width?.toInt() ?? watermarkImage!.width,
          watermarkFile.height?.toInt() ?? watermarkImage!.height,
        );
        img.drawImage(image, watermarkImage!);

        // give position to watermark over image
        _copyImage(
          watermarkFile.alignment,
          watermarkImage.width,
          watermarkImage.height,
          originalImage!,
          image,
        );

      }
    }

    final documentDirectory =
    await path_provider.getApplicationDocumentsDirectory();
    Directory watermarkDir = Directory('${documentDirectory.path}/phlox/');
    if (await watermarkDir.exists() == false) {
      await watermarkDir.create(recursive: true);
    }
    int? fileName = DateTime.now().millisecondsSinceEpoch;
    final file = File("${watermarkDir.path}/phlox_watermark_$fileName.jpg");
    print(file.uri.toString());
    file.writeAsBytesSync(img.encodeJpg(originalImage!));
    return file.readAsBytesSync();
  }

  /// [getImageFromAssetAsFile] get image as file from asset folder
  Future<File> getImageFromAssetAsFile(String path) async {
    var bytes = await rootBundle.load(path);
    String tempPath = (await path_provider.getTemporaryDirectory()).path;
    File file = File('$tempPath/${path.split('/').last}');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  /// [getUint8ListImageFileFromAssets] get image as Uint8List from asset folder
  Future<Uint8List> getUint8ListImageFileFromAssets(String path) async {
    final ByteData bytes = await rootBundle.load(path);
    return bytes.buffer.asUint8List();
  }

  /// [downloadFile] download watermark image from internet
  Future<File?> downloadFile(String url) async {
    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.

    var response = await get(Uri.parse(url)); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/phlox";
    var filePathAndName =
        '${documentDirectory.path}/phlox/phlox_network_watermark_${DateTime.now().millisecondsSinceEpoch}.png';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    try {
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3
      return file2;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// [_copyImage] for set alignment for watermark
  void _copyImage(Alignment alignment, int width, int height,
      img.Image originalImage, img.Image watermark) {
    if (alignment == Alignment.topLeft) {
      img.copyInto(originalImage, watermark, dstX: 0, dstY: 0);
    } else if (alignment == Alignment.topCenter) {
      int dstX = (originalImage.width ~/ 2) - (width ~/ 2);
      img.copyInto(originalImage, watermark, dstX: dstX, dstY: 0);
    } else if (alignment == Alignment.topRight) {
      int dstX = originalImage.width - width;
      img.copyInto(originalImage, watermark, dstX: dstX, dstY: 0);
    } else if (alignment == Alignment.centerLeft) {
      int dstY = (originalImage.height ~/ 2) - (height ~/ 2);
      img.copyInto(originalImage, watermark, dstX: 0, dstY: dstY);
    } else if (alignment == Alignment.center) {
      int dstX = (originalImage.width ~/ 2) - (width ~/ 2);
      int dstY = (originalImage.height ~/ 2) - (height ~/ 2);
      img.copyInto(originalImage, watermark, dstX: dstX, dstY: dstY);
    } else if (alignment == Alignment.centerRight) {
      int dstX = originalImage.width - width;
      int dstY = (originalImage.height ~/ 2) - (height ~/ 2);
      img.copyInto(originalImage, watermark, dstX: dstX, dstY: dstY);
    } else if (alignment == Alignment.bottomLeft) {
      int dstY = originalImage.height - height;
      img.copyInto(originalImage, watermark, dstX: 0, dstY: dstY);
    } else if (alignment == Alignment.bottomCenter) {
      int dstX = (originalImage.width ~/ 2) - (width ~/ 2);
      int dstY = originalImage.height - height;
      img.copyInto(originalImage, watermark, dstX: dstX, dstY: dstY);
    } else if (alignment == Alignment.bottomRight) {
      int dstX = originalImage.width - width;
      int dstY = originalImage.height - height;
      img.copyInto(originalImage, watermark, dstX: dstX, dstY: dstY,);
    }
  }
}
