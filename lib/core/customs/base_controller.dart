import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nocommission_app/app/app.dart';
import 'package:nocommission_app/core/utils/helpers.dart';
import 'package:nocommission_app/core/utils/user_preference.dart';
import 'package:nocommission_app/core/web_services/BaseResponse.dart';
import 'package:nocommission_app/core/web_services/BaseResponseList.dart';
import 'package:nocommission_app/core/web_services/apis.dart';
import 'package:nocommission_app/features/authentication/UI/upgrade_screen.dart';
import 'package:nocommission_app/features/packages/UI/packages_screen.dart';
import 'package:nocommission_app/models/area.dart';
import 'package:nocommission_app/models/estate.dart';
import 'package:nocommission_app/models/place.dart';
import 'package:nocommission_app/models/responses/countries_response.dart';
import 'package:nocommission_app/models/responses/estates_settings.dart';
import 'package:nocommission_app/models/responses/fitch_data_response.dart';
import 'package:nocommission_app/models/responses/providers_settings.dart';
import 'package:nocommission_app/widgets/statuses/end_packages_widgets.dart';
import 'package:nocommission_app/widgets/statuses/upgrade_packages_widgets.dart';

class BaseControllerGetx extends GetxController with Helpers, GenericFunctions {}

class BaseController with Helpers, GenericFunctions {}

mixin GenericFunctions on Helpers {

  FitchDataResponse? userFitch;
  Future<EstatesSetting?> getEstatesSetting() async {
    try {
      //showLoading();
      BaseResponse<EstatesSetting>? response = await Apis().getEstatesSetting();
      //dismissLoading();
      if (response != null) {
        if (response.status ?? false) {
          //showMessage(response.message ?? "", error: false);
        } else {
          //showMessage(response.message ?? '');
        }
       return response.data!;

      } else {
        showMessage('Response Error', error: true);
        return null;
      }
    } catch (error) {
      dismissLoading();
      showMessage(error.toString(), error: true);
      return null;
    }
  }
  Future<BaseResponseList<Area>?> getCountries() async {
    BaseResponse<ResponseCountries>? response = await Apis().getCountries();
    BaseResponseList<Area>? responseList =
        response?.toBaseResponseList<Area>((data) => data?.countries ?? []);
    return responseList;
  }
  Future<BaseResponseList<Area>?> getCities(int? countryId) async {
    BaseResponseList<Area>? response = await Apis().getCities(countryId);
    return response;
  }
  Future<BaseResponseList<Area>?> getDistricts(Map<String, dynamic> ids) async {
    BaseResponseList<Area>? response = await Apis().getDistricts(ids);
    return response;
  }
  Future<BaseResponseList<Place>?> searchPlaces(String query) async {
    BaseResponseList<Place>? response = await Apis().searchPlaces({"q":query});
    return response;
  }
  Future<BaseResponseList<Area>?> getRegions(Map<String, dynamic> ids) async {
    BaseResponseList<Area>? response = await Apis().getRegions(ids);
    return response;
  }
  Future<BaseResponseList<Area>?> getStreets(Map<String, dynamic> ids) async {
    BaseResponseList<Area>? response = await Apis().getStreets(ids);
    return response;
  }
  Future<bool> addFavorite(String id) async {
    try {
      showLoading();
      BaseResponse<Estate>? response = await Apis().addFavorite(id);
      dismissLoading();
      if (response != null) {
        if (response.status??false) {
          showMessage(response.message ?? "", error: false);
          return response.status??false;
        } else {
          showMessage(response.message ?? '');
          return false;
        }
      } else {
        showMessage('Response Error', error: true);
        return false;
      }
    } catch (error) {
      dismissLoading();
      showMessage(error.toString(), error: true);
      return false;
    }
  }

  fitchData({bool? loading}) async {
    try {
      if(loading??true == true) showLoading();
      BaseResponse<FitchDataResponse>? response = await Apis().fitchData();
      if (response != null) {
        if (response.status!) {
          userFitch = response.data;
          dismissLoading();
        } else {
          dismissLoading();
          return response;
        }
      } else {
        dismissLoading();

      }
    } catch (error) {
      dismissLoading();
    }

  }

  checkToAdEstate ({Function()? onSuccess})async{
   if(UserPreferences().isLoggedIn)
     await fitchData();
    if(!UserPreferences().isLoggedIn){
      showDialogUnauthorized();
      print('isLoggedIn');
      return false;
    }
    else if(UserPreferences().getUser().isEstateOwner != true){
      AwesomeDialog(
        context: Get.key.currentContext!,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        desc: App.getString().account_promotion,
        btnOkText: App.getString().account_promotion,
        buttonsTextStyle: TextStyle(height: 1.h),
        btnOkOnPress: ()async {
          String res= await Get.to(UpgradeScreen());
          if(res=="upgraded")
            if(onSuccess!=null) {
              onSuccess();
            }
        },
      ).show();
      print('isEstateOwner');
      return false;
    }
    else if(userFitch?.remainingEstates == '0' || userFitch?.remainingEstates == null){
      Get.to(UpgradePackageWidgets(onPressed: (){
        Get.to(PackagesScreen());
      },));
      print('remainingEstates =0');
      return false;
    }
    else if(userFitch?.isPackageEx == true){
      Get.to(EndPackageWidgets(onPressed: (){
        Get.to(PackagesScreen());
      },));
      print('isPackageEx');
      return false;
    }
    else {
      print('onSuccess');
      if(onSuccess!=null)onSuccess();

    }
  }






}

class BaseFilterGetx extends BaseControllerGetx{
  EstatesSetting? estatesSetting ;
  ProvidersSetting? providersSetting;

  @override
  void onInit() {
    if(estatesSetting==null) {
      getEstatesSetting().then((value) {estatesSetting=value;update();});
      print("onInit getEstatesSetting EstatesController");
    }
    if(providersSetting==null) {
      getServiceProvidersSetting().then((value) {providersSetting=value;update();});
    }
    super.onInit();
  }
  Future<ProvidersSetting?> getServiceProvidersSetting() async {
    try {
      BaseResponse<ProvidersSetting>? response =
      await Apis().getProvidersSettingSetting();
      if (response != null) {
        if (response.status ?? false) {
          return response.data!;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

}
