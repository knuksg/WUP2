import 'package:get/get.dart';
import 'package:mbti_test/binding/calendar_binding.dart';
import 'package:mbti_test/binding/fluttermoji_binding.dart';
import 'package:mbti_test/binding/home_binding.dart';
import 'package:mbti_test/binding/input_binding.dart';
import 'package:mbti_test/binding/login_binding.dart';
import 'package:mbti_test/binding/question_binding.dart';
import 'package:mbti_test/binding/result_binding.dart';
import 'package:mbti_test/binding/splash_binding.dart';
import 'package:mbti_test/binding/welcome_binding.dart';
import 'package:mbti_test/views/calendar_screen.dart';
import 'package:mbti_test/views/fluttermoji_screen.dart';
import 'package:mbti_test/views/home_screen.dart';
import 'package:mbti_test/views/input_screen.dart';
import 'package:mbti_test/views/login_screen.dart';
import 'package:mbti_test/views/question_screen.dart';
import 'package:mbti_test/views/result_screen.dart';
import 'package:mbti_test/views/splash_screen.dart';
import 'package:mbti_test/views/welcome_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.INPUT,
      page: () => const InputScreen(),
      binding: InputBinding(),
    ),
    GetPage(
      name: _Paths.QUESTION,
      page: () => const QuestionScreen(),
      binding: QuestionBinding(),
    ),
    GetPage(
      name: _Paths.FLUTTERMOJI,
      page: () => FluttermojiScreen(),
      binding: FluttermojiBinding(),
    ),
    GetPage(
      name: _Paths.RESULT,
      page: () => const ResultScreen(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarScreen(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const CalendarScreen(),
      binding: CalendarBinding(),
    ),
  ];
}
