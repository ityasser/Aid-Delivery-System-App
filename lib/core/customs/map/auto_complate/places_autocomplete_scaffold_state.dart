import 'package:flutter/material.dart';

import 'flutter_google_places.dart';
import 'places_autocomplete_state.dart';

class PlacesAutocompleteScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(
        textDecoration: widget.textDecoration,
        textStyle: widget.textStyle,
        cursorColor: widget.cursorColor,
      ),
    );
    final body = PlacesAutocompleteResult(
      onTap: Navigator.of(context).pop,
      logo: widget.logo,
    );
    return Scaffold(appBar: appBar, body: body);
  }
}
class AppBarPlacesAutoCompleteTextField extends StatefulWidget {
  final InputDecoration? textDecoration;
  final TextStyle? textStyle;
  final Color? cursorColor;

  AppBarPlacesAutoCompleteTextField({
    Key? key,
    required this.textDecoration,
    required this.textStyle,
    required this.cursorColor,
  }) : super(key: key);

  @override
  _AppBarPlacesAutoCompleteTextFieldState createState() =>
      _AppBarPlacesAutoCompleteTextFieldState();
}

class _AppBarPlacesAutoCompleteTextFieldState
    extends State<AppBarPlacesAutoCompleteTextField> {
  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context);

    return Container(
        alignment: Alignment.topLeft,
        margin:  EdgeInsets.only(top: 2.0),
        child: TextField(
          focusNode: state.queryTextFocusNode,
          controller: state.queryTextController,
          autofocus: true,
          style: widget.textStyle ?? _defaultStyle(),
          decoration:
          widget.textDecoration ?? _defaultDecoration(state.widget.hint),
          cursorColor: widget.cursorColor,
        ));
  }

  InputDecoration _defaultDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white30
          : Colors.black38,
      hintStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black38
            : Colors.white30,
        fontSize: 16.0,
      ),
      border: InputBorder.none,
    );
  }

  TextStyle _defaultStyle() {
    return TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black.withOpacity(0.9)
          : Colors.white.withOpacity(0.9),
      fontSize: 16.0,
    );
  }
}
