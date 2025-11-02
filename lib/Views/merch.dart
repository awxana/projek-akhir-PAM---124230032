import 'package:flutter/material.dart';
import '../data/merch_data.dart';

class MerchPage extends StatefulWidget {
  const MerchPage({super.key});

  @override
  State<MerchPage> createState() => _MerchPageState();
}

class _MerchPageState extends State<MerchPage> {
  // copy warna dari dashboard (biar gak circular import)
  static const Color valorantPink = Color(0xFFFF8FAB);
  static const Color valorantDark = Color(0xFF201628);
  static const Color valorantCard = Color(0xFF2A1E37);
  static const Color valorantWhite = Color(0xFFFFFFFF);

  // kurs statis
  final Map<String, double> currencyRates = {
    'USD': 1.0,
    'IDR': 15500.0,
    'EUR': 0.92,
    'KWD': 0.31,
  };

  String selectedCurrency = 'IDR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDark,
      appBar: AppBar(
        backgroundColor: valorantDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: valorantWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MERCHANDISE VALORANT',
          style: TextStyle(
            color: valorantWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: selectedCurrency,
            dropdownColor: valorantCard,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: valorantWhite),
            items: currencyRates.keys.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(
                  c,
                  style: const TextStyle(color: valorantWhite),
                ),
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
      body: Stack(
        children: [
          // background gambar biar mirip dashboard
          Positioned.fill(
            child: Image.asset(
              'assets/valobackground.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.12),
            ),
          ),
          // overlay gradasi biar teksnya kebaca
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    valorantDark.withOpacity(0.4),
                    valorantDark.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          // konten
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: merchList.length,
            itemBuilder: (context, index) {
              final merch = merchList[index];

              // hitung konversi
              final rate = currencyRates[selectedCurrency] ?? 1.0;
              final converted = merch.priceUsd * rate;

              // simbol
              String symbol;
              switch (selectedCurrency) {
                case 'IDR':
                  symbol = 'Rp ';
                  break;
                case 'EUR':
                  symbol = '€ ';
                  break;
                case 'KWD':
                  symbol = 'KD ';
                  break;
                default:
                  symbol = '\$';
              }

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
                shadowColor: valorantPink.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gambar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 78,
                          height: 78,
                          child: Image.asset(
                            merch.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // kalau asset belum ada, jangan sampai layout rusak
                              return Container(
                                color: valorantDark,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // teks
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              merch.name,
                              style: const TextStyle(
                                color: valorantWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              merch.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${merch.priceUsd.toStringAsFixed(2)} USD',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '≈ $symbol${selectedCurrency == 'IDR' ? converted.toStringAsFixed(0) : converted.toStringAsFixed(2)} $selectedCurrency',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // tombol info
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: valorantDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                merch.name,
                                style: const TextStyle(
                                  color: valorantWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      merch.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const SizedBox(
                                          height: 80,
                                          child: Center(
                                            child: Text(
                                              'Gambar tidak tersedia',
                                              style: TextStyle(
                                                  color: Colors.white54),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    merch.description,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Harga asli: \$${merch.priceUsd.toStringAsFixed(2)} USD',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Konversi: $symbol${selectedCurrency == 'IDR' ? converted.toStringAsFixed(0) : converted.toStringAsFixed(2)} $selectedCurrency',
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white30,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
