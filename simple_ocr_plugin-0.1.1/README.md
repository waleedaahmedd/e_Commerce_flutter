# simple OCR plugin

A compact OCR plugin for flutter apps. Available for both __iOS__ and __Android__. Backed by Google's `ML-Kit` library.

## usage

The following code snippet is all you need to perform OCR on an image / photo:
```
try {
   String _resultString = await SimpleOcrPlugin.performOCR(_pickedImageFile.path);
   print("OCR results => $_resultString");

} catch(e) {
   print("exception on OCR operation: ${e.toString()}");
}
```

## gotchas

### low quality results

In case low quality results were recognized; try to optimize the original photo in a couple of ways:
* resize the photo - if the source photo is too large, nothing senseful would be recognized, hence resize it to a smaller photo would be a trick.
* grayscaling the photo - there are cases when the image is very colorful and makes the recognition much more difficult, try grayscaling it.

__PS__. For more information on image guidelines, please refer to https://developers.google.com/ml-kit/vision/text-recognition/android#input-image-guidelines

### running on Android

For the first time running the plugin, the corresponding Machine Learning models would be downloaded from Google Play Services. Hence make sure:
* the target phone should have Google Play Services app installed (which should be there by default).
* have enough storage space for the ML models - roughly a few 10Mbs.
* reachable to the internet for the downloads.

__PS__. Since download would take some time, corresponding UI screens should be shown to inform the users to wait for a reasonable moment.

## ML-Kit version

The ML-Kit version involved is `0.63.0`.

