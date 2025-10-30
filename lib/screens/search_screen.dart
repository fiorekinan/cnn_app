import 'package:cnn_app/controllers/news_controller.dart';
import 'package:cnn_app/routes/app_pages.dart';
import 'package:cnn_app/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cnn_app/utils/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsController controller = Get.find<NewsController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.searchNews(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search the Article',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: AppColors.tritinary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.searchResults.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 60, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Search the News',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(
            16,
          ),
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final article = controller.searchResults[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: NewsCard(
                article: article,
                onTap: () =>
                    Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
              ),
            );
          },
        );
      }),
    );
  }
}
