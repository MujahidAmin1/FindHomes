import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/chat/model/conversation.dart';
import 'package:find_homes/features/chat/notifier/chat_notifier.dart';
import 'package:find_homes/features/chat/views/chat_screen.dart';
import 'package:find_homes/features/chat/widgets/conversation_tile.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:find_homes/features/property/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Agent-side inquiry list — same data as ChatListScreen but
/// embedded as a navbar tab (no back button, "Inquiries" title).
class AgentInquiriesScreen extends ConsumerWidget {
  const AgentInquiriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.card,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Inquiries',
          style: AppTypography.screenTitle,
        ),
      ),
      body: conversationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => _ErrorView(
          error: error,
          onRetry: () =>
              ref.read(conversationsNotifierProvider.notifier).refresh(),
        ),
        data: (conversations) {
          if (conversations.isEmpty) {
            return const _EmptyView();
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                ref.read(conversationsNotifierProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _InquiryItem(conversation: conversation);
              },
            ),
          );
        },
      ),
    );
  }
}

/// Wraps a [ConversationTile] and fetches the property data for it.
class _InquiryItem extends StatefulWidget {
  final Conversation conversation;

  const _InquiryItem({required this.conversation});

  @override
  State<_InquiryItem> createState() => _InquiryItemState();
}

class _InquiryItemState extends State<_InquiryItem> {
  PropertyModel? _property;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProperty();
  }

  Future<void> _fetchProperty() async {
    try {
      final property = await serviceLocator
          .get<PropertyService>()
          .getPropertyById(widget.conversation.propertyId);
      if (mounted) {
        setState(() {
          _property = property;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _ShimmerCircle(),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBar(width: 140, height: 14),
                  SizedBox(height: 6),
                  _ShimmerBar(width: 200, height: 10),
                  SizedBox(height: 6),
                  _ShimmerBar(width: 180, height: 10),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ConversationTile(
      conversation: widget.conversation,
      property: _property,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversation: widget.conversation,
              property: _property,
            ),
          ),
        );
      },
    );
  }
}

// ── Empty & Error States ──────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No inquiries yet',
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'When potential buyers or renters reach out about your listings, their messages will appear here.',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: AppColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Couldn\'t load inquiries',
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              label: Text(
                'Retry',
                style: AppTypography.buttonLabel.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer placeholders ──────────────────────────────────────────────────────

class _ShimmerCircle extends StatelessWidget {
  const _ShimmerCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ShimmerBar extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBar({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
