import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuranQuestGuideScreen extends StatelessWidget {
  // Define your dark green color
  final Color darkGreen = const Color(0xff004d40);

  const QuranQuestGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quran Quest Guide',
          style: GoogleFonts.nunito(color: darkGreen),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: darkGreen),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Introduction Section
            _buildSectionTitle('Welcome to Quran Quest'),
            const SizedBox(height: 10),
            _buildText(
              'Get authentic Islamic guidance from trusted sources including the Quran, Hadith, and scholars.',
            ),
            const SizedBox(height: 20),

            // How to Use the AI Section
            _buildSectionTitle('How to Use Quran Quest'),
            const SizedBox(height: 10),
            _buildText('Follow these steps to interact with the AI:'),
            _buildBulletPoint(
                'Start with a greeting like "Assalamu Alaikum" or "Hello".'),
            _buildBulletPoint(
                'Ask your question, e.g., "What does the Quran say about charity?".'),
            _buildBulletPoint(
                'Receive answers with references to Quranic verses, Hadith, and scholars.'),
            _buildBulletPoint(
                'Follow the provided references to verify the authenticity.'),

            const SizedBox(height: 20),

            // Precautions Section
            _buildSectionTitle('Important Precautions'),
            const SizedBox(height: 10),
            _buildText('Things to keep in mind when using Quran Quest:'),
            _buildBulletPoint(
                'Authenticity: Verify critical religious matters with local scholars if needed.'),
            _buildBulletPoint(
                'Non-sectarian: The AI avoids divisive topics and stays neutral.'),
            _buildBulletPoint(
                'Limited Scope: The AI doesn’t provide answers outside Islamic teachings.'),
            _buildBulletPoint(
                'Error Handling: The AI may respond with "I don’t have enough information".'),

            const SizedBox(height: 20),

            // Example Interactions Section
            _buildSectionTitle('Example Interactions'),
            const SizedBox(height: 10),
            _buildExample('What is the importance of prayer in Islam?'),
            _buildExample('Can you share a Quranic verse about patience?'),
            _buildExample('Tell me about Zakat from Hadith.'),
          ],
        ),
      ),
    );
  }

  // Reusable method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: darkGreen,
      ),
    );
  }

  // Reusable method to build regular text
  Widget _buildText(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 16,
        color: darkGreen,
      ),
    );
  }

  // Reusable method to build bullet points
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.nunito(fontSize: 16, color: darkGreen),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(fontSize: 16, color: darkGreen),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable method to build example interactions
  Widget _buildExample(String exampleText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.question_answer, color: darkGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exampleText,
              style: GoogleFonts.nunito(fontSize: 16, color: darkGreen),
            ),
          ),
        ],
      ),
    );
  }
}
