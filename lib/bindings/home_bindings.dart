import 'package:cnn_app/controllers/news_controller.dart';
import 'package:get/get.dart';

class HomeBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
  }
}