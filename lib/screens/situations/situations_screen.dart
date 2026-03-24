import 'package:flutter/material.dart';

class SituationsScreen extends StatelessWidget {
  const SituationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scenariusze AI')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          const Text('Wybierz gotowy tryb', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('Wybierz odpowiedni kontekst, a AI przygotuje idealną wiadomość.', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
          const SizedBox(height: 32),
          _ModernScenarioTile(
            title: 'Opóźnienie w podróży',
            desc: 'Realistyczne wytłumaczenie awarii lub korków.',
            icon: Icons.directions_bus_rounded,
            color: const Color(0xFFF59E0B),
            examples: [
              'Przepraszam za spóźnienie — tramwaj stał 15 minut na przystanku z powodu awarii zasilania. Będę za około 10 minut.',
              'Niestety utknęłam w korku na moście z powodu kolizji. Szacuję, że dotrę za 20 minut. Przepraszam za niedogodność.',
            ],
          ),
          _ModernScenarioTile(
            title: 'Potwierdzenie spóźnienia',
            desc: 'Działaj proaktywnie, zanim ktoś zauważy.',
            icon: Icons.timer_rounded,
            color: const Color(0xFF3B82F6),
            examples: [
              'Będę spóźniony około 5-10 minut. Proszę, zacznijcie beze mnie, dołączę natychmiast po przyjeździe!',
              'Właśnie ruszam, ale nawigacja pokazuje 10 minut spóźnienia. Bardzo przepraszam!',
            ],
          ),
          _ModernScenarioTile(
            title: 'Grzeczna odmowa',
            desc: 'Odmów bez poczucia winy.',
            icon: Icons.block_rounded,
            color: const Color(0xFFEF4444),
            examples: [
              'Dziękuję za zaproszenie! Niestety tym razem muszę odmówić — mam już inne plany. Miłej zabawy!',
              'Doceniam pamięć, ale dzisiaj nie dam rady. Mam nadzieję, że nadrobimy w innym terminie.',
            ],
          ),
          _ModernScenarioTile(
            title: 'Tryb Szefa',
            desc: 'Maksymalnie formalny i profesjonalny ton.',
            icon: Icons.business_center_rounded,
            color: const Color(0xFF1E293B),
            examples: [
              'Szanowni Państwo, przepraszam za spóźnienie spowodowane niespodziewanymi problemami technicznymi. Będę na miejscu za 15 minut.',
              'Uprzejmie informuję, że z przyczyn niezależnych od mnie spóźnię się na nasze spotkanie. Bardzo proszę o wyrozumiałość.',
            ],
          ),
          _ModernScenarioTile(
            title: 'Ratowanie randki',
            desc: 'Czułe i szczere wiadomości do bliskich.',
            icon: Icons.favorite_rounded,
            color: const Color(0xFFEC4899),
            examples: [
              'Skarbie, przepraszam, spóźnię się chwilkę. Wpadł mi nagły problem, ale już pędzę do Ciebie! ❤️',
              'Wiem, że czekasz, przepraszam! Będę za 10 minut, wynagrodzę Ci to czekanie! 😘',
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ModernScenarioTile extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final List<String> examples;

  const _ModernScenarioTile({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.examples,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: () => _showExamples(context),
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        subtitle: Text(desc, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }

  void _showExamples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('Wybierz propozycję do skopiowania:', style: TextStyle(color: Colors.grey.shade500)),
              const SizedBox(height: 32),
              ...examples.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(e, style: const TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Skopiowano!')));
                        },
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('Kopiuj', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(foregroundColor: color),
                      ),
                    )
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
