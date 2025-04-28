
import 'package:google_maps_webservice/places.dart';

class SearchState {
  String text;
  bool isSearching;
  PlacesAutocompleteResponse? response;

  SearchState(this.isSearching, this.response, this.text);

  @override
  String toString() =>
      '_SearchState{text: $text, isSearching: $isSearching, response: $response}';
}
