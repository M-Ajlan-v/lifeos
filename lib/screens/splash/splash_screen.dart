import 'package:flutter/material.dart';

import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/splash/widgets/lifeos_wordmark.dart';
import 'package:lifeos/screens/splash/widgets/splash_particle_field.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _ambientController;

  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _verticalMovement;
  late final Animation<double> _ambient;

  @override
  void initState() {
    super.initState();

    // -----------------------------------------------------------
    // Initial LifeOS entrance animation
    // -----------------------------------------------------------
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1100,
      ),
    );

    _fade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0,
        .65,
        curve: Curves.easeOut,
      ),
    );

    _scale = Tween<double>(
      begin: .88,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutBack,
      ),
    );

    _verticalMovement = Tween<double>(
      begin: 14,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
      ),
    );

    // -----------------------------------------------------------
    // Continuous ambient breathing animation
    // -----------------------------------------------------------
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2600,
      ),
    )..repeat(
        reverse: true,
      );

    _ambient = CurvedAnimation(
      parent: _ambientController,
      curve: Curves.easeInOut,
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _ambientController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // =====================================================
          // BREATHING BACKGROUND
          // =====================================================
          AnimatedBuilder(
            animation: _ambient,
            builder: (context, child) {
              return _AnimatedBackground(
                intensity: _ambient.value,
              );
            },
          ),

          // =====================================================
          // PARTICLES
          // =====================================================
          const SplashParticleField(),

          // =====================================================
          // CENTER LifeOS
          // =====================================================
          Center(
            child: AnimatedBuilder(
              animation: _introController,
              builder: (
                context,
                child,
              ) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    _verticalMovement.value,
                  ),
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: LifeOSWordmark(
                        glowAnimation: _ambient,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground
    extends StatelessWidget {
  final double intensity;

  const _AnimatedBackground({
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(
            -.05 + intensity * .1,
            -.06 + intensity * .08,
          ),
          radius: .95,
          colors: [
            Color.lerp(
              const Color(0xFF171120),
              const Color(0xFF1D142A),
              intensity,
            )!,
            const Color(0xFF100E17),
            AppTheme.background,
          ],
          stops: const [
            0,
            .48,
            1,
          ],
        ),
      ),
    );
  }
}