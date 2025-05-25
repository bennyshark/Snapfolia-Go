import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import 'contact_section.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Color constants
    const Color primaryGreen = Color(0xFF1E5434);
    const Color lightGreen = Color(0xFFE5F4E5);
    const Color accentGreen = Color(0xFF4CAF50);

    // Calculate responsive sizing
    final double standardPadding = screenWidth * 0.045; // 4.5% of screen width
    final double smallPadding = screenWidth * 0.02;     // 2% of screen width
    final double iconSize = screenWidth * 0.06;         // 6% of screen width

    // Text sizes
    final double headingSize = screenWidth * 0.065;     // 6.5% of screen width
    final double subheadingSize = screenWidth * 0.054;  // 5.4% of screen width
    final double titleSize = screenWidth * 0.05;        // 5% of screen width
    final double bodySize = screenWidth * 0.039;        // 3.9% of screen width
    final double smallBodySize = screenWidth * 0.037;   // 3.7% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "ABOUT",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.055, // 5.5% of screen width
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            letterSpacing: screenWidth * 0.003, // 0.3% of screen width
          ),
        ),
      ),
      body: BaseScaffold(
        currentIndex: 1,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section with decorative leaf pattern
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: screenWidth * 0.025, // 2.5% of screen width
                      offset: Offset(0, screenHeight * 0.005), // 0.5% of screen height
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative leaf pattern
                    Positioned(
                      right: -screenWidth * 0.125, // -12.5% of screen width
                      top: -screenHeight * 0.025, // -2.5% of screen height
                      child: Opacity(
                        opacity: 0.2,
                        child: Icon(
                          Icons.eco,
                          size: screenWidth * 0.375, // 37.5% of screen width
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Main content
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          standardPadding,
                          screenHeight * 0.035, // 3.5% of screen height
                          standardPadding,
                          screenHeight * 0.02 // 4.7% of screen height
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Uncover Our Roots",
                            style: TextStyle(
                              fontSize: headingSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01), // 1% of screen height
                          Text(
                            "A closer look at what drives us.",
                            style: TextStyle(
                              fontSize: subheadingSize,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // 2% of screen height
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025), // 2.5% of screen height

              // App description
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: standardPadding,
                    vertical: screenHeight * 0.012 // 1.2% of screen height
                ),
                padding: EdgeInsets.all(standardPadding * 1.2), // 20% larger than standard padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04), // 4% of screen width
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.025, // 2.5% of screen width
                      offset: Offset(0, screenHeight * 0.0025), // 0.25% of screen height
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, color: accentGreen, size: iconSize),
                        SizedBox(width: screenWidth * 0.03), // 3% of screen width
                        Text(
                          "About SnapfoliaGO",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% of screen height
                    Text(
                      "Snapfolia GO is the mobile-powered evolution of Snapfolia—a web-based leaf classification system designed to identify Philippine trees with ease. Born from an academic thesis project, this app overcomes the limitations of its web version by offering real-time, offline leaf recognition.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: bodySize,
                        fontFamily: 'Montserrat',
                        height: 1.5,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),

              // Mission section
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: standardPadding,
                    vertical: screenHeight * 0.012 // 1.2% of screen height
                ),
                padding: EdgeInsets.all(standardPadding * 1.2), // 20% larger than standard padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04), // 4% of screen width
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.025, // 2.5% of screen width
                      offset: Offset(0, screenHeight * 0.0025), // 0.25% of screen height
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, color: accentGreen, size: iconSize),
                        SizedBox(width: screenWidth * 0.03), // 3% of screen width
                        Text(
                          "Our Mission",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% of screen height
                    Text(
                      "Snapfolia GO was created to bridge technology and nature, encouraging Filipinos to explore, learn, and appreciate native flora in an instant. By making tree identification effortless, we hope to inspire a deeper connection with the environment.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: smallBodySize,
                        fontFamily: 'Montserrat',
                        height: 1.5,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),

              // Features section
              Padding(
                padding: EdgeInsets.all(standardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Key Features",
                      style: TextStyle(
                        fontSize: screenWidth * 0.055, // 5.5% of screen width
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: primaryGreen,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025), // 2.5% of screen height

                    FeatureItem(
                      icon: Icons.speed,
                      title: "Instant, Offline Identification",
                      description: "No internet? No problem. Get fast, accurate tree species results anytime, anywhere.",
                      color: Color(0xFF4CAF50),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),

                    FeatureItem(
                      icon: Icons.book,
                      title: "Tree Encyclopedia",
                      description: "Dive deeper with a built-in dictionary of Philippine trees, complete with details about each species.",
                      color: Color(0xFF8BC34A),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),

                    FeatureItem(
                      icon: Icons.camera_alt,
                      title: "One-Click Simplicity",
                      description: "Fewer steps, faster answers. Just snap a leaf and let AI do the rest.",
                      color: Color(0xFF009688),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                  ],
                ),
              ),

              ContactSection(),

              SizedBox(height: screenHeight * 0.05), // 5% of screen height
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final double screenWidth;
  final double screenHeight;

  const FeatureItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.03), // 3% of screen height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.03), // 3% of screen width
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
            ),
            child: Icon(
              icon,
              color: color,
              size: screenWidth * 0.07, // 7% of screen width
            ),
          ),
          SizedBox(width: screenWidth * 0.04), // 4% of screen width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: screenWidth * 0.042, // 4.2% of screen width
                    color: Color(0xFF424242),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // 1% of screen height
                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.037, // 3.7% of screen width
                    height: 1.4,
                    color: Colors.black87,
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