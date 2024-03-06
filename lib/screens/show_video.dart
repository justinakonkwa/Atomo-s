// ignore_for_file: unused_field, unused_local_variable, must_be_immutable, depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  const ShowVideo({
    super.key,
    required this.videoFile,
    required this.isPaused,
  });

  final Uint8List videoFile;
  final bool isPaused;

  @override
  _ShowVideoPageState createState() => _ShowVideoPageState();
}

class _ShowVideoPageState extends State<ShowVideo> {
  StreamController<double> progressController = StreamController<double>();
  final TextEditingController _videoController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  double progressing = 0.0;

  late VideoPlayerController _controller;
  bool isVideoPlaying = false;
  bool _isIconVisible = true;
  bool _isOpen = false;
  bool _videoLoading = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    if (!widget.isPaused) {
      _videoLoading = true;
    }
    final tempDir = await getTemporaryDirectory();
    final tempVideoFile = File('${tempDir.path}/temp_video.mp4');

    await tempVideoFile.writeAsBytes(widget.videoFile);

    _controller = VideoPlayerController.file(tempVideoFile)
      ..initialize().then((_) {
        setState(() {
          if (widget.isPaused) {
            _controller.pause();
          } else {
            isVideoPlaying = true;
            _isOpen = true;
            _showIcon();
            _controller.play();
            _videoLoading = false;
          }
        });
      });
  }

  void _showIcon() {
    setState(() {
      _isIconVisible = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isIconVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.closedCaptionFile;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            progressController.close();
            _controller.pause();
            Navigator.of(context).pop();
          },
          icon: const Icon(FluentIcons.dismiss_48_regular),
        ),
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Si le geste de balayage est vers le bas, fermer la page
          if (details.primaryVelocity! > 0) {
            _controller.pause();
            _controller.closedCaptionFile;
            _controller.dispose();
            Navigator.of(context).pop(false);
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      !isVideoPlaying && !_isOpen
                          ? const SizedBox()
                          : AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                children: [
                                  VideoPlayer(_controller),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: VideoProgressIndicator(
                                      _controller,
                                      allowScrubbing: true,
                                      colors: VideoProgressColors(
                                        backgroundColor: Colors.black45,
                                        playedColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        bufferedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isVideoPlaying) {
                              _isOpen = true;
                              _controller.play();
                              _showIcon();
                            } else {
                              _controller.pause();
                              _isIconVisible = true;
                            }
                            isVideoPlaying = !isVideoPlaying;
                          });
                        },
                        child: AnimatedOpacity(
                          opacity: _isIconVisible ? 1.0 : 00,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            width: 70,
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: _videoLoading
                                ? CupertinoActivityIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    radius: 20,
                                  )
                                : Icon(
                                    isVideoPlaying
                                        ? FluentIcons.pause_48_filled
                                        : FluentIcons.play_48_filled,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    size: 40,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
