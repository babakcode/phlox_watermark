import 'package:image/image.dart';
import 'package:phlox_watermark/phlox_watermark.dart';

/// [bitmapFont] for converting int to default size
extension Img on WatermarkTextSize{
  BitmapFont bitmapFont(int index){
    BitmapFont font = index == 0 ? arial_14 : index == 1 ? arial_24 : arial_48;
    return font;
  }
}