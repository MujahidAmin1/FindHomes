import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/services/onesignal_service.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// A wrapper widget that listens for OneSignal push subscription state changes
/// and shows the required Push Subscription Verification Dialog once a real
/// server-assigned subscription ID is assigned to the device.
class OneSignalVerificationListener extends StatefulWidget {
  final Widget child;

  const OneSignalVerificationListener({
    super.key,
    required this.child,
  });

  @override
  State<OneSignalVerificationListener> createState() =>
      _OneSignalVerificationListenerState();
}

class _OneSignalVerificationListenerState
    extends State<OneSignalVerificationListener> {
  final OneSignalService _oneSignalService = serviceLocator<OneSignalService>();
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    // 1. Register push subscription observer callback
    _oneSignalService.addSubscriptionObserver(_onPushSubscriptionChange);

    // 2. Evaluate current subscription ID immediately at registration time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _evaluateSubscriptionState(_oneSignalService.getSubscriptionId());
    });
  }

  @override
  void dispose() {
    _oneSignalService.removeSubscriptionObserver(_onPushSubscriptionChange);
    super.dispose();
  }

  void _onPushSubscriptionChange(OSPushSubscriptionChangedState state) {
    // Evaluate when subscription state changes
    _evaluateSubscriptionState(state.current.id);
  }

  void _evaluateSubscriptionState(String? subscriptionId) {
    if (_hasShownDialog) return;

    // Treat device as registered ONLY when subscription ID is a real server-assigned value:
    // non-null, non-empty, and NOT starting with 'local-'
    if (subscriptionId != null &&
        subscriptionId.isNotEmpty &&
        !subscriptionId.startsWith('local-')) {
      _hasShownDialog = true;
      _showVerificationDialog();
    }
  }

  void _showVerificationDialog() {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your OneSignal SDK integration is complete!'),
          content: const Text(
            'You can now send Push Notifications & In-App Messages through OneSignal. Tap below to enable push notifications.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // On button tap, request push permission
                await _oneSignalService.requestPermission(true);
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
