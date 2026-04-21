import 'package:flutter/material.dart';
import 'dart:math';

// ── Reuse design tokens from main ──────────────────────────────
const _scaffoldBg = Color(0xFF0F1117);
const _cardSurface = Color(0xFF161C26);
const _cardSurfaceLight = Color(0xFF1B2230);
const _subtleBorder = Color(0xFF2A3245);
const _accentPurple = Color(0xFFA855F7);
const _accentViolet = Color(0xFF8B5CF6);
const _accentTeal = Color(0xFF36D1DC);
const _accentGold = Color(0xFFF4B942);

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen>
    with TickerProviderStateMixin {
  // Breathing glow on prayer card
  late final AnimationController _breathCtrl;
  late final Animation<double> _breathAnim;

  // Press scale on CTA
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _breathAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut),
    );

    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _pressScale = Tween(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark base
          Container(color: _scaffoldBg),

          // Ambient spiritual glow — centered behind the prayer card
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.15),
                  radius: 0.85,
                  colors: [
                    _accentPurple.withOpacity(0.07),
                    _accentViolet.withOpacity(0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 0.75],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildPrayerCard(),
                        const SizedBox(height: 32),
                        _buildCTA(),
                        const SizedBox(height: 40),
                        _buildSupportingSection(
                          'Morning Intention',
                          'Lord, guide my thoughts and actions today. '
                              'Let me walk in Your light and share Your love '
                              'with everyone I meet.',
                          Icons.wb_twilight_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildSupportingSection(
                          'Evening Reflection',
                          'Thank You for this day, Lord. Help me rest in '
                              'Your peace and prepare my heart for tomorrow.',
                          Icons.nightlight_round,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _subtleBorder.withOpacity(0.4)),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white.withOpacity(0.6), size: 18),
            ),
          ),
          const Spacer(),
          Text(
            'Daily Prayer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.75),
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40), // balance the back button
        ],
      ),
    );
  }

  Widget _buildPrayerCard() {
    return AnimatedBuilder(
      animation: _breathAnim,
      builder: (context, child) {
        final glowOpacity = 0.04 + 0.06 * _breathAnim.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              // Breathing spiritual glow
              BoxShadow(
                color: _accentPurple.withOpacity(glowOpacity),
                blurRadius: 40 + 10 * _breathAnim.value,
                spreadRadius: 2,
              ),
              // Grounding shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E2538),
              Color(0xFF171D2C),
              Color(0xFF131924),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _subtleBorder.withOpacity(0.45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _accentPurple.withOpacity(0.70),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'PRAYER FOR TODAY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _accentPurple.withOpacity(0.55),
                    letterSpacing: 1.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Prayer title
            Text(
              'A Prayer for\nGuidance & Peace',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.92),
                height: 1.25,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),

            // Subtle divider
            Container(
              width: 40,
              height: 2,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                gradient: LinearGradient(
                  colors: [
                    _accentPurple.withOpacity(0.50),
                    _accentPurple.withOpacity(0.10),
                  ],
                ),
              ),
            ),

            // Prayer body
            Text(
              'Heavenly Father,\n\n'
              'I come before You with a humble heart, '
              'seeking Your wisdom and peace. Guide my steps today '
              'and help me to trust in Your plan, even when the path '
              'is unclear.\n\n'
              'Fill me with Your Spirit, that I may be a light '
              'to those around me. Grant me patience in trials, '
              'gratitude in blessings, and courage in uncertainty.\n\n'
              'In Jesus\' name I pray,\nAmen.',
              style: TextStyle(
                fontSize: 15.5,
                color: Colors.white.withOpacity(0.65),
                height: 1.7,
                letterSpacing: 0.1,
              ),
            ),

            const SizedBox(height: 20),

            // Scripture reference
            Row(
              children: [
                Icon(Icons.menu_book_rounded,
                    size: 15, color: _accentTeal.withOpacity(0.45)),
                const SizedBox(width: 8),
                Text(
                  'Proverbs 3:5-6',
                  style: TextStyle(
                    fontSize: 13,
                    color: _accentTeal.withOpacity(0.50),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA() {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _pressScale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _accentPurple.withOpacity(0.50),
                _accentViolet.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accentPurple.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: _accentPurple.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_rounded,
                  size: 18, color: Colors.white.withOpacity(0.80)),
              const SizedBox(width: 10),
              Text(
                'Begin Prayer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.92),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportingSection(String title, String body, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardSurface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _subtleBorder.withOpacity(0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _accentViolet.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: _accentViolet.withOpacity(0.50), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.38),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
