
abstract class Endpoints {
  static const baseUrl = "https://real-estate-mgmt-api.onrender.com";
  
  static const register = "$baseUrl/auth/register";
  static const login = "$baseUrl/auth/login";
  static const logout = "$baseUrl/auth/logout";
  static const getCurrentUser = "$baseUrl/auth/me";
  static const refresh = "$baseUrl/auth/refresh";

  static const profile = "$baseUrl/profile";
  static const agentProfile = "$baseUrl/profile/agent_profile";
  static const onboardingStatus = "$baseUrl/auth/onboarding-status";


  static const property = "$baseUrl/properties/";
  static String getagentProperties(String agentId) => "$baseUrl/properties/agent/$agentId";
  static String updateProperty(String propertyId) => "$baseUrl/properties/$propertyId";
  static String deleteProperty(String propertyId) => "$baseUrl/properties/$propertyId";
  static String getPropertybyId(String propertyId) => "$baseUrl/properties/$propertyId";

  static String startConversation(String propertyId) => "$baseUrl/conversations/$propertyId";
  static const getConversation = "$baseUrl/conversations";
  static String messages(String conversationId) => "$baseUrl/conversations/$conversationId/messages";
  static String markAsRead(String conversationId) => "$baseUrl/conversations/$conversationId/read";


  static const initializePayment = "$baseUrl/payments/initialize";
  static String getPaymentStatus(String reference) => "$baseUrl/payments/$reference";
}