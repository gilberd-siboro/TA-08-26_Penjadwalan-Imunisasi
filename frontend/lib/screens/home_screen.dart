import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../fitur/hamil/hamil_screen.dart';
import '../fitur/tumbuh/tumbuh_screen.dart';
import '../fitur/menyusui/menyusui_screen.dart';
import '../fitur/nifas/nifas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // 0=Hamil, 1=Nifas, 2=Menyusui, 3=Tumbuh
  int _selectedBottomNav = 0;

  // ──────────────────────────────────────────────
  // Tab definitions
  // ──────────────────────────────────────────────
  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Hamil', 'icon': Icons.favorite_border},
    {'label': 'Nifas', 'icon': Icons.person_outline},
    {'label': 'Menyusui', 'icon': Icons.child_care_outlined},
    {'label': 'Tumbuh', 'icon': Icons.sentiment_satisfied_alt_outlined},
  ];

  // ──────────────────────────────────────────────
  // Dynamic greeting based on device time
  // ──────────────────────────────────────────────
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi ✨';
    if (hour < 15) return 'Selamat Siang ✨';
    if (hour < 18) return 'Selamat Sore ✨';
    return 'Selamat Malam ✨';
  }

  // ──────────────────────────────────────────────
  // Sub-header info per tab
  // ──────────────────────────────────────────────
  Map<String, dynamic> get _tabSubtitle {
    switch (_selectedTab) {
      case 0:
        return {
          'icon': CupertinoIcons.calendar_badge_plus,
          'text': 'Trimester 2 • Bebas keluhan berat',
        };
      case 1:
        return {
          'icon': CupertinoIcons.calendar_badge_plus,
          'text': 'Pemulihan pasca melahirkan',
        };
      case 2:
        return {
          'icon': CupertinoIcons.calendar_badge_plus,
          'text': 'Pantau nutrisi si kecil',
        };
      case 3:
        return {
          'icon': CupertinoIcons.calendar_badge_plus,
          'text': 'Semua jadwal kesehatan aman',
        };
      default:
        return {'icon': CupertinoIcons.calendar_badge_plus, 'text': ''};
    }
  }

  // ──────────────────────────────────────────────
  // Map tab index → feature screen widget
  // ──────────────────────────────────────────────
  Widget get _activeFeatureScreen {
    switch (_selectedTab) {
      case 0:
        return const HamilScreen();
      case 1:
        return const NifasScreen();
      case 2:
        return const MenyusuiScreen();
      case 3:
        return const TumbuhScreen();
      default:
        return const HamilScreen();
    }
  }

  // ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: KeyedSubtree(
                key: ValueKey(_selectedTab),
                child: _activeFeatureScreen,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ──────────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5DADE2), Color(0xFF3498DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 2),
              const Text(
                'Halo, Asri!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    _tabSubtitle['icon'] as IconData,
                    size: 14,
                    color: const Color(0xFFF9D66D),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _tabSubtitle['text'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Tab Bar (Tahap Saat Ini)
  // ──────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TAHAP SAAT INI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9AA5B4),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEEF7FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4A9EE0)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _tabs[index]['icon'] as IconData,
                        size: 24,
                        color: isSelected
                            ? const Color(0xFF4A9EE0)
                            : const Color(0xFF9AA5B4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _tabs[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF4A9EE0)
                              : const Color(0xFF9AA5B4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Bottom Navigation Bar
  // ──────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.description_outlined, 'label': 'Catatan'},
      {'icon': Icons.shield_outlined, 'label': 'Imunisasi'},
      {'icon': Icons.menu_book_outlined, 'label': 'Edukasi'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedBottomNav == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedBottomNav = index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[index]['icon'] as IconData,
                      size: 24,
                      color: isSelected
                          ? const Color(0xFF4A9EE0)
                          : const Color(0xFF9AA5B4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF4A9EE0)
                            : const Color(0xFF9AA5B4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
