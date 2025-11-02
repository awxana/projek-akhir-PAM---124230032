import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Views/favorite_tiers.dart';

class AgentDetailPage extends StatefulWidget {
  final dynamic representativeTier;
  final List<dynamic> subTiers;

  const AgentDetailPage(
      {super.key, required this.representativeTier, required this.subTiers});

  @override
  State<AgentDetailPage> createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  bool isFavorite = false;
  late PageController _pageController;
  int _currentPage = 0;

  // tema pink
  static const Color valoPink = Color(0xFFFF8FAB);
  static const Color valoDark = Color(0xFF201628);
  static const Color valoCard = Color(0xFF2A1E37);
  static const Color valoText = Colors.white;

  // Data deskripsi untuk setiap tier
  final Map<String, String> tierDescriptions = {
    'Iron':
        "🩶 *IRON*\n\n*Iron* adalah tingkatan awal dalam sistem kompetitif Valorant. Pemain di tier ini umumnya masih dalam tahap mempelajari dasar-dasar permainan, seperti kontrol tembakan, mekanik gerak, serta penggunaan kemampuan (abilities) dari setiap agent.\nMereka sering fokus pada pengenalan peta dan mencoba memahami peran tim. Tingkat koordinasi tim masih rendah, dan permainan sering berlangsung dengan gaya individual.\n\nPada tahap ini, pemain dianjurkan untuk berlatih *aim dasar, **pemanfaatan senjata ringan (Spectre, Guardian), serta mulai memahami **timing rotasi dan komunikasi sederhana*.\nTujuannya bukan sekadar menang, tetapi membangun dasar keterampilan agar siap menghadapi tingkat kompetitif yang lebih tinggi.",
    'Bronze':
        "🥉 *BRONZE*\n\n*Bronze* menandakan bahwa pemain telah memahami mekanik dasar dan mulai mencoba strategi sederhana dalam pertandingan.\nMereka sudah mengenal peta dengan lebih baik dan mulai menggunakan kemampuan agent secara efektif, meski masih sering melakukan kesalahan dalam timing atau positioning.\n\nPemain Bronze biasanya sudah aktif berkomunikasi dan mencoba bermain sesuai peran tim. Namun, konsistensi performa masih menjadi tantangan utama.\nUntuk naik ke tier berikutnya, pemain perlu belajar *menjaga ekonomi tim, **melatih kesabaran, serta **mengasah refleks tembakan dan awareness musuh*.",
    'Silver':
        "🥈 *SILVER*\n\n*Silver* adalah tahap transisi dari pemain kasual menuju pemain yang mulai memahami konsep kompetitif.\nDi tier ini, kemampuan menembak dan koordinasi mulai stabil, namun pemain sering kali masih belum bisa menutup kesalahan taktis seperti posisi terbuka atau rotasi yang terlambat.\n\nPemain Silver biasanya sudah mampu membaca situasi gim dan menyesuaikan strategi.\nUntuk berkembang, fokuslah pada *komunikasi aktif, **pemanfaatan utilitas tim, serta **meningkatkan akurasi dan prediksi pergerakan lawan*.\nSilver sering disebut sebagai “zona nyaman” banyak pemain Valorant — tapi hanya pemain yang sabar dan adaptif yang bisa menembus ke tier berikutnya.",
    'Gold':
        "🥇 *GOLD*\n\n*Gold* adalah titik di mana pemain mulai menunjukkan gaya bermain yang matang dan memahami makna permainan tim sebenarnya.\nPemain Gold biasanya sudah menguasai teknik dasar seperti *spray control, **utility usage, dan **posisi bertahan* dengan baik. Mereka mulai berpikir lebih strategis dan menilai lawan berdasarkan pola permainan.\n\nTier ini juga dikenal sebagai “batas menengah” antara pemain kasual dan semi-kompetitif.\nUntuk naik ke Platinum, pemain harus memperkuat *komunikasi tim, **adaptasi terhadap meta, dan **kedisiplinan dalam bermain objektif* (plant/defuse, rotasi, eco-round, dll).\nKonsistensi dan kerja sama jadi kunci utama di level ini.",
    'Platinum':
        "💎 *PLATINUM*\n\n*Platinum* menunjukkan bahwa pemain telah memiliki kemampuan mekanik yang kuat dan pemahaman taktis yang baik.\nPemain di tier ini mampu *mengatur ritme permainan*, membaca situasi lawan, dan menyesuaikan gaya bermain dengan komposisi tim.\n\nMereka sering memanfaatkan kemampuan agent dengan sangat efektif — bukan sekadar untuk menyerang, tapi juga untuk membuka informasi dan menciptakan peluang strategis.\nKesalahan kecil di tier ini bisa berakibat besar, sehingga *komunikasi cepat, **reaksi instan, dan **team coordination* sangat penting.",
    'Diamond':
        "💎✨ *DIAMOND*\n\n*Diamond* adalah tingkatan di mana permainan sudah terasa seperti kompetisi profesional tingkat dasar.\nPemain di level ini memahami *meta terbaru, **kombinasi agent*, dan mampu membaca strategi lawan dalam waktu singkat.\nMereka cenderung bermain dengan kesabaran, memperhitungkan setiap rotasi dan penggunaan utilitas dengan sangat hati-hati.\n\nUntuk naik ke tier berikutnya, pemain Diamond harus memperkuat *decision-making di bawah tekanan* dan *meningkatkan adaptasi* terhadap gaya bermain tim lawan.\nLevel ini menjadi gerbang awal menuju kategori pemain elit.",
    'Ascendant':
        "🔮 *ASCENDANT*\n\n*Ascendant* adalah tier di mana pemain sudah sangat kompeten, sering disebut sebagai pemain tingkat tinggi (high-rank players).\nMereka memiliki kemampuan mekanik hampir sempurna dan pemahaman taktik yang mendalam.\nBiasanya, pemain Ascendant sudah mulai aktif bermain dalam team ranked, turnamen kecil, atau komunitas kompetitif.\n\nDi level ini, komunikasi, kontrol emosi, dan konsistensi performa jauh lebih penting daripada sekadar kemampuan menembak.\nKesalahan kecil bisa memengaruhi hasil pertandingan, jadi fokus dan kesabaran menjadi kunci utama.",
    'Immortal':
        "🩵 *IMMORTAL*\n\n*Immortal* adalah tingkatan untuk pemain elit yang sudah menunjukkan performa di atas rata-rata.\nMereka mampu mengendalikan tempo permainan, memimpin tim, dan membaca strategi lawan secara akurat.\nKoordinasi, posisi, dan manajemen waktu menjadi aspek yang sangat diperhatikan.\n\nDi level ini, mayoritas pemain sudah punya *refleks cepat, **decision-making yang matang, serta **pengalaman bermain kompetitif tinggi*.\nBiasanya pemain Immortal sudah berada di tahap semi-pro atau calon Radiant.",
    'Radiant':
        "🩶🌟 *RADIANT*\n\n*Radiant* adalah peringkat tertinggi dalam sistem kompetitif Valorant — tempat para pemain terbaik di tiap wilayah berada.\nTier ini mencerminkan *puncak keterampilan mekanik, taktik, dan komunikasi tim*.\nPemain Radiant memiliki kemampuan luar biasa dalam membaca situasi, mengatur strategi, dan menjaga stabilitas performa bahkan di bawah tekanan ekstrem.\n\nSetiap keputusan yang diambil di level ini memiliki dampak besar terhadap jalannya pertandingan.\nMereka bukan hanya bermain untuk menang, tetapi juga untuk mempertahankan reputasi dan konsistensi di level tertinggi.\nRadiant adalah simbol prestasi dan pengakuan tertinggi dalam dunia kompetitif Valorant.",
  };

  @override
  void initState() {
    super.initState();
    // Mengurutkan sub-tier agar tampil berurutan (misal: Bronze 1, 2, 3)
    widget.subTiers.sort((a, b) {
      return (a['tierName'] as String).compareTo(b['tierName'] as String);
    });
    _pageController = PageController();
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    isFavorite = await FavoriteTiers().isFavorite(widget.representativeTier);
    if (mounted) {
      setState(() {});
    }
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await FavoriteTiers().addToFavorites(widget.representativeTier);
      _showSnackBar('Tier added to favorites!', valoPink);
    } else {
      await FavoriteTiers().removeFromFavorites(widget.representativeTier);
      _showSnackBar('Tier removed from favorites!', valoCard);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: valoText, fontFamily: 'ValorantFont'),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Widget untuk mem-parsing dan menampilkan teks deskripsi dengan format bold
  Widget _buildDescription(String text) {
    List<TextSpan> spans = [];
    // Regex untuk menemukan teks di antara tanda bintang, termasuk **
    text.splitMapJoin(
      RegExp(r'\*{1,2}(.*?)\*{1,2}'),
      onMatch: (m) {
        spans.add(TextSpan(
          text: m.group(1), // Teks di dalam tanda bintang
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: valoPink, // Beri warna pink agar menonjol
          ),
        ));
        return '';
      },
      onNonMatch: (n) {
        spans.add(TextSpan(text: n));
        return '';
      },
    );

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
          style: TextStyle(
              fontSize: 14.5, color: valoText.withOpacity(0.9), height: 1.5),
          children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil nama dasar dari tier perwakilan untuk judul
    String baseTierName =
        (widget.representativeTier['tierName'] as String? ?? 'Unknown Tier')
            .split(' ')
            .first;

    // Pastikan format kapitalisasi benar (misal: "iron" -> "Iron")
    if (baseTierName.isNotEmpty) {
      baseTierName = baseTierName[0].toUpperCase() +
          baseTierName.substring(1).toLowerCase();
    }

    // Ambil deskripsi yang sesuai
    final description = tierDescriptions[baseTierName] ??
        'No description available for this tier.';

    return Scaffold(
      backgroundColor: valoDark,
      appBar: AppBar(
        backgroundColor: valoDark,
        elevation: 0,
        foregroundColor: valoText,
        title: Text(
          baseTierName.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'ValorantFont',
            color: valoText,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? valoPink : valoText.withOpacity(0.6),
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/valobackground.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.12),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  valoDark.withOpacity(0.4),
                  valoDark.withOpacity(0.98),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                // PageView untuk slider gambar
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.subTiers.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final tier = widget.subTiers[index];
                      final largeIcon = tier['largeIcon'] as String?;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: largeIcon != null
                            ? Image.network(
                                largeIcon,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.shield_outlined,
                                  color: valoPink,
                                  size: 150,
                                ),
                              )
                            : const Icon(
                                Icons.shield_outlined,
                                color: valoPink,
                                size: 150,
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Nama tier yang sedang aktif
                if (widget.subTiers.isNotEmpty)
                  Text(
                    (widget.subTiers[_currentPage]['tierName'] as String? ?? '')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'ValorantFont',
                      fontSize: 28,
                      color: valoText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                const SizedBox(height: 20),

                // Indikator titik-titik (dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.subTiers.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? valoPink
                            : valoText.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          // Geser ke bawah untuk melihat deskripsi
          DraggableScrollableSheet(
            initialChildSize: 0.35, // Ukuran awal sheet
            minChildSize: 0.15, // Ukuran minimum saat ditarik ke bawah
            maxChildSize: 0.8, // Ukuran maksimum saat ditarik ke atas
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: valoCard.withOpacity(0.9),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(color: valoPink.withOpacity(0.2)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                            color: valoText.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Konten deskripsi
                    _buildDescription(description),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
