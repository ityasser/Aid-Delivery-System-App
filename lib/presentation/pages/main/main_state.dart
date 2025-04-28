// main_state.dart
import 'package:flutter/material.dart';

import '../../../core/models/item_nav_bar.dart';

class MainState {
  final int selectedIndex;
  final List<ItemNavBar> items;

  MainState({
    required this.selectedIndex,
    required this.items,
  });

  MainState copyWith({
    int? selectedIndex,
    List<ItemNavBar>? items,
  }) {
    return MainState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      items: items ?? this.items,
    );
  }
}
