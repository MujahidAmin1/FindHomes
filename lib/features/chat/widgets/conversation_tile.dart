import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/chat/model/conversation.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final PropertyModel? property;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    this.property,
  });

  bool get _isUnread => conversation.unreadCount > 0;

  String get _formattedTime {
    final lastMsg = conversation.lastMessageAt;
    if (lastMsg == null) return '';

    final now = DateTime.now();
    final diff = now.difference(lastMsg);

    if (diff.inDays == 0) {
      return DateFormat('h:mm a').format(lastMsg);
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return DateFormat('EEE').format(lastMsg);
    } else {
      return DateFormat('MMM d').format(lastMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyTitle = property?.title ?? 'Property';
    final primaryImage = property?.images
        .where((img) => img.isPrimary)
        .firstOrNull
        ?.imageUrl;
    final fallbackImage =
        property?.images.isNotEmpty == true ? property!.images.first.imageUrl : null;
    final imageUrl = primaryImage ?? fallbackImage;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ─────────────────────────────────────────────
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isUnread ? AppColors.primary : AppColors.divider,
                  width: _isUnread ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
            ),

            const SizedBox(width: 14),

            // ── Content ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          propertyTitle,
                          style: _isUnread
                              ? AppTypography.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w700)
                              : AppTypography.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formattedTime,
                        style: _isUnread
                            ? AppTypography.caption
                                .copyWith(color: AppColors.primary)
                            : AppTypography.caption,
                      ),
                      if (_isUnread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Property reference tag
                  Row(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 12,
                        color: AppColors.muted.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          're: $propertyTitle',
                          style: AppTypography.caption.copyWith(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Last message preview
                  if (conversation.lastMessageText != null)
                    Text(
                      conversation.lastMessageText!,
                      style: _isUnread
                          ? AppTypography.bodySmall.copyWith(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w600,
                            )
                          : AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
