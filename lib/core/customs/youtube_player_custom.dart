import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/utils/functions.dart';
import 'package:nocommission_app/core/utils/helpers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerCustom extends StatefulWidget {
  String urlOrId;
  String? title;

  YoutubePlayerCustom({required this.urlOrId, this.title});

  @override
  _YoutubePlayerCustomState createState() => _YoutubePlayerCustomState();
}

class _YoutubePlayerCustomState extends State<YoutubePlayerCustom>
    with FunctionsGeneral {
  late YoutubePlayerController _controller;

  bool _muted = false;
  bool _isPlayerReady = false;
  double aspectRatio = 16 / 9; // Default aspect ratio
  YoutubeMetaData _videoMetaData=YoutubeMetaData();

  void _initializeVideo() async {
    setState(() {
      // aspectRatio = video.videoDetails.width! / video.videoDetails.height!;
      //  aspectRatio = video.width / video.height;
      // aspectRatio = video.aspectRatio;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    _controller = YoutubePlayerController(
      initialVideoId: getIdFromUrlYoutube(widget.urlOrId),
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: false,
          useHybridComposition: false),
    )..addListener(listener);

  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: TextCustom(
            widget.title ?? "",
            color: ColorsUi.white,
            height: 1.7,
            textOverflow: TextOverflow.ellipsis,
            maxLine: 3,
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: YoutubePlayer(
            actionsPadding: EdgeInsets.all(10),
            controller: _controller,
            aspectRatio: aspectRatio,
            thumbnail: Image.network(getYoutubeThumbnail(getIdFromUrlYoutube(widget.urlOrId)),fit: BoxFit.contain,),
            bottomActions: [
              //  PlayPauseButton(),

              SizedBox(
                width: 10.w,
              ),
              CurrentPosition(),
              SizedBox(
                width: 3.w,
              ),
              ProgressBar(isExpanded: true),
              SizedBox(
                width: 3.w,
              ),
              RemainingDuration(),
              IconButton(
                icon: Icon(
                  _muted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20.r,
                ),
                onPressed: _isPlayerReady
                    ? () {
                        print("onPressed");
                        _muted ? _controller.unMute() : _controller.mute();
                        setState(() {
                          _muted = !_muted;
                        });
                      }
                    : null,
              ),
            ],
            topActions: <Widget>[
              Expanded(
                child: Padding(padding: EdgeInsets.only(top: 55.h),
                  child: TextCustom(
                    _videoMetaData.title,
                    color: ColorsUi.white,
                    align: TextAlign.center,
                    height: 1.7,
                    textOverflow: TextOverflow.ellipsis,
                    maxLine: 3,
                  ),
                ),
              ),
            ],
            showVideoProgressIndicator: true,
            progressIndicatorColor: ColorsUi.primary,
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {},
          ),
        ),
      ),
    );
  }
}
