part of phlox_watermark;

/// [PhloxWatermarks] for creating a watermarks list and writing over the image.
abstract class PhloxWatermarks {}

/// [Watermarks] to help you code better and easier.
class Watermarks extends PhloxWatermarks {
  Watermarks._();

  /// [asset] is a static method to get image from asset the folder
  static PhloxWatermarks asset(String path,
          {double? height, double? width, Alignment? alignment}) =>
      PhloxWatermarkAssetImage(path,
          width: width,
          height: height,
          alignment: alignment ?? Alignment.center);

  /// [network] is a static method to get image from network
  static PhloxWatermarks network(String url,
      {double? height, double? width, Alignment? alignment}) =>
      PhloxWatermarkNetworkImage(url,
          width: width,
          height: height,
          alignment: alignment ?? Alignment.center);

  /// [text] is a static method to write text over original image
  static PhloxWatermarks text(
    String text, {
    int? x,
    int? y,
    int? margin,
    Color? textColor,
    WatermarkTextSize? watermarkTextSize,
  }) =>
      PhloxWatermarkText(text,
          x: x,
          y: y,
          margin: margin,
          textColor: textColor,
          watermarkTextSize: watermarkTextSize);
}
