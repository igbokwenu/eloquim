import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eloquim_client/eloquim_client.dart';
import '../../core/providers/serverpod_client_provider.dart';

class TokenUsageBottomSheet extends ConsumerWidget {
  const TokenUsageBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TokenUsageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(serverpodClientProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: FutureBuilder<TokenUsageInfo>(
        future: client.user.getTokenUsageInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return SizedBox(
              height: 200,
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          }

          final usageInfo = snapshot.data!;
          final totalTokens = usageInfo.totalTokens;
          final lastCalls = usageInfo.lastCalls;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Token usage',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Total Tokens Used',
                totalTokens.toString(),
                Icons.analytics,
                Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Last 5 API Calls',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (lastCalls.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('No API calls logged yet')),
                )
              else
                ...lastCalls.map((call) => _buildCallItem(call)),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.black54)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallItem(TokenCallEntry call) {
    final type = call.type;
    final tokens = call.tokens;
    final cost = call.cost;
    final time = call.time;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(_getIconForType(type), size: 18, color: Colors.black),
        ),
        title: Text(
          type.toUpperCase(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${time.hour}:${time.minute.toString().padLeft(2, '0')} - ${tokens} tokens',
        ),
        trailing: Text(
          '\$${cost.toStringAsFixed(4)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'translation':
        return Icons.translate;
      case 'recommendation':
        return Icons.auto_awesome;
      case 'bot_response':
        return Icons.smart_toy;
      default:
        return Icons.api;
    }
  }
}
