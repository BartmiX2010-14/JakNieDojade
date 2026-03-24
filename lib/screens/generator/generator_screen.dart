import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ai_provider.dart';
import '../../providers/profile_provider.dart';
import 'dart:async';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({Key? key}) : super(key: key);

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _subjectCtrl = TextEditingController();
  final _forgottenCtrl = TextEditingController();

  final List<String> _situations = ['Praca', 'Szkoła', 'Randka', 'Spotkanie', 'Dom', 'Inne'];
  final List<String> _problems = ['Korki', 'Zaspałem', 'Problemy techniczne', 'Zdrowie', 'Wypadek losowy', 'Brak ochoty'];

  List<String> _thinkingLogs = [];
  Timer? _thinkingTimer;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _forgottenCtrl.dispose();
    _thinkingTimer?.cancel();
    super.dispose();
  }

  void _startThinking() {
    setState(() => _thinkingLogs = ['Inicjalizacja FreeLLM 200B+...']);
    const logs = [
      'Analiza kontekstu społecznego...',
      'Dostrajanie parametrów wiarygodności...',
      'Weryfikacja fleksji dla wybranej płci...',
      'Wstrzykiwanie danych personalnych...',
      'Optymalizacja pod kątem copy-paste...',
      'Generowanie wariantów profesjonalnych...',
    ];
    int i = 0;
    _thinkingTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (i < logs.length) {
        setState(() => _thinkingLogs.add(logs[i]));
        i++;
      } else {
        t.cancel();
      }
    });
  }

  void _next() {
    if (_currentStep < 4) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.elasticOut);
    }
  }

  void _prev() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.elasticOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ai = Provider.of<AiProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generator AI'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline_rounded)),
        ],
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildConceptStep(profile),
                _buildSituationStep(ai),
                _buildProblemStep(ai),
                _buildParamsStep(ai, profile),
                _buildResultsStep(ai, profile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Stack(
        children: [
          Container(height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10))),
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            height: 4,
            width: (MediaQuery.of(context).size.width - 64) * ((_currentStep + 1) / 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFC084FC)]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 10)],
            ),
          ),
        ],
      ),
    );
  }

  // --- STEPS ---

  Widget _buildConceptStep(ProfileProvider profile) {
    return _stepLayout(
      title: 'Zacznijmy od podstaw',
      sub: 'Ustawienia płci pozwalają AI pisać naturalnie.',
      child: Row(
        children: [
          _modernSelectCard('On', Icons.male_rounded, profile.gender == 'Mężczyzna', () => profile.setGender('Mężczyzna')),
          const SizedBox(width: 16),
          _modernSelectCard('Ona', Icons.female_rounded, profile.gender == 'Kobieta', () => profile.setGender('Kobieta')),
        ],
      ),
      onNext: profile.gender != 'Nie wybrano' ? _next : null,
    );
  }

  Widget _modernSelectCard(String label, IconData icon, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: active ? const Color(0xFF6366F1) : Colors.grey.withOpacity(0.1), width: 2),
            boxShadow: active ? [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.1), blurRadius: 20)] : [],
          ),
          child: Column(
            children: [
              Icon(icon, size: 48, color: active ? const Color(0xFF6366F1) : Colors.grey),
              const SizedBox(height: 12),
              Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: active ? const Color(0xFF6366F1) : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSituationStep(AiProvider ai) {
    return _stepLayout(
      title: 'Gdzie planowałeś być?',
      sub: 'Wybierz kategorię zdarzenia.',
      child: GridView.count(
        shrinkWrap: true, crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 12, mainAxisSpacing: 12,
        children: _situations.map((s) => _modernBtn(s, ai.selectedSituation == s, () => ai.setSituation(s))).toList(),
      ),
      onNext: ai.selectedSituation != null ? _next : null,
      onPrev: _prev,
    );
  }

  Widget _modernBtn(String t, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6366F1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          boxShadow: active ? [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 8)] : [],
        ),
        child: Text(t, style: TextStyle(color: active ? Colors.white : null, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildProblemStep(AiProvider ai) {
    return _stepLayout(
      title: 'Co poszło nie tak?',
      sub: 'Bądź szczery (lub nie).',
      child: Column(
        children: [
          Wrap(
            spacing: 10, runSpacing: 10,
            children: _problems.map((p) => ChoiceChip(
              label: Text(p),
              selected: ai.selectedProblem == p,
              onSelected: (_) => ai.setProblem(p),
              backgroundColor: Colors.transparent,
              selectedColor: const Color(0xFF6366F1).withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            )).toList(),
          ),
          if (ai.selectedSituation == 'Szkoła') ...[
            const SizedBox(height: 32),
            TextField(
              controller: _subjectCtrl,
              decoration: InputDecoration(
                labelText: 'Przedmiot szkolny',
                filled: true,
                fillColor: Colors.grey.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              onChanged: (v) => ai.setSchoolDetails(v, _forgottenCtrl.text),
            ),
          ]
        ],
      ),
      onNext: ai.selectedProblem != null ? _next : null,
      onPrev: _prev,
    );
  }

  Widget _buildParamsStep(AiProvider ai, ProfileProvider profile) {
    return _stepLayout(
      title: 'Personalizacja AI',
      sub: 'Dostosuj ton wiadomości.',
      child: Column(
        children: [
          _modernSlider('Stopień formalności', ai.formality, (v) => setState(() => ai.setSliders(v, ai.honesty)), Icons.gavel_rounded),
          const SizedBox(height: 24),
          _modernSlider('Poziom szczerości', ai.honesty, (v) => setState(() => ai.setSliders(ai.formality, v)), Icons.favorite_rounded),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF6366F1)),
                const SizedBox(width: 12),
                Expanded(child: Text('AI użyje Twojego bio: "${profile.userBio.isEmpty ? "Domyślne" : profile.userBio}"', style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
      onNext: () { _startThinking(); ai.generateMessages(gender: profile.gender, bio: profile.userBio, personality: profile.aiPersonality); _next(); },
      onPrev: _prev,
    );
  }

  Widget _modernSlider(String label, double val, Function(double) onChanged, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))]),
        Slider(value: val, onChanged: onChanged, activeColor: const Color(0xFF6366F1)),
      ],
    );
  }

  // --- RESULTS STEP ---

  Widget _buildResultsStep(AiProvider ai, ProfileProvider profile) {
    if (ai.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
               width: 100, height: 100,
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2), width: 3),
               ),
               child: const CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF6366F1)),
             ),
             const SizedBox(height: 40),
             const Text('AI GENERUJE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 16, color: Color(0xFF6366F1))),
             const SizedBox(height: 8),
             Text('FreeLLM 200B+', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
             const SizedBox(height: 24),
             ..._thinkingLogs.reversed.take(3).map((log) => Padding(
               padding: const EdgeInsets.symmetric(vertical: 3),
               child: Text(log, style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 12)),
             )).toList(),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gotowe ✨', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text('Kliknij na wiadomość, aby skopiować', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          const SizedBox(height: 24),
          ...ai.generatedMessages.asMap().entries.map((entry) => _premiumMsgCard(entry.key + 1, entry.value, ai, profile)).toList(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => setState(() { _currentStep = 0; _pageController.jumpToPage(0); }),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Wygeneruj ponownie', style: TextStyle(fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                side: const BorderSide(color: Color(0xFF6366F1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumMsgCard(int index, String msg, AiProvider ai, ProfileProvider profile) {
    final isFav = ai.isFavorite(msg);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(isFav ? 0.3 : 0.05), width: isFav ? 2 : 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            ai.copyToClipboard(msg, context);
            ai.saveToHistory(msg, '${ai.selectedSituation ?? "Wymówka"} • ${ai.selectedProblem ?? ""}');
            profile.incrementGenerated();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Wariant $index', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF6366F1))),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => ai.toggleFavorite(msg),
                      child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, 
                        size: 22, color: isFav ? const Color(0xFFEF4444) : Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(msg, style: const TextStyle(fontSize: 15, height: 1.7, fontWeight: FontWeight.w500)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.touch_app_rounded, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text('Dotknij, aby skopiować', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LAYOUT ---

  Widget _stepLayout({required String title, required String sub, required Widget child, VoidCallback? onNext, VoidCallback? onPrev}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Text(sub, style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
          const SizedBox(height: 48),
          child,
          const SizedBox(height: 60),
          Row(
            children: [
              if (onPrev != null) 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: IconButton(onPressed: onPrev, icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
                ),
              const Spacer(),
              if (onNext != null) 
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onNext, 
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: const Text('Dalej', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
