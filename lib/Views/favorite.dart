import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Views/detail.dart';
import 'package:projectakhir_mobile/Views/favorite_tiers.dart';

class FavoriteAgentsPage extends StatefulWidget {
  const FavoriteAgentsPage({super.key});

  @override
  State<FavoriteAgentsPage> createState() => _FavoriteAgentsPageState();
}

class _FavoriteAgentsPageState extends State<FavoriteAgentsPage> {
  late Future<List<dynamic>> _favoriteTiersFuture;

  // Menggunakan warna dari halaman lain agar konsisten
  static const Color valoPink = Color(0xFFFF8FAB);
  static const Color valoDark = Color(0xFF201628);
  static const Color valoCard = Color(0xFF2A1E37);
  static const Color valoText = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoriteTiersFuture = FavoriteTiers().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valoDark, // Main background
      appBar: AppBar(
        backgroundColor: valoDark,
        elevation: 0,
        foregroundColor: valoText,
        title: const Text(
          'FAVORITE TIERS',
          style: TextStyle(
            fontFamily: 'ValorantFont', // Custom font
            color: valoText,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favoriteTiersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    valoPink), // Valorant Red indicator
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'ERROR LOADING FAVORITES: ${snapshot.error}',
                style: const TextStyle(
                  fontFamily: 'ValorantFont',
                  color: valoPink,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border, // Use the bookmark icon
                    color: valoCard,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'NO FAVORITE TIERS YET',
                    style: TextStyle(
                      fontFamily: 'ValorantFont',
                      color: valoText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add tiers to your favorites from their detail pages.',
                    style: TextStyle(
                      fontFamily: 'ValorantFont',
                      color: valoText.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            List<dynamic> favoriteTiers = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteTiers.length,
              itemBuilder: (context, index) {
                dynamic agent = favoriteTiers[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 12.0), // Spacing between list tiles
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentDetailPage(
                              representativeTier: agent, subTiers: []),
                        ),
                      ).then((_) => _loadFavorites());
                    },
                    child: Card(
                      color: valoCard, // Dark grey card background
                      elevation: 6, // Subtle shadow
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                        side: BorderSide(
                          color: valoPink.withOpacity(0.4), // Subtle red border
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipOval(
                              // Circular image for leading icon
                              child: Image.network(
                                agent['largeIcon'] ?? agent['smallIcon'] ?? '',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: valoDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.broken_image,
                                      color: valoPink, size: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (agent['tierName'] ?? 'Unknown Tier')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'ValorantFont',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          valoPink, // Agent name in Valorant Red
                                      letterSpacing: 0.8,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    (agent['divisionName'] ??
                                            'Unknown Division')
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'ValorantFont',
                                      fontSize: 14,
                                      color: valoText.withOpacity(0.8),
                                    ),
                                    maxLines: 2, // Limit description to 2 lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
