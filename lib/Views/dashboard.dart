import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projectakhir_mobile/Views/datadiri.dart';
import 'package:projectakhir_mobile/Views/detail.dart';
import 'package:projectakhir_mobile/Views/favorite.dart';
import 'package:projectakhir_mobile/Views/login_screen.dart';
import 'package:projectakhir_mobile/Views/sarankesan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();

  // warna baru – vibes feminim
  static const Color valorantPink = Color(0xFFFF8FAB);
  static const Color valorantDark = Color(0xFF201628);
  static const Color valorantCard = Color(0xFF2A1E37);
  static const Color valorantSoft = Color(0xFFFDE2E4);
  static const Color valorantAccent = Color(0xFFBDE0FE);
  static const Color valorantWhite = Color(0xFFFFFFFF);
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> tiers = [];
  List<dynamic> searchResults = [];
  bool isSearching = false;

  late SharedPreferences prefs;

  // timezone user
  List<String> selectedTimezones = ['WIB', 'WITA', 'WIT', 'LONDON'];

  @override
  void initState() {
    super.initState();
    _initialSetup();
    fetchTiers();
  }

  void _initialSetup() async {
    prefs = await SharedPreferences.getInstance();

    final saved = prefs.getStringList('selected_timezones');
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        selectedTimezones = saved;
      });
    }
  }

  Future<void> fetchTiers() async {
    final response = await http
        .get(Uri.parse('https://valorant-api.com/v1/competitivetiers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // Ambil episode terakhir (yang paling relevan)
      if (data != null && data.isNotEmpty) {
        final latestEpisode = data.last;
        setState(() {
          // Filter tier yang tidak digunakan
          tiers = latestEpisode['tiers']
              .where((tier) =>
                  tier['tierName'] != null &&
                  !tier['tierName'].toLowerCase().contains('unused'))
              .toList();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to fetch competitive tiers. Please try again later.',
            style: TextStyle(color: DashboardPage.valorantWhite),
          ),
          backgroundColor: DashboardPage.valorantPink,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      throw Exception('Failed to fetch competitive tiers');
    }
  }

  void searchTiers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        isSearching = true;
        searchResults = tiers.where((tier) {
          final tierName = tier['tierName'] as String? ?? '';
          return tierName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        isSearching = false;
        searchResults = [];
      }
    });
  }

  // animasi fade
  void _pushWithFade(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  void navigateToDetailPage(dynamic tier) {
    _pushWithFade(
        AgentDetailPage(agent: tier)); // 'agent' prop now holds tier data
  }

  void navigateToFavoriteAgentsPage() {
    _pushWithFade(const FavoriteAgentsPage());
  }

  void navigateToProfilePage() {
    _pushWithFade(const ProfilePage());
  }

  void navigateToFeedbackPage() {
    _pushWithFade(const FeedbackPage());
  }

  void navigateToLogout() async {
    await prefs.remove("username");
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // bottom sheet timezone
  void _openTimezonePicker() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: DashboardPage.valorantCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        List<String> tempSelected = List.from(selectedTimezones);
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget buildCheckbox(String label) {
              return CheckboxListTile(
                value: tempSelected.contains(label),
                onChanged: (val) {
                  setModalState(() {
                    if (val == true) {
                      tempSelected.add(label);
                    } else {
                      tempSelected.remove(label);
                    }
                  });
                },
                title: Text(
                  label,
                  style: const TextStyle(
                    color: DashboardPage.valorantWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                activeColor: DashboardPage.valorantPink,
                checkColor: DashboardPage.valorantWhite,
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          DashboardPage.valorantWhite.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pilih Zona Waktu',
                    style: TextStyle(
                      color: DashboardPage.valorantWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildCheckbox('WIB'),
                  buildCheckbox('WITA'),
                  buildCheckbox('WIT'),
                  buildCheckbox('LONDON'),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DashboardPage.valorantPink,
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, tempSelected);
                      },
                      child: const Text(
                        'SIMPAN',
                        style: TextStyle(
                          color: DashboardPage.valorantWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      final nonEmptyResult = result.isEmpty ? ['WIB'] : result;

      setState(() {
        selectedTimezones = nonEmptyResult;
      });
      await prefs.setStringList('selected_timezones', selectedTimezones);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardPage.valorantDark,
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/valorant-logo.png',
                  height: 30,
                  color: DashboardPage.valorantPink,
                ),
                const SizedBox(width: 10),
                const Text(
                  'VALORANT TIERS',
                  style: TextStyle(
                    color: DashboardPage.valorantWhite,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            ValorantTimeDisplay(
              selectedTimezones: selectedTimezones,
            ),
          ],
        ),
        backgroundColor: DashboardPage.valorantDark,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _openTimezonePicker,
            icon: const Icon(Icons.access_time,
                color: DashboardPage.valorantWhite),
            tooltip: 'Pilih zona waktu',
          ),
        ],
      ),
      body: tiers.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(DashboardPage.valorantPink),
              ),
            )
          : Column(
              children: [
                // search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: searchTiers,
                    style: const TextStyle(color: DashboardPage.valorantWhite),
                    decoration: InputDecoration(
                      hintText: 'Search tier by name...',
                      hintStyle: TextStyle(
                        color:
                            DashboardPage.valorantWhite.withValues(alpha: 0.5),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: DashboardPage.valorantPink),
                      filled: true,
                      fillColor: DashboardPage.valorantCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color:
                              DashboardPage.valorantPink.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                            color: DashboardPage.valorantPink, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/valobackground.jpg',
                          fit: BoxFit.cover,
                          opacity: const AlwaysStoppedAnimation(0.15),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              DashboardPage.valorantDark.withValues(alpha: 0.2),
                              DashboardPage.valorantDark.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),
                      isSearching
                          ? _buildTierGrid(searchResults)
                          : _buildTierGrid(tiers),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        child: BottomNavigationBar(
          backgroundColor: DashboardPage.valorantCard,
          selectedItemColor: DashboardPage.valorantPink,
          unselectedItemColor:
              DashboardPage.valorantWhite.withValues(alpha: 0.5),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'FAVORITES',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'PROFILE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: 'FEEDBACK',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'LOGOUT',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                navigateToFavoriteAgentsPage();
                break;
              case 1:
                navigateToProfilePage();
                break;
              case 2:
                navigateToFeedbackPage();
                break;
              case 3:
                navigateToLogout();
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildTierGrid(List<dynamic> tierList) {
    if (tierList.isEmpty && isSearching) {
      return const Center(
        child: Text(
          'NO TIERS FOUND',
          style: TextStyle(
            color: DashboardPage.valorantWhite,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (tierList.isEmpty && !isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(DashboardPage.valorantPink),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        // 👉 bikin kartu LEBIH TINGGI dikiiit, biar gak overflow
        childAspectRatio: 0.78,
      ),
      itemCount: tierList.length,
      itemBuilder: (context, index) {
        final tier = tierList[index];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 350 + (index * 40)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () => navigateToDetailPage(tier),
            child: Card(
              color: DashboardPage.valorantCard,
              elevation: 8,
              shadowColor: DashboardPage.valorantPink.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: DashboardPage.valorantPink.withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // gambar
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.black12,
                      child: Image.network(
                        tier['largeIcon'] ?? tier['smallIcon'] ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: DashboardPage.valorantPink,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // info bawah
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6, // 👉 dikurangin biar nggak overflow
                      ),
                      decoration: BoxDecoration(
                        color:
                            DashboardPage.valorantCard.withValues(alpha: 0.85),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(18)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tier['tierName']?.toUpperCase() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: DashboardPage.valorantPink,
                              fontSize: 14.5,
                              letterSpacing: 0.6,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            (tier['divisionName'] ?? '--')
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(
                              color:
                                  DashboardPage.valorantWhite.withOpacity(0.8),
                              fontSize: 11.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget penampil waktu dinamis
class ValorantTimeDisplay extends StatefulWidget {
  final List<String> selectedTimezones;
  const ValorantTimeDisplay({
    super.key,
    required this.selectedTimezones,
  });

  @override
  State<ValorantTimeDisplay> createState() => _ValorantTimeDisplayState();
}

class _ValorantTimeDisplayState extends State<ValorantTimeDisplay> {
  late Timer timer;
  final DateFormat formatter = DateFormat('HH:mm:ss');

  String _formatTime(DateTime dt) => formatter.format(dt);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Map<String, String> _currentTimes() {
    final nowUtc = DateTime.now().toUtc();
    return {
      'WIB': _formatTime(nowUtc.add(const Duration(hours: 7))),
      'WITA': _formatTime(nowUtc.add(const Duration(hours: 8))),
      'WIT': _formatTime(nowUtc.add(const Duration(hours: 9))),
      'LONDON': _formatTime(nowUtc),
    };
  }

  @override
  Widget build(BuildContext context) {
    final times = _currentTimes();

    if (widget.selectedTimezones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.access_time,
              color: DashboardPage.valorantPink, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.selectedTimezones.map((zone) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      "$zone: ${times[zone]}",
                      style: const TextStyle(
                        color: DashboardPage.valorantWhite,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
