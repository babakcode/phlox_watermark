import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phlox_watermark/phlox_watermark.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  File? watermarkedImage;
  PhloxWatermark watermark = PhloxWatermark();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                MaterialButton(
                  color: Colors.amber,
                  onPressed: () async {
                    image = await watermark.camera(
                      height: 512,
                      width: 512
                    );

                    setState((){
                      loading = true;
                    });


                    if (image != null) {
                      watermarkedImage = await watermark.create(
                        image!,
                        watermarks: [
                          Watermarks.asset(
                            'assets/phlox_watermark.png',
                            alignment: Alignment.center,
                          ),
                          Watermarks.text(
                            'Hi, I\'m Babak',
                            x: 100,
                            y: 150,
                            textColor: Colors.greenAccent,
                            watermarkTextSize: WatermarkTextSize.arial_48,
                          ),
                          Watermarks.network(
                            'https://www.pngall.com/wp-content/uploads/8/Sample-Watermark-Transparent.png',
                            height: 512,
                            width: 512,
                            alignment: Alignment.bottomRight
                          ),
                        ],
                      );
                    }
                    setState((){
                      loading = false;
                    });
                  },
                  child: const Text("camera"),
                ),


                if (image != null)
                  Expanded(
                    flex: 1,
                    child: Image.file(image!),
                  ),

                const Text("Watermarked image :"),

                if(loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                if (watermarkedImage != null)
                  Expanded(
                    flex: 2,
                    child:  Image.file(watermarkedImage!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
