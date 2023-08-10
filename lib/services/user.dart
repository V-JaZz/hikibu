import 'dart:developer';
import 'package:get/get.dart';
import 'package:hukibu/API/api_client.dart';

import '../model/user_model.dart';
import '../routes/route_paths.dart';
import '../services/storage.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  final _isLogin = false.obs;
  String uid = '1';
  String userIdKey = 'userIdKey';
  String userTokenKey = 'userTokenKey';
  final _profile = UserModel(
    id: 1,
    image: '',
    email: '',
    mobile: '',
    name: '',
  ).obs;

  bool get isLogin => _isLogin.value;

  UserModel get profile => _profile.value;

  bool get hasToken => uid.isNotEmpty;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getProfile();
    getToken();
  }

  Future<void> setToken(String value) async {
    await StorageService.to.setString(userTokenKey, value);
    ApiClient.to.token = value;
  }

  void getToken() {
    ApiClient.to.token = StorageService.to.getString(userTokenKey);
  }

  Future<void> getProfile() async {
    uid = StorageService.to.getString(userIdKey);
    if (uid.isNotEmpty) {
      print("uid $uid");
      Response res = await ApiClient.to.getData(
        'http://13.127.11.171:3000/getUserById/$uid'
      );
      print(res.statusCode);
      print(res.body);
      log(res.body.toString());
      _profile(UserModel.fromJson(res.body[0]));
    }
    log('user data: $_profile');
    _isLogin.value = true;
  }

  Future<void> saveProfile(String profile) async {
    await StorageService.to.setString(userIdKey, profile);
    await getProfile();
    uid = profile;
    log("data is saved: ${_profile.value}");
  }

  Future<void> onLogout() async {
    await StorageService.to.remove(userIdKey);
    await StorageService.to.remove(userTokenKey);
    _isLogin.value = false;
    uid = '';
    Get.offAllNamed(RoutePaths.loginScreen);
  }
}
