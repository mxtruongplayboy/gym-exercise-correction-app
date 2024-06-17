import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/services/ip_service.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key, required this.title});

  final String title;
  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  File? _videoFile;
  VideoPlayerController? _controller;
  late String ip;
  late IpService ipService = IpService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    ipService.getFirstIP().then((ip) {
      setState(() {
        this.ip = ip;
      });
    }).catchError((error) {
      print('Error getting IP address: $error');
    });
  }

  Future pickVideo() async {
    if (isUploading) return; // Disable video picking during upload

    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null) {
        final file = File(result.files.single.path!);
        _videoFile = file;
        _controller = VideoPlayerController.file(file);

        _controller!.initialize().then((_) {
          setState(() {});
          _controller!.play();
        }).catchError((error) {
          print('Error initializing video: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Error loading video. Please try a different file.'),
              backgroundColor: Colors.red,
            ),
          );
          _controller = null; // Reset the controller on error
        });
      }
    } catch (e) {
      print('Error picking video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future uploadVideo() async {
    if (_videoFile == null || isUploading) return;

    setState(() {
      isUploading = true;
    });

    try {
      var uri = Uri.parse('http://$ip:9999/api/video/upload/plank');
      if (widget.title == 'PLANK') {
        uri = Uri.parse('http://$ip:9999/api/video/upload/plank');
      } else if (widget.title == 'SQUAT') {
        uri = Uri.parse('http://$ip:9999/api/video/upload/squat');
      } else if (widget.title == 'BICEP CURL') {
        uri = Uri.parse('http://$ip:9999/api/video/upload/bicep_curl');
      } else if (widget.title == 'LUNGE') {
        uri = Uri.parse('http://$ip:9999/api/video/upload/lunge');
      }
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', _videoFile!.path))
        ..fields['userId'] = _auth.currentUser!.uid;

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Upload successful, please wait for results in Histories.'),
            backgroundColor: Colors.green,
          ),
        );
        print('Video uploaded successfully');
      } else {
        throw Exception('Failed to upload video.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().contains('Failed to upload')
              ? 'Video upload failed.'
              : 'Server maintenance, please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_controller != null && _controller!.value.isInitialized)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                    if (isUploading) const CircularProgressIndicator(),
                  ],
                ),
              if (_controller != null && _controller!.value.isInitialized)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: isUploading
                          ? null
                          : () {
                              setState(() {
                                if (_controller!.value.isPlaying) {
                                  _controller!.pause();
                                } else {
                                  _controller!.play();
                                }
                              });
                            },
                    ),
                    IconButton(
                      icon: Icon(Icons.replay),
                      onPressed: isUploading
                          ? null
                          : () {
                              setState(() {
                                _controller!.seekTo(Duration.zero);
                                _controller!.play();
                              });
                            },
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: isUploading ? null : pickVideo,
                child: Text('Pick Video from Device'),
              ),
              if (_videoFile != null) SizedBox(height: 20),
              if (_videoFile != null)
                ElevatedButton(
                  onPressed: isUploading ? null : uploadVideo,
                  child: Text('Upload Video'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
