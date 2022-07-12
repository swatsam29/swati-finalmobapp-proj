import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';

class GoogleMlController {
  static const minConfidence = 0.6;
  static Future<List<dynamic>> getImageLabels(
      {required File photo, required EmageLabel label}) async {
    var inputImage = InputImage.fromFile(photo);

    var results = <dynamic>[];

    if (label == EmageLabel.image) {
      final imageLabeler = GoogleMlKit.vision.imageLabeler();
      final List<ImageLabel> imageLabels =  await imageLabeler.processImage(inputImage);
      imageLabeler.close();

     
      for (var i in imageLabels) {
        if (i.confidence >= minConfidence) {
          results.add(i.label.toLowerCase());
        }
      }
    } else {
      final textRec = GoogleMlKit.vision.textRecognizer();
      final imageLabels = await textRec.processImage(inputImage);
      textRec.close();

      

      results.add(imageLabels.text);

    }

    return results;
  }
}
