import 'package:flutter/material.dart';

/// ===============================================================
/// LIFEOS DESIGN SYSTEM
/// ===============================================================
///
/// This file contains the complete visual system for LifeOS:
///
/// 1. App Colors
/// 2. Semantic / Financial Colors
/// 3. Gradients
/// 4. Typography
/// 5. Border Radius
/// 6. Spacing
/// 7. Shadows / Glows
/// 8. ThemeData
///
/// IMPORTANT:
/// Screens should use these values instead of hardcoding colors,
/// font sizes, gradients, radii, etc.
/// ===============================================================

class AppTheme {
  AppTheme._();

  // ===============================================================
  // COLORS
  // ===============================================================

  /// Main application background.
  static const Color background = Color(0xFF08090B);

  /// Secondary dark background used for sections/navigation.
  static const Color backgroundSecondary = Color(0xFF101114);

  /// Standard card background.
  static const Color card = Color(0xFF17181C);

  /// Elevated card background.
  static const Color cardElevated = Color(0xFF1D1F24);

  // ---------------------------------------------------------------
  // GOLD
  // ---------------------------------------------------------------

  /// Main premium LifeOS gold.
  static const Color gold = Color(0xFFD6A84F);

  /// Bright/champagne gold.
  static const Color goldLight = Color(0xFFF0D18A);

  /// Dark gold.
  static const Color goldDark = Color(0xFF9D7430);

  /// Deep gold used as a gradient starting point.
  static const Color goldDeep = Color(0xFF8A5A20);

  // ---------------------------------------------------------------
  // TEXT
  // ---------------------------------------------------------------

  /// Main text color.
  static const Color textPrimary = Color(0xFFF5F5F2);

  /// Secondary text.
  static const Color textSecondary = Color(0xFFA8A8A3);

  /// Low-emphasis / muted text.
  static const Color textMuted = Color(0xFF6F706D);

  // ---------------------------------------------------------------
  // BORDERS / DIVIDERS
  // ---------------------------------------------------------------

  /// Standard divider color.
  static const Color divider = Color(0xFF292A2E);

  /// Card border.
  static const Color cardBorder = Color(0xFF34353A);

  /// Very subtle white border for glass-like components.
  static const Color glassBorder = Color(0x14FFFFFF);

  // ---------------------------------------------------------------
  // FINANCIAL / SEMANTIC COLORS
  // ---------------------------------------------------------------

  /// Income / money received / positive financial value.
  static const Color income = Color(0xFF4DB58A);

  /// Dark income color used in income gradients.
  static const Color incomeDark = Color(0xFF185A45);

  /// Expense / money spent / negative financial value.
  static const Color expense = Color(0xFFE56B6F);

  /// Dark expense color used in expense gradients.
  static const Color expenseDark = Color(0xFF67252A);

  /// Warning state.
  static const Color warning = Color(0xFFD9A441);

  /// Transfer color.
  static const Color transfer = Color(0xFFD6A84F);

  /// Information / analytics color.
  static const Color info = Color(0xFF263A58);

  // ---------------------------------------------------------------
  // ADDITIONAL GRADIENT COLORS
  // ---------------------------------------------------------------

  /// Bright ruby used at the end of the expense gradient.
  static const Color rubyBright = Color(0xFFC6535A);

  /// Dark emerald used at the beginning of the income gradient.
  static const Color emeraldDark = Color(0xFF10251F);

  /// Dark midnight blue used for analytics.
  static const Color midnightDark = Color(0xFF0D111A);

  /// Middle midnight blue.
  static const Color midnight = Color(0xFF172338);

  /// Dark purple used for special/advanced features.
  static const Color purpleDark = Color(0xFF111018);

  /// Middle purple.
  static const Color purple = Color(0xFF252033);

  /// Bright purple.
  static const Color purpleBright = Color(0xFF453665);

  // ===============================================================
  // GRADIENTS
  // ===============================================================

  static const LinearGradient signatureGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      goldDeep,
      gold,
      goldLight,
    ],
  );

  static const LinearGradient blackGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF111214),
      Color(0xFF302518),
      Color(0xFF80602F),
    ],
  );

  static const LinearGradient champagneGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB8863B),
      gold,
      Color(0xFFF5DFA7),
    ],
  );

  static const LinearGradient graphiteGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      card,
      Color(0xFF22201C),
      Color(0xFF332A1D),
    ],
  );

  static const LinearGradient goldGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gold,
      Color(0xFF7A5826),
      card,
    ],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      emeraldDark,
      incomeDark,
      income,
    ],
  );

  static const LinearGradient rubyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF291417),
      expenseDark,
      rubyBright,
    ],
  );

  static const LinearGradient midnightBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      midnightDark,
      midnight,
      Color(0xFF263A58),
    ],
  );

  static const LinearGradient purpleBlackGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      purpleDark,
      purple,
      purpleBright,
    ],
  );

  static const LinearGradient obsidianGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B1C20),
      Color(0xFF0A0B0D),
    ],
  );

  /// Primary button gradient.
  static const LinearGradient buttonGoldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFB8863B),
      Color(0xFFE3BD67),
    ],
  );

  // ===============================================================
  // BORDER RADIUS
  // ===============================================================

  /// Small UI elements.
  static const double radiusSmall = 10;

  /// Medium controls.
  static const double radiusMedium = 14;

  /// Standard cards.
  static const double radiusCard = 18;

  /// Large cards.
  static const double radiusLarge = 24;

  /// Hero / premium cards.
  static const double radiusHero = 28;

  /// Bottom sheets.
  static const double radiusBottomSheet = 28;

  // ===============================================================
  // SPACING
  // ===============================================================

  /// Small spacing.
  static const double space8 = 8;

  /// Medium-small spacing.
  static const double space12 = 12;

  /// Standard spacing.
  static const double space16 = 16;

  /// Large spacing.
  static const double space24 = 24;

  /// Extra large spacing.
  static const double space32 = 32;

  // ===============================================================
  // COMMON DIMENSIONS
  // ===============================================================

  /// Standard horizontal screen padding.
  static const double screenPadding = 16;

  /// Large screen padding.
  static const double screenPaddingLarge = 24;

  /// Standard input height.
  static const double inputHeight = 56;

  /// Standard button height.
  static const double buttonHeight = 52;

  /// Floating navigation bar height.
  static const double navigationHeight = 72;

  // ===============================================================
  // SHADOWS
  // ===============================================================

  /// Very subtle shadow for elevated cards.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// Subtle gold glow for premium/highlighted components.
  static const List<BoxShadow> goldGlow = [
    BoxShadow(
      color: Color(0x26D6A84F),
      blurRadius: 20,
      spreadRadius: 1,
    ),
  ];

  // ===============================================================
  // TEXT STYLES
  // ===============================================================

  /// 32px bold display text.
  static const TextStyle display = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.15,
  );

  /// 28px semi-bold financial balance.
  static const TextStyle largeBalance = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.15,
  );

  /// 24px screen/page title.
  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  /// 18px section heading.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.25,
  );

  /// 16px card title.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.25,
  );

  /// 14px standard body text.
  static const TextStyle body = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );

  /// 13px secondary/supporting text.
  static const TextStyle secondary = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.35,
  );

  /// 12px caption / metadata.
  static const TextStyle caption = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textMuted,
    height: 1.3,
  );

  /// Large financial amount.
  static const TextStyle financialAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.1,
  );

  /// Medium financial amount.
  static const TextStyle financialAmountMedium = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.1,
  );

  /// Income amount.
  static const TextStyle incomeAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: income,
  );

  /// Expense amount.
  static const TextStyle expenseAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: expense,
  );

  /// Transfer amount.
  static const TextStyle transferAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: transfer,
  );

  // ===============================================================
  // THEME DATA
  // ===============================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,

      // -------------------------------------------------------------
      // COLOR SCHEME
      // -------------------------------------------------------------

      colorScheme: const ColorScheme.dark(
        primary: gold,
        onPrimary: Color(0xFF111111),

        secondary: goldLight,
        onSecondary: Color(0xFF111111),

        surface: card,
        onSurface: textPrimary,

        error: expense,
        onError: textPrimary,

        outline: cardBorder,
        outlineVariant: divider,
      ),

      // -------------------------------------------------------------
      // SCAFFOLD
      // -------------------------------------------------------------

      scaffoldBackgroundColor: background,

      // -------------------------------------------------------------
      // APP BAR
      // -------------------------------------------------------------

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,

        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),

        iconTheme: IconThemeData(
          color: textPrimary,
          size: 24,
        ),
      ),

      // -------------------------------------------------------------
      // TEXT THEME
      // -------------------------------------------------------------

      textTheme: const TextTheme(
        displayLarge: display,

        headlineLarge: pageTitle,
        headlineMedium: sectionTitle,

        titleLarge: sectionTitle,
        titleMedium: cardTitle,

        bodyLarge: body,
        bodyMedium: body,
        bodySmall: secondary,

        labelLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),

        labelMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),

        labelSmall: caption,
      ),

      // -------------------------------------------------------------
      // CARD
      // -------------------------------------------------------------

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(
            color: cardBorder,
            width: 1,
          ),
        ),
      ),

      // -------------------------------------------------------------
      // INPUT FIELDS
      // -------------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF141519),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: secondary,
        labelStyle: secondary,

        floatingLabelStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: gold,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: Color(0xFF2B2C31),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: Color(0xFF2B2C31),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: gold,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: expense,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: expense,
            width: 1.5,
          ),
        ),

        errorStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          color: expense,
        ),

        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      // -------------------------------------------------------------
      // ELEVATED BUTTON
      // -------------------------------------------------------------

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: const Color(0xFF111111),

          minimumSize: const Size(
            double.infinity,
            buttonHeight,
          ),

          elevation: 0,

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -------------------------------------------------------------
      // OUTLINED BUTTON
      // -------------------------------------------------------------

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,

          minimumSize: const Size(
            double.infinity,
            buttonHeight,
          ),

          side: const BorderSide(
            color: cardBorder,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // -------------------------------------------------------------
      // TEXT BUTTON
      // -------------------------------------------------------------

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: gold,

          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // -------------------------------------------------------------
      // ICON THEME
      // -------------------------------------------------------------

      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // -------------------------------------------------------------
      // DIVIDER
      // -------------------------------------------------------------

      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      // -------------------------------------------------------------
      // FLOATING ACTION BUTTON
      // -------------------------------------------------------------

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: const Color(0xFF111111),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        iconSize: 26,
      ),

      // -------------------------------------------------------------
      // BOTTOM SHEET
      // -------------------------------------------------------------

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: card,
        modalBackgroundColor: card,
        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusBottomSheet),
          ),
        ),

        showDragHandle: true,
        dragHandleColor: Color(0xFF55565B),
      ),

      // -------------------------------------------------------------
      // DIALOG
      // -------------------------------------------------------------

      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),

        titleTextStyle: pageTitle,
        contentTextStyle: body,
      ),

      // -------------------------------------------------------------
      // CHIP
      // -------------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor: backgroundSecondary,

        selectedColor: gold,

        disabledColor: card,

        side: const BorderSide(
          color: cardBorder,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        labelStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),

        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF111111),
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),

      // -------------------------------------------------------------
      // DROPDOWN
      // -------------------------------------------------------------

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: body,

        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(card),

          surfaceTintColor:
              const WidgetStatePropertyAll(Colors.transparent),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              side: const BorderSide(
                color: cardBorder,
              ),
            ),
          ),
        ),
      ),

      // -------------------------------------------------------------
      // SNACKBAR
      // -------------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardElevated,
        contentTextStyle: body,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),

        actionTextColor: gold,
      ),

      // -------------------------------------------------------------
      // PROGRESS INDICATOR
      // -------------------------------------------------------------

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: gold,
        linearTrackColor: divider,
        circularTrackColor: divider,
      ),

      // -------------------------------------------------------------
      // CHECKBOX
      // -------------------------------------------------------------

      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(
          color: cardBorder,
          width: 1.5,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),

        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return gold;
            }

            return Colors.transparent;
          },
        ),

        checkColor: const WidgetStatePropertyAll(
          Color(0xFF111111),
        ),
      ),

      // -------------------------------------------------------------
      // RADIO
      // -------------------------------------------------------------

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return gold;
            }

            return textMuted;
          },
        ),
      ),

      // -------------------------------------------------------------
      // SWITCH
      // -------------------------------------------------------------

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Color(0xFF111111);
            }

            return textMuted;
          },
        ),

        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return gold;
            }

            return cardElevated;
          },
        ),

        trackOutlineColor: const WidgetStatePropertyAll(
          cardBorder,
        ),
      ),

      // -------------------------------------------------------------
      // LIST TILE
      // -------------------------------------------------------------

      listTileTheme: const ListTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,

        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),

        titleTextStyle: cardTitle,
        subtitleTextStyle: secondary,
      ),

      // -------------------------------------------------------------
      // NAVIGATION BAR
      // -------------------------------------------------------------

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: backgroundSecondary,

        elevation: 0,

        height: navigationHeight,

        indicatorColor: const Color(0x1FD6A84F),

        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: gold,
              );
            }

            return const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textMuted,
            );
          },
        ),

        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: gold,
                size: 24,
              );
            }

            return const IconThemeData(
              color: textMuted,
              size: 24,
            );
          },
        ),
      ),
    );
  }
}