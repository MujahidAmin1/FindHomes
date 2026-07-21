import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/auth/service/auth_service.dart';
import 'package:find_homes/features/chat/model/conversation.dart';
import 'package:find_homes/features/chat/model/message.dart';
import 'package:find_homes/features/chat/notifier/chat_notifier.dart';
import 'package:find_homes/features/chat/widgets/chat_date_separator.dart';
import 'package:find_homes/features/chat/widgets/chat_input_bar.dart';
import 'package:find_homes/features/chat/widgets/message_bubble.dart';
import 'package:find_homes/features/chat/widgets/property_tag_card.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:find_homes/features/property/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Conversation conversation;
  final PropertyModel? property;

  const ChatScreen({
    super.key,
    required this.conversation,
    this.property,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String? _currentUserId;
  PropertyModel? _property;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
    _init();
  }

  Future<void> _init() async {
    // Must fetch current user ID BEFORE messages so bubble alignment is correct
    try {
      final user = await serviceLocator.get<AuthService>().getCurrentUser();
      if (mounted) setState(() => _currentUserId = user.id);
    } catch (_) {}

    // Now fetch messages — userId is already set
    await ref
        .read(messagesNotifierProvider.notifier)
        .fetchMessages(widget.conversation.id);

    // Mark as read (fire-and-forget)
    ref
        .read(messagesNotifierProvider.notifier)
        .markAsRead(widget.conversation.id);

    // Fetch property if not already passed
    if (_property == null) {
      try {
        final property = await serviceLocator
            .get<PropertyService>()
            .getPropertyById(widget.conversation.propertyId);
        if (mounted) setState(() => _property = property);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesNotifierProvider);
    final propertyTitle = _property?.title ?? 'Chat';

    return Scaffold(
      backgroundColor: AppColors.card,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              propertyTitle,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              're: $propertyTitle',
              style: AppTypography.caption.copyWith(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Divider
          const Divider(height: 1, color: AppColors.divider),

          // Messages
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 48,
                        color: AppColors.muted.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Couldn\'t load messages',
                        style: AppTypography.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () => ref
                            .read(messagesNotifierProvider.notifier)
                            .fetchMessages(widget.conversation.id),
                        icon: const Icon(Icons.refresh,
                            color: AppColors.primary),
                        label: Text(
                          'Retry',
                          style: AppTypography.buttonLabel
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              data: (messages) => _MessageListView(
                messages: messages,
                currentUserId: _currentUserId,
                property: _property,
              ),
            ),
          ),

          // Input bar
          ChatInputBar(
            onSend: (text) {
              ref
                  .read(messagesNotifierProvider.notifier)
                  .sendMessage(widget.conversation.id, text);
            },
          ),
        ],
      ),
    );
  }
}

// ── Message list with date separators & property tag ──────────────────────────

class _MessageListView extends StatelessWidget {
  final List<Message> messages;
  final String? currentUserId;
  final PropertyModel? property;

  const _MessageListView({
    required this.messages,
    required this.currentUserId,
    this.property,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_outlined,
                size: 48,
                color: AppColors.muted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'No messages yet',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Send a message to start the conversation.',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Backend returns newest-first; reverse for chronological display
    final sorted = messages.reversed.toList();

    // Build display items: date separators + message indices
    final items = <_DisplayItem>[];
    DateTime? lastDate;

    for (int i = 0; i < sorted.length; i++) {
      final msg = sorted[i];
      final msgDate = DateTime(
        msg.createdAt.year,
        msg.createdAt.month,
        msg.createdAt.day,
      );

      if (lastDate == null || msgDate != lastDate) {
        items.add(_DisplayItem.dateSeparator(msg.createdAt));
        lastDate = msgDate;
      }

      items.add(_DisplayItem.message(i));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item.isDateSeparator) {
          return ChatDateSeparator(date: item.date!);
        }

        final msg = sorted[item.messageIndex!];
        final isMine = msg.senderId == currentUserId;
        final isFirstMessage = item.messageIndex == 0;

        // Check if next message has same sender & is within 2 min
        // to decide whether to show timestamp
        final isLastInGroup = _isLastInGroup(sorted, item.messageIndex!);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Property tag on first message (IG story-reply style)
            if (isFirstMessage && property != null)
              PropertyTagCard(property: property!),

            MessageBubble(
              content: msg.content,
              createdAt: msg.createdAt,
              isMine: isMine,
              isRead: msg.isRead,
            ),

            // Show timestamp at the end of a message group
            if (isLastInGroup)
              MessageTimestamp(
                createdAt: msg.createdAt,
                isMine: isMine,
                isRead: msg.isRead,
              ),
          ],
        );
      },
    );
  }

  /// Returns true if this message is the last one from its sender in a
  /// consecutive group (or if the next message is more than 2 minutes later).
  bool _isLastInGroup(List<Message> sorted, int index) {
    if (index >= sorted.length - 1) return true;

    final current = sorted[index];
    final next = sorted[index + 1];

    if (current.senderId != next.senderId) return true;

    final diff = next.createdAt.difference(current.createdAt);
    return diff.inMinutes > 2;
  }
}

// ── Display item helper ──────────────────────────────────────────────────────

class _DisplayItem {
  final bool isDateSeparator;
  final DateTime? date;
  final int? messageIndex;

  const _DisplayItem._({
    required this.isDateSeparator,
    this.date,
    this.messageIndex,
  });

  factory _DisplayItem.dateSeparator(DateTime date) =>
      _DisplayItem._(isDateSeparator: true, date: date);

  factory _DisplayItem.message(int index) =>
      _DisplayItem._(isDateSeparator: false, messageIndex: index);
}
