import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart' as app_auth;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final auth = Provider.of<app_auth.AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E1B4B), Color(0xFF4338CA), Color(0xFF7C3AED)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      // Avatar z neonową obwódką
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFFC084FC), Color(0xFFF472B6)]),
                          boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.4), blurRadius: 30, spreadRadius: 5)],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: const Color(0xFF1E1B4B),
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null 
                              ? Text(user?.email?[0].toUpperCase() ?? 'U', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white)) 
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(user?.displayName ?? user?.email ?? 'Użytkownik', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(height: 8),
                      // Badge AI
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, size: 14, color: Color(0xFFFBBF24)),
                            SizedBox(width: 8),
                            Text('FreeLLM AI • Aktywne', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- STATYSTYKI ---
                  _buildSectionTitle('TWOJA EFEKTYWNOŚĆ'),
                  const SizedBox(height: 16),
                  _buildStatsRow(profile),
                  const SizedBox(height: 32),

                  // --- USTAWIENIA ---
                  _buildSectionTitle('USTAWIENIA'),
                  const SizedBox(height: 16),
                  _buildSettingTile(context, 'Osobowość AI', profile.aiPersonality, Icons.psychology_rounded, const Color(0xFF8B5CF6), () => _showPersonalityPicker(context, profile)),
                  _buildSettingTile(context, 'Płeć (Fleksja)', profile.gender, Icons.person_search_rounded, const Color(0xFFEC4899), () => _showGenderPicker(context, profile)),
                  _buildSettingTile(context, 'Motyw', profile.themeMode, Icons.palette_rounded, const Color(0xFF06B6D4), () => _showThemePicker(context, profile)),
                  const SizedBox(height: 32),

                  // --- SILNIK ---
                  _buildSectionTitle('SILNIK AI'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF6366F1).withOpacity(0.08), const Color(0xFF8B5CF6).withOpacity(0.04)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.smart_toy_rounded, color: Color(0xFF6366F1), size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FreeLLM 200B+', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                              SizedBox(height: 4),
                              Text('Nielimitowane • Darmowe • Wbudowane', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('ON', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w900, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- WYLOGUJ ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => auth.logout(),
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Text('Wyloguj się', style: TextStyle(fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444).withOpacity(0.08),
                        foregroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        side: BorderSide(color: const Color(0xFFEF4444).withOpacity(0.15)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2, color: Colors.grey));
  }

  Widget _buildStatsRow(ProfileProvider profile) {
    return Row(
      children: [
        Expanded(child: _statCard(profile.generatedCount.toString(), 'Wymówki', Icons.auto_awesome_rounded, const Color(0xFF6366F1))),
        const SizedBox(width: 12),
        Expanded(child: _statCard(profile.lateCount.toString(), 'Spóźnienia', Icons.alarm_rounded, const Color(0xFFF59E0B))),
        const SizedBox(width: 12),
        Expanded(child: _statCard(profile.cancelCount.toString(), 'Anulowane', Icons.close_rounded, const Color(0xFFEF4444))),
      ],
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(val, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, String val, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        subtitle: Text(val, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        trailing: Icon(Icons.chevron_right_rounded, size: 22, color: Colors.grey.shade400),
      ),
    );
  }

  void _showGenderPicker(BuildContext context, ProfileProvider profile) {
    _showPicker(context, 'Wybierz płeć', ['Mężczyzna', 'Kobieta', 'Inna'], (v) => profile.setGender(v));
  }

  void _showPersonalityPicker(BuildContext context, ProfileProvider profile) {
    _showPicker(context, 'Osobowość AI', ['Przyjazny kumpel', 'Profesjonalny asystent', 'Sarkastyczny helper', 'Spokojny doradca'], (v) => profile.setAiPersonality(v));
  }

  void _showThemePicker(BuildContext context, ProfileProvider profile) {
    _showPicker(context, 'Motyw aplikacji', ['Automatyczny', 'Jasny', 'Ciemny'], (v) => profile.setThemeMode(v));
  }

  void _showPicker(BuildContext context, String title, List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            ...options.map((o) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(o, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: Colors.white.withOpacity(0.03),
                onTap: () { onSelect(o); Navigator.pop(ctx); },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
