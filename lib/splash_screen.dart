import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Cinematic recreation of the AIsaiah splash screen, built from vector art.
///
/// Layers, back to front:
///   1. Deep navy radial-gradient backdrop (not pure black).
///   2. Ambient color haze — soft purple + teal light spilling into the dark.
///   3. Layered emissive bloom — several blurred copies of the logo group that
///      give it luminous separation from the background.
///   4. The crisp vector logo (cross + dove) and "AIsaiah" wordmark on top.
///
/// A slow "breathing" pulse animates the glow so it feels alive; an entrance
/// fade + scale plays on launch. Tap anywhere or hit Refresh to replay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _crossAsset = 'assets/images/Cross.svg';
  static const _markAsset = 'assets/images/AIsaiah.svg';

  // Brand accents used for the emissive haze.
  static const _purple = Color(0xFF8B5CF6);
  static const _teal = Color(0xFF14B8A6);

  static const _crossWidth = 150.0;
  static const _markWidth = 210.0;

  // Brand gradient: deep purple -> blue-violet -> azure -> cyan-blue.
  static const _brandColors = [
    Color(0xFF6A2C91),
    Color(0xFF5538B8),
    Color(0xFF2C8FD0),
    Color(0xFF12A0D8),
  ];
  static const _brandStops = [0.0, 0.38, 0.78, 1.0];

  late final AnimationController _entrance;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  late final AnimationController _pulse; // slow breathing glow

  @override
  void initState() {
    super.initState();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    _scale = Tween(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic),
    );
    _entrance.forward();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);
  }

  void _replay() {
    _entrance
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  /// The composed logo: vector cross/dove above the gradient "AIsaiah"
  /// wordmark and the "FAITH. GROWTH. PURPOSE." tagline.
  Widget _logoGroup() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(_crossAsset, width: _crossWidth),
        const SizedBox(height: 22),
        _wordmark(),
        const SizedBox(height: 11),
        _tagline(),
      ],
    );
  }

  /// "AIsaiah" recolored with a left-to-right purple → blue gradient by
  /// masking the wordmark's vector shapes (BlendMode.srcIn keeps the glyph
  /// alpha and paints the gradient through it).
  Widget _wordmark() {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: _brandColors,
        stops: _brandStops,
      ).createShader(bounds),
      child: SvgPicture.asset(_markAsset, width: _markWidth),
    );
  }

  /// Muted, letter-spaced tagline under the wordmark.
  Widget _tagline() {
    return Text(
      'FAITH.  GROWTH.  PURPOSE.',
      style: TextStyle(
        fontSize: 9,
        letterSpacing: 3.0,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.55),
      ),
    );
  }

  /// One blurred copy of the logo group, scaled out and faded — a bloom shell.
  Widget _bloom(double sigma, double opacity, double scale) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: scale,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: _logoGroup(),
        ),
      ),
    );
  }

  /// A soft radial light blob that spills brand color into the darkness.
  Widget _haze(Color color, double diameter, Alignment align, double opacity) {
    return Align(
      alignment: align,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(opacity.clamp(0.0, 1.0)),
              color.withOpacity(0.0),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _replay,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: Listenable.merge([_entrance, _pulse]),
          builder: (context, _) {
            // Breathing factor 0.78 -> 1.0, gated by the entrance fade so the
            // glow blooms in rather than popping.
            final breath = 0.78 + 0.22 * _pulse.value;
            final glow = breath * _fade.value;

            return Stack(
              children: [
                // 1. Deep cinematic navy backdrop.
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.95,
                        colors: [
                          Color(0xFF111827),
                          Color(0xFF050816),
                          Color(0xFF000000),
                        ],
                        stops: [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // 2. Ambient color haze — light spill into the dark.
                Positioned.fill(
                  child: _haze(
                      _purple, 620, const Alignment(0, -0.18), 0.22 * glow),
                ),
                Positioned.fill(
                  child: _haze(
                      _teal, 520, const Alignment(0, 0.12), 0.13 * glow),
                ),

                // 3 + 4. Logo with layered bloom, centered.
                Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _bloom(46, 0.40 * breath, 1.16),
                          _bloom(22, 0.50 * breath, 1.07),
                          _bloom(9, 0.62 * breath, 1.01),
                          _logoGroup(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: TextButton.icon(
          onPressed: _replay,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withOpacity(0.45),
          ),
        ),
      ),
    );
  }
}
