part of phlox_watermark;

/// [PhloxWatermarkAssetImage] for get watermark image from asset
class PhloxWatermarkAssetImage extends PhloxWatermarks {
  String? path;
  double? height, width;
  Alignment alignment;

  PhloxWatermarkAssetImage(this.path,
      {this.height, this.width, this.alignment = Alignment.center});
}


/// [PhloxWatermarkNetworkImage] for get watermark image from network
class PhloxWatermarkNetworkImage extends PhloxWatermarks {
  String url;
  double? height, width;
  Alignment alignment;

  PhloxWatermarkNetworkImage(this.url,
      {this.height, this.width, this.alignment = Alignment.center});
}

/// [PhloxWatermarkNetworkImage] for write text over image
class PhloxWatermarkText extends PhloxWatermarks {
  String text;
  int? x, y, margin;
  Color? textColor;
  WatermarkTextSize? watermarkTextSize;

  PhloxWatermarkText(this.text,
      { this.x =0,
        this.y = 0,
        this.margin = 0,
        this.textColor,
        this.watermarkTextSize});
}