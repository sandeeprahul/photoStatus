import 'package:get/get.dart';

import '../models/user_details.dart';

class UserController extends GetxController {
  String? uid;
  String? name;
  String? phone;
  var userDetails = UserDetails(uid: '', phoneNumber: '', displayName: '').obs;

  void updateUserDetails(UserDetails newUserDetails) {
    userDetails(newUserDetails);
  }
  void saveUserDetails({String? uid, String? name, String? phone}) {
    // Save the details to the UserController properties
    this.uid = uid;
    this.name = name;
    this.phone = phone;

    // You can also implement additional logic here, such as saving to a database
    // or performing any necessary actions when user details are updated.
  }
}