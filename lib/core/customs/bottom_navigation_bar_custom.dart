// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection' show Queue;
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nocommission_app/app/app.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;


/// Defines the layout and behavior of a [BottomNavigationBarCustom].
///
/// For a sample on how to use these, please see [BottomNavigationBarCustom].
/// See also:
///
///  * [BottomNavigationBarCustom]
///  * [BottomNavigationBarItem]
///  * <https://material.io/design/components/bottom-navigation.html#specs>
enum BottomNavigationBarTypeCustom {
  /// The [BottomNavigationBarCustom]'s [BottomNavigationBarItem]s have fixed width.
  fixed,

  /// The location and size of the [BottomNavigationBar] [BottomNavigationBarItem]s
  /// animate and labels fade in when they are tapped.
  shifting,
}

/// Refines the layout of a [BottomNavigationBarCustom] when the enclosing
/// [MediaQueryData.orientation] is [Orientation.landscape].
enum BottomNavigationBarLandscapeLayout {
  /// If the enclosing [MediaQueryData.orientation] is
  /// [Orientation.landscape] then the navigation bar's items are
  /// evenly spaced and spread out across the available width. Each
  /// item's label and icon are arranged in a column.
  spread,

  /// If the enclosing [MediaQueryData.orientation] is
  /// [Orientation.landscape] then the navigation bar's items are
  /// evenly spaced in a row but only consume as much width as they
  /// would in portrait orientation. The row of items is centered within
  /// the available width. Each item's label and icon are arranged
  /// in a column.
  centered,

  /// If the enclosing [MediaQueryData.orientation] is
  /// [Orientation.landscape] then the navigation bar's items are
  /// evenly spaced and each item's icon and label are lined up in a
  /// row instead of a column.
  linear,
}

/// A material widget that's displayed at the bottom of an app for selecting
/// among a small number of views, typically between three and five.
///
/// The bottom navigation bar consists of multiple items in the form of
/// text labels, icons, or both, laid out on top of a piece of material. It
/// provides quick navigation between the top-level views of an app. For larger
/// screens, side navigation may be a better fit.
///
/// A bottom navigation bar is usually used in conjunction with a [Scaffold],
/// where it is provided as the [Scaffold.bottomNavigationBar] argument.
///
/// The bottom navigation bar's [type] changes how its [items] are displayed.
/// If not specified, then it's automatically set to
/// [BottomNavigationBarTypeCustom.fixed] when there are less than four items, and
/// [BottomNavigationBarTypeCustom.shifting] otherwise.
///
/// The length of [items] must be at least two and each item's icon and title/label
/// must not be null.
///
///  * [BottomNavigationBarTypeCustom.fixed], the default when there are less than
///    four [items]. The selected item is rendered with the
///    [selectedItemColor] if it's non-null, otherwise the theme's
///    [ColorScheme.primary] color is used for [Brightness.light] themes
///    and [ColorScheme.secondary] for [Brightness.dark] themes.
///    If [backgroundColor] is null, The
///    navigation bar's background color defaults to the [Material] background
///    color, [ThemeData.canvasColor] (essentially opaque white).
///  * [BottomNavigationBarTypeCustom.shifting], the default when there are four
///    or more [items]. If [selectedItemColor] is null, all items are rendered
///    in white. The navigation bar's background color is the same as the
///    [BottomNavigationBarItem.backgroundColor] of the selected item. In this
///    case it's assumed that each item will have a different background color
///    and that background color will contrast well with white.
///
/// {@tool dartpad}
/// This example shows a [BottomNavigationBarCustom] as it is used within a [Scaffold]
/// widget. The [BottomNavigationBarCustom] has three [BottomNavigationBarItem]
/// widgets, which means it defaults to [BottomNavigationBarTypeCustom.fixed], and
/// the [currentIndex] is set to index 0. The selected item is
/// amber. The `_onItemTapped` function changes the selected item's index
/// and displays a corresponding message in the center of the [Scaffold].
///
/// ** See code in examples/api/lib/material/bottom_navigation_bar/bottom_navigation_bar.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows a [BottomNavigationBarCustom] as it is used within a [Scaffold]
/// widget. The [BottomNavigationBarCustom] has four [BottomNavigationBarItem]
/// widgets, which means it defaults to [BottomNavigationBarTypeCustom.shifting], and
/// the [currentIndex] is set to index 0. The selected item is amber in color.
/// With each [BottomNavigationBarItem] widget, backgroundColor property is
/// also defined, which changes the background color of [BottomNavigationBarCustom],
/// when that item is selected. The `_onItemTapped` function changes the
/// selected item's index and displays a corresponding message in the center of
/// the [Scaffold].
///
/// ** See code in examples/api/lib/material/bottom_navigation_bar/bottom_navigation_bar.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows [BottomNavigationBarCustom] used in a [Scaffold] Widget with
/// different interaction patterns. Tapping twice on the first [BottomNavigationBarItem]
/// uses the [ScrollController] to animate the [ListView] to the top. The second
/// [BottomNavigationBarItem] shows a Modal Dialog.
///
/// ** See code in examples/api/lib/material/bottom_navigation_bar/bottom_navigation_bar.2.dart **
/// {@end-tool}
/// See also:
///
///  * [BottomNavigationBarItem]
///  * [Scaffold]
///  * <https://material.io/design/components/bottom-navigation.html>
///  * [NavigationBar], this widget's replacement in Material Design 3.
class BottomNavigationBarCustom extends StatefulWidget {
  /// Creates a bottom navigation bar which is typically used as a
  /// [Scaffold]'s [Scaffold.bottomNavigationBar] argument.
  ///
  /// The length of [items] must be at least two and each item's icon and label
  /// must not be null.
  ///
  /// If [type] is null then [BottomNavigationBarTypeCustom.fixed] is used when there
  /// are two or three [items], [BottomNavigationBarTypeCustom.shifting] otherwise.
  ///
  /// The [iconSize], [selectedFontSize], [unselectedFontSize], and [elevation]
  /// arguments must be non-null and non-negative.
  ///
  /// If [selectedLabelStyle].color and [unselectedLabelStyle].color values
  /// are non-null, they will be used instead of [selectedItemColor] and
  /// [unselectedItemColor].
  ///
  /// If custom [IconThemeData]s are used, you must provide both
  /// [selectedIconTheme] and [unselectedIconTheme], and both
  /// [IconThemeData.color] and [IconThemeData.size] must be set.
  ///
  /// If [useLegacyColorScheme] is set to `false`
  /// [selectedIconTheme] values will be used instead of [iconSize] and [selectedItemColor] for selected icons.
  /// [unselectedIconTheme] values will be used instead of [iconSize] and [unselectedItemColor] for unselected icons.
  ///
  ///
  /// If both [selectedLabelStyle].fontSize and [selectedFontSize] are set,
  /// [selectedLabelStyle].fontSize will be used.
  ///
  /// Only one of [selectedItemColor] and [fixedColor] can be specified. The
  /// former is preferred, [fixedColor] only exists for the sake of
  /// backwards compatibility.
  ///
  /// If [showSelectedLabels] is `null`, [BottomNavigationBarThemeData.showSelectedLabels]
  /// is used. If [BottomNavigationBarThemeData.showSelectedLabels]  is null,
  /// then [showSelectedLabels] defaults to `true`.
  ///
  /// If [showUnselectedLabels] is `null`, [BottomNavigationBarThemeData.showUnselectedLabels]
  /// is used. If [BottomNavigationBarThemeData.showSelectedLabels] is null,
  /// then [showUnselectedLabels] defaults to `true` when [type] is
  /// [BottomNavigationBarTypeCustom.fixed] and `false` when [type] is
  /// [BottomNavigationBarTypeCustom.shifting].
  BottomNavigationBarCustom({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation,
    this.type,
    Color? fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    Color? selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
  })  : assert(items.length >= 2),
        assert(
          items.every((BottomNavigationBarItem item) => item.label != null),
          'Every item must have a non-null label',
        ),
        assert(0 <= currentIndex && currentIndex < items.length),
        assert(elevation == null || elevation >= 0.0),
        assert(iconSize >= 0.0),
        assert(
          selectedItemColor == null || fixedColor == null,
          'Either selectedItemColor or fixedColor can be specified, but not both',
        ),
        assert(selectedFontSize >= 0.0),
        assert(unselectedFontSize >= 0.0),
        selectedItemColor = selectedItemColor ?? fixedColor;

  /// Defines the appearance of the button items that are arrayed within the
  /// bottom navigation bar.
  final List<BottomNavigationBarItem> items;

  /// Called when one of the [items] is tapped.
  ///
  /// The stateful widget that creates the bottom navigation bar needs to keep
  /// track of the index of the selected [BottomNavigationBarItem] and call
  /// `setState` to rebuild the bottom navigation bar with the new [currentIndex].
  final ValueChanged<int>? onTap;

  /// The index into [items] for the current active [BottomNavigationBarItem].
  final int currentIndex;

  /// The z-coordinate of this [BottomNavigationBarCustom].
  ///
  /// If null, defaults to `8.0`.
  ///
  /// {@macro flutter.material.material.elevation}
  final double? elevation;

  /// Defines the layout and behavior of a [BottomNavigationBarCustom].
  ///
  /// See documentation for [BottomNavigationBarTypeCustom] for information on the
  /// meaning of different types.
  final BottomNavigationBarTypeCustom? type;

  /// The value of [selectedItemColor].
  ///
  /// This getter only exists for backwards compatibility, the
  /// [selectedItemColor] property is preferred.
  Color? get fixedColor => selectedItemColor;

  /// The color of the [BottomNavigationBarCustom] itself.
  ///
  /// If [type] is [BottomNavigationBarTypeCustom.shifting] and the
  /// [items] have [BottomNavigationBarItem.backgroundColor] set, the [items]'
  /// backgroundColor will splash and overwrite this color.
  final Color? backgroundColor;

  /// The size of all of the [BottomNavigationBarItem] icons.
  ///
  /// See [BottomNavigationBarItem.icon] for more information.
  final double iconSize;

  /// The color of the selected [BottomNavigationBarItem.icon] and
  /// [BottomNavigationBarItem.label].
  ///
  /// If null then the [ThemeData.primaryColor] is used.
  final Color? selectedItemColor;

  /// The color of the unselected [BottomNavigationBarItem.icon] and
  /// [BottomNavigationBarItem.label]s.
  ///
  /// If null then the [ThemeData.unselectedWidgetColor]'s color is used.
  final Color? unselectedItemColor;

  /// The size, opacity, and color of the icon in the currently selected
  /// [BottomNavigationBarItem.icon].
  ///
  /// If this is not provided, the size will default to [iconSize], the color
  /// will default to [selectedItemColor].
  ///
  /// It this field is provided, it must contain non-null [IconThemeData.size]
  /// and [IconThemeData.color] properties. Also, if this field is supplied,
  /// [unselectedIconTheme] must be provided.
  final IconThemeData? selectedIconTheme;

  /// The size, opacity, and color of the icon in the currently unselected
  /// [BottomNavigationBarItem.icon]s.
  ///
  /// If this is not provided, the size will default to [iconSize], the color
  /// will default to [unselectedItemColor].
  ///
  /// It this field is provided, it must contain non-null [IconThemeData.size]
  /// and [IconThemeData.color] properties. Also, if this field is supplied,
  /// [selectedIconTheme] must be provided.
  final IconThemeData? unselectedIconTheme;

  /// The [TextStyle] of the [BottomNavigationBarItem] labels when they are
  /// selected.
  final TextStyle? selectedLabelStyle;

  /// The [TextStyle] of the [BottomNavigationBarItem] labels when they are not
  /// selected.
  final TextStyle? unselectedLabelStyle;

  /// The font size of the [BottomNavigationBarItem] labels when they are selected.
  ///
  /// If [TextStyle.fontSize] of [selectedLabelStyle] is non-null, it will be
  /// used instead of this.
  ///
  /// Defaults to `14.0`.
  final double selectedFontSize;

  /// The font size of the [BottomNavigationBarItem] labels when they are not
  /// selected.
  ///
  /// If [TextStyle.fontSize] of [unselectedLabelStyle] is non-null, it will be
  /// used instead of this.
  ///
  /// Defaults to `12.0`.
  final double unselectedFontSize;

  /// Whether the labels are shown for the unselected [BottomNavigationBarItem]s.
  final bool? showUnselectedLabels;

  /// Whether the labels are shown for the selected [BottomNavigationBarItem].
  final bool? showSelectedLabels;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// items.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///
  /// If null, then the value of [BottomNavigationBarThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// The arrangement of the bar's [items] when the enclosing
  /// [MediaQueryData.orientation] is [Orientation.landscape].
  ///
  /// The following alternatives are supported:
  ///
  /// * [BottomNavigationBarLandscapeLayout.spread] - the items are
  ///   evenly spaced and spread out across the available width. Each
  ///   item's label and icon are arranged in a column.
  /// * [BottomNavigationBarLandscapeLayout.centered] - the items are
  ///   evenly spaced in a row but only consume as much width as they
  ///   would in portrait orientation. The row of items is centered within
  ///   the available width. Each item's label and icon are arranged
  ///   in a column.
  /// * [BottomNavigationBarLandscapeLayout.linear] - the items are
  ///   evenly spaced and each item's icon and label are lined up in a
  ///   row instead of a column.
  ///
  /// If this property is null, then the value of the enclosing
  /// [BottomNavigationBarThemeData.landscapeLayout is used. If that
  /// property is also null, then
  /// [BottomNavigationBarLandscapeLayout.spread] is used.
  ///
  /// This property is null by default.
  ///
  /// See also:
  ///
  ///  * [ThemeData.bottomNavigationBarTheme] - which can be used to specify
  ///    bottom navigation bar defaults for an entire application.
  ///  * [BottomNavigationBarTheme] - which can be used to specify
  ///    bottom navigation bar defaults for a widget subtree.
  ///  * [MediaQuery.of] - which can be used to determine the current
  ///    orientation.
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  /// This flag is controlling how [BottomNavigationBarCustom] is going to use
  /// the colors provided by the [selectedIconTheme], [unselectedIconTheme],
  /// [selectedItemColor], [unselectedItemColor].
  /// The default value is `true` as the new theming logic is a breaking change.
  /// To opt-in the new theming logic set the flag to `false`
  final bool useLegacyColorScheme;

  @override
  State<BottomNavigationBarCustom> createState() =>
      BottomNavigationBarCustomState();
}

// This represents a single tile in the bottom navigation bar. It is intended
// to go into a flex container.
class _BottomNavigationTile extends StatelessWidget {
  const _BottomNavigationTile(
    this.type,
    this.item,
    this.animation,
    this.iconSize, {
    this.onTap,
    this.labelColorTween,
    this.iconColorTween,
    this.flex,
    this.selected = false,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.selectedIconTheme,
    required this.unselectedIconTheme,
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
    this.indexLabel,
    required this.mouseCursor,
    required this.enableFeedback,
    required this.layout,
  });

  final BottomNavigationBarTypeCustom type;
  final BottomNavigationBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback? onTap;
  final ColorTween? labelColorTween;
  final ColorTween? iconColorTween;
  final double? flex;
  final bool selected;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final String? indexLabel;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final MouseCursor mouseCursor;
  final bool enableFeedback;
  final BottomNavigationBarLandscapeLayout layout;

  @override
  Widget build(BuildContext context) {
    // In order to use the flex container to grow the tile during animation, we
    // need to divide the changes in flex allotment into smaller pieces to
    // produce smooth animation. We do this by multiplying the flex value
    // (which is an integer) by a large number.
    final int size;

    final double selectedFontSize = selectedLabelStyle.fontSize!;

    final double selectedIconSize = selectedIconTheme?.size ?? iconSize;
    final double unselectedIconSize = unselectedIconTheme?.size ?? iconSize;

    // The amount that the selected icon is bigger than the unselected icons,
    // (or zero if the selected icon is not bigger than the unselected icons).
    final double selectedIconDiff =
        math.max(selectedIconSize - unselectedIconSize, 0);
    // The amount that the unselected icons are bigger than the selected icon,
    // (or zero if the unselected icons are not any bigger than the selected icon).
    final double unselectedIconDiff =
        math.max(unselectedIconSize - selectedIconSize, 0);

    // The effective tool tip message to be shown on the BottomNavigationBarItem.
    final String? effectiveTooltip = item.tooltip == '' ? null : item.tooltip;

    // Defines the padding for the animating icons + labels.
    //
    // The animations go from "Unselected":
    // =======
    // |      <-- Padding equal to the text height + 1/2 selectedIconDiff.
    // |  ☆
    // | text <-- Invisible text + padding equal to 1/2 selectedIconDiff.
    // =======
    //
    // To "Selected":
    //
    // =======
    // |      <-- Padding equal to 1/2 text height + 1/2 unselectedIconDiff.
    // |  ☆
    // | text
    // |      <-- Padding equal to 1/2 text height + 1/2 unselectedIconDiff.
    // =======
    double bottomPadding;
    double topPadding;
    if (showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else if (!showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else {
      bottomPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    }

    switch (type) {
      case BottomNavigationBarTypeCustom.fixed:
        size = 1;
        break;
      case BottomNavigationBarTypeCustom.shifting:
        size = (flex! * 1000.0).round();
    }

    Widget result = InkResponse(
      onTap: onTap,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding - 4),
        child: _Tile(
          selected: selected,
          layout: layout,
          icon: _TileIcon(
            colorTween: iconColorTween!,
            animation: animation,
            iconSize: iconSize,
            selected: selected,
            item: item,
            selectedIconTheme: selectedIconTheme,
            unselectedIconTheme: unselectedIconTheme,
          ),
          label: _Label(
            colorTween: labelColorTween!,
            animation: animation,
            item: item,
            selectedLabelStyle: selectedLabelStyle,
            unselectedLabelStyle: unselectedLabelStyle,
            showSelectedLabels: showSelectedLabels,
            showUnselectedLabels: showUnselectedLabels,
          ),
        ),
      ),
    );

    if (effectiveTooltip != null) {
      result = Tooltip(
        message: effectiveTooltip,
        preferBelow: false,
        verticalOffset: selectedIconSize + selectedFontSize,
        excludeFromSemantics: true,
        child: result,
      );
    }

    result = Semantics(
      selected: selected,
      container: true,
      child: Stack(
        children: <Widget>[
          result,
          Semantics(
            label: indexLabel,
          ),
        ],
      ),
    );

    return Expanded(
      flex: size,
      child: result,
    );
  }
}

// If the orientation is landscape and layout is
// BottomNavigationBarLandscapeLayout.linear then return a
// icon-space-label row, where space is 8 pixels. Otherwise return a
// icon-label column.
class _Tile extends StatelessWidget {
  const _Tile(
      {required this.layout,
      required this.icon,
      required this.label,
      required this.selected});

  final BottomNavigationBarLandscapeLayout layout;
  final Widget icon;
  final Widget label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.orientationOf(context) == Orientation.landscape &&
        layout == BottomNavigationBarLandscapeLayout.linear) {
      return Align(
        heightFactor: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[icon, const SizedBox(width: 8), label],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: selected ? 1 : 14,
        ),
        icon,
        SizedBox(
          height: selected ? 8 : 0,
        ),
        label,
        SizedBox(
          height: selected ?0: 1,
        ),
      ],
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    required this.colorTween,
    required this.animation,
    required this.iconSize,
    required this.selected,
    required this.item,
    required this.selectedIconTheme,
    required this.unselectedIconTheme,
  });

  final ColorTween colorTween;
  final Animation<double> animation;
  final double iconSize;
  final bool selected;
  final BottomNavigationBarItem item;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = colorTween.evaluate(animation);
    final IconThemeData defaultIconTheme = IconThemeData(
      color: iconColor,
      size: iconSize,
    );
    final IconThemeData iconThemeData = IconThemeData.lerp(
      defaultIconTheme.merge(unselectedIconTheme),
      defaultIconTheme.merge(selectedIconTheme),
      animation.value,
    );

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: IconTheme(
        data: iconThemeData,
        child: selected ? item.activeIcon : item.icon,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.colorTween,
    required this.animation,
    required this.item,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
  });

  final ColorTween colorTween;
  final Animation<double> animation;
  final BottomNavigationBarItem item;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  @override
  Widget build(BuildContext context) {
    final double? selectedFontSize = selectedLabelStyle.fontSize;
    final double? unselectedFontSize = unselectedLabelStyle.fontSize;

    final TextStyle customStyle = TextStyle.lerp(
      unselectedLabelStyle,
      selectedLabelStyle,
      animation.value,
    )!;
    Widget text = DefaultTextStyle.merge(
      style: customStyle.copyWith(
        fontSize: selectedFontSize,
        color: colorTween.evaluate(animation),
      ),
      // The font size should grow here when active, but because of the way
      // font rendering works, it doesn't grow smoothly if we just animate
      // the font size, so we use a transform instead.
      child: Transform(
        transform: Matrix4.diagonal3(
          Vector3.all(
            Tween<double>(
              begin: unselectedFontSize! / selectedFontSize!,
              end: 1.0,
            ).evaluate(animation),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Text(item.label!),
      ),
    );

    if (!showUnselectedLabels && !showSelectedLabels) {
      // Never show any labels.
      text = Visibility.maintain(
        visible: false,
        child: text,
      );
    } else if (!showUnselectedLabels) {
      // Fade selected labels in.
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: animation,
        child: text,
      );
    } else if (!showSelectedLabels) {
      // Fade selected labels out.
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
        child: text,
      );
    }

    text = Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: Container(child: text),
    );

    if (item.label != null) {
      // Do not grow text in bottom navigation bar when we can show a tooltip
      // instead.
      final MediaQueryData mediaQueryData = MediaQuery.of(context);
      text = MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: math.min(1.0, mediaQueryData.textScaleFactor),
        ),
        child: text,
      );
    }

    return text;
  }
}

class BottomNavigationBarCustomState extends State<BottomNavigationBarCustom>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = <AnimationController>[];
  late List<CurvedAnimation> _animations;

  // A queue of color splashes currently being animated.
  final Queue<_Circle> _circles = Queue<_Circle>();

  // Last splash circle's color, and the final color of the control after
  // animation is complete.
  Color? _backgroundColor;
  late Tween<double> _positionTween;
  late Animation<double> _positionAnimation;
  late AnimationController _animationController;
  void changeAnimation(int currentIndex){
    print("changeAnimation ${widget.currentIndex} ${_positionAnimation.value}");
    _initAnimationAndStart(_positionAnimation.value,
        App.isRTL() ? getPosition(currentIndex) * -1 : getPosition(currentIndex));
  }
  static final Animatable<double> _flexTween =
      Tween<double>(begin: 1.0, end: 1.5);

  double getPosition(int i) {
    double pace = 2 / (widget.items.length - 1);
    double vv = (pace * i) - 1;
    return vv;
  }

  get position {
    double pace = 2 / (widget.items.length - 1);
    double vv = (pace * widget.currentIndex) - 1;
    return vv;
  }

  void _resetState() {
    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    for (final _Circle circle in _circles) {
      circle.dispose();
    }
    _circles.clear();

    _controllers =
        List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations =
        List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  // Computes the default value for the [type] parameter.
  //
  // If type is provided, it is returned. Next, if the bottom navigation bar
  // theme provides a type, it is used. Finally, the default behavior will be
  // [BottomNavigationBarType.fixed] for 3 or fewer items, and
  // [BottomNavigationBarType.shifting] is used for 4+ items.
  BottomNavigationBarTypeCustom get _effectiveType {
    return widget.type ??
        (widget.items.length <= 3
            ? BottomNavigationBarTypeCustom.fixed
            : BottomNavigationBarTypeCustom.shifting);
  }

  // Computes the default value for the [showUnselected] parameter.
  //
  // Unselected labels are shown by default for [BottomNavigationBarType.fixed],
  // and hidden by default for [BottomNavigationBarType.shifting].
  bool get _defaultShowUnselected {
    switch (_effectiveType) {
      case BottomNavigationBarTypeCustom.shifting:
        return false;
      case BottomNavigationBarTypeCustom.fixed:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    double p = App.isRTL() ? position * -1 : position;

    _positionTween = Tween<double>(begin: p, end: 1);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _positionAnimation = _positionTween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });
    _resetState();
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animated.
    });
  }

  @override
  void dispose() {
    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    for (final _Circle circle in _circles) {
      circle.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  double _evaluateFlex(Animation<double> animation) =>
      _flexTween.evaluate(animation);

  void _pushCircle(int index) {
    if (widget.items[index].backgroundColor != null) {
      _circles.add(
        _Circle(
          state: this,
          index: index,
          color: widget.items[index].backgroundColor!,
          vsync: this,
        )..controller.addStatusListener(
            (AnimationStatus status) {
              switch (status) {
                case AnimationStatus.completed:
                  setState(() {
                    final _Circle circle = _circles.removeFirst();
                    _backgroundColor = circle.color;
                    circle.dispose();
                  });
                  break;
                case AnimationStatus.dismissed:
                case AnimationStatus.forward:
                case AnimationStatus.reverse:
                  break;
              }
            },
          ),
      );
    }
  }

  @override
  void didUpdateWidget(BottomNavigationBarCustom oldWidget) {
    super.didUpdateWidget(oldWidget);

    // No animated segue if the length of the items list changes.
    if (widget.items.length != oldWidget.items.length) {
      _resetState();
      return;
    }

    if (widget.currentIndex != oldWidget.currentIndex) {
      switch (_effectiveType) {
        case BottomNavigationBarTypeCustom.fixed:
          break;
        case BottomNavigationBarTypeCustom.shifting:
          _pushCircle(widget.currentIndex);
      }
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    } else {
      if (_backgroundColor !=
          widget.items[widget.currentIndex].backgroundColor) {
        _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
      }
    }
  }

  // If the given [TextStyle] has a non-null `fontSize`, it should be used.
  // Otherwise, the [selectedFontSize] parameter should be used.
  static TextStyle _effectiveTextStyle(TextStyle? textStyle, double fontSize) {
    textStyle ??= const TextStyle();
    // Prefer the font size on textStyle if present.
    return textStyle.fontSize == null
        ? textStyle.copyWith(fontSize: fontSize)
        : textStyle;
  }

  // If [IconThemeData] is provided, it should be used.
  // Otherwise, the [IconThemeData]'s color should be selectedItemColor
  // or unselectedItemColor.
  static IconThemeData _effectiveIconTheme(
      IconThemeData? iconTheme, Color? itemColor) {
    // Prefer the iconTheme over itemColor if present.
    return iconTheme ?? IconThemeData(color: itemColor);
  }


  List<Widget> _createTiles(BottomNavigationBarLandscapeLayout layout) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final ThemeData themeData = Theme.of(context);
    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);

    final Color themeColor;
    switch (themeData.brightness) {
      case Brightness.light:
        themeColor = themeData.colorScheme.primary;
        break;
      case Brightness.dark:
        themeColor = themeData.colorScheme.secondary;
    }

    final TextStyle effectiveSelectedLabelStyle = _effectiveTextStyle(
      widget.selectedLabelStyle ?? bottomTheme.selectedLabelStyle,
      widget.selectedFontSize,
    );

    final TextStyle effectiveUnselectedLabelStyle = _effectiveTextStyle(
      widget.unselectedLabelStyle ?? bottomTheme.unselectedLabelStyle,
      widget.unselectedFontSize,
    );

    final IconThemeData effectiveSelectedIconTheme = _effectiveIconTheme(
        widget.selectedIconTheme ?? bottomTheme.selectedIconTheme,
        widget.selectedItemColor ??
            bottomTheme.selectedItemColor ??
            themeColor);

    final IconThemeData effectiveUnselectedIconTheme = _effectiveIconTheme(
        widget.unselectedIconTheme ?? bottomTheme.unselectedIconTheme,
        widget.unselectedItemColor ??
            bottomTheme.unselectedItemColor ??
            themeData.unselectedWidgetColor);

    final ColorTween colorTween;
    switch (_effectiveType) {
      case BottomNavigationBarTypeCustom.fixed:
        colorTween = ColorTween(
          begin: widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.unselectedWidgetColor,
          end: widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              widget.fixedColor ??
              themeColor,
        );
        break;
      case BottomNavigationBarTypeCustom.shifting:
        colorTween = ColorTween(
          begin: widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.colorScheme.surface,
          end: widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              themeData.colorScheme.surface,
        );
    }

    final ColorTween labelColorTween;
    switch (_effectiveType) {
      case BottomNavigationBarTypeCustom.fixed:
        labelColorTween = ColorTween(
          begin: effectiveUnselectedLabelStyle.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.unselectedWidgetColor,
          end: effectiveSelectedLabelStyle.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              widget.fixedColor ??
              themeColor,
        );
        break;
      case BottomNavigationBarTypeCustom.shifting:
        labelColorTween = ColorTween(
          begin: effectiveUnselectedLabelStyle.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.colorScheme.surface,
          end: effectiveSelectedLabelStyle.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              themeColor,
        );
    }

    final ColorTween iconColorTween;
    switch (_effectiveType) {
      case BottomNavigationBarTypeCustom.fixed:
        iconColorTween = ColorTween(
          begin: effectiveSelectedIconTheme.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.unselectedWidgetColor,
          end: effectiveUnselectedIconTheme.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              widget.fixedColor ??
              themeColor,
        );
        break;
      case BottomNavigationBarTypeCustom.shifting:
        iconColorTween = ColorTween(
          begin: effectiveUnselectedIconTheme.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.colorScheme.surface,
          end: effectiveSelectedIconTheme.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              themeColor,
        );
    }

    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < widget.items.length; i++) {
      final Set<MaterialState> states = <MaterialState>{
        if (i == widget.currentIndex) MaterialState.selected,
      };

      final MouseCursor effectiveMouseCursor =
          MaterialStateProperty.resolveAs<MouseCursor?>(
                  widget.mouseCursor, states) ??
              bottomTheme.mouseCursor?.resolve(states) ??
              MaterialStateMouseCursor.clickable.resolve(states);

      tiles.add(_BottomNavigationTile(
        _effectiveType,
        widget.items[i],
        _animations[i],
        widget.iconSize,
        selectedIconTheme: widget.useLegacyColorScheme
            ? widget.selectedIconTheme ?? bottomTheme.selectedIconTheme
            : effectiveSelectedIconTheme,
        unselectedIconTheme: widget.useLegacyColorScheme
            ? widget.unselectedIconTheme ?? bottomTheme.unselectedIconTheme
            : effectiveUnselectedIconTheme,
        selectedLabelStyle: effectiveSelectedLabelStyle,
        unselectedLabelStyle: effectiveUnselectedLabelStyle,
        enableFeedback:
            widget.enableFeedback ?? bottomTheme.enableFeedback ?? true,
        onTap: () async {

          _initAnimationAndStart(_positionAnimation.value,
              App.isRTL() ? getPosition(i) * -1 : getPosition(i));
          widget.onTap?.call(i);

        },
        labelColorTween:
            widget.useLegacyColorScheme ? colorTween : labelColorTween,
        iconColorTween:
            widget.useLegacyColorScheme ? colorTween : iconColorTween,
        flex: _evaluateFlex(_animations[i]),
        selected: i == widget.currentIndex,
        showSelectedLabels:
            widget.showSelectedLabels ?? bottomTheme.showSelectedLabels ?? true,
        showUnselectedLabels: widget.showUnselectedLabels ??
            bottomTheme.showUnselectedLabels ??
            _defaultShowUnselected,
        indexLabel: localizations.tabLabel(
            tabIndex: i + 1, tabCount: widget.items.length),
        mouseCursor: effectiveMouseCursor,
        layout: layout,
      ));
    }
    return tiles;
  }


  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasOverlay(context));

    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);
    final BottomNavigationBarLandscapeLayout layout =
        widget.landscapeLayout ?? BottomNavigationBarLandscapeLayout.spread;
    final double additionalBottomPadding =
        MediaQuery.viewPaddingOf(context).bottom;

    Color? backgroundColor;
    switch (_effectiveType) {
      case BottomNavigationBarTypeCustom.fixed:
        backgroundColor = widget.backgroundColor ?? bottomTheme.backgroundColor;
        break;
      case BottomNavigationBarTypeCustom.shifting:
        backgroundColor = _backgroundColor;
    }

    int tabAmount = widget.items.length;

    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        IgnorePointer(
          child: Align(
            heightFactor: Platform.isAndroid?6.6:10,
            alignment: Alignment(_positionAnimation.value, 0),
            child: FractionallySizedBox(
              widthFactor: 1 / tabAmount,
              child: Container(
                height: 20,
                child: CustomPaint(
                  painter: _CurvedAppBarPainter(isShadow: true),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: kBottomNavigationBarHeight + additionalBottomPadding,
          decoration: BoxDecoration(color: widget.backgroundColor, boxShadow: [
            BoxShadow(
              color: ColorsUi.primary.withOpacity(0.2),
              blurRadius: 5,
            )
          ]),
        ),
        IgnorePointer(
          child: Align(
            heightFactor: Platform.isAndroid?6.6:10,
            alignment: Alignment(_positionAnimation.value, 0),
            child: FractionallySizedBox(
              widthFactor: 1 / tabAmount,
              child: Container(
                height: 20,
                child: CustomPaint(
                  painter: _CurvedAppBarPainter(),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Align(
            heightFactor: Platform.isAndroid?2.2:3.7,
            alignment: Alignment(_positionAnimation.value, 0),
            child: FractionallySizedBox(
              widthFactor: 1 / tabAmount,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, gradient: ColorsUi.gradientLogo),
              ),
            ),
          ),
        ),
        Semantics(
          explicitChildNodes: true,
          child: _Bar(
            layout: layout,
            elevation: 0, // widget.elevation ?? bottomTheme.elevation ?? 8.0,
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight:
                      kBottomNavigationBarHeight + additionalBottomPadding),
              child: CustomPaint(
                painter: _RadialPainter(
                  circles: _circles.toList(),
                  textDirection: Directionality.of(context),
                ),
                child: Material(
                  // Splashes.
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: additionalBottomPadding),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      child: DefaultTextStyle.merge(
                        overflow: TextOverflow.ellipsis,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _createTiles(layout),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return Stack(
        fit: StackFit.loose,
        alignment: Alignment.topCenter,
        children: [
          CustomPaint(
            painter: NavCustomPainter(
              startingLoc: (widget.currentIndex / widget.items.length),
              itemsLength: widget.items.length,
              color: Colors.white,
              textDirection: Directionality.of(context),
              hasLabel: true,
            ),
            child: Container(
                height:
                    kBottomNavigationBarHeight + additionalBottomPadding + 13),
          ),
          Semantics(
            explicitChildNodes: true,
            child: _Bar(
              layout: layout,
              elevation: 0, // widget.elevation ?? bottomTheme.elevation ?? 8.0,
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight:
                        kBottomNavigationBarHeight + additionalBottomPadding),
                child: CustomPaint(
                  painter: _RadialPainter(
                    circles: _circles.toList(),
                    textDirection: Directionality.of(context),
                  ),
                  child: Material(
                    // Splashes.
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: additionalBottomPadding),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        child: DefaultTextStyle.merge(
                          overflow: TextOverflow.ellipsis,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _createTiles(layout),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]);
  }

  Future<void> _initAnimationAndStart(double from, double to)async {
    _positionTween.begin = from;
    _positionTween.end = to;

    _animationController.reset();
    _animationController.forward();
  }
}

class _CurvedAppBarPainter extends CustomPainter {
  bool isShadow;

  _CurvedAppBarPainter({this.isShadow = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double x = size.width;
    double y = size.height;
    double r = 0.5;
    Path path = Path()
      ..moveTo(x, y)
      ..relativeQuadraticBezierTo(
          ((-x / 2) + (x / 6)) * (1 - r), 0, -x / 2 * r, -y * r)
      ..relativeQuadraticBezierTo(
          -x / 6 * r, -y * (1 - r), -x / 2 * (1 - r), -y * (1 - r))
      ..relativeQuadraticBezierTo(
          ((-x / 2) + (x / 6)) * (1 - r), 0, -x / 2 * (1 - r), y * (1 - r))
      ..relativeQuadraticBezierTo(-x / 6 * r, y * r, -x / 2 * r, y * r);

    final shadowPaint = Paint()
      ..color =ColorsUi.primary.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

    if (isShadow) canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurvedAppBarPainter oldDelegate) => false;
}

class NavCustomPainter extends CustomPainter {
  double s = 0.13;

  late double loc;
  late double bottom;
  Color color;
  bool hasLabel;
  TextDirection textDirection;

  NavCustomPainter({
    required double startingLoc,
    required int itemsLength,
    required this.color,
    required this.textDirection,
    this.hasLabel = false,
  }) {
    final span = 1.0 / (itemsLength);
    double l = startingLoc + (span - 0.27) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    // loc+=0.070;
    bottom = hasLabel
        ? (Platform.isAndroid ? 0.25 : 0.15)
        : (Platform.isAndroid ? 0.6 : 0.5);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ColorsUi.white;
    //..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * (loc - 0.10), 0)
      ..cubicTo(
        size.width * (loc + s * 0.2), // topX
        -size.height * 0.02, // topY
        size.width * loc, // bottomX
        -size.height * bottom, // bottomY
        size.width * (loc + s * 0.5), // centerX
        -size.height * bottom, // centerY
      )
      ..cubicTo(
        size.width * (loc + s), // bottomX
        -size.height * bottom, // bottomY
        size.width * (loc + s * 0.8), // topX
        -size.height * 0.02, // topY
        size.width * (loc + s + 0.10),
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawShadow(path, ColorsUi.greyF7, 1, false);

    final shadowPaint = Paint()
      ..color = ColorsUi.greyDark
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        1,
      );

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}

// Optionally center a Material child for landscape layouts when layout is
// BottomNavigationBarLandscapeLayout.centered
class _Bar extends StatelessWidget {
  const _Bar({
    required this.child,
    required this.layout,
    required this.elevation,
    required this.color,
  });

  final Widget child;
  final BottomNavigationBarLandscapeLayout layout;
  final double elevation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget alignedChild = child;
    if (MediaQuery.orientationOf(context) == Orientation.landscape &&
        layout == BottomNavigationBarLandscapeLayout.centered) {
      alignedChild = Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).height,
          child: child,
        ),
      );
    }
    return Material(
      elevation: elevation,
      color: color,
      child: alignedChild,
    );
  }
}

// Describes an animating color splash circle.
class _Circle {
  _Circle({
    required this.state,
    required this.index,
    required this.color,
    required TickerProvider vsync,
  }) {
    controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: vsync,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    controller.forward();
  }

  final BottomNavigationBarCustomState state;
  final int index;
  final Color color;
  late AnimationController controller;
  late CurvedAnimation animation;

  double get horizontalLeadingOffset {
    double weightSum(Iterable<Animation<double>> animations) {
      // We're adding flex values instead of animation values to produce correct
      // ratios.
      return animations
          .map<double>(state._evaluateFlex)
          .fold<double>(0.0, (double sum, double value) => sum + value);
    }

    final double allWeights = weightSum(state._animations);
    // These weights sum to the start edge of the indexed item.
    final double leadingWeights =
        weightSum(state._animations.sublist(0, index));

    // Add half of its flex value in order to get to the center.
    return (leadingWeights +
            state._evaluateFlex(state._animations[index]) / 2.0) /
        allWeights;
  }

  void dispose() {
    controller.dispose();
  }
}

class HalfPainter extends CustomPainter {
  final Color color;

  HalfPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    // final Rect largeRect = Rect.fromLTWH(10, 0, size.width - 20, 70);
    // final Rect afterRect = Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);

    // final path = Path();

    // path.arcTo(beforeRect, vector.radians(0), vector.radians(90), false);
    // path.lineTo(20, size.height / 2);
    // path.arcTo(largeRect, vector.radians(0), -vector.radians(180), false);
    // path.moveTo(size.width - 10, size.height / 2);
    // path.lineTo(size.width - 10, (size.height / 2) - 10);
    // path.arcTo(afterRect, vector.radians(180), vector.radians(-90), false);

    final double curveSize = 10;
    final double xStartingPos = 0;
    final double yStartingPos = (size.height / 2);
    final double yMaxPos = yStartingPos - curveSize;

    final path = Path();

    //ar
    path.moveTo(xStartingPos, yStartingPos);
    path.lineTo(size.width, yStartingPos);
    path.quadraticBezierTo(size.width - (curveSize), yStartingPos,
        size.width - (curveSize + 5), yMaxPos);
    path.lineTo(xStartingPos + (curveSize + 5), yMaxPos);
    path.quadraticBezierTo(
        xStartingPos + (curveSize), yStartingPos, xStartingPos, yStartingPos);

    /* en
    path.moveTo(xStartingPos, yStartingPos);
    path.lineTo(size.width - xStartingPos, yStartingPos);
    path.quadraticBezierTo(size.width - (curveSize), yStartingPos, size.width - (curveSize + 5), yMaxPos);
    path.lineTo(xStartingPos + (curveSize + 5), yMaxPos);
    path.quadraticBezierTo(xStartingPos + (curveSize), yStartingPos, xStartingPos, yStartingPos);
*/
    path.close();

    canvas.drawPath(path, Paint()..color = color ?? Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Paints the animating color splash circles.
class _RadialPainter extends CustomPainter {
  _RadialPainter({
    required this.circles,
    required this.textDirection,
  });

  final List<_Circle> circles;
  final TextDirection textDirection;

  // Computes the maximum radius attainable such that at least one of the
  // bounding rectangle's corners touches the edge of the circle. Drawing a
  // circle larger than this radius is not needed, since there is no perceivable
  // difference within the cropped rectangle.
  static double _maxRadius(Offset center, Size size) {
    final double maxX = math.max(center.dx, size.width - center.dx);
    final double maxY = math.max(center.dy, size.height - center.dy);
    return math.sqrt(maxX * maxX + maxY * maxY);
  }

  @override
  bool shouldRepaint(_RadialPainter oldPainter) {
    if (textDirection != oldPainter.textDirection) {
      return true;
    }
    if (circles == oldPainter.circles) {
      return false;
    }
    if (circles.length != oldPainter.circles.length) {
      return true;
    }
    for (int i = 0; i < circles.length; i += 1) {
      if (circles[i] != oldPainter.circles[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Circle circle in circles) {
      final Paint paint = Paint()..color = circle.color;
      final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      canvas.clipRect(rect);
      final double leftFraction;
      switch (textDirection) {
        case TextDirection.rtl:
          leftFraction = 1.0 - circle.horizontalLeadingOffset;
          break;
        case TextDirection.ltr:
          leftFraction = circle.horizontalLeadingOffset;
      }
      final Offset center =
          Offset(leftFraction * size.width, size.height / 2.0);
      final Tween<double> radiusTween = Tween<double>(
        begin: 0.0,
        end: _maxRadius(center, size),
      );
      canvas.drawCircle(
        center,
        radiusTween.transform(circle.animation.value),
        paint,
      );
    }
  }
}
