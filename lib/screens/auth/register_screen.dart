import 'package:flutter/material.dart';
import 'package:lifeos/screens/auth/widgets/register_action_button.dart';
import 'package:lifeos/screens/auth/widgets/register_brand_mark.dart';
import 'package:lifeos/screens/auth/widgets/register_text_field.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../main_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final AnimationController _entranceController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        0.045,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();

    _entranceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // =========================================================
          // BACKGROUND BASE
          // =========================================================
          const Positioned.fill(
            child: ColoredBox(
              color: AppTheme.background,
            ),
          ),

          // =========================================================
          // VIOLET AMBIENT LIGHT
          // =========================================================
          Positioned(
            top: -170,
            right: -155,
            child: IgnorePointer(
              child: Container(
                width: 390,
                height: 390,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.violetBright.withOpacity(
                        0.14,
                      ),
                      AppTheme.violet.withOpacity(
                        0.045,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // =========================================================
          // ORANGE AMBIENT LIGHT
          // =========================================================
          Positioned(
            left: -165,
            bottom: -195,
            child: IgnorePointer(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.orange.withOpacity(
                        0.08,
                      ),
                      AppTheme.orange.withOpacity(
                        0.02,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // =========================================================
          // SOFT MID SCREEN DEPTH
          // =========================================================
          Positioned(
            left: -90,
            top: 310,
            child: IgnorePointer(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.violet.withOpacity(
                        0.035,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // =========================================================
          // CONTENT
          // =========================================================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppTheme.screenPaddingLarge,
                  12,
                  AppTheme.screenPaddingLarge,
                  24 + bottomInset,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Form(
                    key: _formKey,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            // =========================================
                            // BACK
                            // =========================================
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withOpacity(
                                    0.035,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    13,
                                  ),
                                  border: Border.all(
                                    color: AppTheme
                                        .glassBorderStrong,
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons
                                        .arrow_back_ios_new_rounded,
                                    size: 18,
                                    color:
                                        AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =========================================
                            // BRAND
                            // =========================================
                            const RegisterBrandMark(),

                            const SizedBox(height: 24),

                            // =========================================
                            // TITLE
                            // =========================================
                            const Text(
                              'Create your account',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontFamily: 'Outfit',
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                                letterSpacing: -0.55,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Build your LifeOS and keep everything in one place.',
                              style: TextStyle(
                                color:
                                    AppTheme.textSecondary,
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                              ),
                            ),

                            const SizedBox(height: 26),

                            // =========================================
                            // FORM SURFACE
                            // =========================================
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                16,
                                17,
                                16,
                                16,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.cardElevated
                                        .withOpacity(0.97),
                                    AppTheme.card
                                        .withOpacity(0.97),
                                    AppTheme.surfaceDeep
                                        .withOpacity(0.98),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  24,
                                ),
                                border: Border.all(
                                  color: AppTheme
                                      .glassBorderStrong,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.32),
                                    blurRadius: 28,
                                    offset:
                                        const Offset(0, 14),
                                  ),
                                  BoxShadow(
                                    color: AppTheme.violet
                                        .withOpacity(0.045),
                                    blurRadius: 26,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // =================================
                                  // TOP HIGHLIGHT
                                  // =================================
                                  Positioned(
                                    left: 25,
                                    right: 25,
                                    top: 0,
                                    child: Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient:
                                            LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            AppTheme
                                                .violetBright
                                                .withOpacity(
                                              0.28,
                                            ),
                                            Colors.white
                                                .withOpacity(
                                              0.10,
                                            ),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .stretch,
                                    children: [
                                      const Text(
                                        'Account details',
                                        style: TextStyle(
                                          color: AppTheme
                                              .textPrimary,
                                          fontFamily: 'Outfit',
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.w700,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      const Text(
                                        'Enter your details below',
                                        style: TextStyle(
                                          color:
                                              AppTheme.textMuted,
                                          fontFamily: 'Outfit',
                                          fontSize: 11,
                                        ),
                                      ),

                                      const SizedBox(height: 17),

                                      // =================================
                                      // USERNAME
                                      // =================================
                                      RegisterTextField(
                                        controller:
                                            _usernameController,
                                        label: 'Username',
                                        icon: Icons
                                            .person_outline_rounded,
                                        validator: (v) =>
                                            v == null ||
                                                    v.isEmpty
                                                ? 'Username is required'
                                                : null,
                                      ),

                                      const SizedBox(height: 12),

                                      // =================================
                                      // PASSWORD
                                      // =================================
                                      RegisterTextField(
                                        controller:
                                            _passwordController,
                                        label: 'Password',
                                        icon: Icons
                                            .lock_outline_rounded,
                                        obscureText: true,
                                        validator: (v) =>
                                            v == null ||
                                                    v.isEmpty
                                                ? 'Password is required'
                                                : null,
                                      ),

                                      const SizedBox(height: 12),

                                      // =================================
                                      // CONFIRM PASSWORD
                                      // =================================
                                      RegisterTextField(
                                        controller:
                                            _confirmPasswordController,
                                        label:
                                            'Confirm Password',
                                        icon: Icons
                                            .verified_user_outlined,
                                        obscureText: true,
                                        validator: (v) {
                                          if (v == null ||
                                              v.isEmpty) {
                                            return 'Please confirm your password';
                                          }

                                          if (v !=
                                              _passwordController
                                                  .text) {
                                            return 'Passwords do not match';
                                          }

                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 12),

                                      // =================================
                                      // DISPLAY NAME
                                      // =================================
                                      RegisterTextField(
                                        controller:
                                            _displayNameController,
                                        label: 'Display Name',
                                        hintText: 'Optional',
                                        icon: Icons
                                            .badge_outlined,
                                      ),

                                      // =================================
                                      // ERROR
                                      // =================================
                                      if (auth.error !=
                                          null) ...[
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal: 13,
                                            vertical: 11,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: AppTheme
                                                .expense
                                                .withOpacity(
                                              0.08,
                                            ),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              12,
                                            ),
                                            border:
                                                Border.all(
                                              color: AppTheme
                                                  .expense
                                                  .withOpacity(
                                                0.22,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .error_outline_rounded,
                                                color: AppTheme
                                                    .expense,
                                                size: 19,
                                              ),
                                              const SizedBox(
                                                width: 9,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  auth.error!,
                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        AppTheme.expense,
                                                    fontFamily:
                                                        'Outfit',
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      const SizedBox(height: 19),

                                      // =================================
                                      // CREATE ACCOUNT BUTTON
                                      // =================================
                                      RegisterActionButton(
                                        isLoading:
                                            auth.isLoading,
                                        onPressed:
                                            auth.isLoading
                                                ? null
                                                : () async {
                                                    if (_formKey.currentState!.validate()) {
                                                      final success =
                                                          await auth.register(
                                                        username:
                                                            _usernameController.text.trim(),
                                                        password:
                                                            _passwordController.text,
                                                        displayName:
                                                            _displayNameController.text.trim().isEmpty
                                                                ? null
                                                                : _displayNameController.text.trim(),
                                                      );

                                                      if (success &&
                                                          context.mounted) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Account created successfully',
                                                            ),
                                                            backgroundColor:
                                                                AppTheme.incomeDark,
                                                          ),
                                                        );

                                                        Navigator.of(
                                                          context,
                                                        ).pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                const MainScreen(),
                                                          ),
                                                          (route) => false,
                                                        );
                                                      }
                                                    }
                                                  },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 21),

                            // =========================================
                            // FOOTER
                            // =========================================
                            Center(
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    AppTheme.textMuted,
                                    AppTheme.violetBright,
                                    AppTheme.orangeBright,
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'LIFEOS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Outfit',
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.w700,
                                    letterSpacing: 3.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}