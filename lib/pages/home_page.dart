import 'dart:async';
import 'package:flutter/material.dart';
import 'base_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF1E5434);
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/leaf_icon.png',
              width: screenSize.width * 0.08, // 8% of screen width
              height: screenSize.width * 0.08, // Keep aspect ratio
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.eco, color: Colors.white,
                      size: screenSize.width * 0.08),
            ),
            SizedBox(width: screenSize.width * 0.03), // 3% of screen width
            Text(
              'Snapfolia',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: screenSize.width * 0.055, // Responsive text size
              ),
            ),
            Text(
              'GO',
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.055, // Responsive text size
              ),
            ),
          ],
        ),
      ),
      body: BaseScaffold(
        currentIndex: 0,
        body: const HomeContent(),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<GuideItem> _guideItems = [
    GuideItem(imagePath: 'assets/images/about.png'),
    GuideItem(imagePath: 'assets/images/about2.png'),
    GuideItem(imagePath: 'assets/images/about3.png'),
    GuideItem(imagePath: 'assets/images/about4.png'),
    GuideItem(imagePath: 'assets/images/about5.png'),
    GuideItem(imagePath: 'assets/images/about6.png'),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _guideItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF1E5434);
    const Color lightGreen = Color(0xFFE5F4E5);

    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Calculate responsive sizing
    final double standardPadding = screenWidth * 0.045; // 5% of screen width
    final double smallPadding = screenWidth * 0.02;    // 2% of screen width
    final double iconSize = screenWidth * 0.06;        // 5% of screen width

    // Text sizes
    final double headingSize = screenWidth * 0.065;     // 7% of screen width
    final double subheadingSize = screenWidth * 0.054; // 5.5% of screen width
    final double labelSize = screenWidth * 0.05;       // 5% of screen width

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          Container(
            width: double.infinity,
            height: screenHeight * 0.15, // 20% of screen height
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E5434), Color(0xFF2E7D32)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -screenWidth * 0.1, // -10% of screen width
                  top: -screenHeight * 0.03, // -3% of screen height
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.eco,
                        size: screenWidth * 0.5, // 50% of screen width
                        color: Colors.white),
                  ),
                ),
                Positioned(
                  left: -screenWidth * 0.08, // -8% of screen width
                  bottom: -screenHeight * 0.04, // -4% of screen height
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.spa,
                        size: screenWidth * 0.38, // 38% of screen width
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Discover Trees in a Snap",
                        style: TextStyle(
                          fontSize: headingSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01), // 1% of screen height
                      Text(
                        "— Wherever you GO!",
                        style: TextStyle(
                            fontSize: subheadingSize,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
              height: screenHeight * 0.029, // 5% of screen height
              color: lightGreen.withOpacity(0.5)
          ),
          // User Guide Title + Progress Bar
          Padding(
            padding: EdgeInsets.fromLTRB(
                standardPadding,
                standardPadding,
                standardPadding,
                smallPadding
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.book, color: primaryGreen, size: iconSize),
                    SizedBox(width: screenWidth * 0.025), // 2.5% of screen width
                    Text(
                      "USER GUIDE",
                      style: TextStyle(
                        fontSize: labelSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: primaryGreen,
                        letterSpacing: screenWidth * 0.003, // 0.3% of screen width
                      ),
                    ),
                  ],
                ),
                Container(
                  width: screenWidth * 0.125, // 12.5% of screen width
                  height: screenHeight * 0.005, // 0.5% of screen height
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(screenWidth * 0.005),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(screenWidth * 0.005),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.015,),
          // Image-Only Carousel
          Container(
            height: screenHeight * 0.48, // 50% of screen height
            margin: EdgeInsets.fromLTRB(
                standardPadding,
                0,
                standardPadding,
                standardPadding
            ),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _guideItems.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                  itemBuilder: (context, index) {
                    return GuideCard(guideItem: _guideItems[index]);
                  },
                ),
                Positioned(
                  bottom: screenHeight * 0.015, // 1.5% of screen height
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_guideItems.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01 // 1% of screen width
                        ),
                        height: screenHeight * 0.01, // 1% of screen height
                        width: _currentPage == index
                            ? screenWidth * 0.06 // 6% of screen width when active
                            : screenWidth * 0.02, // 2% of screen width when inactive
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? primaryGreen
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(screenWidth * 0.01),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GuideItem {
  final String imagePath;

  GuideItem({required this.imagePath});
}

class GuideCard extends StatelessWidget {
  final GuideItem guideItem;

  const GuideCard({super.key, required this.guideItem});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final double borderRadius = screenSize.width * 0.05; // 5% of screen width
    final double errorIconSize = screenSize.width * 0.15; // 15% of screen width

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        guideItem.imagePath,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(
                Icons.broken_image,
                size: errorIconSize,
                color: Colors.grey
            ),
          ),
        ),
      ),
    );
  }
}