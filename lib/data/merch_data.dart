class Merchandise {
  final String name;
  final double priceUsd;
  final String imageUrl;
  final String description;

  Merchandise({
    required this.name,
    required this.priceUsd,
    required this.imageUrl,
    required this.description,
  });
}

// perhatiin: SEKARANG pake 'assets/...'
final List<Merchandise> merchList = [
  Merchandise(
    name: 'Valorant Hoodie',
    priceUsd: 75.0,
    imageUrl: 'assets/hoodie.png',
    description: 'Hoodie resmi Valorant dengan desain simpel dan warna gelap.',
  ),
  Merchandise(
    name: 'Gekko Mousepad',
    priceUsd: 30.0,
    imageUrl: 'assets/mousepad.png',
    description: 'Mousepad gaming bertema Valorant / Gekko ukuran besar.',
  ),
  Merchandise(
    name: 'Valorant T-Shirt',
    priceUsd: 25.0,
    imageUrl: 'assets/tshirt.png',
    description: 'Kaos Valorant kasual yang nyaman buat dipakai harian.',
  ),
  Merchandise(
    name: 'Valorant Keychain Set',
    priceUsd: 18.0,
    imageUrl: 'assets/keychain.jpg',
    description:
        'Set gantungan kunci karakter agent Valorant dengan bahan logam premium.',
  ),
  Merchandise(
    name: 'Jett Cap',
    priceUsd: 28.0,
    imageUrl: 'assets/cap.jpg',
    description:
        'Topi bertema agent Jett dengan logo bordir dan bahan katun nyaman.',
  ),
  Merchandise(
    name: 'Valorant Tumbler',
    priceUsd: 22.0,
    imageUrl: 'assets/mug.jpg',
    description:
        'Mug bertema Valorant, cocok untuk ngopi atau latihan aim.',
  ),
  Merchandise(
    name: 'Valorant Poster Collection',
    priceUsd: 40.0,
    imageUrl: 'assets/poster.jpg',
    description:
        'Poster edisi spesial berisi ilustrasi agent favorit seperti Gekko, Jett, dan Phoenix.',
  ),
];
