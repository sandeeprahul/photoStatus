import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:photostatus/presentation/PhoneVerificationPage.dart';
import 'package:photostatus/presentation/home_page.dart';
import 'package:photostatus/presentation/provider/upload_home_page.dart';

import 'controllers/user_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserController userController = Get.put(UserController());

  User? currentUser = FirebaseAuth.instance.currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Photo Status',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: currentUser == null
          ? PhoneVerificationPage()
          : currentUser!.phoneNumber == "+918106519615"
              ? const UploadHomePage()
              : currentUser!.phoneNumber == "+918977771266"
                  ? const UploadHomePage()
                  : const MyHomePage(),
    );
  }
}
