import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Views/detail.dart';
import 'package:projectakhir_mobile/Views/favorite_tiers.dart';
import 'package:projectakhir_mobile/Views/favorite_merch.dart';
import 'package:projectakhir_mobile/data/merch_data.dart';
import 'package:projectakhir_mobile/Views/merch_detail.dart';
import 'package:provider/provider.dart';
import 'package:projectakhir_mobile/Models/cart_manager.dart';

class FavoriteAgentsPage extends StatefulWidget {
  const FavoriteAgentsPage({super.key});

  @override
  State<FavoriteAgentsPage> createState() => _FavoriteAgentsPageState();
}

class _FavoriteAgentsPageState extends State<FavoriteAgentsPage> {
  late Future<List<dynamic>> _favoriteTiersFuture;
  late Future<List<String>> _favoriteMerchIdsFuture;

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
      _favoriteMerchIdsFuture = FavoriteMerch().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: valoDark, // Main background
        appBar: AppBar(
          backgroundColor: valoDark,
          elevation: 0,
          foregroundColor: valoText,
          title: const Text(
            'FAVORITES',
            style: TextStyle(
              fontFamily: 'ValorantFont', // Custom font
              color: valoText,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tiers'),
              Tab(text: 'Merch'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tiers Tab (original behavior)
            FutureBuilder<List<dynamic>>(
              future: _favoriteTiersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(valoPink),
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
                          Icons.favorite_border,
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
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                    builder: (context) => AgentDetailPage(
                                      representativeTier: agent,
                                      subTiers: []),
                              ),
                            ).then((_) => _loadFavorites());
                          },
                          child: Card(
                            color: valoCard,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: valoPink.withOpacity(0.4),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      agent['largeIcon'] ?? agent['smallIcon'] ?? '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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
                                            color: valoPink,
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
                                          maxLines: 2,
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

            // Merch Tab - show favorite merch items
            FutureBuilder<List<String>>(
              future: _favoriteMerchIdsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(valoPink),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'ERROR LOADING FAVORITE MERCH: ${snapshot.error}',
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
                          Icons.shopping_bag_outlined,
                          color: valoCard,
                          size: 80,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'NO FAVORITE MERCH',
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
                          'Mark merch as favorite from the merch page.',
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
                  final ids = snapshot.data!;
                  final favMerch = merchList
                      .where((m) => ids.contains(m.id))
                      .toList(growable: false);

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favMerch.length,
                    itemBuilder: (context, index) {
                      final m = favMerch[index];
                      return Card(
                        color: valoCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: valoPink.withOpacity(0.3)),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MerchDetailPage(
                                        merch: m,
                                      )),
                            ).then((_) => _loadFavorites());
                          },
                          
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              m.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 56,
                                height: 56,
                                color: valoDark,
                                child: const Icon(Icons.broken_image,
                                    color: valoPink),
                              ),
                            ),
                          ),
                          title: Text(
                            m.name,
                            style: const TextStyle(
                                fontFamily: 'ValorantFont',
                                color: valoText,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'USD ${m.priceUsd.toStringAsFixed(2)}',
                            style: TextStyle(color: valoText.withOpacity(0.7)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart, color: Colors.white70),
                                tooltip: 'Add to Cart',
                                onPressed: () {
                                  final cartManager = Provider.of<CartManager>(context, listen: false);
                                  cartManager.addItem(m);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${m.name} ditambahkan ke keranjang'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: valoPink.withOpacity(0.9),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.redAccent),
                                onPressed: () async {
                                  await FavoriteMerch().toggle(m.id);
                                  _loadFavorites();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${m.name} dihapus dari favorit'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: valoPink.withOpacity(0.9),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
