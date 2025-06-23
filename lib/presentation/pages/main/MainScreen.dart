import 'dart:async';

import 'package:aid_registry_flutter_app/core/utils/helpers.dart';
import 'package:aid_registry_flutter_app/core/utils/user_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aid_registry_flutter_app/core/customs/custom_button.dart';
import 'package:aid_registry_flutter_app/presentation/shared/widgets/lists/list_general.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app.dart';
import '../../../core/constant/imagepath.dart';
import '../../../core/constant/share_pref.dart';
import '../../../core/customs/custom_text.dart';
import '../../../core/models/identifiable.dart';
import '../../../core/theme/color.dart';
import '../../../core/theme/founts.dart';
import '../../../core/utils/dialog_service.dart';
import '../../../core/web_services/BaseResponse.dart';
import '../../../core/web_services/apis.dart';
import '../../shared/widgets/lists/list_notifier.dart';
import '../login/login_screen.dart';
import '../projects/local_projects/local_projects_screen.dart';
import '../projects/project_tabs_screen.dart';
import '../received_aid/screens/received_aid_page.dart';
import 'main_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with Helpers, DialogService {
  final GlobalKey _navigationBarKey = GlobalKey(debugLabel: 'navigation_bar_global_Key');

  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();

    ref.read(mainControllerProvider.notifier).registerAnimationCallback(
          (index) {
            final navBarState = _navigationBarKey.currentState as dynamic;
            navBarState.changeAnimation(index);
      },
    );
    _syncTimer =Timer.periodic(Duration(minutes: 2), (timer) {
       ref.read(mainControllerProvider.notifier).syncNow();

      // await fetchAndSyncData();
    });
  }

  Widget _buildCircularItem(IconData iconData, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Icon(iconData, color: isSelected ? ColorsUi.primary : null),
    );
  }

  void test() {
    // listController.addItem(item)
  }
  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final controller = ref.watch(mainControllerProvider);
    final notifier = ref.read(mainControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PhysicalModel(
              elevation: 4,
              shape: BoxShape.circle,
              color: Colors.transparent,
              child: CircleAvatar(child: SvgPicture.asset(ImagePath.logo)),
            ),
            SizedBox(width: 20.w),
            Column(
              children: [
                CustomText(
                  "مرحباً بك، ${UserPreferences().getUser().name}",
                  size: 16.sp,
                  fontFamily: Founts.medium,
                ),
                CustomText(
                  UserPreferences().getUser().email ?? "",
                  size: 16.sp,
                  fontFamily: Founts.normal,
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "logout") {
                DialogService.showMessageDialog(
                  title: App.getString().logout,
                  description: App.getString().do_you_want_to_logout,
                  btnOkOnPress: (n) async {
                    try {
                      showLoading();

                      BaseResponse? re = await Apis().logout();
                      if (re?.status ?? false) {
                        dismissLoading();
                        await UserPreferences().setObject(
                          ConstantsSherPref.userInfo,
                          {},
                        );
                        await UserPreferences().setValue(
                          ConstantsSherPref.password,
                          "",
                        );
                        await UserPreferences().setValue(
                          ConstantsSherPref.username,
                          "",
                        );
                        await UserPreferences().setValue(
                          ConstantsSherPref.token,
                          '',
                        );
                        await UserPreferences().setValue(
                          ConstantsSherPref.isLogged,
                          false,
                        );

                        push(context, screen: LoginScreen(), removeUntil: true);
                      } else {
                        showMessage(re?.message ?? "Error Server");
                      }
                    } catch (e) {
                      dismissLoading();
                      showMessage(e.toString() ?? "Error Server");
                    }
                  },
                );
              } else if (value == "about") {
                DialogService.showMessageDialog(
                  // btnOkText: "تواصل",
                  // btnOkOnPress: (n) {
                  //  openWhatsApp("970594899524");
                  // },
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CustomText(
                            "عن التطبيق",
                            color: Colors.black,
                            fontFamily: Founts.medium,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        CustomText(
                          App.getString().app_description,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.center,
                          height: 1.5,
                        ),
                        CustomText(
                          App.getString().features_title,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.center,
                          height: 1.5,
                        ),
                        CustomText(
                          App.getString().feature_1,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.start,
                          height: 1.5,
                          size: 10.sp,
                        ),
                        CustomText(
                          App.getString().feature_2,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.start,
                          height: 1.5,
                          size: 10.sp,
                        ),
                        CustomText(
                          App.getString().feature_3,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.start,
                          height: 1.5,
                          size: 10.sp,
                        ),
                        CustomText(
                          App.getString().feature_4,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.start,
                          height: 1.5,
                          size: 10.sp,
                        ),
                        CustomText(
                          App.getString().feature_5,
                          color: Colors.black,
                          fontFamily: Founts.normal,
                          align: TextAlign.start,
                          height: 1.5,
                          size: 10.sp,
                        ),
                        SizedBox(height: 30.h),
                        Center(
                          child: CustomText(
                            "لا تتردد بالتواصل مع قسم التطوير",
                            color: Colors.black,
                            fontFamily: Founts.normal,
                            align: TextAlign.center,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: "logout",
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: ColorsUi.primary),
                        const SizedBox(width: 8),
                        Text("تسجيل الخروج"),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "about",
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: ColorsUi.primary),
                        const SizedBox(width: 8),
                        Text("عن التطبيق"),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: _navigationBarKey,
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 25.r),
        unselectedIconTheme: IconThemeData(size: 20.r),
        iconSize: 25.r,
        selectedLabelStyle: TextStyle(fontFamily: Founts.medium, height: 0.8.h),
        unselectedLabelStyle: TextStyle(
          fontFamily: Founts.normal,
          color: ColorsUi.black,
          height: 0.8.h,
        ),
        selectedFontSize: 14.sp,
        unselectedFontSize: 13.sp,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 20,
        currentIndex: controller.selectedIndex,
        onTap: (index) {
          notifier.changeSelect(index);
        },
        selectedItemColor: ColorsUi.primary,
        unselectedItemColor: Colors.grey,
        items: List<BottomNavigationBarItem>.generate(controller.items.length, (
          index,
        ) {
          return BottomNavigationBarItem(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.items[index].image,
                  color:
                      controller.selectedIndex == index
                          ? ColorsUi.primary
                          : Colors.grey,
                  size: controller.selectedIndex == index ? 25.r : 20.r,
                ),
                SizedBox(width: 6),
                Text(
                  controller.items[index].name,
                  style: TextStyle(
                    color:
                        controller.selectedIndex == index
                            ? ColorsUi.primary
                            : Colors.grey,
                    fontSize: controller.selectedIndex == index ? 14.sp : 13.sp,
                    fontFamily:
                        controller.selectedIndex == index
                            ? Founts.medium
                            : Founts.normal,
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
      ),
      body: IndexedStack(
        index: controller.selectedIndex,
        children: List<Widget>.generate(controller.items.length, (index) {
          return controller.items[index].isInitialized
              ? controller.items[index].screen
              : SizedBox.shrink();
        }),
      ),
    );
  }
}
