import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Core ──────────────────────────────────────────────────────────────────
  static const Color ink = Color(0xFF0F1B2D);
  static const Color surface = Color(0xFFF7F5F0);
  static const Color card = Color(0xFFFFFFFF);

  // ── Primary ───────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1B6CA8);
  static const Color primaryLight = Color(0xFFEBF3FB);

  // ── Accent (Gold) ─────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFE8A838);
  static const Color accentLight = Color(0xFFFDF4E3);

  // ── Neutrals ──────────────────────────────────────────────────────────────
  static const Color muted = Color(0xFF8A95A3);
  static const Color divider = Color(0xFFE8EAF0);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2D7A4F);
  static const Color successLight = Color(0xFFE8F5EE);
  static const Color error = Color(0xFFC0392B);
  static const Color errorLight = Color(0xFFFDECEA);

  // ── Listing Type Tags ─────────────────────────────────────────────────────
  static const Color rentTag = Color(0xFF1B6CA8);
  static const Color saleTag = Color(0xFF0F1B2D);
  static const Color shortletTag = Color(0xFF7B3FA0);
  static const Color shortletTagLight = Color(0xFFF3EBF9);

  // ── Status Badge Backgrounds ──────────────────────────────────────────────
  static const Color availableBg = Color(0xFFE8F5EE);
  static const Color soldBg = Color(0xFFFDECEA);
  static const Color rentedBg = Color(0xFFFFF3CD);
  static const Color inactiveBg = Color(0xFFF0F2F5);
  static const Color verifiedBg = Color(0xFFFDF4E3);

  // ── Status Badge Foregrounds ──────────────────────────────────────────────
  static const Color rentedText = Color(0xFFB8860B);
  static const Color inactiveText = Color(0xFF8A95A3);

  // ── Card Shadow ───────────────────────────────────────────────────────────
  static const Color cardShadow = Color(0x140F1B2D); // rgba(15,27,45,0.08)
}