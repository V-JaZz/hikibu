import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatSpaceState {
  var _isLoading = true.obs;
  RxList<types.Message> chatData = <types.Message>[].obs;
  var toUserProfile = ''.obs;
  var toUserName = ''.obs;
  var toUserDescription =''.obs;
  var toUserUid = ''.obs;
  var chatRoomId = ''.obs;

  /* This is the getter */
  get isLoading => _isLoading.value;

  /* This is the setter */
  set isLoading(value) {
    _isLoading = value;
  }
}