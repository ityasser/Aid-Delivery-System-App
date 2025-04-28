library flutter_google_places_hoc081098.src;

import 'dart:async';
import 'package:get/get.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:nocommission_app/core/customs/text_field_custom.dart';

import 'places_autocomplete_scaffold_state.dart';
import 'places_autocomplete_state.dart';
import 'powered_by_google_image.dart';
import 'search_state.dart';

class PlacesAutocompleteWidget extends StatefulWidget {
  final String? apiKey;
  final Mode mode;
  final String? hint;

  final String? startText;
  final BorderRadius? overlayBorderRadius;
  final Location? location;
  final Location? origin;
  final num? offset;
  final num? radius;
  final String? language;
  final String? sessionToken;
  final List<String>? types;
  final List<Component>? components;
  final bool? strictbounds;
  final String? region;
  final Widget? logo;
  final ValueChanged<PlacesAutocompleteResponse>? onError;
  final Duration? debounce;
  final Map<String, String>? headers;

  /// This defines the space between the screens's edges and the dialog.
  /// This is only used in Mode.overlay.
  final EdgeInsetsGeometry? insetPadding;
  final Widget? backArrowIcon;

  /// Decoration for search text field
  final InputDecoration? textDecoration;

  /// Text style for search text field
  final TextStyle? textStyle;

  final Color? cursorColor;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String? proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final Client? httpClient;

  final ValueChanged<Prediction>? onTap;

  bool isWidget;
  PlacesAutocompleteWidget(

      {Key? key,
      required this.apiKey,
      this.mode = Mode.fullscreen,
      this.hint = 'Search',
      this.insetPadding,
      this.isWidget=false,
      this.backArrowIcon,
      this.onTap,
      this.overlayBorderRadius,
      this.offset,
      this.location,
      this.origin,
      this.radius,
      this.language,
      this.sessionToken,
      this.types,
      this.components,
      this.strictbounds,
      this.region,
      this.logo,
      this.onError,
      this.proxyBaseUrl,
      this.httpClient,
      this.startText,
      this.debounce,
      this.headers,
      this.textDecoration,
      this.textStyle,
      this.cursorColor})
      : super(key: key) {
    if (apiKey == null && proxyBaseUrl == null) {
      throw ArgumentError(
          'One of `apiKey` and `proxyBaseUrl` fields is required');
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<PlacesAutocompleteWidget> createState() => mode == Mode.fullscreen
      ? PlacesAutocompleteScaffoldState()
      : _PlacesAutocompleteOverlayState();

  static PlacesAutocompleteState of(BuildContext context) =>
      context.findAncestorStateOfType<PlacesAutocompleteState>()!;
}


class _PlacesAutocompleteOverlayState extends PlacesAutocompleteState {
  void onTapp<T extends Object?>([ T? result ]) {
     if(widget.onTap!=null){
        FocusScope.of(context).requestFocus(new FocusNode());
        widget.onTap!(result as Prediction);
        //  state.text="";
        // _queryTextController.text=value.description.toString();
        //response.predictions.clear();
      }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
     // FocusScope.of(context).requestFocus(new FocusNode());


    });

  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerTopLeftBorderRadius =
        widget.overlayBorderRadius?.topLeft ??  Radius.circular(10);

    final headerTopRightBorderRadius =
        widget.overlayBorderRadius?.topRight ??  Radius.circular(10);

    final header = Column(children: <Widget>[
      Material(

          color:widget.isWidget?Colors.transparent: theme.dialogBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: headerTopLeftBorderRadius,
              topRight: headerTopRightBorderRadius),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(!widget.isWidget)
              IconButton(
                padding:  EdgeInsets.all(8.0).copyWith(top: 12.0),
                color: theme.brightness == Brightness.light
                    ? Colors.black45
                    : null,
                icon: _iconBack,
                onPressed: () {
                  Navigator.of(context).pop();

                },
              ),

              Expanded(
                child: _textField(context),
              ),
            ],
          )),
     //  Divider(),
    ]);

    final bodyBottomLeftBorderRadius =
        widget.overlayBorderRadius?.bottomLeft ??  Radius.circular(2);

    final bodyBottomRightBorderRadius =
        widget.overlayBorderRadius?.bottomRight ??  Radius.circular(2);

    final container = Container(
      margin:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      child: Stack(
        children: <Widget>[
          header,
          Padding(
            padding:  EdgeInsets.only(top: 48.0),
            child: StreamBuilder<SearchState>(
              stream: state,
              initialData:state.value,
              builder: (context, snapshot) {
                final state = snapshot.requireData;
                final response = state.response;

                if (state.isSearching) {
                  return Stack(
                    alignment: FractionalOffset.bottomCenter,
                    children: <Widget>[_Loader()],
                  );
                } else if (state.text.isEmpty ||
                    response == null ||
                    response.predictions.isEmpty || !queryTextFocusNode.hasFocus) {
                  return Material(
                    color: theme.dialogBackgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: bodyBottomLeftBorderRadius,
                      bottomRight: bodyBottomRightBorderRadius,
                    ),

                    child: widget.logo ??(!widget.isWidget||queryTextFocusNode.hasFocus? PoweredByGoogleImage():SizedBox.fromSize()),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Material(
                      borderRadius: BorderRadius.only(
                        bottomLeft: bodyBottomLeftBorderRadius,
                        bottomRight: bodyBottomRightBorderRadius,
                      ),
                      color: theme.dialogBackgroundColor,
                      child: ListBody(
                        children: response.predictions
                            .map(
                              (p) => PredictionTile(
                                prediction: p,
                                onTap: widget.isWidget?onTapp: Navigator
                                    .of(context)
                                    .pop,
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return Padding(
          padding: widget.insetPadding ??  EdgeInsets.only(top: 8.0),
          child: container);
    }

    return Padding(
      padding: widget.insetPadding ?? EdgeInsets.zero,
      child: container,
    );
  }

  Widget get _iconBack {
    if (widget.backArrowIcon != null) return widget.backArrowIcon!;
    return Theme.of(context).platform == TargetPlatform.iOS
        ?  Icon(Icons.arrow_back_ios)
        :  Icon(Icons.arrow_back);
  }

  Widget _textField(BuildContext context) =>
      widget.isWidget?TextFieldCustom(
    focusNode: queryTextFocusNode,
    controller: queryTextController,
    hintText: widget.hint??"",

  ):TextField(

        focusNode: queryTextFocusNode,
        controller: queryTextController,
        autofocus: true,
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : null,
            fontSize: 16.0),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black45
                : null,
            fontSize: 16.0,
          ),
          border: InputBorder.none,
        ),
      );

  Widget _textFieldc(BuildContext context) => TextField(

    focusNode: queryTextFocusNode,
        controller: queryTextController,
        autofocus: true,
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black87
                : null,
            fontSize: 16.0),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black45
                : null,
            fontSize: 16.0,
          ),
          border: InputBorder.none,
        ),
      );
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:  BoxConstraints(maxHeight: 2.0),
      child: LinearProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class PlacesAutocompleteResult extends StatelessWidget {
  final ValueChanged<Prediction> onTap;
  final Widget? logo;

   PlacesAutocompleteResult(
      {Key? key, required this.onTap, required this.logo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context);

    return StreamBuilder<SearchState>(
      stream: state.state,
      initialData: state.state.value,
      builder: (context, snapshot) {
        final state = snapshot.requireData;
        final response = state.response;

        if (state.text.isEmpty || response == null || response.predictions.isEmpty) {
          return Stack(
            children: [

              if (state.isSearching) _Loader(),
              logo ?? PoweredByGoogleImage()
            ],
          );
        }
        return PredictionsListView(
          predictions: response.predictions,
          onTap: onTap,
        );
      },
    );
  }
}



class PredictionsListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<Prediction> onTap;

   PredictionsListView(
      {Key? key, required this.predictions, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: predictions
          .map((Prediction p) => PredictionTile(prediction: p, onTap: onTap))
          .toList(growable: false),
    );
  }
}

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction> onTap;

   PredictionTile(
      {Key? key, required this.prediction, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:  Icon(Icons.location_on),
      title: Text(prediction.description ?? ''),
      onTap: () => onTap(prediction),
    );
  }
}

enum Mode { overlay, fullscreen }


abstract class PlacesAutocomplete {
  static Future<Prediction?> show(
      {required BuildContext context,
      required String? apiKey,
      Mode mode = Mode.fullscreen,
      String? hint = 'Search',
      BorderRadius? overlayBorderRadius,
      num? offset,
      Location? location,
      num? radius,
      String? language,
      String? sessionToken,
      List<String>? types,
      List<Component>? components,
      bool? strictbounds,
      String? region,
      Widget? logo,
      ValueChanged<PlacesAutocompleteResponse>? onError,
      String? proxyBaseUrl,
      Client? httpClient,
      String? startText,
      Duration? debounce,
      Location? origin,
      Map<String, String>? headers,
      InputDecoration? textDecoration,
      TextStyle? textStyle,
      Color? cursorColor,
        EdgeInsetsGeometry? insetPadding,
      Widget? backArrowIcon}) {

    PlacesAutocompleteWidget builder(BuildContext context) =>
        PlacesAutocompleteWidget(
          apiKey: apiKey,
          mode: mode,
          overlayBorderRadius: overlayBorderRadius,
          language: language,
          sessionToken: sessionToken,
          components: components,
          types: types,
          location: location,
          radius: radius,
          strictbounds: strictbounds,
          region: region,
          offset: offset,
          hint: hint,
          logo: logo,
          onError: onError,
          proxyBaseUrl: proxyBaseUrl,
          httpClient: httpClient,
          startText: startText,
          debounce: debounce,
          origin: origin,
          headers: headers,
          textDecoration: textDecoration,
          textStyle: textStyle,
          cursorColor: cursorColor,
          insetPadding: insetPadding,
          backArrowIcon: backArrowIcon,
        );

    if (mode == Mode.overlay) {
      return showDialog<Prediction>(context: context, builder: builder,useRootNavigator: true);
    }
    return Navigator.push<Prediction>(
        context, MaterialPageRoute(builder: builder));
  }
}
