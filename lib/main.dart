import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CfcApp());
}

// ── Design Tokens ──────────────────────────────────────────────
const _scaffoldBg = Color(0xFF0F1117);
const _cardSurface = Color(0xFF161C26);
const _cardSurfaceTop = Color(0xFF1B2230);
const _cardSurfaceBot = Color(0xFF151B27);
const _subtleBorder = Color(0xFF2A3245);
const _bottomBarBg = Color(0xFF12151D);

// Accent palette — semantic assignments
const _accentPurple = Color(0xFFA855F7);
const _accentTeal = Color(0xFF36D1DC);
const _accentGold = Color(0xFFF4B942);
const _accentIndigo = Color(0xFF6366F1);
const _accentViolet = Color(0xFF8B5CF6);

const _cardGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [_cardSurfaceTop, _cardSurfaceBot],
);

BoxDecoration _cardDecoration({double borderRadius = 14}) => BoxDecoration(
      gradient: _cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: _subtleBorder.withOpacity(0.45)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.18),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );

class CfcApp extends StatelessWidget {
  const CfcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CFC Portal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _scaffoldBg,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Solid dark base
          Container(color: _scaffoldBg),

          // Broad ambient glow behind ring — wider, softer, no beam
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accentPurple.withOpacity(0.10),
                      _accentTeal.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.40, 0.80],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildScriptureVerse(),
                  const SizedBox(height: 30),
                  _buildSpiritualProgress(),
                  const SizedBox(height: 30),
                  _buildFeatureCards(),
                  const SizedBox(height: 18),
                  _buildUpcomingEvent(),
                  const SizedBox(height: 18),
                  _buildJournalEntry(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _accentPurple.withOpacity(0.65),
                _accentPurple.withOpacity(0.35),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Evening, Alvin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Friday, April 18',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.50),
                ),
              ),
              Text(
                'Friday in the Octave of Easter',
                style: TextStyle(
                  fontSize: 13,
                  color: _accentPurple.withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Icon(Icons.notifications_outlined,
                color: Colors.white.withOpacity(0.55), size: 27),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _accentPurple.withOpacity(0.75),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScriptureVerse() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(Icons.shield_outlined,
              color: _accentIndigo.withOpacity(0.65), size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The Lord is my strength and my shield',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.80),
                height: 1.3,
              ),
            ),
          ),
          Text(
            'Ps 3:7',
            style: TextStyle(
              fontSize: 13,
              color: _accentTeal.withOpacity(0.60),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualProgress() {
    return Column(
      children: [
        Center(
          // Ring reduced ~10% from 200 → 178
          child: SizedBox(
            width: 178,
            height: 178,
            child: CustomPaint(
              painter: _GradientRingPainter(),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '0%',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'Spiritual Today',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.42),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIndicator(_accentPurple, 'Pray'),
            const SizedBox(width: 32),
            _buildIndicator(_accentTeal, 'Reflect'),
            const SizedBox(width: 32),
            _buildIndicator(_accentGold, 'Serve'),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color.withOpacity(0.75),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.48),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                Icons.menu_book_rounded,
                'Scripture\nReading',
                'Read and meditate\non God\'s Word',
                _accentIndigo, // blue/indigo for Scripture
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                Icons.auto_stories_rounded,
                'Devotions',
                'Daily devotionals\nfor your journey',
                _accentPurple, // purple for Devotions
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                Icons.favorite_rounded,
                'Journal',
                'Reflect and grow\nspiritually',
                _accentViolet, // soft violet for Journal
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                Icons.wb_sunny_rounded,
                'Daily Prayer',
                'Start your day\nwith God',
                _accentGold, // warm gold for Prayer
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String subtitle, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: _cardDecoration(borderRadius: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor.withOpacity(0.75), size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.88),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.38),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: Colors.white.withOpacity(0.18), size: 20),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D2436),
            Color(0xFF1A1F30),
          ],
        ),
        border: Border.all(color: _accentPurple.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: _accentPurple.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event label — stronger contrast, gold accent
                Text(
                  'Upcoming Event',
                  style: TextStyle(
                    fontSize: 12,
                    color: _accentGold.withOpacity(0.80),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Morning Prayer Session',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wed, April 8 \u2022 8:00 AM',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 28,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: List.generate(3, (i) {
                      final colors = [
                        [_accentPurple.withOpacity(0.6), _accentPurple.withOpacity(0.3)],
                        [_accentTeal.withOpacity(0.6), _accentTeal.withOpacity(0.3)],
                        [_accentGold.withOpacity(0.6), _accentGold.withOpacity(0.3)],
                      ];
                      return Positioned(
                        left: i * 18.0,
                        top: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF1A1F30), width: 2),
                            gradient: LinearGradient(colors: colors[i]),
                          ),
                          child: Icon(Icons.person,
                              size: 14, color: Colors.white.withOpacity(0.50)),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '24 going',
                  style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.45)),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _accentPurple.withOpacity(0.55),
                        _accentPurple.withOpacity(0.38),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _accentPurple.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Join',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.90),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          color: Colors.white.withOpacity(0.75), size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntry() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(borderRadius: 16),
      child: Row(
        children: [
          // Badge matches action card system — violet for Journal
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentViolet.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description_outlined,
                color: _accentViolet.withOpacity(0.70), size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Journal',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.88),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Today was a peaceful day.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.42)),
                ),
                const SizedBox(height: 2),
                Text(
                  '2 days ago',
                  style: TextStyle(
                      fontSize: 11, color: Colors.white.withOpacity(0.25)),
                ),
              ],
            ),
          ),
          // Plus button — smaller, more restrained
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentViolet.withOpacity(0.18),
              border: Border.all(color: _accentViolet.withOpacity(0.15)),
            ),
            child: Icon(Icons.add,
                color: _accentViolet.withOpacity(0.70), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _bottomBarBg,
        border: Border(
            top: BorderSide(color: _subtleBorder.withOpacity(0.30))),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _accentPurple.withOpacity(0.75),
        unselectedItemColor: Colors.white.withOpacity(0.26),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'CFC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background track — subtle
    final bgPaint = Paint()
      ..color = const Color(0xFF1A2030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    canvas.drawCircle(center, radius, bgPaint);

    // Gradient ring — smooth transitions, refined palette
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        _accentPurple.withOpacity(0.90),
        _accentPurple.withOpacity(0.75),
        _accentGold.withOpacity(0.80),
        _accentGold.withOpacity(0.85),
        _accentTeal.withOpacity(0.80),
        _accentTeal.withOpacity(0.85),
        _accentPurple.withOpacity(0.75),
        _accentPurple.withOpacity(0.90),
      ],
      stops: const [0.0, 0.12, 0.25, 0.38, 0.52, 0.68, 0.85, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * 0.85,
      false,
      gradientPaint,
    );

    // Soft ambient glow — very restrained
    final glowGradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        _accentPurple.withOpacity(0.10),
        _accentGold.withOpacity(0.07),
        _accentTeal.withOpacity(0.08),
        _accentPurple.withOpacity(0.10),
      ],
      stops: const [0.0, 0.33, 0.66, 1.0],
    );

    final glowPaint = Paint()
      ..shader = glowGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 24);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * 0.85,
      false,
      glowPaint,
    );

    // Subtle sparkle at arc end
    final sparkleAngle = -pi / 2 + 2 * pi * 0.85;
    final sparkleX = center.dx + radius * cos(sparkleAngle);
    final sparkleY = center.dy + radius * sin(sparkleAngle);
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(0.50)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(sparkleX, sparkleY), 2, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
