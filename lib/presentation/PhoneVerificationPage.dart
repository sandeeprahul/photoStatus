import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:photostatus/models/user_details.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:photostatus/presentation/upload_home_page.dart';

import '../controllers/user_controller.dart';
import '../firebase_calls/FirebaseAuthenticationService.dart';
import '../providers/user_provider.dart';
import 'home_page.dart';
import 'otp_input_page.dart';


class PhoneVerificationPage extends StatelessWidget {
  final UserController userController = Get.find();
  final FirebaseAuthenticationService authService = FirebaseAuthenticationService();
  final TextEditingController phoneNumberController = TextEditingController();

  PhoneVerificationPage({super.key});

  Future<void> verifyPhoneNumber() async {
    String phoneNumber ="+91${phoneNumberController.text.trim()}";

    // if(Platform.isAndroid){
      await authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          await authService.signInWithCredential(credential);

          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            UserDetails userDetails = UserDetails(
              uid: currentUser.uid,
              phoneNumber: phoneNumber,
              displayName: currentUser.displayName!,
            );
            userController.updateUserDetails(userDetails);
            if(phoneNumber=="+918977771266"||phoneNumber=="+918106519615"){
              Get.to(const UploadHomePage());
            }else{
              Get.to(const MyHomePage());

            }
          } else {
            print('Current user is null');
          }
          // Get.to(AnotherPage());
        },
        onVerificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        onCodeSent: (String verificationId, int? resendToken) {
          Get.to(OTPInputPage(verificationId: verificationId, authService: authService, userController: userController,));
        },
        onCodeAutoRetrievalTimeout: (String verificationId) {},
      );



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                maxLength: 10,
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                verifyPhoneNumber();
              },
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}



