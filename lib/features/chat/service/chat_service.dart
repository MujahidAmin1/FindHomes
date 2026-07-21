import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/chat/model/message.dart';
import '../model/conversation.dart';

class ChatService {
  final Dio _dio = serviceLocator.get<Dio>();

  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _dio.get(Endpoints.getConversation);
      final List<dynamic> data = response.data;
      return data.map((json) => Conversation.fromJson(json)).toList();
     
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to load conversations');
    }
  }

  Future<Conversation> startConversation(String propertyId, String agentId) async {
    try {
      final response = await _dio.post(
        Endpoints.startConversation(propertyId),
        queryParameters: {'agent_id': agentId},
      );
     
        return Conversation.fromJson(response.data);
      
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to start conversation');
    }
  }

  Future<List<Message>> getMessages(
    String conversationId, {
    int limit = 50,
    DateTime? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (before != null) {
        queryParams['before'] = before.toIso8601String();
      }

      final response = await _dio.get(
        Endpoints.messages(conversationId),
        queryParameters: queryParams,
      );
      
      final List<dynamic> data = response.data;
      return data.map((json) => Message.fromJson(json)).toList();
      
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to load messages');
    }
  }

  Future<Message> sendMessage(String conversationId, String content) async {
    try {
      final response = await _dio.post(
        Endpoints.messages(conversationId),
        data: {'content': content},
      );
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to send message');
    }
  }

  Future<void> markAsRead(String conversationId) async {
    try {
     await _dio.patch(Endpoints.markAsRead(conversationId));
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to mark messages as read');
    }
  }

}