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

const _accentPurple = Color(0xFFA855F7);
const _accentTeal = Color(0xFF36D1DC);
const _accentGold = Color(0xFFF4B942);

const _cardGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [_cardSurfaceTop, _cardSurfaceBot],
);

BoxDecoration _cardDecoration({double borderRadius = 14}) => BoxDecoration(
      gradient: _cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: _subtleBorder.withOpacity(0.5)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 20,
          offset: const Offset(0, 8),
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

          // Radial glow behind ring area only
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accentPurple.withOpacity(0.16),
                      _accentTeal.withOpacity(0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.85],
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
                  const SizedBox(height: 28),
                  _buildSpiritualProgress(),
                  const SizedBox(height: 28),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _accentPurple.withOpacity(0.8),
                _accentPurple.withOpacity(0.4),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 22,
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
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
              Text(
                'Friday in the Octave of Easter',
                style: TextStyle(
                  fontSize: 13,
                  color: _accentPurple.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Icon(Icons.notifications_outlined,
                color: Colors.white.withOpacity(0.6), size: 28),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _accentPurple.withOpacity(0.85),
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
              color: _accentPurple.withOpacity(0.7), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The Lord is my strength and my shield',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
                height: 1.3,
              ),
            ),
          ),
          Text(
            'Ps 3:7',
            style: TextStyle(
              fontSize: 13,
              color: _accentTeal.withOpacity(0.7),
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
          child: SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: _GradientRingPainter(),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '0%',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'Spiritual Today',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.50),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withOpacity(0.85),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 14,
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
                _accentPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                Icons.auto_stories_rounded,
                'Devotions',
                'Daily devotionals\nfor your journey',
                _accentTeal,
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
                _accentTeal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                Icons.wb_sunny_rounded,
                'Daily Prayer',
                'Start your day\nwith God',
                _accentGold,
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
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(borderRadius: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor.withOpacity(0.85), size: 22),
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
                    color: Colors.white.withOpacity(0.90),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.40),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: Colors.white.withOpacity(0.20), size: 20),
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
        border: Border.all(color: _accentPurple.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: _accentPurple.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                Text(
                  'Upcoming Event',
                  style: TextStyle(
                    fontSize: 12,
                    color: _accentTeal.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Morning Prayer Session',
                  style: TextStyle(
                    fontSize: 18,
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
                    color: Colors.white.withOpacity(0.50),
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
                        [_accentPurple.withOpacity(0.7), _accentPurple.withOpacity(0.4)],
                        [_accentTeal.withOpacity(0.7), _accentTeal.withOpacity(0.4)],
                        [_accentGold.withOpacity(0.7), _accentGold.withOpacity(0.4)],
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
                              size: 14, color: Colors.white.withOpacity(0.6)),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '24 going',
                  style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.50)),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _accentPurple.withOpacity(0.7),
                        _accentPurple.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _accentPurple.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Join',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          color: Colors.white.withOpacity(0.85), size: 18),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentTeal.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description_outlined,
                color: _accentTeal.withOpacity(0.7), size: 22),
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
                    color: Colors.white.withOpacity(0.90),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Today was a peaceful day.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.45)),
                ),
                const SizedBox(height: 2),
                Text(
                  '2 days ago',
                  style: TextStyle(
                      fontSize: 11, color: Colors.white.withOpacity(0.28)),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _accentPurple.withOpacity(0.6),
                  _accentPurple.withOpacity(0.35),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _accentPurple.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.add, color: Colors.white.withOpacity(0.9), size: 24),
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
            top: BorderSide(color: _subtleBorder.withOpacity(0.4))),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _accentPurple.withOpacity(0.9),
        unselectedItemColor: Colors.white.withOpacity(0.30),
        selectedFontSize: 12,
        unselectedFontSize: 12,
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
    final radius = size.width / 2 - 12;

    // Background track ring
    final bgPaint = Paint()
      ..color = const Color(0xFF1B2230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Gradient ring — smoother color transitions
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        _accentPurple,                    // Pray start
        _accentPurple.withOpacity(0.85),
        _accentGold.withOpacity(0.9),     // transition to Serve
        _accentGold,
        _accentTeal.withOpacity(0.9),     // transition to Reflect
        _accentTeal,
        _accentPurple.withOpacity(0.85),  // loop back
        _accentPurple,
      ],
      stops: const [0.0, 0.12, 0.25, 0.38, 0.52, 0.68, 0.85, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * 0.85,
      false,
      gradientPaint,
    );

    // Soft glow — reduced intensity, wider blur
    final glowGradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        _accentPurple.withOpacity(0.14),
        _accentGold.withOpacity(0.10),
        _accentTeal.withOpacity(0.12),
        _accentPurple.withOpacity(0.14),
      ],
      stops: const [0.0, 0.33, 0.66, 1.0],
    );

    final glowPaint = Paint()
      ..shader = glowGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 22);

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
      ..color = Colors.white.withOpacity(0.65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(sparkleX, sparkleY), 2.5, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
