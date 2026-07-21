import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/chat/model/conversation.dart';
import 'package:find_homes/features/chat/model/message.dart';
import 'package:find_homes/features/chat/service/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Conversations Notifier ───────────────────────────────────────────────────

final conversationsNotifierProvider =
    AsyncNotifierProvider<ConversationsNotifier, List<Conversation>>(
  ConversationsNotifier.new,
);

class ConversationsNotifier extends AsyncNotifier<List<Conversation>> {
  ChatService get _service => serviceLocator.get<ChatService>();

  @override
  Future<List<Conversation>> build() async => _service.getConversations();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await _guard(_service.getConversations);
  }

  Future<void> startConversation(String propertyId, String agentId) async {
    state = const AsyncValue.loading();
    state = await _guard(() async {
      await _service.startConversation(propertyId, agentId);
      return _service.getConversations();
    });
  }

  Future<AsyncValue<List<Conversation>>> _guard(
    Future<List<Conversation>> Function() action,
  ) async {
    try {
      return AsyncValue.data(await action());
    } catch (error, stackTrace) {
      return AsyncValue.error(
        BackendException(BackendError.extractMessage(error)),
        stackTrace,
      );
    }
  }
}

// ── Messages Notifier (family — per conversation) ────────────────────────────

final messagesNotifierProvider =
    AsyncNotifierProvider<MessagesNotifier, List<Message>>(
  MessagesNotifier.new,
);

class MessagesNotifier extends AsyncNotifier<List<Message>> {
  ChatService get _service => serviceLocator.get<ChatService>();

  @override
  Future<List<Message>> build() async => [];

  Future<void> fetchMessages(String conversationId) async {
    state = const AsyncValue.loading();
    state = await _guard(() => _service.getMessages(conversationId));
  }

  Future<void> sendMessage(String conversationId, String content) async {
    state = await _guard(() async {
      await _service.sendMessage(conversationId, content);
      return _service.getMessages(conversationId);
    });
  }

  Future<void> markAsRead(String conversationId) async {
    await _guard(() async {
      await _service.markAsRead(conversationId);
      return state.value ?? [];
    });
  }

  Future<AsyncValue<List<Message>>> _guard(
    Future<List<Message>> Function() action,
  ) async {
    try {
      return AsyncValue.data(await action());
    } catch (error, stackTrace) {
      return AsyncValue.error(
        BackendException(BackendError.extractMessage(error)),
        stackTrace,
      );
    }
  }
}
