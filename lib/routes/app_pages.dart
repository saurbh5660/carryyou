import 'package:carry_you_user/views/auth/license_detail_screen.dart';
import 'package:carry_you_user/views/auth/vehicle_detail_screen.dart';
import 'package:carry_you_user/views/home/home_screen.dart';
import 'package:carry_you_user/views/home/lost_item_map_screen.dart';
import 'package:carry_you_user/views/map/AddNewBankScreen.dart';
import 'package:carry_you_user/views/map/bank_account_screen.dart';
import 'package:carry_you_user/views/map/choose_time_screen.dart';
import 'package:carry_you_user/views/map/activity_screen.dart';
import 'package:carry_you_user/views/map/lost_item_screen.dart';
import 'package:carry_you_user/views/map/payment_detail_screen.dart';
import 'package:carry_you_user/views/map/track_map_screen.dart';
import 'package:carry_you_user/views/profile/profile_screen.dart';
import 'package:carry_you_user/views/setting/change_password_screen.dart';
import 'package:carry_you_user/views/setting/voucher_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../all_binding/all_bindings.dart';
import '../views/auth/add_detail_screen.dart';
import '../views/auth/edit_profile_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/on_boarding_screen.dart';
import '../views/auth/reset_password_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/auth/splash_screen.dart';
import '../views/auth/subscription_buy_screen.dart';
import '../views/auth/verification_screen.dart';
import '../views/chat/chat_screen.dart';
import '../views/chat/message_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/event/event_detail_screen.dart';
import '../views/map/add_rating_screen.dart';
import '../views/map/payment_status_screen.dart';
import '../views/setting/account_screen.dart';
import '../views/setting/cms_screen_screen.dart';
import '../views/setting/contact_screen.dart';
import '../views/setting/faq_screen.dart';
import '../views/setting/location_screen.dart';
import '../views/setting/membership_screen.dart';
import '../views/setting/notification_screen.dart';
import '../views/setting/ride_detail_screen.dart';
import '../views/setting/payment_history_screen.dart';
import '../views/setting/reward_screen.dart';
import '../views/setting/setting_screen.dart';
import '../views/setting/subscription_plan.dart';
import '../views/setting/wallet_screen.dart';
import '../views/shop/review_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static String initialRoute = AppRoutes.splashView;
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splashView, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.onboardingView,
      page: () => const OnboardingScreen(),
    ),

    GetPage(
      name: AppRoutes.loginView,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),

    GetPage(name: AppRoutes.signupView, page: () => const SignupScreen()),

    GetPage(
      name: AppRoutes.resetScreenView,
      page: () => const ResetPasswordScreen(),
      binding: ResetBinding(),
    ),

    GetPage(
      name: AppRoutes.dashboardView,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: AppRoutes.verificationScreen,
      page: () => const VerificationScreen(),
    ),

    GetPage(
      name: AppRoutes.addDetailScreen,
      page: () => const AddDetailScreen(),
    ),



    GetPage(name: AppRoutes.eventDetail, page: () => const EventDetailScreen()),


    GetPage(name: AppRoutes.settingView, page: () => const SettingScreen()),



    GetPage(
      name: AppRoutes.membershipScreen,
      page: () => const MembershipScreen(),
    ),


    GetPage(
      name: AppRoutes.paymentHistoryScreen,
      page: () => const PaymentHistoryScreen(),
    ),


    GetPage(
      name: AppRoutes.rideDetailScreen,
      page: () => const RideDetailScreen(),
      binding: RideDetailBinding()
    ),


    GetPage(
      name: AppRoutes.reviewScreen,
      page: () =>  ReviewRateScreen(),
    ),



    GetPage(
      name: AppRoutes.messageScreen,
      page: () =>  MessagesScreen(),
    ),

    GetPage(
      name: AppRoutes.chatScreen,
      page: () =>  ChatScreen(),
    ),

    GetPage(
      name: AppRoutes.voucherScreen,
      page: () =>  VoucherScreen(),
    ),

    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () =>  EditProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.contactScreen,
      page: () =>  ContactUsScreen(),
    ),

    GetPage(
      name: AppRoutes.faqScreen,
      page: () =>  FaqScreen(),
    ),

    GetPage(
      name: AppRoutes.cmsScreen,
      page: () =>  CmsScreen(),
    ),

    GetPage(
      name: AppRoutes.rewardScreen,
      page: () =>  RewardsScreen(),
    ),

    GetPage(
      name: AppRoutes.locationScreen,
      page: () =>  LocationScreen(),
    ),

    GetPage(
      name: AppRoutes.subscriptionBuyScreen,
      page: () =>  SubscriptionBuyScreen(),
    ),

    GetPage(
      name: AppRoutes.subscriptionPlanScreen,
      page: () =>  SubscriptionPlanScreen(),
    ),

    GetPage(
      name: AppRoutes.notificationScreen,
      page: () =>  NotificationScreen(),
    ),


    GetPage(
      name: AppRoutes.licenseDetail,
      page: () =>  LicenseDetailScreen(),
    ),

    GetPage(
      name: AppRoutes.vehicleDetail,
      page: () =>  VehicleDetailScreen(),
    ),

    GetPage(
      name: AppRoutes.homeScreen,
      page: () =>  HomeScreen(),
    ),

    /*GetPage(
      name: AppRoutes.mapScreen,
      page: () =>  RideBookingMainScreen(),
    ),*/

    GetPage(
      name: AppRoutes.paymentStatus,
      page: () =>  PaymentStatusScreen(),
    ),

    GetPage(
      name: AppRoutes.activityScreen,
      page: () =>  ActivityScreen(),
      binding: ActivityBinding()
    ),

    GetPage(
      name: AppRoutes.paymentDetail,
      page: () =>  PaymentDetailScreen(),
    ),

    GetPage(
      name: AppRoutes.walletScreen,
      page: () =>  WalletScreen(),
    ),

    GetPage(
      name: AppRoutes.bankAccount,
      page: () =>  MyBankAccountsScreen(),
    ),

    GetPage(
      name: AppRoutes.addNewBankScreen,
      page: () =>  AddNewBankScreen(),
    ),

    GetPage(
      name: AppRoutes.profileScreen,
      page: () =>  ProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.changePasswordScreen,
      page: () =>  ChangePasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.ratingScreen,
      page: () =>  RatingScreen(),
    ),

    GetPage(
      name: AppRoutes.accountScreen,
      page: () =>  AccountScreen(),
    ),

    GetPage(
      name: AppRoutes.chooseTime,
      page: () =>  ChooseTimeScreen(),
    ),

    GetPage(
      name: AppRoutes.trackMapScreen,
      page: () =>  TrackMapScreen(),
    ),

    GetPage(
      name: AppRoutes.lostItemScreen,
      page: () =>  LostItemScreen(),
    ),

    GetPage(
      name: AppRoutes.lostItemMapScreen,
      page: () =>  LostItemMapScreen(),
    ),

  ];
}
