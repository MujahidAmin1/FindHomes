import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final DateTime createdAt;
  final bool isMine;
  final bool isRead;

  const MessageBubble({
    super.key,
    required this.content,
    required this.createdAt,
    required this.isMine,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) const SizedBox(width: 4),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMine ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMine ? 18 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 18),
                ),
                border: isMine
                    ? null
                    : Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                content,
                style: AppTypography.body.copyWith(
                  color: isMine ? Colors.white : AppColors.ink,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isMine) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

/// Timestamp + read-receipt row shown below a bubble or group of bubbles.
class MessageTimestamp extends StatelessWidget {
  final DateTime createdAt;
  final bool isMine;
  final bool isRead;

  const MessageTimestamp({
    super.key,
    required this.createdAt,
    required this.isMine,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('h:mm a').format(createdAt);

    return Padding(
      padding: EdgeInsets.only(
        left: isMine ? 0 : 24,
        right: isMine ? 24 : 0,
        top: 2,
        bottom: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(
            time,
            style: AppTypography.caption.copyWith(fontSize: 11),
          ),
          if (isMine) ...[
            const SizedBox(width: 4),
            Icon(
              isRead ? Icons.done_all : Icons.done,
              size: 14,
              color: isRead ? AppColors.primary : AppColors.muted,
            ),
          ],
        ],
      ),
    );
  }
}
