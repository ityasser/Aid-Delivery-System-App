import 'package:flutter/material.dart';

class ItemNavBar {
  final String name;
  final IconData image;
  final Widget screen;
  final bool isInitialized;

  const ItemNavBar({
    required this.name,
    required this.image,
    required this.screen,
    this.isInitialized = false,
  });

  ItemNavBar copyWith({
    String? name,
    IconData? image,
    Widget? screen,
    bool? isInitialized,
  }) {
    return ItemNavBar(
      name: name ?? this.name,
      image: image ?? this.image,
      screen: screen ?? this.screen,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
