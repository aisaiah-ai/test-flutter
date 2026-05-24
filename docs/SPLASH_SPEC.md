# Cinematic Splash Screen — Implementation Spec

A reference for reproducing the **AIsaiah** animated splash in another Flutter app.
Source: `lib/splash_screen.dart` (the `SplashScreen` widget) wired in `lib/main.dart`.

The effect: a vector logo (cross/dove + "AIsaiah" wordmark + tagline) floating in a
deep navy void, wrapped in a soft multi-color glow. On launch it fades + scales in,
the glow breathes, a purple→cyan gradient flows continuously across the wordmark, and
after a brief hold the splash cross-fades into the app's main screen.

---

## 1. Dependencies & assets

```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.10        # renders the vector logo + wordmark

flutter:
  assets:
    - assets/images/          # contains Cross.svg and AIsaiah.svg
```

Two SVGs drive the logo:

| Asset                      | Role                       | Render width |
|----------------------------|----------------------------|--------------|
| `assets/images/Cross.svg`  | Cross / dove mark          | `150` px     |
| `assets/images/AIsaiah.svg`| Wordmark (recolored, see §5)| `210` px    |

> The wordmark SVG should be **solid/monochrome** (ideally white or black fills). Its
> shape is used as a mask and recolored at runtime by a gradient — any baked-in color is
> overwritten by the `ShaderMask`.

---

## 2. Layer architecture (back → front)

The whole screen is a `Stack` of four conceptual layers:

```
┌─────────────────────────────────────────────┐
│ 4. Crisp logo group (cross + wordmark + tag) │  ← sharp, on top
│ 3. Layered emissive bloom (3 blurred copies) │  ← halo / glow
│ 2. Ambient color haze (purple + teal blobs)  │  ← light spill
│ 1. Deep navy radial backdrop                 │  ← never pure black
└─────────────────────────────────────────────┘
```

1. **Backdrop** — `RadialGradient` `#111827 → #050816 → #000000` (stops `0.0, 0.45, 1.0`,
   radius `0.95`, centered). Avoid pure black; the navy core gives depth.
2. **Ambient haze** — two `RadialGradient` circles ("light blobs") that fade color→transparent:
   - purple `#8B5CF6`, ⌀640, aligned `(0, -0.18)`, opacity `0.26 × glow`
   - teal `#14B8A6`, ⌀540, aligned `(0, 0.12)`, opacity `0.16 × glow`
3. **Bloom** — the *same logo group* rendered 3 times, each blurred + scaled out + faded,
   stacked behind the crisp copy. This is what gives the logo luminous separation:

   | Blur σ | Opacity        | Scale |
   |--------|----------------|-------|
   | 48     | `0.50 × breath`| 1.18  |
   | 24     | `0.62 × breath`| 1.08  |
   | 10     | `0.78 × breath`| 1.01  |

4. **Logo group** — `Column` of: cross SVG → 22px gap → gradient wordmark → 11px gap →
   tagline `FAITH.  GROWTH.  PURPOSE.` (9px, letterSpacing 3.0, white @55%).

Layers 3+4 sit inside a `Center` → `FadeTransition` → `ScaleTransition` so they share the
entrance animation. Layers 1+2 are `Positioned.fill`.

---

## 3. Animation controllers

Three independent controllers, merged into one `AnimatedBuilder` via
`Listenable.merge([_entrance, _pulse, _flow])`:

| Controller | Duration | Mode                 | Drives                                            |
|------------|----------|----------------------|---------------------------------------------------|
| `_entrance`| 1400 ms  | `forward()` once     | fade `0→1` + scale `0.86→1.0` (`Curves.easeOutCubic`) |
| `_pulse`   | 2800 ms  | `repeat(reverse:true)`| "breath" — glow brightness                        |
| `_flow`    | 5200 ms  | `repeat()`           | horizontal gradient slide across the wordmark     |

Derived values each frame:

```dart
final breath = 0.60 + 0.40 * _pulse.value;   // 0.6 → 1.0 swing
final glow   = breath * _fade.value;          // breath gated by entrance fade
final flow   = _flow.value;                   // 0 → 1, one seamless loop
```

`breath` scales bloom opacity + haze; gating by `_fade.value` means the glow *blooms in*
with the entrance rather than popping at full strength.

> Uses `TickerProviderStateMixin` (3 controllers). Dispose all three (and the timer, §4).

---

## 4. Splash sequence & navigation

The splash is a **timed sequence**, not a dead-end screen. `SplashScreen` takes the
destination as a constructor parameter (avoids a circular import with `main.dart`):

```dart
// main.dart
home: const SplashScreen(next: HomeScreen()),
```

Flow:

```
launch ──► entrance (1.4s) ──► hold ──► [2.8s total] ──► cross-fade ──► next screen
                  └──────────── tap anywhere skips straight to cross-fade ───────────┘
```

```dart
// initState
_advance = Timer(const Duration(milliseconds: 2800), _goHome);

void _goHome() {
  if (_leaving || !mounted) return;   // idempotent: timer OR tap, fires once
  _leaving = true;
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (_, __, ___) => widget.next,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ),
  );
}
```

Key points:
- **`pushReplacement`** so the splash isn't kept on the back stack.
- **`_leaving` guard** so the auto-advance timer and a user tap can't double-navigate.
- **Cancel the timer in `dispose()`** to avoid calling `Navigator` after unmount.
- 2800 ms total = 1400 ms entrance + ~1400 ms hold on the fully-bloomed logo. Tune to taste.

---

## 5. Key technique — flowing gradient wordmark

The wordmark color "flows" by masking a **repeating** linear gradient with the SVG shape
and translating the gradient horizontally each frame.

```dart
ShaderMask(
  blendMode: BlendMode.srcIn,                  // keep gradient only where SVG is opaque
  shaderCallback: (bounds) => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: _flowColors,                        // see palette below
    tileMode: TileMode.repeated,                // wraps for a seamless loop
    transform: _SlideGradient(flow),            // slides by `flow × width`
  ).createShader(bounds),
  child: SvgPicture.asset('assets/images/AIsaiah.svg', width: 210),
)
```

The slide is a custom `GradientTransform`:

```dart
class _SlideGradient extends GradientTransform {
  final double fraction;
  const _SlideGradient(this.fraction);
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * fraction, 0.0, 0.0);
}
```

**Why the palette is mirrored** (`_flowColors` starts and ends on the same purple):
`purple → blue-violet → azure → cyan → azure → blue-violet → purple`. With
`TileMode.repeated`, identical endpoints make the loop seamless (no color jump on wrap).

---

## 6. Color palette / tokens

```dart
// Haze accents
const purple = Color(0xFF8B5CF6);
const teal   = Color(0xFF14B8A6);

// Backdrop radial
[Color(0xFF111827), Color(0xFF050816), Color(0xFF000000)]  // stops 0.0, 0.45, 1.0

// Wordmark flow gradient (mirrored for seamless repeat)
const flowColors = [
  Color(0xFF6A2C91), // purple
  Color(0xFF5538B8), // blue-violet
  Color(0xFF2C8FD0), // azure
  Color(0xFF12A0D8), // cyan
  Color(0xFF2C8FD0), // azure
  Color(0xFF5538B8), // blue-violet
  Color(0xFF6A2C91), // purple
];
```

---

## 7. Porting checklist (drop into another app)

1. Add `flutter_svg` and your two SVG assets; declare them in `pubspec.yaml`.
2. Copy `SplashScreen` + `_SlideGradient` into the new project.
3. Swap the asset paths, render widths, palette, and tagline for the new brand.
4. Ensure the wordmark SVG is a solid silhouette (color is applied at runtime).
5. Set `home: SplashScreen(next: <YourFirstScreen>())`.
6. Tune timings: `_entrance` (entrance feel), `2800 ms` Timer (total dwell),
   `_flow`/`_pulse` durations (motion speed), bloom σ/opacity/scale (glow strength).

---

## 8. Platform / rendering notes

- **Renderer-independent.** The splash relies only on `ShaderMask`, `ImageFiltered` blur,
  `RadialGradient`, and `flutter_svg` — it renders identically on Impeller and Skia. No
  custom fragment shaders, so no `shaders:` entry or `.frag` files are needed.
- **iOS 26.x debug-mode caveat (this project's environment).** Running on a physical
  iPhone on iOS 26.4.2 in **debug** mode crashes at launch with `EXC_BAD_ACCESS` — a Dart
  JIT/lldb issue with that OS, *not* a splash bug (it reproduces under both renderers, and
  **release/profile mode runs fine**). On-device: use `flutter run --release` (or
  `--profile`). The simulator runs debug fine. See memory `feedback_physical_device`.
- **Performance.** The bloom blurs the live logo group 3× every frame while animating.
  It's cheap at this size, but if targeting low-end devices, consider rasterizing the
  logo once (`RepaintBoundary` + cached image) and blurring that instead.
