// eloquim_server/lib/src/endpoints/user_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  
  /// Get current user profile
  Future<User?> getCurrentUser(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return null;
    }

    return await User.db.findById(session, authInfo.userId);
  }

  /// Create or update user profile
  Future<User> updateProfile(
    Session session, {
    String? username,
    String? gender,
    int? age,
    String? country,
  }) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    var user = await User.db.findById(session, authInfo.userId);
    
    if (user == null) {
      // Create new user
      user = User(
        id: authInfo.userId,
        username: username ?? 'User${authInfo.userId}',
        email: null,
        gender: gender,
        age: age,
        country: country,
        emojiSignature: '✨🎵💫',
        hasDoneTutorial: false,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isAnonymous: true,
      );
      return await User.db.insertRow(session, user);
    } else {
      // Update existing user
      if (username != null) user.username = username;
      if (gender != null) user.gender = gender;
      if (age != null) user.age = age;
      if (country != null) user.country = country;
      user.lastSeen = DateTime.now();
      
      return await User.db.updateRow(session, user);
    }
  }

  /// Mark tutorial as completed
  Future<void> completeTutorial(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final user = await User.db.findById(session, authInfo.userId);
    if (user != null) {
      user.hasDoneTutorial = true;
      await User.db.updateRow(session, user);
    }
  }

  /// Get user by ID (for profile viewing)
  Future<User?> getUser(Session session, int userId) async {
    return await User.db.findById(session, userId);
  }

  /// Update last seen timestamp
  Future<void> updateLastSeen(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return;
    }

    final user = await User.db.findById(session, authInfo.userId);
    if (user != null) {
      user.lastSeen = DateTime.now();
      await User.db.updateRow(session, user);
    }
  }

  /// Find potential matches
  Future<List<User>> findMatches(
    Session session, {
    int? minAge,
    int? maxAge,
    String? country,
    int limit = 10,
  }) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    // Get current user
    final currentUser = await User.db.findById(session, authInfo.userId);
    if (currentUser == null) {
      return [];
    }

    // Find users (excluding current user and anonymous users)
    var matches = await User.db.find(
      session,
      where: (t) => t.id.notEquals(authInfo.userId) & t.isAnonymous.equals(false),
      limit: limit,
      orderBy: (t) => t.lastSeen,
      orderDescending: true,
    );

    // Apply filters
    if (minAge != null) {
      matches = matches.where((u) => u.age != null && u.age! >= minAge).toList();
    }
    if (maxAge != null) {
      matches = matches.where((u) => u.age != null && u.age! <= maxAge).toList();
    }
    if (country != null) {
      matches = matches.where((u) => u.country == country).toList();
    }

    return matches;
  }
}