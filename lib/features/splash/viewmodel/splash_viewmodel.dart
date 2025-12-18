import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashViewModelProvider = Provider((ref) {
  return SplashViewModel();
});

class SplashViewModel {
  Future<void> start(Function onFinished) async {
    await Future.delayed(const Duration(seconds: 3));
    onFinished();
  }
}
