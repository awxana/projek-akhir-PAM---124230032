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
import 'package:projectakhir_mobile/Views/merch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();

  static const Color valorantPink = Color(0xFFFF8FAB);
  static const Color valorantDark = Color(0xFF201628);
  static const Color valorantCard = Color(0xFF2A1E37);
  static const Color valorantWhite = Color(0xFFFFFFFF);
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> tiers = [];
  List<dynamic> _fullTierList = [];
  List<dynamic> searchResults = [];
  bool isSearching = false;
  late SharedPreferences prefs;
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
      if (data != null && data.isNotEmpty) {
        final latestEpisode = data.last;
        setState(() {
          List<dynamic> allTiers = latestEpisode['tiers']
              .where((tier) =>
                  tier['tierName'] != null &&
                  !tier['tierName'].toLowerCase().contains('unused'))
              .toList();

          _fullTierList = allTiers;
          Map<String, dynamic> uniqueTiersMap = {};
          for (var tier in allTiers) {
            String tierName = tier['tierName'];
            String baseName = tierName.split(' ').first;
            if (!uniqueTiersMap.containsKey(baseName) ||
                (uniqueTiersMap[baseName]?['largeIcon'] == null &&
                    tier['largeIcon'] != null)) {
              uniqueTiersMap[baseName] = tier;
            }
          }
          tiers = uniqueTiersMap.values.toList();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to fetch competitive tiers. Coba lagi nanti.',
            style: TextStyle(color: DashboardPage.valorantWhite),
          ),
          backgroundColor: DashboardPage.valorantPink,
        ),
      );
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
    final baseName = (tier['tierName'] as String? ?? '').split(' ').first;
    final subTiers = _fullTierList
        .where((t) => (t['tierName'] as String? ?? '').startsWith(baseName))
        .toList();
    _pushWithFade(AgentDetailPage(
      representativeTier: tier,
      subTiers: subTiers,
    ));
  }

  void navigateToFavoriteAgentsPage() => _pushWithFade(const FavoriteAgentsPage());
  void navigateToProfilePage() => _pushWithFade(const ProfilePage());
  void navigateToFeedbackPage() => _pushWithFade(const FeedbackPage());
  void navigateToMerchPage() => _pushWithFade(const MerchPage());

  void navigateToLogout() async {
    await prefs.remove("username");
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

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
                title: Text(label,
                    style: const TextStyle(
                        color: DashboardPage.valorantWhite,
                        fontWeight: FontWeight.w600)),
                activeColor: DashboardPage.valorantPink,
                checkColor: DashboardPage.valorantWhite,
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pilih Zona Waktu',
                    style: TextStyle(
                        color: DashboardPage.valorantWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildCheckbox('WIB'),
                  buildCheckbox('WITA'),
                  buildCheckbox('WIT'),
                  buildCheckbox('LONDON'),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DashboardPage.valorantPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, tempSelected),
                    child: const Text(
                      'SIMPAN',
                      style: TextStyle(
                        color: DashboardPage.valorantWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                      fontSize: 20),
                ),
              ],
            ),
            ValorantTimeDisplay(selectedTimezones: selectedTimezones),
          ],
        ),
        backgroundColor: DashboardPage.valorantDark,
        actions: [
          IconButton(
            onPressed: _openTimezonePicker,
            icon: const Icon(Icons.access_time,
                color: DashboardPage.valorantWhite),
            tooltip: 'Pilih zona waktu',
          ),
          IconButton(
            onPressed: navigateToMerchPage,
            icon: const Icon(Icons.shopping_bag,
                color: DashboardPage.valorantPink),
            tooltip: 'Lihat Merchandise',
          ),
        ],
      ),
      body: tiers.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      DashboardPage.valorantPink)))
          : Column(
              children: [
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
                    ),
                  ),
                ),
                Expanded(
                  child:
                      isSearching ? _buildTierGrid(searchResults) : _buildTierGrid(tiers),
                ),
              ],
            ),
      bottomNavigationBar: ClipRRect(
        borderRadius:
            const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        child: BottomNavigationBar(
          backgroundColor: DashboardPage.valorantCard,
          selectedItemColor: DashboardPage.valorantPink,
          unselectedItemColor:
              DashboardPage.valorantWhite.withValues(alpha: 0.5),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'FAVORITES'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'MERCH'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
            BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'FEEDBACK'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'LOGOUT'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                navigateToFavoriteAgentsPage();
                break;
              case 1:
                navigateToMerchPage();
                break;
              case 2:
                navigateToProfilePage();
                break;
              case 3:
                navigateToFeedbackPage();
                break;
              case 4:
                navigateToLogout();
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildTierGrid(List<dynamic> tierList) {
    if (tierList.isEmpty) {
      return const Center(
        child: Text('NO TIERS FOUND',
            style: TextStyle(color: DashboardPage.valorantWhite)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemCount: tierList.length,
      itemBuilder: (context, index) {
        final tier = tierList[index];
        return GestureDetector(
          onTap: () => navigateToDetailPage(tier),
          child: Card(
            color: DashboardPage.valorantCard,
            elevation: 8,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Image.network(
                    tier['largeIcon'] ?? tier['smallIcon'] ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    color:
                        DashboardPage.valorantCard.withValues(alpha: 0.85),
                    child: Text(
                      (tier['tierName'] as String? ?? '').toUpperCase(),
                      style: const TextStyle(
                          color: DashboardPage.valorantPink,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget waktu dinamis
class ValorantTimeDisplay extends StatefulWidget {
  final List<String> selectedTimezones;
  const ValorantTimeDisplay({super.key, required this.selectedTimezones});

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
    if (widget.selectedTimezones.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: DashboardPage.valorantPink, size: 14),
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
