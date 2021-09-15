
import 'package:deliver_me/data/login/login_datasource.dart';
import 'package:deliver_me/data/set_destination/set_destination_datasource_imp.dart';
import 'package:get/get.dart';
import 'package:login/data/login_datasource.dart';
import 'package:login/login.dart';
import 'package:set_destination/business_logic/data/set_destination_datasource.dart';
import 'package:set_destination/business_logic/set_destination_controller.dart';

inject(){
  Get.put<LoginDataSource>(LoginDataSourceImp());
  Get.put<SetDestinationDataSource>(SetDestinationDataSourceImp());
  Get.put(LoginController(Get.find()));
  Get.put(SetDestinationController(Get.find()) , permanent: true);
}