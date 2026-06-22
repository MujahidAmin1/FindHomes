import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.card,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.accent,
      onSecondary: AppColors.ink,
      secondaryContainer: AppColors.accentLight,
      onSecondaryContainer: AppColors.ink,
      error: AppColors.error,
      onError: AppColors.card,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.muted,
      outline: AppColors.divider,
      outlineVariant: AppColors.divider,
      shadow: AppColors.cardShadow,
      scrim: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Inter',

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.screenTitle,
        iconTheme: IconThemeData(color: AppColors.ink, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // ── Bottom Navigation ──────────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.navLabel,
        unselectedLabelStyle: AppTypography.navLabel,
      ),

      // ── Navigation Bar (M3) ────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.primaryLight,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.muted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.navLabel.copyWith(color: AppColors.primary);
          }
          return AppTypography.navLabel.copyWith(color: AppColors.muted);
        }),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Elevated Button (Primary) ──────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.card,
          disabledBackgroundColor: AppColors.divider,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: AppTypography.buttonLabel,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),

      // ── Outlined Button ────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          elevation: 0,
          textStyle: AppTypography.buttonLabel.copyWith(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),

      // ── Text Button (Ghost) ────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTypography.buttonLabel.copyWith(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),

      // ── Input Fields ───────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTypography.body.copyWith(color: AppColors.muted),
        labelStyle: AppTypography.caption.copyWith(color: AppColors.muted),
        floatingLabelStyle: AppTypography.caption.copyWith(color: AppColors.primary),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // ── Cards ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),

      // ── Chip ───────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.card,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.divider,
        labelStyle: AppTypography.caption.copyWith(color: AppColors.ink),
        secondaryLabelStyle: AppTypography.caption.copyWith(color: AppColors.card),
        side: const BorderSide(color: AppColors.divider, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Bottom Sheet ───────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.card,
        modalBackgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
        modalElevation: 0,
        dragHandleColor: AppColors.divider,
        dragHandleSize: Size(40, 4),
        showDragHandle: true,
      ),

      // ── Dialog / Modal ─────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTypography.screenTitle,
        contentTextStyle: AppTypography.body,
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── List Tile ──────────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: AppTypography.bodyLarge,
        subtitleTextStyle: AppTypography.bodySmall,
        iconColor: AppColors.muted,
        dense: false,
      ),

      // ── Snack Bar (Toast) ──────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTypography.body.copyWith(color: AppColors.card),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),

      // ── Progress Indicator ─────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryLight,
        circularTrackColor: AppColors.primaryLight,
      ),

      // ── Switch ─────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? AppColors.primaryLight : AppColors.divider;
        }),
      ),

      // ── Tab Bar ────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.muted,
        labelStyle: AppTypography.bodyMedium,
        unselectedLabelStyle: AppTypography.body,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.divider,
      ),

      // ── Floating Action Button ─────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.card,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }
}