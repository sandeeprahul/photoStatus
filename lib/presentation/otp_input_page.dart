
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photostatus/presentation/provider/upload_home_page.dart';

import '../controllers/user_controller.dart';
import '../firebase_calls/FirebaseAuthenticationService.dart';
import '../models/user_details.dart';
import 'PhoneVerificationPage.dart';
import 'home_page.dart';

class OTPInputPage extends StatelessWidget {
  final String verificationId;
  final FirebaseAuthenticationService authService;
  final UserController userController;

  OTPInputPage({required this.verificationId, required this.authService, required this.userController});

  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOTP() async {
    String otp = otpController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await authService.signInWithCredential(credential);

    User? currentUser = FirebaseAuth.instance.currentUser;
    UserDetails userDetails = UserDetails(
      uid: currentUser!.uid,
      phoneNumber: currentUser.phoneNumber!,
      displayName: currentUser.phoneNumber!,
    );
    userController.updateUserDetails(userDetails);
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set(userDetails.toJson());

    if(currentUser.phoneNumber=="+918977771266"||currentUser.phoneNumber=="+918106519615"){
      Get.to(const UploadHomePage());
    }else{
      Get.to(const MyHomePage());

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}