import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AgentContactCard extends StatelessWidget {
  final String agentId;

  const AgentContactCard({super.key, required this.agentId});

  @override
  Widget build(BuildContext context) {
  
    const agentName = 'Ayo Davies';
    const isVerified = true;
    const avatarUrl = '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Property Agent',
            style: AppTypography.titleMedium.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: avatarUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: avatarUrl,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.person, size: 36, color: AppColors.muted),
                    ),
                    const SizedBox(width: 16),
                    
                    // Name & Badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                agentName,
                                style: AppTypography.titleMedium,
                              ),
                              const SizedBox(width: 8),
                              if (isVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified, size: 12, color: AppColors.accent),
                                      const SizedBox(width: 4),
                                      Text(
                                        'VERIFIED AGENT',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // User requested: "reviews dont exist yet, so dont include."
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),


                Row(
                  children: [
                    Expanded(
                      child: AppButton.outlined(
                        label: 'Inquire',
                        leading: const Icon(Icons.chat_bubble_outline, size: 18),
                        onPressed: () {
                          // Handle inquire
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Call',
                        leading: const Icon(Icons.phone_outlined, size: 18),
                        onPressed: () {
                          // Handle call
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
