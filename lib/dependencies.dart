
import 'package:deliver_me/data/login/login_datasource.dart';
import 'package:deliver_me/data/map/map_datasource.dart';
import 'package:deliver_me/data/set_destination/set_destination_datasource_imp.dart';
import 'package:deliver_me/data/splash/splash_datasource_imp.dart';
import 'package:deliver_me/data/user/user_provider.dart';
import 'package:deliver_me/data/user/user_provider_imp.dart';
import 'package:get/get.dart';
import 'package:login/data/login_datasource.dart';
import 'package:login/login.dart';
import 'package:map/business_logic/data/map_datasource.dart';
import 'package:map/business_logic/map_controller.dart';
import 'package:set_destination/business_logic/data/set_destination_datasource.dart';
import 'package:set_destination/business_logic/set_destination_controller.dart';
import 'package:splash/business_logic/controller.dart';
import 'package:splash/business_logic/splash_datasource.dart';

inject(){
  Get.put<UserProvider>(UserProviderImp());
  Get.put<LoginDataSource>(LoginDataSourceImp());
  Get.put<SetDestinationDataSource>(SetDestinationDataSourceImp());
  Get.put<MapDataSource>(MapDataSourceImp(Get.find()));
  Get.put<SplashDataSource>(SplashDataSourceImp(Get.find()));
  Get.put(LoginController(Get.find()));
  Get.put(SetDestinationController(Get.find()) , permanent: true);
  Get.put(MapController(Get.find()));
  Get.put(SplashController(Get.find()));
}