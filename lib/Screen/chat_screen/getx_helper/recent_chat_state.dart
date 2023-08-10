
import 'package:get/get.dart';

import '../../../model/chat_room_model/chat_room_model.dart';
import '../../../model/user_model.dart';

class  RecentChatState {
  RxList<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;
  RxList<UserModel> otherUser = <UserModel>[].obs;

}