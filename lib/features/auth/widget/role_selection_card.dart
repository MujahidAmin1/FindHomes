import 'package:flutter/material.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';

class RoleSelectionCard extends StatelessWidget {
  final String role; // 'client' or 'agent'
  final ValueChanged<String> onChanged;

  const RoleSelectionCard({
    super.key,
    required this.role,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('I want to', style: AppTypography.caption.copyWith(color: AppColors.muted)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _RoleOption(
                label: 'Find a Home',
                isSelected: role == 'client',
                onTap: () => onChanged('client'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RoleOption(
                label: 'List a Property',
                isSelected: role == 'agent',
                onTap: () => onChanged('agent'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.card,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
