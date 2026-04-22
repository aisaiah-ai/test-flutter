import 'dart:math' as math;
import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────
// Color System — locked brand tokens
// ──────────────────────────────────────────────────────────────────────

const prayColor = Color(0xFF7B61FF);
const reflectColor = Color(0xFF1AAE9F);
const serveColor = Color(0xFFE0A100);

// ──────────────────────────────────────────────────────────────────────
// Ring Center Content
// ──────────────────────────────────────────────────────────────────────

enum JourneyPhase { empty, partial, fulfilled }

class RingCenterContent {
  final String title;
  final String subtitle;

  const RingCenterContent({required this.title, required this.subtitle});

  factory RingCenterContent.fromContext({
    required JourneyPhase phase,
    String? dominantPillar,
    bool isBalanced = false,
  }) {
    switch (phase) {
      case JourneyPhase.empty:
        return const RingCenterContent(
          title: 'Your Daily\nRhythm',
          subtitle: 'Begin with prayer',
        );
      case JourneyPhase.partial:
        if (isBalanced) {
          return const RingCenterContent(
            title: 'Your Daily\nRhythm',
            subtitle: 'Your rhythm is growing',
          );
        }
        final sub = switch (dominantPillar) {
          'Pray' => 'Continue with reflection or service',
          'Reflect' => 'Continue with prayer or service',
          'Serve' => 'Continue with prayer or reflection',
          _ => 'Your rhythm is growing',
        };
        return RingCenterContent(
          title: 'Your Daily\nRhythm',
          subtitle: sub,
        );
      case JourneyPhase.fulfilled:
        return const RingCenterContent(
          title: 'Your Daily\nRhythm',
          subtitle: 'Prayer, reflection, and service',
        );
    }
  }
}

// ──────────────────────────────────────────────────────────────────────
// Ring Screen — just the rings
// ──────────────────────────────────────────────────────────────────────

class RingScreen extends StatefulWidget {
  const RingScreen({super.key});

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  double _pray = 1.0;
  double _reflect = 1.0;
  double _serve = 1.0;

  JourneyPhase get _phase {
    final avg = (_pray + _reflect + _serve) / 3.0;
    if (avg < 0.05) return JourneyPhase.empty;
    if (avg < 0.95) return JourneyPhase.partial;
    return JourneyPhase.fulfilled;
  }

  @override
  Widget build(BuildContext context) {
    final centerContent = RingCenterContent.fromContext(phase: _phase);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: SpiritualRingGauge(
                prayIntensity: _pray,
                reflectIntensity: _reflect,
                serveIntensity: _serve,
                centerContent: centerContent,
                size: 240,
              ),
            ),
            const SizedBox(height: 40),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legend(prayColor, 'Pray'),
                const SizedBox(width: 32),
                _legend(reflectColor, 'Reflect'),
                const SizedBox(width: 32),
                _legend(serveColor, 'Serve'),
              ],
            ),
            const SizedBox(height: 48),
            // Sliders for testing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _slider('Pray', prayColor, _pray, (v) => setState(() => _pray = v)),
                  _slider('Reflect', reflectColor, _reflect, (v) => setState(() => _reflect = v)),
                  _slider('Serve', serveColor, _serve, (v) => setState(() => _serve = v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.80),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _slider(String label, Color color, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: color,
                thumbColor: color,
                inactiveTrackColor: color.withValues(alpha: 0.2),
                overlayColor: color.withValues(alpha: 0.1),
              ),
              child: Slider(value: value, onChanged: onChanged),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Ring Widget
// ──────────────────────────────────────────────────────────────────────

class SpiritualRingGauge extends StatefulWidget {
  final double prayIntensity;
  final double reflectIntensity;
  final double serveIntensity;
  final RingCenterContent centerContent;
  final double size;

  const SpiritualRingGauge({
    super.key,
    this.prayIntensity = 0.0,
    this.reflectIntensity = 0.0,
    this.serveIntensity = 0.0,
    required this.centerContent,
    this.size = 200,
  });

  @override
  State<SpiritualRingGauge> createState() => _SpiritualRingGaugeState();
}

class _SpiritualRingGaugeState extends State<SpiritualRingGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(SpiritualRingGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prayIntensity != oldWidget.prayIntensity ||
        widget.reflectIntensity != oldWidget.reflectIntensity ||
        widget.serveIntensity != oldWidget.serveIntensity) {
      _entryController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        final t = CurvedAnimation(
          parent: _entryController,
          curve: Curves.easeOut,
        ).value;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: SpiritualRingPainter(
                  prayIntensity: widget.prayIntensity * t,
                  reflectIntensity: widget.reflectIntensity * t,
                  serveIntensity: widget.serveIntensity * t,
                  isDark: isDark,
                ),
              ),
              SizedBox(
                width: widget.size * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.centerContent.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.centerContent.subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.50),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Ring Painter — single gradient, intensity-driven
// ──────────────────────────────────────────────────────────────────────

class SpiritualRingPainter extends CustomPainter {
  final double prayIntensity;
  final double reflectIntensity;
  final double serveIntensity;
  final bool isDark;

  SpiritualRingPainter({
    required this.prayIntensity,
    required this.reflectIntensity,
    required this.serveIntensity,
    required this.isDark,
  });

  static const _dimDark = Color(0xFF1A1A2E);
  static const _dimLight = Color(0xFFD8D8E0);
  static const _minBrightness = 0.35;

  Color _color(Color brand, double intensity) {
    final dim = Color.lerp(brand, isDark ? _dimDark : _dimLight, 1.0 - _minBrightness)!;
    return Color.lerp(dim, brand, intensity.clamp(0.0, 1.0))!;
  }

  /// Total stops around the full ring — one continuous loop, no separate arcs.
  static const _totalSteps = 72;

  List<Color> _buildColors() {
    final pHsv = HSVColor.fromColor(prayColor);
    final rHsv = HSVColor.fromColor(reflectColor);
    final colors = <Color>[];
    for (var i = 0; i <= _totalSteps; i++) {
      final t = i / _totalSteps;

      final Color brandColor;
      final double intensity;

      if (t < 1.0 / 3.0) {
        final localT = t * 3.0;
        brandColor = HSVColor.lerp(pHsv, rHsv, localT)!.toColor();
        intensity = prayIntensity + localT * (reflectIntensity - prayIntensity);
      } else if (t < 2.0 / 3.0) {
        final localT = (t - 1.0 / 3.0) * 3.0;
        brandColor = Color.lerp(reflectColor, serveColor, localT)!;
        intensity = reflectIntensity + localT * (serveIntensity - reflectIntensity);
      } else {
        final localT = (t - 2.0 / 3.0) * 3.0;
        brandColor = Color.lerp(serveColor, prayColor, localT)!;
        intensity = serveIntensity + localT * (prayIntensity - serveIntensity);
      }

      colors.add(_color(brandColor, intensity));
    }
    return colors;
  }

  List<double> _buildStops() {
    final stops = <double>[];
    for (var i = 0; i <= _totalSteps; i++) {
      stops.add(i / _totalSteps);
    }
    return stops;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = isDark ? 12.0 : 11.0;
    final radius = size.width / 2 - strokeWidth;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final colors = _buildColors();
    final stops = _buildStops();

    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: colors,
      stops: stops,
    );

    // Light mode: gray base ring for contrast
    if (!isDark) {
      canvas.drawCircle(
        center, radius,
        Paint()
          ..color = const Color(0xFFEAEAEA)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }

    if (isDark) {
      canvas.drawCircle(
        center, radius,
        Paint()
          ..shader = SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: 3 * math.pi / 2,
            colors: colors.map((c) => c.withValues(alpha: 0.25)).toList(),
            stops: stops,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 4
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
    }

    canvas.drawCircle(
      center, radius,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(SpiritualRingPainter oldDelegate) {
    return oldDelegate.prayIntensity != prayIntensity ||
        oldDelegate.reflectIntensity != reflectIntensity ||
        oldDelegate.serveIntensity != serveIntensity ||
        oldDelegate.isDark != isDark;
  }
}
