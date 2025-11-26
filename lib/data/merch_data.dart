class Merchandise {
  final String id;
  final String name;
  final double priceUsd;
  final String imageUrl;
  final String description;

  Merchandise({
    required this.id,
    required this.name,
    required this.priceUsd,
    required this.imageUrl,
    required this.description,
  });
}

// perhatiin: SEKARANG pake 'assets/...'
final List<Merchandise> merchList = [
  Merchandise(
    id: 'hoodie',
    name: 'Valorant Hoodie',
    priceUsd: 75.0,
    imageUrl: 'assets/hoodie.png',
    description: 'Hoodie resmi Valorant dengan desain simpel dan warna gelap.',
  ),
  Merchandise(
    id: 'mousepad',
    name: 'Gekko Mousepad',
    priceUsd: 30.0,
    imageUrl: 'assets/mousepad.png',
    description: 'Mousepad gaming bertema Valorant / Gekko ukuran besar.',
  ),
  Merchandise(
    id: 'tshirt',
    name: 'Valorant T-Shirt',
    priceUsd: 25.0,
    imageUrl: 'assets/tshirt.png',
    description: 'Kaos Valorant kasual yang nyaman buat dipakai harian.',
  ),
  Merchandise(
    id: 'keychain',
    name: 'Valorant Keychain Set',
    priceUsd: 18.0,
    imageUrl: 'assets/keychain.jpg',
    description:
        'Set gantungan kunci karakter agent Valorant dengan bahan logam premium.',
  ),
  Merchandise(
    id: 'cap',
    name: 'Jett Cap',
    priceUsd: 28.0,
    imageUrl: 'assets/cap.jpg',
    description:
        'Topi bertema agent Jett dengan logo bordir dan bahan katun nyaman.',
  ),
  Merchandise(
    id: 'mug',
    name: 'Valorant Tumbler',
    priceUsd: 22.0,
    imageUrl: 'assets/mug.jpg',
    description: 'Mug bertema Valorant, cocok untuk ngopi atau latihan aim.',
  ),
  Merchandise(
    id: 'poster',
    name: 'Valorant Poster Collection',
    priceUsd: 40.0,
    imageUrl: 'assets/poster.jpg',
    description:
        'Poster edisi spesial berisi ilustrasi agent favorit seperti Gekko, Jett, dan Phoenix.',
  ),
];
