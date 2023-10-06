import 'package:get/get.dart';

import '../models/user_details.dart';

class UserController extends GetxController {
  var userDetails = UserDetails(uid: '', phoneNumber: '', displayName: '').obs;

  void updateUserDetails(UserDetails newUserDetails) {
    userDetails(newUserDetails);
  }
}