//eloquim_server/lib/src/endpoints/user_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  
  Future<User?> getCurrentUser(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return null;
    
    // Parse the ID
    final userId = int.parse(authInfo.userIdentifier);

    return await User.db.findById(session, userId);
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
    
    final userId = int.parse(authInfo.userIdentifier);

    var user = await User.db.findById(session, userId);
    
    if (user == null) {
      // Create new user
      // FIX: Explicitly set ID to match Auth ID. 
      // Initialize personaId to null or a default.
      user = User(
        id: userId,
        username: username ?? 'User$userId',
        email: null,
        gender: gender,
        age: age,
        country: country,
        personaId: 0, // FIX: Pass nullable
        emojiSignature: '✨🎵💫',
        hasDoneTutorial: false,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isAnonymous: true,
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

  Future<void> completeTutorial(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    final userId = int.parse(authInfo.userIdentifier);

    final user = await User.db.findById(session, userId);
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
    final userId = int.parse(authInfo.userIdentifier);

    final user = await User.db.findById(session, userId);
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
    final userId = int.parse(authInfo.userIdentifier);

    // FIX: Using simple find, filtering in memory for complex exclusions in V1
    var matches = await User.db.find(
      session,
      where: (t) => t.isAnonymous.equals(false),
      limit: limit * 2, // Fetch more to filter
      orderBy: (t) => t.lastSeen,
      orderDescending: true,
    );

    // Filter out self and apply filters
    var filtered = matches.where((u) => u.id != userId).toList();

    if (minAge != null) {
      filtered = filtered.where((u) => u.age != null && u.age! >= minAge).toList();
    }
    if (maxAge != null) {
      filtered = filtered.where((u) => u.age != null && u.age! <= maxAge).toList();
    }
    if (country != null) {
      filtered = filtered.where((u) => u.country == country).toList();
    }

    return filtered.take(limit).toList();
  }
}