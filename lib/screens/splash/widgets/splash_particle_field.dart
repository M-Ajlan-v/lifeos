import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class SplashParticleField extends StatefulWidget {
  const SplashParticleField({
    super.key,
  });

  @override
  State<SplashParticleField> createState() =>
      _SplashParticleFieldState();
}

class _SplashParticleFieldState
    extends State<SplashParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(
                progress: _controller.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;

  const _ParticlePainter({
    required this.progress,
  });

  static const particles = <_Particle>[
    _Particle(.08, .10, 1.4, true, .2),
    _Particle(.22, .17, 2.1, false, 1.1),
    _Particle(.39, .08, 1.1, true, 2.0),
    _Particle(.63, .13, 1.7, false, 2.8),
    _Particle(.80, .08, 1.1, true, 3.5),
    _Particle(.92, .18, 2.0, false, 4.3),

    _Particle(.13, .29, 1.0, false, .8),
    _Particle(.28, .34, 2.2, true, 1.7),
    _Particle(.72, .30, 1.2, false, 2.4),
    _Particle(.88, .37, 1.8, true, 3.3),

    // Leave centre clean.
    _Particle(.06, .47, 1.7, true, 1.4),
    _Particle(.17, .55, 1.0, false, 2.2),
    _Particle(.83, .48, 1.0, true, 3.1),
    _Particle(.95, .56, 1.9, false, 4.0),

    _Particle(.11, .68, 1.4, false, .6),
    _Particle(.28, .73, 2.0, true, 1.5),
    _Particle(.70, .69, 1.1, false, 2.8),
    _Particle(.86, .76, 1.8, true, 3.8),

    _Particle(.08, .89, 1.0, true, .4),
    _Particle(.32, .85, 1.7, false, 1.6),
    _Particle(.52, .92, 2.1, true, 2.6),
    _Particle(.73, .87, 1.1, false, 3.5),
    _Particle(.93, .91, 1.7, true, 4.4),
  ];

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final time = progress * math.pi * 2;

    _drawAmbientOrbits(
      canvas,
      size,
      time,
    );

    _drawParticles(
      canvas,
      size,
      time,
    );

    _drawStreak(
      canvas,
      size,
      .14,
      .22,
      18,
      true,
      time + .6,
    );

    _drawStreak(
      canvas,
      size,
      .84,
      .26,
      13,
      false,
      time + 2.1,
    );

    _drawStreak(
      canvas,
      size,
      .14,
      .78,
      15,
      false,
      time + 3.0,
    );

    _drawStreak(
      canvas,
      size,
      .82,
      .82,
      19,
      true,
      time + 1.4,
    );
  }

  void _drawParticles(
    Canvas canvas,
    Size size,
    double time,
  ) {
    for (final particle in particles) {
      final angle = time + particle.phase;

      final driftX =
          math.sin(angle * .85) * 4;

      final driftY =
          math.cos(angle * .72) * 5.5;

      final center = Offset(
        size.width * particle.x + driftX,
        size.height * particle.y + driftY,
      );

      final pulse =
          .72 +
          math.sin(angle * 1.45) * .22;

      final color = particle.violet
          ? AppTheme.violetBright
          : AppTheme.orangeBright;

      // Wide soft glow.
      final glowPaint = Paint()
        ..color = color.withOpacity(
          .075 * pulse,
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          10,
        );

      canvas.drawCircle(
        center,
        particle.radius * 5,
        glowPaint,
      );

      // Particle body.
      final bodyPaint = Paint()
        ..color = color.withOpacity(
          .58 * pulse,
        );

      canvas.drawCircle(
        center,
        particle.radius,
        bodyPaint,
      );

      // Bright centre for larger particles.
      if (particle.radius >= 1.7) {
        canvas.drawCircle(
          center,
          particle.radius * .34,
          Paint()
            ..color = Colors.white.withOpacity(
              .38 * pulse,
            ),
        );
      }
    }
  }

  void _drawAmbientOrbits(
    Canvas canvas,
    Size size,
    double time,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    // Almost invisible orbital arcs.
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .6
      ..color = AppTheme.violetBright.withOpacity(.055);

    final rect = Rect.fromCenter(
      center: center,
      width: size.width * .63,
      height: size.width * .23,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-.35);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawArc(
      rect,
      .3,
      1.1,
      false,
      orbitPaint,
    );

    canvas.drawArc(
      rect,
      3.3,
      .9,
      false,
      orbitPaint,
    );

    canvas.restore();

    // Violet orbiting particle.
    final radiusX = size.width * .30;
    final radiusY = size.width * .10;

    final orbit1 = Offset(
      center.dx + math.cos(time * .55) * radiusX,
      center.dy + math.sin(time * .55) * radiusY,
    );

    _drawOrbitalParticle(
      canvas,
      orbit1,
      AppTheme.violetBright,
    );

    // Orange particle moving opposite direction.
    final orbit2 = Offset(
      center.dx +
          math.cos(-time * .42 + 2.8) *
              radiusX,
      center.dy +
          math.sin(-time * .42 + 2.8) *
              radiusY,
    );

    _drawOrbitalParticle(
      canvas,
      orbit2,
      AppTheme.orangeBright,
    );
  }

  void _drawOrbitalParticle(
    Canvas canvas,
    Offset center,
    Color color,
  ) {
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..color = color.withOpacity(.08)
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          8,
        ),
    );

    canvas.drawCircle(
      center,
      1.3,
      Paint()
        ..color = color.withOpacity(.72),
    );
  }

  void _drawStreak(
    Canvas canvas,
    Size size,
    double x,
    double y,
    double length,
    bool violet,
    double animation,
  ) {
    final movement =
        math.sin(animation * .7) * 3;

    final center = Offset(
      size.width * x,
      size.height * y + movement,
    );

    final color = violet
        ? AppTheme.violetBright
        : AppTheme.orangeBright;

    final opacity =
        .15 +
        (math.sin(animation * 1.2) + 1) *
            .045;

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    canvas.save();

    canvas.translate(
      center.dx,
      center.dy,
    );

    canvas.rotate(-.7);

    canvas.drawLine(
      Offset(-length / 2, 0),
      Offset(length / 2, 0),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(
    covariant _ParticlePainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final bool violet;
  final double phase;

  const _Particle(
    this.x,
    this.y,
    this.radius,
    this.violet,
    this.phase,
  );
}