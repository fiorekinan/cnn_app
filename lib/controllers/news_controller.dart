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
  // untuk hasil pencarian agar tidak campur dengan data utama
  final _searchResults = <NewsArticles>[].obs;
  //untuk handel kategori atau yg muncul di screen 
  final _selectedCategory = 'general'.obs;
  // kalo ada kesalahan pesan error akan disimpan disiini
  final _error = ''.obs;
  //getters = seperti jendela yang bisa mwlihat isis variabel yg sudah didefinisikan
  // dengan ini, UI bisa dengan mudah melihat data dari controller.
  // semua yg ada di setter sifatnya privat.

  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  List<NewsArticles> get searchResults => _searchResults; // hasil pencarian
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  //begitu app dibuka app langsung menampilkan berita pertama dari endpoint top-headlines
  //TODO: Fetching data dari endpoint top=headlines
  Future<void> fetchTopHeadlines({String? category, bool showSnackbar = false}) async {
    //blok ini akan dijalan kan jika rest api berhasil berkomunikasi dgn server
    try {
      _isLoading.value = true;
      _error.value = '';
      final response = await _newsServices.getTopHeadLines(
        category: category ?? _selectedCategory.value,
      );
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      if (showSnackbar) {
        Get.snackbar(
          'Error', 
          'Failed to Load news: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      // finally akan tetap di execute setelah salah satu dari blok try atau catch sudah berhasil mendapatkan hasil
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews({bool showSnackbar = false}) async {
    await fetchTopHeadlines(showSnackbar: showSnackbar);
  }

  void selectCategory(String category, {bool showSnackbar = false}) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category, showSnackbar: showSnackbar);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines(); // default tanpa snackbar
  }

  // untuk fitur search
  Future<void> searchNews(String query, {bool showSnackbar = false}) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.searchNews(query: query);
      _searchResults.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to search news: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void clearSearchResults() {
    _searchResults.clear();
  }
}
