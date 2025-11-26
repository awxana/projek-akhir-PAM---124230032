import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  // warna disamain sama login/profile
  static const Color valoPink = Color(0xFFFF8FAB);
  static const Color valoDark = Color(0xFF201628);
  static const Color valoCard = Color(0xFF2A1E37);
  static const Color valoText = Color(0xFFFFFFFF);

  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valoDark,
      appBar: AppBar(
        backgroundColor: valoDark,
        elevation: 0,
        title: const Text(
          'FEEDBACK',
          style: TextStyle(
            fontFamily: 'ValorantFont',
            color: valoText,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: valoText,
        ),
      ),
      body: Stack(
        children: [
          // background image tipis (sama kayak login)
          Positioned.fill(
            child: Image.asset(
              'assets/valobackground.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.08),
            ),
          ),
          // overlay gradient (biar teks tetep kebaca)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  valoDark.withOpacity(0.35),
                  valoDark.withOpacity(0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // isi
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saran & Kesan',
                  style: TextStyle(
                    fontFamily: 'ValorantFont',
                    fontSize: 22,
                    color: valoText,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ISI HATI UNTUK PEMOGRAMAN MOBILE',
                  style: TextStyle(
                    fontSize: 13,
                    color: valoText.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                // CARD: SARAN
                _buildSection(
                  title: 'Saran',
                  subtitle: 'Untuk saran kedepannya 🛠️',
                  points: const [
                    '• Boleh yah ya pak buat banyakin latihan dan penjelasannya untuk matkul mobile agar kami lebih paham dan jago di matkul ini.',
                  ],
                ),
                const SizedBox(height: 16),

                // CARD: KESAN
                _buildSection(
                  title: 'Kesan',
                  subtitle: 'Yang dirasain selama Mobile 💪',
                  points: const [
                    '• jujur tugas ini sangat membuat saya mendekatkan diri kepada Tuhan.',
                    '• Overall: seru, menantang, layak direkomendasikan (asal tugasnya dikit).',
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // card ala dashboard tapi tema pink
  static Widget _buildSection({
    required String title,
    String? subtitle,
    required List<String> points,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: valoCard.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: valoPink.withOpacity(0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title card
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'ValorantFont',
              fontSize: 16,
              color: valoText,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.5,
                color: valoText.withOpacity(0.6),
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Divider(
            color: valoPink,
            thickness: 1.5,
          ),
          const SizedBox(height: 10),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: 14.5,
                  color: valoText.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
