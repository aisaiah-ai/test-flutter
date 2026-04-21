import 'package:flutter/material.dart';
import 'dart:math';
import 'prayer_screen.dart';
import 'reflect_screen.dart';

void main() {
  runApp(const CfcApp());
}

// ── Design Tokens ──────────────────────────────────────────────
const _scaffoldBg = Color(0xFF0F1117);
const _cardSurface = Color(0xFF161C26);
const _cardSurfaceLight = Color(0xFF1B2230);
const _subtleBorder = Color(0xFF2A3245);
const _bottomBarBg = Color(0xFF12151D);

const _accentPurple = Color(0xFFA855F7);
const _accentTeal = Color(0xFF36D1DC);
const _accentGold = Color(0xFFF4B942);
const _accentGoldLabel = Color(0xFFE7B93E);
const _accentIndigo = Color(0xFF6366F1);
const _accentViolet = Color(0xFF8B5CF6);

BoxDecoration _cardDecoration({double borderRadius = 20}) => BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_cardSurfaceLight, _cardSurface],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: _subtleBorder.withOpacity(0.6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.30),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );

// ── Pressable Card Wrapper ─────────────────────────────────────
class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _PressableCard({required this.child, this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ── Shimmer Loading Widget ─────────────────────────────────────
class _ShimmerCard extends StatefulWidget {
  final double height;
  final double borderRadius;
  const _ShimmerCard({this.height = 80, this.borderRadius = 20});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _ctrl.value, 0),
              end: Alignment(-0.5 + 2.0 * _ctrl.value, 0),
              colors: [
                _cardSurface,
                _cardSurfaceLight.withOpacity(0.7),
                _cardSurface,
              ],
            ),
          ),
        );
      },
    );
  }
}

class CfcApp extends StatelessWidget {
  const CfcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CFC Portal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _scaffoldBg,
      ),
      home: const ReflectScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isLoaded = false;

  // Breathing animation for ring glow
  late final AnimationController _breathCtrl;
  late final Animation<double> _breathAnim;

  // Mock spiritual state — full engagement
  final _ringState = const SpiritualRingState(
    prayIntensity: 1.0,
    reflectIntensity: 1.0,
    serveIntensity: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _breathAnim = Tween(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut),
    );

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoaded = true);
    });
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: _scaffoldBg),

          // Soft radial ambient glow — no banding
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.25),
                  radius: 1.0,
                  colors: [
                    _accentPurple.withOpacity(0.06),
                    _accentTeal.withOpacity(0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.30, 0.70],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _isLoaded
                      ? _buildScriptureVerse()
                      : const _ShimmerCard(height: 52),
                  const SizedBox(height: 30),
                  _buildSpiritualProgress(),
                  const SizedBox(height: 28),
                  _isLoaded
                      ? _buildFeatureCards()
                      : Column(
                          children: [
                            Row(children: [
                              const Expanded(
                                  child: _ShimmerCard(height: 90)),
                              const SizedBox(width: 12),
                              const Expanded(
                                  child: _ShimmerCard(height: 90)),
                            ]),
                            const SizedBox(height: 12),
                            Row(children: [
                              const Expanded(
                                  child: _ShimmerCard(height: 90)),
                              const SizedBox(width: 12),
                              const Expanded(
                                  child: _ShimmerCard(height: 90)),
                            ]),
                          ],
                        ),
                  const SizedBox(height: 18),
                  _isLoaded
                      ? _buildUpcomingEvent()
                      : const _ShimmerCard(height: 120),
                  const SizedBox(height: 18),
                  _isLoaded
                      ? _buildJournalEntry()
                      : const _ShimmerCard(height: 76),
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
    return _PressableCard(
      child: Container(
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
      ),
    );
  }

  Widget _buildSpiritualProgress() {
    final centerText = _ringState.centerMessage;
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 178,
            height: 178,
            child: AnimatedBuilder(
              animation: _breathAnim,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SpiritualPresencePainter(
                    state: _ringState,
                    breathIntensity: _breathAnim.value,
                  ),
                  child: child,
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      centerText.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: centerText.titleSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.90),
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      centerText.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withOpacity(0.38),
                        letterSpacing: 0.2,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
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
            color: color.withOpacity(0.80),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
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
                'Scripture Reading',
                'Read and meditate on God\'s Word',
                _accentIndigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                Icons.auto_stories_rounded,
                'Devotions',
                'Daily devotionals for your journey',
                _accentPurple,
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
                'Reflect and grow spiritually',
                _accentViolet,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                Icons.wb_sunny_rounded,
                'Daily Prayer',
                'Start your day with God',
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
    return _PressableCard(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(borderRadius: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor.withOpacity(0.75), size: 20),
                ),
                const Spacer(),
                Icon(Icons.chevron_right,
                    color: Colors.white.withOpacity(0.18), size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.88),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.40),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvent() {
    return _PressableCard(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_cardSurfaceLight, _cardSurface],
          ),
          border: Border.all(color: _subtleBorder.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 20,
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
                  Text(
                    'Upcoming Event',
                    style: TextStyle(
                      fontSize: 12,
                      color: _accentGoldLabel.withOpacity(0.85),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                                  color: _cardSurface, width: 2),
                              gradient: LinearGradient(colors: colors[i]),
                            ),
                            child: Icon(Icons.person,
                                size: 14,
                                color: Colors.white.withOpacity(0.50)),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '24 going',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.45)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accentPurple.withOpacity(0.45),
                          _accentPurple.withOpacity(0.30),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _accentPurple.withOpacity(0.06),
                          blurRadius: 10,
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
      ),
    );
  }

  Widget _buildJournalEntry() {
    return _PressableCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(borderRadius: 20),
        child: Row(
          children: [
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
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.42)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '2 days ago',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.25)),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentViolet.withOpacity(0.10),
              ),
              child: Icon(Icons.add,
                  color: _accentViolet.withOpacity(0.50), size: 18),
            ),
          ],
        ),
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
        selectedItemColor: _accentPurple,
        unselectedItemColor: Colors.white.withOpacity(0.50),
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

// ── Spiritual Ring State Model ─────────────────────────────────
class SpiritualRingState {
  final double prayIntensity;
  final double reflectIntensity;
  final double serveIntensity;

  const SpiritualRingState({
    this.prayIntensity = 0.0,
    this.reflectIntensity = 0.0,
    this.serveIntensity = 0.0,
  });

  double get overallPresence =>
      (prayIntensity + reflectIntensity + serveIntensity) / 3.0;

  bool get isEmpty => overallPresence < 0.05;
  bool get isPartial => !isEmpty && overallPresence < 0.7;

  _RingCenterMessage get centerMessage {
    if (isEmpty) {
      return const _RingCenterMessage(
        title: "Today's\nJourney",
        subtitle: 'Begin with prayer',
        titleSize: 22,
      );
    }
    if (isPartial) {
      return const _RingCenterMessage(
        title: 'Keep\nGoing',
        subtitle: 'You\'ve made space\nfor God today',
        titleSize: 22,
      );
    }
    return const _RingCenterMessage(
      title: 'Grace-Filled\nDay',
      subtitle: 'Pray, Reflect, Serve',
      titleSize: 20,
    );
  }
}

class _RingCenterMessage {
  final String title;
  final String subtitle;
  final double titleSize;

  const _RingCenterMessage({
    required this.title,
    required this.subtitle,
    this.titleSize = 22,
  });
}

// ── Spiritual Presence Ring Painter ────────────────────────────
//
// Single full-circle SweepGradient with smooth color transitions.
// No separate arcs, no seams, no gaps. Intensity controls the
// brightness of each category's zone within one continuous ring.
//
class _SpiritualPresencePainter extends CustomPainter {
  final SpiritualRingState state;
  final double breathIntensity;

  _SpiritualPresencePainter({
    required this.state,
    this.breathIntensity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Dark background track
    final trackPaint = Paint()
      ..color = const Color(0xFF1A2030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Single sweep gradient — all three colors in one continuous ring
    // Layout (starting from top, clockwise):
    //   Pray (purple):   0.0 – 0.33
    //   Reflect (teal):  0.33 – 0.67
    //   Serve (gold):    0.67 – 1.0
    // Transitions blend smoothly between zones.

    final prayOp = 0.15 + 0.85 * state.prayIntensity;
    final reflectOp = 0.15 + 0.85 * state.reflectIntensity;
    final serveOp = 0.15 + 0.85 * state.serveIntensity;

    Color _prayC(double o) => _accentPurple.withOpacity(prayOp * o);
    Color _reflC(double o) => _accentTeal.withOpacity(reflectOp * o);
    Color _servC(double o) => _accentGold.withOpacity(serveOp * o);

    // Blend helper — mix two colors at boundary
    Color _blend(Color a, double opA, Color b, double opB) {
      return Color.lerp(a.withOpacity(opA), b.withOpacity(opB), 0.5)!;
    }

    final ringGradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        _prayC(1.0),                                              // top — pray center
        _prayC(1.0),                                              // pray strong
        _prayC(0.7),                                              // pray fading
        _blend(_accentPurple, prayOp * 0.5,
               _accentTeal, reflectOp * 0.5),                     // pray→reflect blend
        _reflC(0.7),                                              // reflect rising
        _reflC(1.0),                                              // reflect center
        _reflC(1.0),                                              // reflect strong
        _reflC(0.7),                                              // reflect fading
        _blend(_accentTeal, reflectOp * 0.5,
               _accentGold, serveOp * 0.5),                       // reflect→serve blend
        _servC(0.7),                                              // serve rising
        _servC(1.0),                                              // serve center
        _servC(1.0),                                              // serve strong
        _servC(0.7),                                              // serve fading
        _blend(_accentGold, serveOp * 0.5,
               _accentPurple, prayOp * 0.5),                      // serve→pray blend
        _prayC(0.7),                                              // pray rising
        _prayC(1.0),                                              // back to top
      ],
      stops: const [
        0.000,  // pray center
        0.150,  // pray strong
        0.270,  // pray fading
        0.333,  // pray→reflect midpoint
        0.400,  // reflect rising
        0.480,  // reflect center
        0.520,  // reflect strong
        0.600,  // reflect fading
        0.667,  // reflect→serve midpoint
        0.730,  // serve rising
        0.810,  // serve center
        0.850,  // serve strong
        0.930,  // serve fading
        0.970,  // serve→pray midpoint (near wrap)
        0.985,  // pray rising
        1.000,  // back to top
      ],
    );

    // Main ring — single draw, zero seams
    final ringPaint = Paint()
      ..shader = ringGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, ringPaint);

    // 3. Soft glow halo — same gradient, blurred
    final glowBase = 0.08 + 0.06 * breathIntensity;
    final glowGradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        _accentPurple.withOpacity(glowBase * state.prayIntensity),
        _accentPurple.withOpacity(glowBase * state.prayIntensity * 0.5),
        _accentTeal.withOpacity(glowBase * state.reflectIntensity),
        _accentTeal.withOpacity(glowBase * state.reflectIntensity * 0.5),
        _accentGold.withOpacity(glowBase * state.serveIntensity),
        _accentGold.withOpacity(glowBase * state.serveIntensity * 0.5),
        _accentPurple.withOpacity(glowBase * state.prayIntensity),
      ],
      stops: const [0.0, 0.17, 0.33, 0.50, 0.67, 0.83, 1.0],
    );

    final glowPaint = Paint()
      ..shader = glowGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _SpiritualPresencePainter oldDelegate) =>
      oldDelegate.breathIntensity != breathIntensity ||
      oldDelegate.state.prayIntensity != state.prayIntensity ||
      oldDelegate.state.reflectIntensity != state.reflectIntensity ||
      oldDelegate.state.serveIntensity != state.serveIntensity;
}
