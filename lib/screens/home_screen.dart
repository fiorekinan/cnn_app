import 'package:cnn_app/controllers/news_controller.dart';
import 'package:cnn_app/routes/app_pages.dart';
import 'package:cnn_app/utils/app_colors.dart';
import 'package:cnn_app/widgets/bottom_nav_bar.dart';
import 'package:cnn_app/widgets/loading_splendid.dart';
import 'package:cnn_app/widgets/news_snippet.dart';
import 'package:cnn_app/widgets/story_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<NewsController>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.fetchTopHeadlines();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.offAllNamed(Routes.HOME);
    } else if (index == 1) {
      Get.offAllNamed(Routes.NEWS_SECTION);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Image.asset(
          'assets/images/CNN_International_logo.png',
          height: 60,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(Routes.SEARCH),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) return const LoadingSplendid();
        if (!controller.isLoading && controller.articles.isEmpty) {
          return controller.error.isNotEmpty
              ? _buildErrorWidget()
              : _buildEmptyWidget();
        }

        final articles = controller.articles;

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "BREAKING NEWS",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 380,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: articles.length < 5 ? articles.length : 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: NewsSnippet(
                            article: article,
                            onTap: () => Get.toNamed(
                              Routes.NEWS_DETAIL,
                              arguments: article,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Top Headlines",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Icon(Icons.arrow_right, size: 32),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: articles.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return StoryCard(
                          article: article,
                          onTap: () => Get.toNamed(
                            Routes.NEWS_DETAIL,
                            arguments: article,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text('Please try again later', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            'Please check your internet connection',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshNews,
            style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
            child: const Text('Retry', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
