import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/ai_provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final ai = Provider.of<AiProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withOpacity(0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Witaj,', style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                              Text(user?.displayName?.split(' ')[0] ?? 'Legendo!', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2), width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                              child: user?.photoURL == null ? const Icon(Icons.person_rounded, color: Color(0xFF6366F1)) : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildMainStats(context, profile),
                      const SizedBox(height: 40),
                      const Text('Szybkie Akcje AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 16),
                      _buildQuickActions(context, ai, profile),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ostatnie Wymówki', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          if (ai.history.isNotEmpty)
                            TextButton(
                              onPressed: () => ai.clearHistory(),
                              child: const Text('Wyczyść', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (ai.history.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _emptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _HistoryCard(item: ai.history[index]),
                      childCount: ai.history.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainStats(BuildContext context, ProfileProvider profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Wymówki', profile.generatedCount.toString()),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          _statItem('Spóźnienia', profile.lateCount.toString()),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
          _statItem('Status', 'PRO'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AiProvider ai, ProfileProvider profile) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _actionCard(context, 'Korki', Icons.traffic_rounded, const Color(0xFFF59E0B), () => _showQuickAi(context, ai, profile, 'Stoję w korku')),
          _actionCard(context, 'Zaspałem', Icons.hotel_rounded, const Color(0xFF3B82F6), () => _showQuickAi(context, ai, profile, 'Zaspałem do pracy')),
          _actionCard(context, 'Techniczne', Icons.router_rounded, const Color(0xFF10B981), () => _showQuickAi(context, ai, profile, 'Awaria internetu')),
          _actionCard(context, 'Zdrowie', Icons.medical_services_rounded, const Color(0xFFEF4444), () => _showQuickAi(context, ai, profile, 'Złe samopoczucie')),
        ],
      ),
    );
  }

  Widget _actionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }

  void _showQuickAi(BuildContext context, AiProvider ai, ProfileProvider profile, String situation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _QuickAiSheet(situation: situation, ai: ai, profile: profile),
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history_rounded, size: 64, color: Colors.grey.withOpacity(0.2)),
        const SizedBox(height: 16),
        Text('Twoja historia jest pusta', style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, String> item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(item['title'] ?? 'Wymówka', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(item['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(item['time'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            Text(item['date'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        onTap: () => _viewMessage(context),
      ),
    );
  }

  void _viewMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(item['message']!, style: const TextStyle(fontSize: 16, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Zamknij', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _QuickAiSheet extends StatefulWidget {
  final String situation;
  final AiProvider ai;
  final ProfileProvider profile;
  const _QuickAiSheet({required this.situation, required this.ai, required this.profile});

  @override
  State<_QuickAiSheet> createState() => _QuickAiSheetState();
}

class _QuickAiSheetState extends State<_QuickAiSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => widget.ai.quickGenerate(
      widget.situation, 
      gender: widget.profile.gender, 
      personality: widget.profile.aiPersonality
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 24),
          Text(widget.situation, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: Consumer<AiProvider>(
              builder: (ctx, ai, _) {
                if (ai.isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
                return ListView.builder(
                  itemCount: ai.generatedMessages.length,
                  itemBuilder: (ctx, i) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: ListTile(
                      title: Text(ai.generatedMessages[i], style: const TextStyle(fontSize: 14)),
                      trailing: const Icon(Icons.copy_rounded, size: 20, color: Color(0xFF6366F1)),
                      onTap: () {
                        ai.saveToHistory(ai.generatedMessages[i], widget.situation);
                        widget.profile.incrementGenerated();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
