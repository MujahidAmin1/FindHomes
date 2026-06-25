import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

var currentScreenProvider = StateProvider.autoDispose<int?>(
 (ref) => 0
);

void navigateTo(WidgetRef ref, int screen) {
  if (screen != ref.watch(currentScreenProvider)) {
    ref.read(currentScreenProvider.notifier).state = screen;
  }
}
