import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/local.dart';
import 'package:nocommission_app/core/theme/color.dart';

import 'auto_complate/flutter_google_places.dart';

class PikerMap extends StatefulWidget {
  LatLng? initial;
  Function(LatLng)? onPressedConfirm;

  bool enable;
  PikerMap({
    Key? key,
    this.initial,
    this.onPressedConfirm,
    required this.enable,
  }) : super(key: key);

  @override
  _PikerMapState createState() => _PikerMapState();
}

class _PikerMapState extends State<PikerMap> {
  String googleApikey = "AIzaSyA6LZY2kdzHQjCcUKbIgkw2Enwt_Hx0ukk"; // "AIzaSyAbFNbprjW6oW2NMuyGvHCXARK26NELclQ";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  GoogleMapController? controller;
  String location = AppLocal.getString().search;
  late LatLng target = widget.initial ?? LatLng(0, 0);
  double zoom = 15;
  late CameraPosition? cameraPosition = CameraPosition(target: target, zoom: zoom);

  void locatePosition() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    if (widget.initial == null||widget.initial?.latitude==0.0) {

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        target = LatLng(position.latitude, position.longitude);

        cameraPosition = CameraPosition(target: target, zoom: zoom);
        controller
            ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
      });

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.enable)
    locatePosition();
    else{
      _add(widget.initial??LatLng(0, 0));
    }
  }
  void _add(LatLng latLng) {
    final int markerCount = markers.length;

    final String markerIdVal = 'marker_id_$markerCount';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
    // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
      onDragEnd: (LatLng position)  {},
      onDrag: (LatLng position) =>  {},
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        myLocationButtonEnabled: widget.enable,
        myLocationEnabled: true,
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
          FocusScope.of(context).requestFocus(new FocusNode());

        },
        onCameraMove: (CameraPosition onCameraPosition) {
          cameraPosition = onCameraPosition; //when map is dragging
        },
        onCameraIdle: () async {
          placemarkFromCoordinates(cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude)
              .then((placemarks) {
            setState(() {
              location = placemarks.first.administrativeArea.toString() +
                  ", " +
                  placemarks.first.street.toString();
            });
          }).catchError((onError) {
            setState(() {
              location = AppLocal.getString().search;
            });
          });
        },
        gestureRecognizers: Set()
          ..add(
              Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
          markers: Set<Marker>.of(markers.values),
      ),
      if(widget.enable)
        Center(
        //picker image on google map
        child: Transform.translate(
            offset: Offset(0, -17),
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 50.r,
            )),
      ),

      PositionedDirectional(
          start: 30.w,
          bottom: 35.h,
          child: FloatingActionButton(
            mini: false,
            backgroundColor: ColorsUi.primary,
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 40.r,
            ),
            onPressed: () {
              if (widget.onPressedConfirm != null)
                widget.onPressedConfirm!(LatLng(
                    cameraPosition?.target.latitude ?? 0,
                    cameraPosition?.target.longitude ?? 0));
            },
          )),
      Visibility(visible: widget.enable,
        child: PositionedDirectional(
            //widget to display location name
            top: 7,
            start: 10,
            end: 50,
            child: InkWell(
              onTap: () async {
                PlacesAutocomplete.show(
                  insetPadding: EdgeInsetsDirectional.only(top: 45.h),
                    hint: AppLocal.getString().search,
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    // components: [Component(Component.country, 'np')],
                    onError: (err) {
                      print(err);
                    }).then((place)async {
                  if (place != null) {
                    setState(() {
                      location = place.description.toString();
                    });
                    //form google_maps_webservice package
                    final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                  //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  controller?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: newlatlang, zoom: zoom)));
                }

                });

              },
              child: Card(
                child: Container(
                  alignment: AlignmentDirectional.centerStart,
                  height: 43.h,
                    padding: EdgeInsetsDirectional.only(start: 5.w,end: 5.w),
                    child: Row(
    children: [

    SvgPicture.asset('assets/images/map_pin.svg',
    color: ColorsUi.primary, fit: BoxFit.scaleDown),
    SizedBox(width: 10.w,),
    Expanded(child: TextCustom(location,size: 14))
    ],

    )
              ),
            ))),
      ),
      Visibility(
        visible: false,
        child: PositionedDirectional(
            top: 0.h,
            end: 40.w,
            start: 10.w,
            child: PlacesAutocompleteWidget(

              isWidget: true,
                onTap: (place) async {
                  if (place != null) {
                    setState(() {
                      location = place.description.toString();
                    });
                    //form google_maps_webservice package
                    final plist = GoogleMapsPlaces(
                      apiKey: googleApikey,
                      apiHeaders: await GoogleApiHeaders().getHeaders(),
                      //from google_api_headers package
                    );
                    String placeid = place.placeId ?? "0";
                    final detail = await plist.getDetailsByPlaceId(placeid);
                    final geometry = detail.result.geometry!;
                    final lat = geometry.location.lat;
                    final lang = geometry.location.lng;
                    var newlatlang = LatLng(lat, lang);

                    //move map camera to selected place with animation
                    controller?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: newlatlang, zoom: zoom)));
                  }
                },
                hint: AppLocal.getString().search,
                apiKey: googleApikey,
                mode: Mode.overlay,
                types: [],
                strictbounds: false,
                // components: [Component(Component.country, 'np')],
                onError: (err) {
                  print(err);
                })),
      ),
    ]);
  }
}
