import 'package:cnn_app/screens/home_screen.dart';
import 'package:cnn_app/screens/news_detail_screen.dart';
import 'package:cnn_app/screens/news_section.dart';
import 'package:cnn_app/screens/search_screen.dart';
import 'package:cnn_app/screens/splash_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

   static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: _Paths.NEWS_SECTION,
      page: () => const NewsSection(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => NewsDetailScreen(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchScreen(),
    ),
  ];
}
