//eloquim_server/lib/src/endpoints/user_endpoint.dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  Future<User?> getCurrentUser(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return null;

    // Get the auth user ID as UuidValue
    final authUserId = authInfo.authUserId;

    // Find user by authUserId
    var user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );

    // If user doesn't exist, create one
    if (user == null) {
      user = User(
        authUserId: authUserId,
        username: 'User${authUserId.toString().substring(0, 8)}',
        email: null,
        gender: null,
        age: null,
        country: null,
        emojiSignature: '✨🎵💫',
        hasDoneTutorial: false,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isAnonymous: false, // Authenticated users are not anonymous
      );
      user = await User.db.insertRow(session, user);
    }

    return user;
  }

  Future<User> updateProfile(
    Session session, {
    String? username,
    String? gender,
    int? age,
    String? country,
  }) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');

    final authUserId = authInfo.authUserId;

    var user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );

    if (user == null) {
      // Create new user
      user = User(
        authUserId: authUserId,
        username: username ?? 'User${authUserId.toString().substring(0, 8)}',
        email: null,
        gender: gender,
        age: age,
        country: country,
        emojiSignature: '✨🎵💫',
        hasDoneTutorial: false,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isAnonymous: false,
      );
      return await User.db.insertRow(session, user);
    } else {
      // Update existing user
      final updatedUser = user.copyWith(
        username: username,
        gender: gender,
        age: age,
        country: country,
        lastSeen: DateTime.now(),
      );

      return await User.db.updateRow(session, updatedUser);
    }
  }

  // ... (Rest of the file remains exactly the same as your previous paste) ...
  // completeTutorial, getUser, updateLastSeen, findMatches...

  Future<void> completeTutorial(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    final authUserId = authInfo.authUserId;

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (user != null) {
      final updated = user.copyWith(hasDoneTutorial: true);
      await User.db.updateRow(session, updated);
    }
  }

  Future<User?> getUser(Session session, int userId) async {
    return await User.db.findById(session, userId);
  }

  Future<void> updateLastSeen(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final authUserId = authInfo.authUserId;

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (user != null) {
      final updated = user.copyWith(lastSeen: DateTime.now());
      await User.db.updateRow(session, updated);
    }
  }

  Future<List<User>> findMatches(
    Session session, {
    int? minAge,
    int? maxAge,
    String? country,
    int limit = 10,
  }) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    final authUserId = authInfo.authUserId;

    // Get current user to exclude from matches
    final currentUser = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );

    var matches = await User.db.find(
      session,
      where: (t) => t.isAnonymous.equals(false),
      limit: limit * 2,
      orderBy: (t) => t.lastSeen,
      orderDescending: true,
    );

    var filtered = matches.where((u) => u.id != currentUser?.id).toList();

    if (minAge != null) {
      filtered = filtered
          .where((u) => u.age != null && u.age! >= minAge)
          .toList();
    }
    if (maxAge != null) {
      filtered = filtered
          .where((u) => u.age != null && u.age! <= maxAge)
          .toList();
    }
    if (country != null) {
      filtered = filtered.where((u) => u.country == country).toList();
    }

    return filtered.take(limit).toList();
  }
}
