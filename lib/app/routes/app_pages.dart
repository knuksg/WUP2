import 'package:get/get.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_binding.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_screen.dart';
import 'package:wup/app/modules/calendar/calendar_binding.dart';
import 'package:wup/app/modules/calendar/calendar_screen.dart';
import 'package:wup/app/modules/game/game_binding.dart';
import 'package:wup/app/modules/game/game_screen.dart';
import 'package:wup/app/modules/home/home_binding.dart';
import 'package:wup/app/modules/home/home_screen.dart';
import 'package:wup/app/modules/user/fluttermoji/fluttermoji_binding.dart';
import 'package:wup/app/modules/user/fluttermoji/fluttermoji_screen.dart';
import 'package:wup/app/modules/user/input/input_binding.dart';
import 'package:wup/app/modules/user/input/input_screen.dart';
import 'package:wup/app/modules/user/login/login_binding.dart';
import 'package:wup/app/modules/user/login/login_screen.dart';
import 'package:wup/app/modules/user/profile/profile_binding.dart';
import 'package:wup/app/modules/user/profile/profile_screen.dart';
import 'package:wup/app/modules/user/question/question_binding.dart';
import 'package:wup/app/modules/user/question/question_screen.dart';
import 'package:wup/app/modules/user/result/result_binding.dart';
import 'package:wup/app/modules/user/result/result_screen.dart';
import 'package:wup/app/modules/user/splash/splash_binding.dart';
import 'package:wup/app/modules/user/splash/splash_screen.dart';
import 'package:wup/app/modules/user/welcome/welcome_binding.dart';
import 'package:wup/app/modules/user/welcome/welcome_screen.dart';
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
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.GAME,
      page: () => const GameScreen(),
      binding: GameBinding(),
    ),
    GetPage(
      name: _Paths.BIORHYTHM,
      page: () => const NewBiorhythmScreen(),
      binding: BiorhythmBinding(),
    ),
  ];
}
