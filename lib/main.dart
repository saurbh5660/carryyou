import 'package:carry_you_user/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'common/app_colors.dart';

/*@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService().init();
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint('Notification Message: ${message.data}');
}*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/

  await GetStorage.init();
  /* await NotificationService().init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
*/
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.black.withOpacity(0.7),
      overlayWidgetBuilder: (_) {
        return Center(
            child: CircularProgressIndicator(
              color: AppColor.blueColor,
            ));
      },
      child: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Carry You',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          initialRoute: AppPages.initialRoute,
          getPages: AppPages.pages,
        ),
      ),
    );
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

