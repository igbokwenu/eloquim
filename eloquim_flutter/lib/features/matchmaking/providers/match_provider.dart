// eloquim_flutter/lib/features/matchmaking/providers/match_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../../core/providers/serverpod_client_provider.dart';

class MatchNotifier extends AsyncNotifier<User?> {
  List<User> _matches = [];
  int _currentIndex = 0;

  @override
  Future<User?> build() async {
    return null;
  }

  Future<void> findMatches() async {
    state = const AsyncLoading();

    try {
      final client = ref.read(serverpodClientProvider);

      _matches = await client.user.findMatches(
        limit: 10,
      );

      _currentIndex = 0;

      if (_matches.isNotEmpty) {
        state = AsyncData(_matches[_currentIndex]);
      } else {
        state = const AsyncData(null);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void nextMatch() {
    if (_currentIndex < _matches.length - 1) {
      _currentIndex++;
      state = AsyncData(_matches[_currentIndex]);
    } else {
      state = const AsyncData(null);
    }
  }

  void reset() {
    _matches = [];
    _currentIndex = 0;
    state = const AsyncData(null);
  }
}

final matchProvider = AsyncNotifierProvider.autoDispose<MatchNotifier, User?>(
  MatchNotifier.new,
);
