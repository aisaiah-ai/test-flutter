import 'package:flutter/material.dart';

const _bgDark = Color(0xFF110B1F);
const _bgPurple = Color(0xFF2D1650);
const _cardBg = Color(0xFF2A1B4A);
const _cardBgLight = Color(0xFF3A2660);
const _accentPurple = Color(0xFF8B5CF6);
const _accentPurpleBright = Color(0xFFA78BFA);
const _accentGold = Color(0xFFF4B942);
const _textPrimary = Color(0xFFFFFFFF);

class ReflectScreen extends StatefulWidget {
  const ReflectScreen({super.key});

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  int _currentNav = 1;
  final Map<int, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Cosmic background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_dark_cosmic.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildReadingsCard(),
                        const SizedBox(height: 20),
                        _buildReadNowButton(),
                        const SizedBox(height: 24),
                        _buildRosaryCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buildBottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Reflect',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Daily Scripture for April 20, 2026',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Monday of the Third Week of Easter',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.45),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildReadingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8935A).withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8935A).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: _accentPurple.withOpacity(0.06),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _accentPurple.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.auto_stories_rounded,
                      color: _accentPurpleBright, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Today\'s Readings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Date row
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
            child: Row(
              children: [
                Text(
                  'April 20, 2026',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.40),
                  ),
                ),
                const Spacer(),
                Text(
                  'April 20, 2026',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.40),
                  ),
                ),
              ],
            ),
          ),

          _buildDivider(),
          _buildReadingItem(0, 'First Reading', 'Acts 6:8–15'),
          _buildDivider(),
          _buildReadingItem(1, 'Responsorial Psalm', 'Psalm 119:23–24, 26–27, 29–30'),
          _buildDivider(),
          _buildReadingItem(2, 'Gospel', 'John 6:22–29'),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildReadingItem(int index, String title, String reference) {
    final isExpanded = _expanded[index] ?? false;
    return GestureDetector(
      onTap: () => setState(() => _expanded[index] = !isExpanded),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.88),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reference,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.38),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withOpacity(0.35),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: CustomPaint(
        size: const Size(double.infinity, 12),
        painter: _GlowLinePainter(),
      ),
    );
  }

  Widget _buildReadNowButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF6D28D9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _accentPurple.withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Read Now',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildRosaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _cardBgLight.withOpacity(0.70),
            _cardBg.withOpacity(0.65),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accentPurple.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentPurple.withOpacity(0.20),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(Icons.self_improvement_rounded,
                color: _accentPurpleBright.withOpacity(0.80), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rosary Prayer Guide',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.88),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Learn how to pray the Rosary',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.38),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.30), size: 22),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF130D22),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.favorite_rounded, 'Pray', 0),
          _buildNavItem(Icons.auto_stories_rounded, 'Reflect', 1),
          _buildNavItem(Icons.volunteer_activism_rounded, 'Serve', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentNav == index;
    return GestureDetector(
      onTap: () => setState(() => _currentNav = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator line
            Container(
              width: 24,
              height: 3,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive ? _accentPurple : Colors.transparent,
              ),
            ),
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? _accentPurpleBright
                  : Colors.white.withOpacity(0.30),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? _accentPurpleBright
                    : Colors.white.withOpacity(0.30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.height / 2;
    final width = size.width;

    // Soft glow — warm amber blurred stroke
    const glowColor = Color(0xFFE8935A);
    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          glowColor.withOpacity(0.40),
          glowColor.withOpacity(0.60),
          glowColor.withOpacity(0.40),
          Colors.transparent,
        ],
        stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, width, 1))
      ..strokeWidth = 7
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, center), Offset(width, center), glowPaint);

    // Crisp bright line on top
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          _accentPurple.withOpacity(0.45),
          _accentPurpleBright.withOpacity(0.65),
          _accentPurple.withOpacity(0.45),
          Colors.transparent,
        ],
        stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, width, 1))
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, center), Offset(width, center), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
