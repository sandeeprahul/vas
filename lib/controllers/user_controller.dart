import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserController extends GetxController {
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxString token = ''.obs;
  final RxString employeeId = ''.obs;
  final RxString userId = ''.obs;
  final RxString clientId = ''.obs;
  final RxString name = ''.obs;
  final RxString roleId = ''.obs;
  final RxString deptId = ''.obs;
  final RxString zoneId = ''.obs;
  final RxString loadGeneralSettings = ''.obs;
  final RxString accountId = ''.obs;
  final RxString timerLocationData = ''.obs;
  final RxString blockId = ''.obs;
  final RxString deviceRegnId = ''.obs;
  final RxString stopId = ''.obs;
  final RxString imeiNumber = ''.obs;
  final RxString vehicleId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// ✅ **Save User Data in SharedPreferences**
  Future<void> saveUserData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(data)); // Store as JSON

    userData.value = data;
    token.value = data['token'] ?? '';
    employeeId.value = data['employeeId'] ?? '';
    userId.value = data['employeeId'] ?? '';
    name.value = data['name'] ?? '';
    loadGeneralSettings.value = data['loadGeneralSettings'] ?? '';
    clientId.value = data['clientId'] ?? '';
    timerLocationData.value = data['timerLocationData'] ?? '';
    roleId.value = data['roleId'] ?? '';
    deptId.value = data['deptId'] ?? '';
    imeiNumber.value = data['imeiNumber'] ?? '';
    accountId.value = data['accountId'] ?? '';
    zoneId.value = data['zoneId'] ?? '';
    deviceRegnId.value = data['deviceRegnId'] ?? '';
    blockId.value = data['blockId'] ?? '';
    stopId.value = data['stopId'] ?? '';
    vehicleId.value = data['vehicleId'] ?? '';
  }

  /// ✅ **Load User Data from SharedPreferences**
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      Map<String, dynamic> data = jsonDecode(userDataString);
      userData.value = data;
      token.value = data['token'] ?? '';
      employeeId.value = data['employeeId'] ?? '';
      userId.value = data['employeeId'] ?? '';
      clientId.value = data['clientId'] ?? '';
      name.value = data['name'] ?? '';
      roleId.value = data['roleId'] ?? '';
      loadGeneralSettings.value = data['loadGeneralSettings'] ?? '';
      deptId.value = data['deptId'] ?? '';
      imeiNumber.value = data['imeiNumber'] ?? '';
      zoneId.value = data['zoneId'] ?? '';
      timerLocationData.value = data['timerLocationData'] ?? '';
      blockId.value = data['blockId'] ?? '';
      deviceRegnId.value = data['deviceRegnId'] ?? '';
      accountId.value = data['accountId'] ?? '';
      stopId.value = data['stopId'] ?? '';
      vehicleId.value = data['vehicleId'] ?? '';
    }
  }

  /// ✅ **Clear User Data (Logout)**
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');

    userData.clear();
    token.value = '';
    employeeId.value = '';
    userId.value = '';
    name.value = '';
    imeiNumber.value = '';
    roleId.value = '';
    clientId.value = '';
    deptId.value = '';
    timerLocationData.value = '';
    zoneId.value = '';
    loadGeneralSettings.value = '';
    blockId.value = '';
    deviceRegnId.value = '';
    stopId.value = '';
    accountId.value = '';
    vehicleId.value = '';
  }
}
