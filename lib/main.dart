
import 'package:courier_application/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'Provider/ParcelProvider.dart';
import 'Provider/SignInProvider.dart';
import 'Provider/SignUpProvider.dart';
import 'Provider/UploadIdProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInProvider>(
          create:(context)=>SignInProvider(),
        ),
        ChangeNotifierProvider<UploadIdProvider>(
          create:(context)=>UploadIdProvider(),
        ),
        ChangeNotifierProvider<SignUpProvider>(
          create:(context)=>SignUpProvider(),
        ),
        ChangeNotifierProvider<ParcelProvider>(
          create:(context)=>ParcelProvider(),
        ),
        // ChangeNotifierProvider<WishlistProvider>(
        //   create:(context)=>WishlistProvider(),
        // ),
        // ChangeNotifierProvider<CheckOutProvider>(
        //   create:(context)=>CheckOutProvider(),
        // ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

