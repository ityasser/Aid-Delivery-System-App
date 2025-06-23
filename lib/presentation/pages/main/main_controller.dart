// main_controller.dart
import 'package:aid_registry_flutter_app/databse/objectbox_database.dart';
import 'package:aid_registry_flutter_app/presentation/pages/projects/project_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/app.dart';
import '../../../core/customs/custom_icons_icons.dart';
import '../../../core/models/item_nav_bar.dart';
import '../../../data/project.dart';
import '../../../databse/sync_service.dart';
import '../projects/local_projects/local_projects_notifier.dart';
import '../search/search.dart';
import 'main_state.dart';

final mainControllerProvider =
    StateNotifierProvider<MainControllerNotifier, MainState>((ref) {
      return MainControllerNotifier(ref);
    });

class MainControllerNotifier extends StateNotifier<MainState> {
  Ref ref;
  Function(int)? onAnimateNavBar;
  void registerAnimationCallback(Function(int) callback) {
    onAnimateNavBar = callback;
  }
  MainControllerNotifier(this.ref)
    : super(
        MainState(
          selectedIndex: 0,
          items: [
            ItemNavBar(
              isInitialized: true,
              name: App.getString().search,
              image: Icons.search,
              screen: SearchPage(),
            ),
            ItemNavBar(
              isInitialized: false,
              name: App.getString().projects,
              image: Icons.assistant_direction_outlined,
              screen: ProjectTabsScreen(),
            ),
          ],
        ),
      );



  void changeSelect(int index) {
    final updatedItems = [...state.items];
    updatedItems[index] = updatedItems[index].copyWith(isInitialized: true);

    state = state.copyWith(selectedIndex: index, items: updatedItems);
  }

  void onClickSearch() {
    // final navBarState = navigationBarGlobalKey.currentState as dynamic;
    // navBarState.changeAnimation(1);
    onAnimateNavBar?.call(1);
    changeSelect(1);
  }

  void syncNow() {
    SyncService.sync();
  }
}
