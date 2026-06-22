import 'package:find_homes/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FontFamily {
  static const String lato = 'Lato';
  static const String roboto = 'Roboto';
  static const String robotoMono = 'Roboto Mono';

}

class AppTypography {
  
  static const TextStyle heroPrice = TextStyle(
    fontFamily: FontFamily.lato,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// 28sp Bold — Onboarding headlines
  static const TextStyle displayLarge = TextStyle(
    fontFamily: FontFamily.lato,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.3,
    height: 1.25,
  );

  /// 24sp SemiBold — Screen titles
  static const TextStyle screenTitle = TextStyle(
    fontFamily: FontFamily.lato,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.2,
    height: 1.3,
  );

  /// 22sp SemiBold — Auth screen titles
  static const TextStyle displaySmall = TextStyle(
    fontFamily: FontFamily.lato,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.2,
    height: 1.3,
  );

  /// 20sp SemiBold — Card prices (featured), greeting headline
  static const TextStyle titleLarge = TextStyle(
    fontFamily: FontFamily.lato,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.1,
    height: 1.35,
  );

  /// 18sp SemiBold — Property detail price repeat, section display
  static const TextStyle titleMedium = TextStyle(
    fontFamily: FontFamily.lato,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.35,
  );

  // ── Body / UI (Inter) ─────────────────────────────────────────────────────

  /// 16sp SemiBold — Section headers
  static const TextStyle sectionHeader = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.4,
  );

  /// 15sp SemiBold — Button labels, agent names in cards
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.card,
    height: 1.0,
  );

  /// 15sp Medium — Prominent body, list item titles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.5,
  );

  /// 14sp Regular — Standard body copy, descriptions, form inputs
  static const TextStyle body = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.57,
  );

  /// 14sp Medium — Emphasis within body
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.57,
  );

  /// 13sp Regular — Subtitles, secondary info
  static const TextStyle bodySmall = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.5,
  );

  /// 12sp Medium — Captions, labels, badge text
  static const TextStyle caption = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    height: 1.4,
  );

  /// 10sp Medium — Bottom nav labels
  static const TextStyle navLabel = TextStyle(
    fontFamily: FontFamily.roboto,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // ── Data / Specs (Inter Mono) ─────────────────────────────────────────────

  /// 13sp Medium — Property specs (beds, baths, sqm), inline data
  static const TextStyle specData = TextStyle(
    fontFamily: FontFamily.robotoMono,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
    height: 1.4,
  );

  /// 12sp Regular — Payment references, transaction IDs, lat/lng
  static const TextStyle monoSmall = TextStyle(
    fontFamily: FontFamily.robotoMono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.4,
    letterSpacing: 0.3,
  );

  /// 15sp Bold — Card prices (list view)
  static const TextStyle priceSmall = TextStyle(
    fontFamily: FontFamily.robotoMono,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    height: 1.2,
  );
}