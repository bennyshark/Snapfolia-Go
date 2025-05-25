import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1E5434);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryGreen, Color(0xFF2E7D32)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Get in Touch",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactCard(
            context,
            Icons.email,
            "Email Us",
            "snapfoliago@gmail.com",
            "mailto:snapfoliago@gmail.com",
          ),
          _buildContactCard(
            context,
            Icons.language,
            "Visit Website",
            "https://trees.firstasia.edu.ph/",
            "https://trees.firstasia.edu.ph/",
          ),
          _buildContactCard(
            context,
            Icons.bug_report,
            "Report Issues",
            "github.com",
            "github.com",
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, IconData icon, String title, String detail, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
        subtitle: Text(
          detail,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontFamily: 'Montserrat',
          ),
        ),
        onTap: () async {
          try {
            final uri = Uri.parse(url);
            if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              throw Exception('Could not launch $url');
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open $url: $e')),
            );
          }
        },
      ),
    );
  }
}
