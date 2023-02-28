import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:wup/binding/calendar_binding.dart';
import 'package:wup/binding/fluttermoji_binding.dart';
import 'package:wup/binding/game_binding.dart';
import 'package:wup/binding/home_binding.dart';
import 'package:wup/binding/input_binding.dart';
import 'package:wup/binding/login_binding.dart';
import 'package:wup/binding/question_binding.dart';
import 'package:wup/binding/result_binding.dart';
import 'package:wup/binding/splash_binding.dart';
import 'package:wup/binding/welcome_binding.dart';
import 'package:wup/views/calendar_screen.dart';
import 'package:wup/views/fluttermoji_screen.dart';
import 'package:wup/views/game_screen.dart';
import 'package:wup/views/home_screen.dart';
import 'package:wup/views/input_screen.dart';
import 'package:wup/views/login_screen.dart';
import 'package:wup/views/question_screen.dart';
import 'package:wup/views/result_screen.dart';
import 'package:wup/views/splash_screen.dart';
import 'package:wup/views/welcome_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
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
    GetPage(
      name: _Paths.GAME,
      page: () => GameWidget(game: GameScreen()),
      binding: GameBinding(),
    ),
  ];
}
