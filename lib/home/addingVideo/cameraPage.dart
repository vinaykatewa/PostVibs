import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:postvibs/home/addingVideo/addDetails.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddDetails(path: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  _flipCamera() async {
    final cameras = await availableCameras();
    final newCamera = cameras.firstWhere((camera) =>
        camera.lensDirection != _cameraController.description.lensDirection);
    await _cameraController.dispose();
    _cameraController = CameraController(newCamera, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    child: const Icon(
                      Icons.flip_camera_ios,
                      size: 56,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _flipCamera();
                    },
                  ),
                  SizedBox(
                    width: size.width / 4,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    child: _isRecording
                        ? const Icon(
                            Icons.stop,
                            size: 66,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.circle,
                            size: 66,
                          ),
                    onPressed: () => _recordVideo(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
