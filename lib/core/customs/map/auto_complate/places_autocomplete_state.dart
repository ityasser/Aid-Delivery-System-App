library flutter_google_places_hoc081098.src;

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:rxdart_ext/state_stream.dart';
import 'flutter_google_places.dart';
import 'search_state.dart';

abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  FocusNode queryTextFocusNode = new FocusNode();

  late  TextEditingController queryTextController =
  TextEditingController(text: widget.startText)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.startText?.length ?? 0,
    );

  late  StateConnectableStream<SearchState> state;
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();

    state = Rx.fromCallable( GoogleApiHeaders().getHeaders)
        .exhaustMap(createGoogleMapsPlaces)
        .exhaustMap(
          (places) => queryTextController
          .toValueStream(replayValue: true)
          .map((v) => v.text)
          .debounceTime(
          widget.debounce ??  Duration(milliseconds: 300))
          .where((s) => s.isNotEmpty)
          .distinct()
          .switchMap((s) => doSearch(s, places)),
    )
        .publishState(  SearchState(false, null, ''));
    _subscription = state.connect();
  }

  Stream<GoogleMapsPlaces> createGoogleMapsPlaces(Map<String, String> headers) {
    assert(() {
      debugPrint('[flutter_google_places_hoc081098] headers=$headers');
      return true;
    }());

    return Rx.using(
          () => GoogleMapsPlaces(
        apiKey: widget.apiKey,
        baseUrl: widget.proxyBaseUrl,
        httpClient: widget.httpClient,
        apiHeaders: <String, String>{
          ...headers,
          ...?widget.headers,
        },
      ),
          (GoogleMapsPlaces places) =>
          Rx.never<GoogleMapsPlaces>().startWith(places),
          (GoogleMapsPlaces places) {
        assert(() {
          debugPrint('[flutter_google_places_hoc081098] disposed');
          return true;
        }());
        return places.dispose();
      },
    );
  }

  Stream<SearchState> doSearch(String value, GoogleMapsPlaces places) async* {
    yield SearchState(true, null, value);

    assert(() {
      debugPrint(
          '[flutter_google_places_hoc081098] input=$value location=${widget.location} origin=${widget.origin}');
      return true;
    }());

    try {
      final res = await places.autocomplete(
        value,
        offset: widget.offset,
        location: widget.location,
        radius: widget.radius,
        language: widget.language,
        sessionToken: widget.sessionToken,
        types: widget.types ??  [],
        components: widget.components ??  [],
        strictbounds: widget.strictbounds ?? false,
        region: widget.region,
        origin: widget.origin,
      );

      if (res.errorMessage?.isNotEmpty == true ||
          res.status == 'REQUEST_DENIED') {
        assert(() {
          debugPrint('[flutter_google_places_hoc081098] REQUEST_DENIED $res');
          return true;
        }());
        onResponseError(res);
      }

      yield SearchState(
        false,
        PlacesAutocompleteResponse(
          status: res.status,
          errorMessage: res.errorMessage,
          predictions: _sorted(res.predictions),
        ),
        value,
      );
    } catch (e, s) {
      assert(() {
        debugPrint('[flutter_google_places_hoc081098] ERROR $e $s');
        return true;
      }());
      yield SearchState(false, null, value);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    queryTextController.dispose();

    super.dispose();
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;
    widget.onError?.call(res);
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse res) {}

  static List<Prediction> _sorted(List<Prediction> predictions) {
    if (predictions.isEmpty ||
        predictions.every((e) => e.distanceMeters == null)) {
      return predictions;
    }

    final sorted = predictions.sortedBy<num>((e) => e.distanceMeters ?? 0);

    assert(() {
      debugPrint(
          '[flutter_google_places_hoc081098] sorted=${sorted.map((e) => e.distanceMeters).toList(growable: false)}');
      return true;
    }());

    return sorted;
  }
}
