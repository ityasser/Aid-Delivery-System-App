import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nocommission_app/core/customs/custom_button.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/local.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/utils/functions.dart';
import 'package:nocommission_app/core/utils/helpers.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'indicator.dart';

enum IndicatorType { circle, text,none }

/*InkWell(
    onTap: () {
      Get.to(ImagePreview(
        items: widget.items,
        index: index,
      ));
    },child:widget.itemBuilder(context,index,realIndex))*/
class SliderCustom extends StatefulWidget {
  int itemCount;
  double elevation;
  double radius;
  double? height;
  EdgeInsetsDirectional? margin;
  ExtendedIndexedWidgetBuilder? itemBuilder;
  IndicatorType indicatorType;
  CarouselOptions? options;
  int? initialPage;
  bool? enableInfiniteScroll;
  bool? autoPlay;

  SliderCustom(
      {required this.itemCount,
      this.itemBuilder,
      this.elevation = 3,
      this.radius = 20,
      this.margin,
      this.indicatorType = IndicatorType.circle,
      this.options,
      this.enableInfiniteScroll,
      this.autoPlay,
      this.height,
      this.initialPage});

  @override
  _SliderCustomState createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Card(
          margin: EdgeInsetsDirectional.only(
              top: widget.margin?.top ?? 0,
              bottom: ((widget.itemCount) > 1 && widget.indicatorType == IndicatorType.circle) ? 18.h : widget.margin?.bottom ?? 0,
              start: widget.margin?.start ?? 0,
              end: widget.margin?.end ?? 0),
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            child: CarouselSlider.builder(
              itemCount: widget.itemCount,
              itemBuilder: widget.itemBuilder,
              options: widget.options ??
                  CarouselOptions(
                    height:widget.height ,
                    viewportFraction: 1,
                    initialPage: widget.initialPage ?? 0,
                    //enableInfiniteScroll: widget.enableInfiniteScroll ?? true,
                    reverse: false,
                    autoPlay: widget.autoPlay ?? true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    enlargeCenterPage: false,
                    enlargeFactor: 0.3,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(
                        () {
                          _selectedPage = index;
                        },
                      );
                    },
                  ),
            ),
          ),
        ),
        if ((widget.itemCount) > 1 && widget.indicatorType == IndicatorType.circle)
          SizedBox(height: 7.h),
        if ((widget.itemCount) > 1 && widget.indicatorType == IndicatorType.circle)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: getRowIndicator(),
            ),
          ),
        if ((widget.itemCount) > 1 && widget.indicatorType == IndicatorType.text)
          PositionedDirectional(
              bottom: 25.h,
              end: 25.w,
              child: Container(
                padding: EdgeInsetsDirectional.only(
                    start: 10.w, end: 8.w, top: 3.h, bottom: 1.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    color: ColorsUi.black.withOpacity(0.4)),
                child: TextCustom("${_selectedPage + 1}/${widget.itemCount}",
                    size: 12.sp, color: ColorsUi.white, height: 1.h),
              ))
      ],
    );
  }

  Widget getRowIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: _selectedPage,
      count: widget.itemCount,
      duration: const Duration(milliseconds: 400),
      effect: WormEffect(
          dotHeight: 8.h,
          dotWidth: 20.w,
          spacing: 5.w,
          activeDotColor: ColorsUi.primary,
          dotColor: ColorsUi.greyDark.withOpacity(0.7)),
    );

    List<Widget> list = [];
    for (var i = 0; i < widget.itemCount; i++) {
      list.add(
        SliderIndicator(
          endMargin: 5,
          selected: _selectedPage == i,
          color1: ColorsUi.primary,
          color2: ColorsUi.black.withOpacity(0.20),
          isCircle: false,
        ),
      );
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }
}

class ImagePreview extends StatelessWidget {
  final List<String> items;
  final int index;

  const ImagePreview({Key? key, required this.items, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        leading: IconButton(icon: Icon(Icons.chevron_left_rounded,color: Colors.white,size: 35.r,), onPressed: () {
          Get.back();
        },),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorsUi.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor:ColorsUi.primary,centerTitle: true,title:TextCustom(
          AppLocal.getString().imagesViewer,      size: 16.sp,color: Colors.white),
          elevation: 0
      ),

      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions.customChild(
              child: CachedNetworkImage(imageUrl:items[index], fit: BoxFit.contain),
            //initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag:    "ImagePreview$index",),
          );
        },
        itemCount: items.length,
        loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
                ),
              ),
            ),
        backgroundDecoration: const BoxDecoration(
            gradient: ColorsUi.gradientLogo
        ),
        pageController: PageController(initialPage: index),
        // onPageChanged: onPageChanged,
      )/*PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions.customChild(
              child: CachedNetworkImage(imageUrl:items[index], fit: BoxFit.contain));
        },
        itemCount: items.length,
        loadingBuilder: (context, event) =>
            Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
                ),
              ),
            ),
        pageController: PageController(initialPage: index),
        backgroundDecoration: const BoxDecoration(
            gradient: ColorsUi.gradientLogo
        ),
        // backgroundDecoration: widget.backgroundDecoration,
        // onPageChanged: onPageChanged,
      ),*/
    );
  }
}