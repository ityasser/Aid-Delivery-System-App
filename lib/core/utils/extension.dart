import 'package:flutter/material.dart';
import 'package:aid_registry_flutter_app/core/theme/color.dart';

extension StringNullSaftyExtensions on String? {
  bool get isNullOrEmpty {
    if(this==null)
      return true;

    return (this?.trim().isEmpty??true);
  }
}
extension MyExtensions on String {

  int toIntCodeUnit(){
    int intValue = 0;
    for (int codeUnit in codeUnits) {
      if (codeUnit >= 48 && codeUnit <= 57) {
        intValue = intValue * 10 + (codeUnit - 48);
      } else {
        intValue=intValue+1;
      }
    }
    return intValue;
  }

  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  bool parseBool() {
    return this.toLowerCase() == 'true';
  }

  Color toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    } else
      return ColorsUi.primary;
  }

  int toInt() {
    return int.parse(this);
  }

  String toId(String id) {
    return this.replaceAll("%id", id);
  }
}
extension object on Object{
  external int? id;
}
extension ListExtensions<T> on List<T> {
  void addOrUpdate(T element) {
    final index = indexOf(element);
    if (index != -1) {
      // Update existing item
      this[index] = element;
    } else {
      // Add new item
      if (element != null)add(element);
    }
  }
  void addIfOrUpdate(T element, bool Function(T element) condition) {
    final index = indexOf(element);
    if (index != -1) {
      // Update existing item
      this[index] = element;
    } else {
      // Add new item
      if (element != null && condition(element))add(element);
    }
  }

  void addAllOrUpdate(Iterable<T> elements) {
    for (var element in elements) {
      final index = indexOf(element);
      if (index != -1) {
        // Update existing item
        this[index] = element;
      } else {
        // Add new item
        add(element);
      }
    }
  }
}
extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> removeNullValues() {
    return Map.fromEntries(entries.where((entry) => entry.value != null));
  }
  void add(K, V){
    if((V==null)&&containsKey(K)){
      remove(K);
    }
    else{
      if(V!=null){
        if(V.runtimeType ==String){
          String vv=V as String;
          if(vv.isNotEmpty) {
            this[K]=V as  dynamic;
          }else{
            remove(K);
          }
        }else{
          this[K]=V;
        }
      }

    }
  }
}
