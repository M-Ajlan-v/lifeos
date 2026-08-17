import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../main_screen.dart';
import 'register_screen.dart';
import 'package:lifeos/screens/auth/widgets/login_action_button.dart';
import 'package:lifeos/screens/auth/widgets/login_ambient_background.dart';
import 'package:lifeos/screens/auth/widgets/login_brand_mark.dart';
import 'package:lifeos/screens/auth/widgets/login_text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _usernameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  late final AnimationController
      _entranceController;

  late final AnimationController
      _ambientController;

  late final Animation<double>
      _heroFade;

  late final Animation<Offset>
      _heroSlide;

  late final Animation<double>
      _formFade;

  late final Animation<Offset>
      _formSlide;

  @override
  void initState() {
    super.initState();

    // =========================================================
    // ENTRANCE
    // =========================================================
    _entranceController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 850,
      ),
    );

    _heroFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0,
        0.65,
        curve: Curves.easeOut,
      ),
    );

    _heroSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.10,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _formFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.25,
        1,
        curve: Curves.easeOut,
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.08,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.25,
          1,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // =========================================================
    // AMBIENT EFFECTS
    // =========================================================
    _ambientController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 6500,
      ),
    );

    _entranceController.forward();

    _ambientController.repeat();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    _entranceController.dispose();
    _ambientController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        Provider.of<AuthProvider>(
      context,
    );

    final bottomInset =
        MediaQuery.of(context)
            .viewInsets
            .bottom;

    return Scaffold(
      backgroundColor:
          AppTheme.background,
      body: Stack(
        children: [
          // =====================================================
          // AMBIENT BACKGROUND
          // =====================================================
          Positioned.fill(
            child:
                LoginAmbientBackground(
              animation:
                  _ambientController,
            ),
          ),

          // =====================================================
          // CONTENT
          // =====================================================
          SafeArea(
            child: Center(
              child:
                  SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    EdgeInsets.fromLTRB(
                  AppTheme
                      .screenPaddingLarge,
                  16,
                  AppTheme
                      .screenPaddingLarge,
                  24 + bottomInset,
                ),
                child:
                    ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),

                        // =========================================
                        // HERO
                        // =========================================
                        FadeTransition(
                          opacity:
                              _heroFade,
                          child:
                              SlideTransition(
                            position:
                                _heroSlide,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                LoginBrandMark(
                                  animation:
                                      _ambientController,
                                ),

                                const SizedBox(
                                  height: 27,
                                ),

                                const Text(
                                  'Welcome back',
                                  style:
                                      TextStyle(
                                    color: AppTheme
                                        .textPrimary,
                                    fontFamily:
                                        'Outfit',
                                    fontSize:
                                        32,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                    height: 1.05,
                                    letterSpacing:
                                        -0.6,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                const Text(
                                  'Your life, organized in one place.',
                                  style:
                                      TextStyle(
                                    color: AppTheme
                                        .textSecondary,
                                    fontFamily:
                                        'Outfit',
                                    fontSize:
                                        14,
                                    fontWeight:
                                        FontWeight
                                            .w400,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // =========================================
                        // LOGIN PANEL
                        // =========================================
                        FadeTransition(
                          opacity:
                              _formFade,
                          child:
                              SlideTransition(
                            position:
                                _formSlide,
                            child:
                                Container(
                              padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                17,
                                18,
                                17,
                                17,
                              ),
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  begin: Alignment
                                      .topLeft,
                                  end: Alignment
                                      .bottomRight,
                                  colors: [
                                    AppTheme
                                        .cardElevated
                                        .withOpacity(
                                      0.96,
                                    ),
                                    AppTheme.card
                                        .withOpacity(
                                      0.96,
                                    ),
                                    AppTheme
                                        .surfaceDeep
                                        .withOpacity(
                                      0.98,
                                    ),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  24,
                                ),
                                border:
                                    Border.all(
                                  color: AppTheme
                                      .glassBorderStrong,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                      0.34,
                                    ),
                                    blurRadius:
                                        30,
                                    offset:
                                        const Offset(
                                      0,
                                      15,
                                    ),
                                  ),
                                  BoxShadow(
                                    color: AppTheme
                                        .violet
                                        .withOpacity(
                                      0.055,
                                    ),
                                    blurRadius:
                                        30,
                                  ),
                                ],
                              ),
                              child:
                                  Stack(
                                clipBehavior:
                                    Clip.none,
                                children: [
                                  // =================================
                                  // TOP LIGHT
                                  // =================================
                                  Positioned(
                                    left: 24,
                                    right: 24,
                                    top: -18,
                                    child:
                                        Container(
                                      height: 1,
                                      decoration:
                                          BoxDecoration(
                                        gradient:
                                            LinearGradient(
                                          colors: [
                                            Colors
                                                .transparent,
                                            AppTheme
                                                .violetBright
                                                .withOpacity(
                                              0.30,
                                            ),
                                            Colors
                                                .white
                                                .withOpacity(
                                              0.12,
                                            ),
                                            Colors
                                                .transparent,
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
                                        'Sign in',
                                        style:
                                            TextStyle(
                                          color: AppTheme
                                              .textPrimary,
                                          fontFamily:
                                              'Outfit',
                                          fontSize:
                                              17,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      const Text(
                                        'Continue to LifeOS',
                                        style:
                                            TextStyle(
                                          color: AppTheme
                                              .textMuted,
                                          fontFamily:
                                              'Outfit',
                                          fontSize:
                                              11,
                                          fontWeight:
                                              FontWeight
                                                  .w400,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 18,
                                      ),

                                      LoginTextField(
                                        controller:
                                            _usernameController,
                                        label:
                                            'Username',
                                        icon: Icons
                                            .person_outline_rounded,
                                        validator:
                                            (v) =>
                                                v == null ||
                                                        v.isEmpty
                                                    ? 'Username is required'
                                                    : null,
                                      ),

                                      const SizedBox(
                                        height: 13,
                                      ),

                                      LoginTextField(
                                        controller:
                                            _passwordController,
                                        label:
                                            'Password',
                                        icon: Icons
                                            .lock_outline_rounded,
                                        obscureText:
                                            true,
                                        validator:
                                            (v) =>
                                                v == null ||
                                                        v.isEmpty
                                                    ? 'Password is required'
                                                    : null,
                                      ),

                                      if (auth.error !=
                                          null) ...[
                                        const SizedBox(
                                          height: 14,
                                        ),

                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal:
                                                13,
                                            vertical:
                                                11,
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
                                          child:
                                              Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .error_outline_rounded,
                                                color:
                                                    AppTheme.expense,
                                                size:
                                                    19,
                                              ),
                                              const SizedBox(
                                                width:
                                                    9,
                                              ),
                                              Expanded(
                                                child:
                                                    Text(
                                                  auth.error!,
                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        AppTheme.expense,
                                                    fontFamily:
                                                        'Outfit',
                                                    fontSize:
                                                        12,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    height:
                                                        1.35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      const SizedBox(
                                        height: 19,
                                      ),

                                      // =====================================
                                      // LOGIN
                                      // =====================================
                                      LoginActionButton(
                                        animation:
                                            _ambientController,
                                        isLoading:
                                            auth.isLoading,
                                        onPressed:
                                            auth.isLoading
                                                ? null
                                                : () async {
                                                    if (_formKey.currentState!.validate()) {
                                                      final success = await auth.login(
                                                        username: _usernameController.text.trim(),
                                                        password: _passwordController.text,
                                                      );

                                                      if (success &&
                                                          context.mounted) {
                                                        Navigator.of(context).pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder: (_) => const MainScreen(),
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
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // =========================================
                        // DIVIDER
                        // =========================================
                        FadeTransition(
                          opacity:
                              _formFade,
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    Container(
                                  height: 1,
                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        LinearGradient(
                                      colors: [
                                        Colors
                                            .transparent,
                                        AppTheme
                                            .divider,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      13,
                                ),
                                child: Text(
                                  'NEW TO LIFEOS?',
                                  style: AppTheme
                                      .caption
                                      .copyWith(
                                    fontSize:
                                        10,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                    letterSpacing:
                                        1.25,
                                  ),
                                ),
                              ),

                              Expanded(
                                child:
                                    Container(
                                  height: 1,
                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        LinearGradient(
                                      colors: [
                                        AppTheme
                                            .divider,
                                        Colors
                                            .transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // =========================================
                        // CREATE ACCOUNT
                        // =========================================
                        FadeTransition(
                          opacity:
                              _formFade,
                          child:
                              Container(
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme
                                      .violet
                                      .withOpacity(
                                    0.025,
                                  ),
                                  blurRadius:
                                      14,
                                ),
                              ],
                            ),
                            child:
                                TextButton(
                              onPressed: () {
                                auth.clearError();

                                Navigator.of(
                                  context,
                                ).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              style:
                                  TextButton
                                      .styleFrom(
                                foregroundColor:
                                    AppTheme
                                        .textPrimary,
                                minimumSize:
                                    const Size(
                                  double.infinity,
                                  50,
                                ),
                                backgroundColor:
                                    Colors.white
                                        .withOpacity(
                                  0.025,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14,
                                  ),
                                  side:
                                      BorderSide(
                                    color: AppTheme
                                        .glassBorderStrong,
                                  ),
                                ),
                              ),
                              child:
                                  const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                    Icons
                                        .person_add_alt_1_rounded,
                                    size:
                                        17,
                                  ),
                                  SizedBox(
                                    width:
                                        8,
                                  ),
                                  Text(
                                    'Create Account',
                                    style:
                                        TextStyle(
                                      fontFamily:
                                          'Outfit',
                                      fontSize:
                                          14,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // =========================================
                        // FOOTER
                        // =========================================
                        Center(
                          child: ShaderMask(
                            blendMode:
                                BlendMode.srcIn,
                            shaderCallback:
                                (bounds) =>
                                    const LinearGradient(
                              colors: [
                                AppTheme
                                    .textMuted,
                                AppTheme
                                    .violetBright,
                                AppTheme
                                    .orangeBright,
                              ],
                            ).createShader(
                              bounds,
                            ),
                            child:
                                const Text(
                              'LIFEOS',
                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontFamily:
                                    'Outfit',
                                fontSize:
                                    10,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                letterSpacing:
                                    3.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),
                      ],
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