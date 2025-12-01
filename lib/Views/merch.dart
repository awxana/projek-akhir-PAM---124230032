import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/merch_data.dart';
import '../Models/cart_manager.dart';
import 'cart_page.dart'; // Import CartPage
import 'favorite_merch.dart';

class MerchPage extends StatefulWidget {
  const MerchPage({super.key});

  // Contoh rute statis
  static const String routeName = '/merch';

  @override
  State<MerchPage> createState() => _MerchPageState();
}

class _MerchPageState extends State<MerchPage> {
  // --- Warna dan Kurs (Konstanta) ---
  static const Color valorantPink = Color(0xFFFF8FAB);
  static const Color valorantDark = Color(0xFF201628);
  static const Color valorantCard = Color(0xFF2A1E37);
  static const Color valorantWhite = Color(0xFFFFFFFF);

  final Map<String, double> currencyRates = {
    'USD': 1.0,
    'IDR': 15500.0,
    'EUR': 0.92,
    'KWD': 0.31,
  };
  String selectedCurrency = 'IDR';

  // Set of favorite merch ids
  Set<String> _favoriteIds = {};

  // Helper function untuk konversi dan format mata uang
  String _formatCurrency(double amountUsd) {
    final rate = currencyRates[selectedCurrency] ?? 1.0;
    final converted = amountUsd * rate;
    String symbol;
    String formattedAmount;

    switch (selectedCurrency) {
      case 'IDR':
        symbol = 'Rp ';
        // Format IDR dengan titik sebagai pemisah ribuan
        formattedAmount = converted.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
        break;
      case 'EUR':
        symbol = '€ ';
        formattedAmount = converted.toStringAsFixed(2);
        break;
      case 'KWD':
        symbol = 'KD ';
        formattedAmount = converted.toStringAsFixed(3);
        break;
      default:
        symbol = '\$';
        formattedAmount = converted.toStringAsFixed(2);
    }
    return '$symbol$formattedAmount $selectedCurrency';
  }
  // --- Akhir Warna dan Kurs ---

  // Fungsi navigasi ke CartPage
  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoriteMerch().getFavorites();
    if (mounted) {
      setState(() {
        _favoriteIds = favs.toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context, listen: false);

    void addToCartProvider(Merchandise merch) {
      cartManager.addItem(merch);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${merch.name} ditambahkan ke keranjang!'),
          duration: const Duration(seconds: 1),
          backgroundColor: valorantPink.withOpacity(0.8),
        ),
      );
    }

    return Scaffold(
      backgroundColor: valorantDark,
      appBar: AppBar(
        backgroundColor: valorantDark,
        elevation: 0,
        leading: const BackButton(color: valorantWhite),
        title: const Text(
          'MERCHANDISE VALORANT',
          style: TextStyle(
            color: valorantWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Ikon Keranjang dengan Notifikasi Jumlah Item (Consumer)
          Consumer<CartManager>(
            builder: (context, manager, child) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: valorantWhite),
                    onPressed: _goToCart, // Navigasi ke CartPage
                  ),
                  if (manager.itemCount > 0)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: valorantPink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${manager.itemCount}',
                        style: const TextStyle(
                          color: valorantDark,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                ],
              );
            },
          ),
          // Dropdown Mata Uang
          DropdownButton<String>(
            value: selectedCurrency,
            dropdownColor: valorantCard,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: valorantWhite),
            items: currencyRates.keys.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(c, style: const TextStyle(color: valorantWhite)),
              );
            }).toList(),
            onChanged: (val) {
              if (val == null) return;
              setState(() {
                selectedCurrency = val;
              });
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: merchList.length,
        itemBuilder: (context, index) {
          final merch = merchList[index];
          final convertedPrice = _formatCurrency(merch.priceUsd);
          final isFav = _favoriteIds.contains(merch.id);

          return Card(
            color: valorantCard.withOpacity(0.95),
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: valorantPink.withOpacity(0.35),
                width: 1.1,
              ),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Produk
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 78,
                      height: 78,
                      child: Image.asset(
                        merch.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: valorantDark,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.white24),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Detail Produk
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(merch.name,
                            style: const TextStyle(
                              color: valorantWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                        const SizedBox(height: 4),
                        Text(merch.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            )),
                        const SizedBox(height: 6),
                        Text(convertedPrice,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                  // Favorite + Add to Cart buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await FavoriteMerch().toggle(merch.id);
                          setState(() {
                            if (_favoriteIds.contains(merch.id)) {
                              _favoriteIds.remove(merch.id);
                            } else {
                              _favoriteIds.add(merch.id);
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFav
                                  ? '${merch.name} dihapus dari favorit'
                                  : '${merch.name} ditambahkan ke favorit'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: valorantPink.withOpacity(0.8),
                            ),
                          );
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? valorantPink : valorantWhite,
                          size: 20,
                        ),
                        tooltip: isFav ? 'Hapus Favorit' : 'Tambahkan Favorit',
                      ),
                      IconButton(
                        onPressed: () => addToCartProvider(merch),
                        icon: const Icon(Icons.add_shopping_cart,
                            color: valorantPink, size: 20),
                        tooltip: 'Tambahkan ke Keranjang',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
