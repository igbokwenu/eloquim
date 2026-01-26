//eloquim_server/lib/src/endpoints/user_endpoint.dart
import 'package:serverpod/serverpod.dart' hide Message;
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
        totalTokenCount: 0,
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

      // Create initial conversation with Adanna bot
      final adanna = await User.db.findFirstRow(
        session,
        where: (t) => t.username.equals('Adanna'),
      );

      if (adanna != null) {
        // Check if conversation already exists
        final allConversations = await Conversation.db.find(session);
        final existing = allConversations.any(
          (c) =>
              c.participantIds.contains(user.id!) &&
              c.participantIds.contains(adanna.id!),
        );

        if (!existing) {
          await Conversation.db.insertRow(
            session,
            Conversation(
              participantIds: [user.id!, adanna.id!],
              title: 'Adanna 👋',
              startedAt: DateTime.now(),
              lastMessageAt: DateTime.now(),
            ),
          );
        }
      }
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

    // Include bots in matches
    final bots = await User.db.find(
      session,
      where: (t) => t.isBot.equals(true),
    );
    filtered.addAll(bots);

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

    // Shuffle to mix bots and humans
    filtered.shuffle();

    return filtered.take(limit).toList();
  }

  /// Deletes the user account and all associated data.
  Future<void> deleteAccount(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    final authUserId = authInfo.authUserId;

    // Find custom user
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );

    if (user != null) {
      // 1. Delete user's messages
      await Message.db.deleteWhere(
        session,
        where: (t) => t.senderId.equals(user.id!),
      );

      // 2. Remove user from conversations
      // Fetch all conversations where this user is a participant.
      // Note: In a large-scale app, we might use a junction table or more efficient querying.
      final conversations = await Conversation.db.find(session);
      for (final conv in conversations) {
        if (conv.participantIds.contains(user.id)) {
          final updatedIds = conv.participantIds
              .where((id) => id != user.id)
              .toList();
          if (updatedIds.isEmpty) {
            await Conversation.db.deleteRow(session, conv);
          } else {
            await Conversation.db.updateRow(
              session,
              conv.copyWith(participantIds: updatedIds),
            );
          }
        }
      }

      // 3. Delete the custom user record
      await User.db.deleteRow(session, user);
    }

    // 4. Delete the auth user (this will also revoke tokens and delete auth tables entry)
    await AuthServices.instance.authUsers.delete(
      session,
      authUserId: authUserId,
    );
  }

  /// Seed initial bots if they don't exist
  Future<void> seedBots(Session session) async {
    final bots = [
      {'name': 'Adanna', 'signature': '✨💖🤳', 'persona': 'Casual & Flirty'},
      {'name': 'Chuck', 'signature': '💼📊🤝', 'persona': 'Professional'},
      {'name': 'Sarah', 'signature': '🌙📖🕯️', 'persona': 'Romantic'},
      {'name': 'Brian', 'signature': '🔥💯⚡', 'persona': 'Hype'},
    ];

    for (final bot in bots) {
      final existing = await User.db.findFirstRow(
        session,
        where: (t) => t.username.equals(bot['name']!),
      );

      if (existing == null) {
        await User.db.insertRow(
          session,
          User(
            username: bot['name']!,
            emojiSignature: bot['signature']!,
            isBot: true,
            isAnonymous: false,
            createdAt: DateTime.now(),
            lastSeen: DateTime.now(),
            hasDoneTutorial: true,
          ),
        );
      }
    }
  }

  /// Logs token usage for a user
  Future<void> logTokenUsage(
    Session session, {
    required int userId,
    required int tokenCount,
    required String apiCallType,
  }) async {
    final user = await User.db.findById(session, userId);
    if (user != null) {
      // 1. Update user total
      final updatedUser = user.copyWith(
        totalTokenCount: user.totalTokenCount + tokenCount,
      );
      await User.db.updateRow(session, updatedUser);

      // 2. Create log entry
      // Estimated cost: $0.01 per 1000 tokens (simplified)
      final estimatedCost = (tokenCount / 1000) * 0.01;

      await TokenLog.db.insertRow(
        session,
        TokenLog(
          userId: userId,
          tokenCount: tokenCount,
          estimatedCost: estimatedCost,
          apiCallType: apiCallType,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  /// Gets token usage info for the current user
  Future<Map<String, dynamic>> getTokenUsageInfo(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.authUserId),
    );
    if (user == null) throw Exception('User not found');

    // Get last 5 logs
    final logs = await TokenLog.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: 5,
    );

    return {
      'totalTokens': user.totalTokenCount,
      'lastCalls': logs
          .map(
            (l) => {
              'tokens': l.tokenCount,
              'cost': l.estimatedCost,
              'type': l.apiCallType,
              'time': l.timestamp.toIso8601String(),
            },
          )
          .toList(),
    };
  }
}
