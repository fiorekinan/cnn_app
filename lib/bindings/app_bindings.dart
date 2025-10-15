import 'package:cnn_app/controllers/news_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies(){
    Get.put<NewsController>(NewsController(), permanent: true);
  }
}