import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Views/favorite_tiers.dart';

class AgentDetailPage extends StatefulWidget {
  final dynamic agent;

  const AgentDetailPage({super.key, required this.agent});

  @override
  State<AgentDetailPage> createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  bool isFavorite = false;

  // tema pink
  static const Color valoPink = Color(0xFFFF8FAB);
  static const Color valoDark = Color(0xFF201628);
  static const Color valoCard = Color(0xFF2A1E37);
  static const Color valoText = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    isFavorite = await FavoriteTiers().isFavorite(widget.agent);
    if (mounted) {
      setState(() {});
    }
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await FavoriteTiers().addToFavorites(widget.agent);
      _showSnackBar('Tier added to favorites!', valoPink);
    } else {
      await FavoriteTiers().removeFromFavorites(widget.agent);
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

  @override
  Widget build(BuildContext context) {
    // Data tier sekarang ada di `widget.agent`
    final tier = widget.agent;
    final tierName = tier['tierName'] as String? ?? 'Unknown Tier';
    final divisionName = tier['divisionName'] as String? ?? 'Unknown Division';
    final largeIcon = tier['largeIcon'] as String?;

    return Scaffold(
      backgroundColor: valoDark,
      appBar: AppBar(
        backgroundColor: valoDark,
        elevation: 0,
        foregroundColor: valoText,
        title: Text(
          tierName.toUpperCase(),
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
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon Peringkat
                  if (largeIcon != null)
                    Image.network(
                      largeIcon,
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shield_outlined,
                        color: valoPink,
                        size: 150,
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Nama Peringkat
                  Text(
                    tierName.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'ValorantFont',
                      fontSize: 32,
                      color: valoText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Nama Divisi
                  Text(
                    divisionName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'ValorantFont',
                      fontSize: 18,
                      color: valoText.withOpacity(0.7),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
