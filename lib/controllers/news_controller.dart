import 'package:cnn_app/models/news_articles.dart';
import 'package:cnn_app/services/news_services.dart';
import 'package:cnn_app/utils/constants.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  // untuk memproses request yang sudah dibuat oleh news services
  final NewsServices _newsServices = NewsServices();

  // observable variables (variable yang bisa berubah)
  // apakah aplikasi sedang membuat berita dan nilainya adalah
  final _isLoading = false.obs;
  // ini untuk menampilkan data berita yang sudah berhasil didapat.
  final _articles = <NewsArticles>[].obs;
  //untuk handel kategori atau yg muncul di screen 
  final _selectedCategory = 'general'.obs;
  // kalo ada kesalahan pesan error akan disimpan disiini
  final _error = ''.obs;
  //getters = seperti jendela yang bisa mwlihat isis variabel yg sudah didefinisikan
  // dengan ini, UI bisa dengan mudah melihat data dari controller.
  // semua yg ada di setter sifatnya privat.

  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  //begitu app dibuka app langsung menampilkan berita pertama dari endpoint top-headlines
  //TODO: Fetching data dari endpoint top=headlines
  Future<void> fetchTopHeadlines({String? category}) async {
    //blok ini akan dijalan kan jika rest api berhasil berkomunikasi dgn server
    try {
      _isLoading.value = true;
      _error.value = '';
      final response = await _newsServices.getTopHeadLines(
        category: category ?? _selectedCategory.value,
      );
      _articles.value = response.articles;
    } catch (e) {
      _error.value = error.toString();
      Get.snackbar(
        'Error', 
        'Failed to Load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        );
        // finally akan tetap di execute setelah salah satu dari blok try atau catch sudah berhasil mendapatkan hasil
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM
      );
    }
    finally {
      _isLoading.value = false;
    }
  }
}