import 'package:cnn_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingSplendid extends StatefulWidget {
  const LoadingSplendid({super.key});

  @override
  State<LoadingSplendid> createState() => _LoadingSplendidState();
}

class _LoadingSplendidState extends State<LoadingSplendid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedBox({double width = double.infinity, double height = 16, double radius = 8}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.divider,
                AppColors.divider.withValues(alpha: .5),
                AppColors.divider,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(_animation.value * 3.14159),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildAnimatedBox(width: 120, height: 16, radius: 6),
            const SizedBox(height: 8),
            _buildAnimatedBox(width: 220, height: 28, radius: 8),
            const SizedBox(height: 10),
            SizedBox(
              height: 380,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: screenWidth * 0.8,
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildAnimatedBox(width: screenWidth * 0.7, height: 16, radius: 8),
                      const SizedBox(height: 6),
                      _buildAnimatedBox(width: screenWidth * 0.5, height: 14, radius: 7),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildAnimatedBox(width: 180, height: 24, radius: 8),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: screenWidth * 0.5,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildAnimatedBox(width: screenWidth * 0.45, height: 16, radius: 8),
                      const SizedBox(height: 6),
                      _buildAnimatedBox(width: screenWidth * 0.35, height: 14, radius: 7),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
