import 'package:flutter/material.dart';
import '../data/merch_data.dart';
import 'favorite_merch.dart';
import 'package:provider/provider.dart';
import '../Models/cart_manager.dart';

class MerchDetailPage extends StatefulWidget {
  final Merchandise merch;
  const MerchDetailPage({super.key, required this.merch});

  @override
  State<MerchDetailPage> createState() => _MerchDetailPageState();
}

class _MerchDetailPageState extends State<MerchDetailPage> {
  bool _isFavorite = false;

  static const Color valorantPink = Color(0xFFFF8FAB);
  static const Color valorantDark = Color(0xFF201628);
  static const Color valorantCard = Color(0xFF2A1E37);
  static const Color valorantWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final fav = await FavoriteMerch().isFavorite(widget.merch.id);
    if (mounted) setState(() => _isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    await FavoriteMerch().toggle(widget.merch.id);
    final nowFav = await FavoriteMerch().isFavorite(widget.merch.id);
    if (mounted) setState(() => _isFavorite = nowFav);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowFav
            ? '${widget.merch.name} ditambahkan ke favorit'
            : '${widget.merch.name} dihapus dari favorit'),
        duration: const Duration(seconds: 1),
        backgroundColor: valorantPink.withOpacity(0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDark,
      appBar: AppBar(
        backgroundColor: valorantDark,
        elevation: 0,
        title: Text(widget.merch.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? valorantPink : valorantWhite),
            onPressed: () async {
              await _toggleFavorite();
              // return to previous screen when toggling? no — just update
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.merch.imageUrl,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 220,
                    height: 220,
                    color: valorantDark,
                    child: const Icon(Icons.broken_image, color: Colors.white24, size: 80),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.merch.name,
                style: const TextStyle(
                    color: valorantWhite, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('USD ${widget.merch.priceUsd.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
            const SizedBox(height: 12),
            Text(widget.merch.description,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await _toggleFavorite();
                  },
                  icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                  label: Text(_isFavorite ? 'Hapus Favorit' : 'Tambah Favorit'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: valorantPink, foregroundColor: valorantDark),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    final cartManager = Provider.of<CartManager>(context, listen: false);
                    cartManager.addItem(widget.merch);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.merch.name} ditambahkan ke keranjang'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: valorantPink.withOpacity(0.9),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: valorantCard, foregroundColor: valorantWhite),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
