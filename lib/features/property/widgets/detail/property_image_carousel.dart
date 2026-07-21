import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

class PropertyImageCarousel extends StatefulWidget {
  final List<PropertyImage> images;

  const PropertyImageCarousel({super.key, required this.images});

  @override
  State<PropertyImageCarousel> createState() => _PropertyImageCarouselState();
}

class _PropertyImageCarouselState extends State<PropertyImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fallback if no images
    if (widget.images.isEmpty) {
      return Container(
        height: 350,
        width: double.infinity,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, size: 64, color: AppColors.muted),
      );
    }

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        children: [

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.images[index].imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 48, color: AppColors.muted),
                ),
              );
            },
          ),
          

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: .4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),


          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: _buildCircleButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCircleButton(
                  icon: Icons.share_outlined,
                  onTap: () {
                    // Handle share
                  },
                ),
                const SizedBox(width: 12),
                _buildCircleButton(
                  icon: Icons.favorite_border,
                  onTap: () {
                    // Handle favorite
                  },
                ),
              ],
            ),
          ),


          if (widget.images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 8 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: .5),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.ink, size: 22),
      ),
    );
  }
}
