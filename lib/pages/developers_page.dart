import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'base_scaffold.dart';

class DevelopersPage extends StatelessWidget {
  const DevelopersPage({super.key});

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
          "DEVELOPERS",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            letterSpacing: screenWidth * 0.003,
          ),
        ),
      ),
      body: BaseScaffold(
        currentIndex: 4,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: screenWidth * 0.025,
                      offset: Offset(0, screenHeight * 0.005),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -screenWidth * 0.125,
                      top: -screenHeight * 0.025,
                      child: Opacity(
                        opacity: 0.2,
                        child: Icon(
                          Icons.people_alt_outlined,
                          size: screenWidth * 0.375,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        standardPadding,
                        screenHeight * 0.035,
                        standardPadding,
                        screenHeight * 0.047,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Meet our Team",
                            style: TextStyle(
                              fontSize: headingSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "The minds behind SnapfoliaGo",
                            style: TextStyle(
                              fontSize: subheadingSize,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.025),

              // Team Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: standardPadding),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    DeveloperProfile(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      name: "Angelo Castillo",
                      role: "UI/UX Designer & Machine Learning Engineer",
                      imageUrl: "assets/images/prof.png",
                      githubUrl: "github.com/Gel000",
                      linkedinUrl: "https://www.linkedin.com/in/angelo-castillo-938162341/",
                      email: "alcastillo887@gmail.com",
                    ),
                    DeveloperProfile(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      name: "Benedict Gutierrez",
                      role: "Full Stack Developer & Machine Learning Engineer",
                      imageUrl: "assets/images/prof.png",
                      githubUrl: "https://github.com/bennyshark",
                      linkedinUrl: "https://www.linkedin.com/in/benedict-gutierrez-15917b333/",
                      email: "benedictgutierrezcs25@gmail.com",
                    ),
                    DeveloperProfile(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      name: "Nikka Ysabel Farofaldane",
                      role: "UI/UX Designer & Machine Learning Engineer",
                      imageUrl: "assets/images/prof.png",
                      githubUrl: "https://github.com/sayysa",
                      linkedinUrl: "https://www.linkedin.com/in/nikka-ysabel-farofaldane-6a145130b/",
                      email: "farofaldaneny@gmail.com",
                    ),
                  ],
                ),
              ),

              // Contact Section
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperProfile extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final String githubUrl;
  final String linkedinUrl;
  final String email;
  final double screenWidth;
  final double screenHeight;

  const DeveloperProfile({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.email,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double profileImageSize = screenWidth * 0.2;
    final double socialIconSize = screenWidth * 0.045;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.025),
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: screenWidth * 0.025,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(profileImageSize),
            child: Image.network(
              imageUrl,
              width: profileImageSize,
              height: profileImageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: profileImageSize,
                  height: profileImageSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E5434).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF1E5434),
                    size: profileImageSize * 0.5,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: screenWidth * 0.045),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: const Color(0xFF1E5434),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: const Color(0xFF4CAF50),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                // Social media links row
                Row(
                  children: [
                    _buildSocialIcon(
                      context,
                      Icons.email,
                      "Email",
                      "mailto:$email",
                      socialIconSize,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    _buildSocialIcon(
                      context,
                      Icons.code,
                      "GitHub",
                      githubUrl,
                      socialIconSize,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    _buildSocialIcon(
                      context,
                      Icons.work,
                      "LinkedIn",
                      linkedinUrl,
                      socialIconSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(
      BuildContext context,
      IconData icon,
      String label,
      String url,
      double size,
      ) {
    return InkWell(
      onTap: () async {
        try {
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          )) {
            throw Exception('Could not launch $url');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open $label link: $e')),
          );
        }
      },
      child: Tooltip(
        message: label,
        child: Container(
          padding: EdgeInsets.all(size * 0.5),
          decoration: BoxDecoration(
            color: const Color(0xFF1E5434).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1E5434),
            size: size,
          ),
        ),
      ),
    );
  }
}