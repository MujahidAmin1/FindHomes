
abstract class Endpoints {
  static const baseUrl = "https://real-estate-mgmt-api.onrender.com";
  
  static const register = "$baseUrl/auth/register";
  static const login = "$baseUrl/auth/login";
  static const logout = "$baseUrl/auth/logout";
  static const getCurrentUser = "$baseUrl/auth/me";
  static const refresh = "$baseUrl/auth/refresh";
}