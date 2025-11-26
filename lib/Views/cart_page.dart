import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../Models/cart_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // --- Warna dan Kurs (Konstanta) ---
  static const Color valorantPink = Color(0xFFFF8FAB);
  static const Color valorantDark = Color(0xFF201628);
  static const Color valorantCard = Color(0xFF2A1E37);
  static const Color valorantWhite = Color(0xFFFFFFFF);

  final TextEditingController _promoController = TextEditingController();
  final Map<String, double> currencyRates = {
    'USD': 1.0,
    'IDR': 15500.0,
    'EUR': 0.92,
    'KWD': 0.31,
  };
  String selectedCurrency = 'IDR';

  @override
  void initState() {
    super.initState();
    // Inisialisasi mata uang default, bisa disinkronkan dengan state di MerchPage jika ada
    // Untuk demo ini, kita biarkan default 'IDR'
  }

  // Helper function untuk konversi dan format mata uang
  String _formatCurrency(double amountUsd) {
    if (amountUsd < 0) amountUsd = 0; 
    final rate = currencyRates[selectedCurrency] ?? 1.0;
    final converted = amountUsd * rate;
    String symbol;
    String formattedAmount;

    switch (selectedCurrency) {
      case 'IDR':
        symbol = 'Rp ';
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

  // Logika Checkout (Simulasi Pembayaran)
  void _checkout(CartManager manager) {
    if (manager.cartItems.isEmpty) return;

    // 1. Simulasikan pemrosesan
    final finalPrice = manager.totalPriceUsd;

    // 2. Clear Cart (sebelum dialog muncul, untuk mencegah error)
    manager.clearCart();
    
    // 3. Tampilkan Konfirmasi Pesanan
    final orderId = Random().nextInt(90000) + 10000;
    FocusScope.of(context).unfocus(); 

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: valorantCard,
        title: const Text('Pembayaran Berhasil!', style: TextStyle(color: Colors.greenAccent)),
        content: Text(
          'Pesanan Anda sudah diproses dengan total ${_formatCurrency(finalPrice)}.\n\nNomor Pesanan Anda:\n#VALO$orderId',
          style: const TextStyle(color: valorantWhite),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Kembali ke MerchPage
            },
            child: const Text('OK', style: TextStyle(color: valorantPink)),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk baris detail harga
  Widget _buildPriceRow(String title, String amount, Color color, {bool isBold = false, double size = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: valorantWhite,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: size)),
          Text(amount,
              style: TextStyle(
                  color: color,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: size)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer agar otomatis me-rebuild saat CartManager berubah
    return Consumer<CartManager>(
      builder: (context, manager, child) {
        return Scaffold(
          backgroundColor: valorantDark,
          appBar: AppBar(
            backgroundColor: valorantDark,
            title: const Text('Keranjang & Checkout',
                style: TextStyle(color: valorantWhite)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: valorantWhite),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
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
          body: manager.cartItems.isEmpty
              ? Center(
                  child: Text('Keranjang kosong. Tambahkan item dari halaman produk!',
                      style: TextStyle(color: Colors.white70.withOpacity(0.8))),
                )
              : Column(
                  children: [
                    // 1. Daftar Item Keranjang
                    Expanded(
                      child: ListView.builder(
                        itemCount: manager.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = manager.cartItems[index];
                          final itemTotal = _formatCurrency(item.merch.priceUsd * item.quantity);
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(item.merch.imageUrl, 
                                width: 50, height: 50, fit: BoxFit.cover, 
                                errorBuilder: (c,e,s) => Container(color: valorantDark, child: const Icon(Icons.image_not_supported, color: Colors.white24, size: 40))),
                            ),
                            title: Text(item.merch.name,
                                style: const TextStyle(color: valorantWhite)),
                            subtitle: Text(
                                'Total: $itemTotal',
                                style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            // Kontrol Kuantitas
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: item.quantity > 1 ? valorantPink : Colors.white24),
                                  onPressed: () => manager.removeItem(item.merch),
                                  tooltip: 'Kurangi Kuantitas',
                                ),
                                Text('${item.quantity}',
                                    style: const TextStyle(color: valorantWhite)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle,
                                      color: Colors.greenAccent),
                                  onPressed: () => manager.addItem(item.merch),
                                  tooltip: 'Tambah Kuantitas',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(color: Colors.white12),

                    // 2. Simulasi Promo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              style: const TextStyle(color: valorantWhite),
                              decoration: InputDecoration(
                                labelText: 'Kode Promo (Coba: RIOT20)',
                                labelStyle: const TextStyle(color: Colors.white54),
                                hintText: manager.discountUsd > 0 ? 'Promo Diterapkan!' : 'Masukkan kode diskon',
                                hintStyle: TextStyle(color: manager.discountUsd > 0 ? Colors.greenAccent : Colors.white24),
                                border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: valorantPink)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                manager.applyPromo(_promoController.text.trim());
                                // Tampilkan notifikasi
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(manager.discountUsd > 0 
                                        ? 'Promo RIOT20 berhasil! Diskon ${_formatCurrency(manager.discountUsd)} diterapkan.'
                                        : 'Kode promo tidak valid.'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: manager.discountUsd > 0 ? Colors.green.withOpacity(0.8) : valorantPink.withOpacity(0.8),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: valorantPink,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Apply', style: TextStyle(color: valorantDark, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 3. Detail Harga (Kalkulasi)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildPriceRow('Subtotal (${manager.itemCount} item)', _formatCurrency(manager.subtotalUsd), valorantWhite),
                          if (manager.discountUsd > 0)
                            _buildPriceRow('Diskon Promo', '- ${_formatCurrency(manager.discountUsd)}', Colors.redAccent),
                          _buildPriceRow('Biaya Kirim', manager.shippingFeeUsd > 0 ? _formatCurrency(manager.shippingFeeUsd) : 'Gratis', valorantWhite),
                          const Divider(color: Colors.white30, height: 20),
                          _buildPriceRow('Total Akhir', _formatCurrency(manager.totalPriceUsd), Colors.greenAccent, isBold: true, size: 18),
                        ],
                      ),
                    ),

                    // 4. Tombol Checkout Utama
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _checkout(manager),
                          icon: const Icon(Icons.payment, color: valorantDark),
                          label: Text(
                            'Checkout (${_formatCurrency(manager.totalPriceUsd)})',
                            style: const TextStyle(
                                color: valorantDark, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: valorantPink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}