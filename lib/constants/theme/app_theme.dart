import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ===============================================================
  // COLORS
  // ===============================================================

  static const Color background = Color(0xFF0B0B12);
  static const Color backgroundSecondary = Color(0xFF12121A);
  static const Color card = Color(0xFF17171F);
  static const Color cardElevated = Color(0xFF1E1E27);
  static const Color surface = Color(0xFF22222C);
  static const Color surfaceDeep = Color(0xFF0F0F16);

  // Violet
  static const Color violetDeep = Color(0xFF32145F);
  static const Color violetDark = Color(0xFF4A1F8C);
  static const Color violet = Color(0xFF7C3FF2);
  static const Color violetBright = Color(0xFFA86BFF);
  static const Color lavender = Color(0xFFC08BFF);
  static const Color violetSoft = Color(0x337C3FF2);

  // Orange
  static const Color orangeDeep = Color(0xFFE84B08);
  static const Color orange = Color(0xFFFF6A00);
  static const Color orangeBright = Color(0xFFFF8528);
  static const Color amber = Color(0xFFFF9A3D);
  static const Color amberLight = Color(0xFFFFBC69);
  static const Color orangeSoft = Color(0x33FF6A00);

  // Gold
  static const Color gold = Color(0xFFD6A84F);
  static const Color goldLight = Color(0xFFF0D18A);
  static const Color goldDark = Color(0xFF9D7430);
  static const Color goldDeep = Color(0xFF8A5A20);

  // Text
  static const Color textPrimary = Color(0xFFF7F5F2);
  static const Color textSecondary = Color(0xFFAAA8B0);
  static const Color textMuted = Color(0xFF74737C);
  static const Color textOnAccent = Color(0xFF120D16);

  // Borders
  static const Color divider = Color(0xFF292931);
  static const Color cardBorder = Color(0xFF34343E);
  static const Color glassBorder = Color(0x18FFFFFF);
  static const Color glassBorderStrong = Color(0x2DFFFFFF);
  static const Color glassSurface = Color(0x0FFFFFFF);

  // Financial
  static const Color income = Color(0xFF55C99A);
  static const Color incomeDark = Color(0xFF185A45);
  static const Color expense = Color(0xFFE96B72);
  static const Color expenseDark = Color(0xFF67252A);
  static const Color warning = amber;
  static const Color transfer = Color(0xFFD6A84F);
  static const Color info = Color(0xFF5575B5);

  // Other
  static const Color rubyBright = Color(0xFFC6535A);
  static const Color emeraldDark = Color(0xFF10251F);
  static const Color midnightDark = Color(0xFF080910);
  static const Color midnight = Color(0xFF171B2A);
  static const Color purpleDark = Color(0xFF111018);
  static const Color purple = Color(0xFF252033);
  static const Color purpleBright = Color(0xFF453665);

  // ===============================================================
  // GRADIENTS
  // ===============================================================

  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      violetDeep,
      Color(0xFF6B32D8),
      violetBright,
    ],
  );

  static const LinearGradient violetBrightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5B24C7),
      violet,
      lavender,
    ],
  );

  static const LinearGradient purpleCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF25104A),
      Color(0xFF5420A0),
      Color(0xFF8B4DFF),
    ],
  );

  static const LinearGradient violetGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B4DFF),
      Color(0xFF5D2BC2),
      Color(0xFF17121F),
    ],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      orangeDeep,
      orange,
      amber,
    ],
  );

  static const LinearGradient orangeBrightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5A00),
      Color(0xFFFF7818),
      Color(0xFFFFB24D),
    ],
  );

  static const LinearGradient orangeGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      orange,
      orangeDeep,
      Color(0xFF35170C),
    ],
  );

  static const LinearGradient violetOrangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6328C8),
      Color(0xFF8B4DFF),
      Color(0xFFFF7A18),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF),
      Color(0x08FFFFFF),
    ],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF20202A),
      Color(0xFF111117),
    ],
  );

  static const LinearGradient purpleBlackGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF17121F),
      Color(0xFF25183A),
      Color(0xFF3B2166),
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

  static const LinearGradient obsidianGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B1C20),
      Color(0xFF0A0B0D),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF6B32D8),
      Color(0xFF8B4DFF),
    ],
  );

  static const LinearGradient buttonOrangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFF5A00),
      Color(0xFFFF8A2A),
    ],
  );

  static const LinearGradient buttonGoldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFB8863B),
      Color(0xFFE3BD67),
    ],
  );

  // ===============================================================
  // RADIUS
  // ===============================================================

  static const double radiusSmall = 10;
  static const double radiusMedium = 14;
  static const double radiusCard = 18;
  static const double radiusLarge = 24;
  static const double radiusHero = 28;
  static const double radiusBottomSheet = 28;

  // ===============================================================
  // SPACING
  // ===============================================================

  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;
  static const double space32 = 32;

  // ===============================================================
  // DIMENSIONS
  // ===============================================================

  static const double screenPadding = 16;
  static const double screenPaddingLarge = 24;
  static const double inputHeight = 56;
  static const double buttonHeight = 52;
  static const double navigationHeight = 72;

  // ===============================================================
  // SHADOWS
  // ===============================================================

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x55000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> violetGlow = [
    BoxShadow(
      color: Color(0x407C3FF2),
      blurRadius: 28,
      spreadRadius: 1,
    ),
  ];

  static const List<BoxShadow> violetStrongGlow = [
    BoxShadow(
      color: Color(0x667C3FF2),
      blurRadius: 36,
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> orangeGlow = [
    BoxShadow(
      color: Color(0x40FF6A00),
      blurRadius: 28,
      spreadRadius: 1,
    ),
  ];

  static const List<BoxShadow> orangeStrongGlow = [
    BoxShadow(
      color: Color(0x66FF6A00),
      blurRadius: 36,
      spreadRadius: 2,
    ),
  ];

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

  static const TextStyle display = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.15,
  );

  static const TextStyle largeBalance = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.15,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.25,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.25,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle secondary = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textMuted,
    height: 1.3,
  );

  static const TextStyle financialAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.1,
  );

  static const TextStyle financialAmountMedium = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.1,
  );

  static const TextStyle incomeAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: income,
  );

  static const TextStyle expenseAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: expense,
  );

  static const TextStyle transferAmount = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: transfer,
  );

  // ===============================================================
  // THEME
  // ===============================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: const ColorScheme.dark(
        primary: violet,
        onPrimary: Colors.white,
        secondary: violetBright,
        onSecondary: Colors.white,
        surface: card,
        onSurface: textPrimary,
        error: expense,
        onError: textPrimary,
        outline: cardBorder,
        outlineVariant: divider,
      ),

      scaffoldBackgroundColor: background,

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

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF14141B),
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
          color: violetBright,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: Color(0xFF2B2B33),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: Color(0xFF2B2B33),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(
            color: violet,
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

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
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

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: violetBright,
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: violet,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        iconSize: 26,
      ),

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

      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: pageTitle,
        contentTextStyle: body,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: backgroundSecondary,
        selectedColor: violet,
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
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: body,
        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(card),
          surfaceTintColor: const WidgetStatePropertyAll(
            Colors.transparent,
          ),
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

      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardElevated,
        contentTextStyle: body,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        actionTextColor: violetBright,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: violet,
        linearTrackColor: divider,
        circularTrackColor: divider,
      ),

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
              return violet;
            }

            return Colors.transparent;
          },
        ),
        checkColor: const WidgetStatePropertyAll(
          Colors.white,
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return violet;
            }

            return textMuted;
          },
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }

            return textMuted;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return violet;
            }

            return cardElevated;
          },
        ),
        trackOutlineColor: const WidgetStatePropertyAll(
          cardBorder,
        ),
      ),

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

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: backgroundSecondary,
        elevation: 0,
        height: navigationHeight,
        indicatorColor: Color(0x337C3FF2),
        labelTextStyle:
            WidgetStateProperty.resolveWith<TextStyle?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: violetBright,
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
        iconTheme:
            WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: violetBright,
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