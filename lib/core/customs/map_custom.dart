


import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nocommission_app/core/constant/imagepath.dart';
import 'package:nocommission_app/core/theme/color.dart';

class CustomMap extends StatefulWidget {
  LatLng? initial;
  bool enable;
  CustomMap({
    Key? key,
    this.initial,
    this.enable=true,
  }) : super(key: key);

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  GoogleMapController? controller;
  late LatLng target = widget.initial ?? LatLng(0, 0);
  double zoom = 15;
  late CameraPosition? cameraPosition = CameraPosition(target: target, zoom: zoom);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      _add(widget.initial??LatLng(0, 0));

  }
  void _add(LatLng latLng) {
    final int markerCount = markers.length;

    final String markerIdVal = 'marker_id_$markerCount';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
     // infoWindow: InfoWindow(title: markerIdVal),
      onTap: () {},
      onDragEnd: (LatLng position)  {},
      onDrag: (LatLng position) =>  {},
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(

  //    myLocationButtonEnabled: widget.enable,
     // myLocationEnabled: true,
      scrollGesturesEnabled: true,

      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: target,
        zoom: zoom,
      ),
      mapType: MapType.normal,
      onMapCreated: (onController) {
        setState(() {
          controller = onController;
        });
      },
      onTap: (latLng){
      },
      onCameraMove: (CameraPosition onCameraPosition) {
        cameraPosition = onCameraPosition; //when map is dragging
      },
      onCameraIdle: () async {},
      gestureRecognizers:widget.enable? <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
        Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
        Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
      }:<Factory<OneSequenceGestureRecognizer>>{},
        //gestureRecognizers: {Factory<PanGestureRecognizer>(() => PanGestureRecognizer(),)},
    //  gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
      markers: Set<Marker>.of(markers.values),
    );
  }
}


