import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Centralized service wrapping all OneSignal SDK calls.
/// No direct OneSignal SDK calls should be made outside this wrapper.
class OneSignalService {
  bool _isInitialized = false;

  /// Returns whether the OneSignal SDK has been initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize the OneSignal SDK with the given [appId].
  void initialize(String appId) {
    if (_isInitialized) return;

    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    } else {
      OneSignal.Debug.setLogLevel(OSLogLevel.none);
    }

    OneSignal.initialize(appId);
    _isInitialized = true;
  }

  /// Sets the external user ID for identity management.
  void login(String externalId) {
    OneSignal.login(externalId);
  }

  /// Clears user identity on logout.
  void logout() {
    OneSignal.logout();
  }

  /// Adds a single tag key-value pair to the user.
  void addTag(String key, String value) {
    OneSignal.User.addTagWithKey(key, value);
  }

  /// Removes a tag by key.
  void removeTag(String key) {
    OneSignal.User.removeTag(key);
  }

  /// Adds multiple tags at once.
  void addTags(Map<String, String> tags) {
    OneSignal.User.addTags(tags);
  }

  /// Adds an email subscription for the user.
  void setEmail(String email) {
    OneSignal.User.addEmail(email);
  }

  /// Removes an email subscription for the user.
  void removeEmail(String email) {
    OneSignal.User.removeEmail(email);
  }

  /// Adds an SMS subscription for the user.
  void setSms(String number) {
    OneSignal.User.addSms(number);
  }

  /// Removes an SMS subscription for the user.
  void removeSms(String number) {
    OneSignal.User.removeSms(number);
  }

  /// Prompt for push notification permission.
  /// [fallbackToSettings] opens app settings if permission was previously denied.
  Future<bool> requestPermission([bool fallbackToSettings = true]) async {
    return await OneSignal.Notifications.requestPermission(fallbackToSettings);
  }

  /// Registers an observer for push subscription state changes.
  void addSubscriptionObserver(OnPushSubscriptionChangeObserver observer) {
    OneSignal.User.pushSubscription.addObserver(observer);
  }

  /// Removes a previously registered push subscription observer.
  void removeSubscriptionObserver(OnPushSubscriptionChangeObserver observer) {
    OneSignal.User.pushSubscription.removeObserver(observer);
  }

  /// Gets the current push subscription ID, or null if not yet available.
  String? getSubscriptionId() {
    return OneSignal.User.pushSubscription.id;
  }

  /// Returns true if push subscription is currently opted in.
  bool? isOptedIn() {
    return OneSignal.User.pushSubscription.optedIn;
  }
}
