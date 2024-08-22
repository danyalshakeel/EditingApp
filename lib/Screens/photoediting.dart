import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photofilters/photofilters.dart';

class ImageEditScreen extends StatefulWidget {
  final File image;
  String? path;

  ImageEditScreen({required this.image});

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late File _editableImage;
  List<Filter> filters = presetFiltersList;
  @override
  void initState() {
    super.initState();
    _editableImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Image"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // TODO: Implement save functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Image.file(
                _editableImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () {
                    // TODO: Implement filter functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.text_fields),
                  onPressed: () {
                    // TODO: Implement add text functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    // TODO: Implement add emoji functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.crop_rotate),
                  onPressed: () async {
                    await _cropImage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement undo functionality
                },
                child: Text("Undo"),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement redo functionality
                },
                child: Text("Redo"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePermissionsAndCropImage() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.photos,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.storage]!.isGranted &&
        statuses[Permission.photos]!.isGranted) {
      await _cropImage();
    } else {
      // Handle permissions not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissions not granted.')),
      );
    }
  }

  Future<void> _cropImage() async {
    if (_editableImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: _editableImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 30, ratioY: 20),
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image', // Set the title of the toolbar
            toolbarColor:
                Color.fromARGB(255, 13, 15, 61), // Set the toolbar color
            statusBarColor: Colors.transparent, // Set the status bar color
            toolbarWidgetColor:
                Colors.white, // Set the color of toolbar widgets
            backgroundColor:
                Colors.black, // Set the background color of the cropper
            activeControlsWidgetColor:
                Colors.black, // Set the color of active controls
            dimmedLayerColor: Colors.black
                .withOpacity(0.5), // Set the color of the dimmed layer
            cropFrameColor: Colors.white, // Set the color of the crop frame
            cropGridColor:
                Colors.white.withOpacity(0.7), // Set the color of the crop grid
            cropFrameStrokeWidth: 3, // Set the width of the crop frame
            cropGridRowCount: 3, // Set the number of rows in the crop grid
            cropGridColumnCount:
                3, // Set the number of columns in the crop grid
            cropGridStrokeWidth: 1, // Set the width of the crop grid lines
            showCropGrid: true, // Show or hide the crop grid
            lockAspectRatio: false, // Lock or unlock the aspect ratio
            hideBottomControls: false, // Show or hide the bottom controls
            initAspectRatio:
                CropAspectRatioPreset.square, // Set the initial aspect ratio
            cropStyle:
                CropStyle.rectangle, // Set the crop style (rectangle or circle)
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ], // List of aspect ratio presets
          ),
          IOSUiSettings(
            title: 'Cropper', // Set the title of the cropper
            aspectRatioLockEnabled:
                false, // Enable or disable aspect ratio lock
            aspectRatioPickerButtonHidden:
                false, // Show or hide the aspect ratio picker button
            rotateButtonsHidden: false, // Show or hide the rotate buttons
            rotateClockwiseButtonHidden:
                false, // Show or hide the rotate clockwise button
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ], // List of aspect ratio presets
            // Additional iOS-specific properties can be set here
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _editableImage = File(croppedImage.path);
        });
      }
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
