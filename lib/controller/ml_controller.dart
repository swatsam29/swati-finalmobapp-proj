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
      final List<ImageLabel> imageLabels =
          await imageLabeler.processImage(inputImage);
      imageLabeler.close();

      for (var i in imageLabels) {
        if (i.confidence >= minConfidence) {
          results.add(i.label.toLowerCase());
        }
      }
    } else if (label == EmageLabel.textRecog) {
      final textRec = GoogleMlKit.vision.textRecognizer();
      final imageLabels = await textRec.processImage(inputImage);
      textRec.close();

      results.add(imageLabels.text);
    } else {
      final options = FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: true,
      );
      final faceRec = GoogleMlKit.vision.faceDetector(options);
      final List<Face> faceLabels = await faceRec.processImage(inputImage);

      for (var i in faceLabels) {
        if (i.leftEyeOpenProbability != null) {
          if (i.leftEyeOpenProbability! >= minConfidence) {
            results.add("lefteyeopen");
          }
        }
        if (i.rightEyeOpenProbability != null) {
          if (i.rightEyeOpenProbability! >= minConfidence) {
            results.add("righteyeopen");
          }
        }
        if (i.smilingProbability != null) {
          if (i.smilingProbability! >= minConfidence) {
            results.add("smilling");
          } else {
            results.add("notsmilling");
          }
        }
        results
            .add(i.contours[FaceContourType.face]?.type != null ? "face" : "");
        results.add(i.contours[FaceContourType.lowerLipBottom]?.type != null &&
                i.contours[FaceContourType.lowerLipTop] != null
            ? "lip"
            : "");
        results.add(i.contours[FaceContourType.leftEye] != null &&
                i.contours[FaceContourType.rightEye] != null
            ? "eye"
            : "");
        results.add(i.landmarks[FaceLandmarkType.noseBase]?.type != null &&
                i.landmarks[FaceLandmarkType.bottomMouth] != null &&
                i.landmarks[FaceLandmarkType.leftMouth] != null &&
                i.landmarks[FaceLandmarkType.rightMouth] != null
            ? "mouth"
            : "");
      }
      faceRec.close();
    }

    return results;
  }
}
