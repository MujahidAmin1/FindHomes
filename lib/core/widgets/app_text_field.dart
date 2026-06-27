import 'package:flutter/material.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool optional;
  final Widget? trailing;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.optional = false,
    this.trailing,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: AppTypography.caption.copyWith(color: AppColors.muted),
            ),
            if (widget.optional)
              Text(
                'Optional',
                style: AppTypography.caption.copyWith(color: AppColors.muted),
              ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          style: AppTypography.body,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.muted.withValues(alpha: .5),
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: AppColors.muted,
              size: 20,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.muted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
