import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AiProvider with ChangeNotifier {
  // ======= FREELLM — JEDYNY SILNIK AI =======
  static const String _apiKey = 'apf_ah3ktdphs6ofbeby3znqeg7h';
  static const String _endpoint = 'https://apifreellm.com/api/v1/chat';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedSituation;
  String? get selectedSituation => _selectedSituation;

  String? _selectedProblem;
  String? get selectedProblem => _selectedProblem;

  String? _selectedSubject;
  String? get selectedSubject => _selectedSubject;

  String? _forgottenItem;
  String? get forgottenItem => _forgottenItem;

  double _formality = 0.5;
  double get formality => _formality;

  double _honesty = 0.5;
  double get honesty => _honesty;

  List<String> _generatedMessages = [];
  List<String> get generatedMessages => _generatedMessages;

  List<Map<String, String>> _history = [];
  List<Map<String, String>> get history => _history;

  List<String> _favorites = [];
  List<String> get favorites => _favorites;

  AiProvider() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('ai_history');
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      _history = decoded.map((item) => Map<String, String>.from(item)).toList();
    }
    final favsJson = prefs.getString('ai_favorites');
    if (favsJson != null) {
      _favorites = List<String>.from(jsonDecode(favsJson));
    }
    notifyListeners();
  }

  // ======= ULUBIONE =======
  Future<void> toggleFavorite(String message) async {
    if (_favorites.contains(message)) {
      _favorites.remove(message);
    } else {
      _favorites.add(message);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_favorites', jsonEncode(_favorites));
    notifyListeners();
  }

  bool isFavorite(String message) => _favorites.contains(message);

  // ======= KOPIUJ DO SCHOWKA =======
  Future<void> copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Skopiowano do schowka!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> saveToHistory(String message, String title) async {
    final newItem = {
      'title': title,
      'message': message,
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'date': '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
    };
    _history.insert(0, newItem);
    if (_history.length > 30) _history.removeLast();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_history', jsonEncode(_history));
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ai_history');
    notifyListeners();
  }

  void setSituation(String situation) { _selectedSituation = situation; notifyListeners(); }
  void setProblem(String problem) { _selectedProblem = problem; notifyListeners(); }
  void setSchoolDetails(String subject, String item) { _selectedSubject = subject; _forgottenItem = item; notifyListeners(); }
  void setSliders(double formality, double honesty) { _formality = formality; _honesty = honesty; notifyListeners(); }

  // ==========================================
  // FREELLM AI ENGINE
  // ==========================================

  String _buildPrompt(String gender, String bio, String personality) {
    final genderInfo = gender == 'Kobieta'
        ? 'Kobieta (ZAWSZE formy żeńskie: zaspałam, spóźniłam się, byłam, musiałam, utknęłam, mogłam, chciałam)'
        : 'Mężczyzna (ZAWSZE formy męskie: zaspałem, spóźniłem się, byłem, musiałem, utknąłem, mogłem, chciałem)';
    final formalityDesc = _formality > 0.7 ? 'bardzo formalny, oficjalny' : (_formality > 0.4 ? 'neutralny, uprzejmy' : 'luźny, koleżeński, potoczny');
    final honestyDesc = _honesty > 0.7 ? 'szczera, oparta na prawdopodobnych faktach' : (_honesty > 0.4 ? 'lekko ubarwiona, przekonująca' : 'kreatywna, wymyślona ale wiarygodna');

    return 'Jesteś genialnym ekspertem od wymówek w języku polskim. Tworzysz naturalne, wiarygodne i gotowe do wysłania wiadomości SMS/WhatsApp.\n\n'
        'ZASADY:\n'
        '- Pisz WYŁĄCZNIE po polsku, poprawną polską gramatyką\n'
        '- Płeć użytkownika: $genderInfo — NIGDY nie mieszaj form\n'
        '- Ton wiadomości: $formalityDesc\n'
        '- Rodzaj wymówki: $honestyDesc\n'
        '- Osobowość: $personality\n'
        '- NIE używaj placeholderów typu [Imię], [czas], [miejsce] — wymyśl konkretne dane\n'
        '- Wiadomość musi być GOTOWA do skopiowania i wysłania\n'
        '- Każdy wariant powinien być inny (krótki / szczegółowy / emocjonalny)\n'
        '- Zwróć DOKŁADNIE 3 warianty oddzielone znakiem ###\n\n'
        'KONTEKST:\n'
        '- Sytuacja: ${_selectedSituation ?? "ogólna"}\n'
        '- Problem: ${_selectedProblem ?? "spóźnienie"}\n'
        '${_selectedSubject != null ? "- Przedmiot szkolny: $_selectedSubject\n" : ""}'
        '${bio.isNotEmpty ? "- O użytkowniku: $bio\n" : ""}'
        '\nWygeneruj 3 warianty wiadomości:';
  }

  Future<void> generateMessages({String gender = 'Mężczyzna', String bio = '', String personality = 'Przyjazny kumpel'}) async {
    _isLoading = true;
    _generatedMessages.clear();
    notifyListeners();

    try {
      final prompt = _buildPrompt(gender, bio, personality);
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({'message': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true) {
          final text = data['response'] as String;
          _generatedMessages = text.split('###').map((e) => e.trim()).where((e) => e.isNotEmpty && e.length > 10).toList();
          // Oczyść numerację typu "1.", "Wariant 1:" itd.
          _generatedMessages = _generatedMessages.map((m) {
            return m.replaceAll(RegExp(r'^(Wariant\s*\d+[:\.]?\s*|^\d+[\.\)]\s*)', multiLine: true), '').trim();
          }).where((e) => e.isNotEmpty).toList();
        }
      }

      if (_generatedMessages.isEmpty) throw Exception('Pusta odpowiedź');
    } catch (e) {
      debugPrint('FreeLLM Error: $e — fallback offline');
      _generatedMessages = [
        _neuralAssembly(0, gender, bio, personality),
        _neuralAssembly(1, gender, bio, personality),
        _neuralAssembly(2, gender, bio, personality),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> quickGenerate(String prompt, {String gender = 'Mężczyzna', String personality = 'Przyjazny kumpel'}) async {
    _isLoading = true;
    _generatedMessages.clear();
    notifyListeners();

    try {
      final genderInfo = gender == 'Kobieta' ? 'Kobieta (formy żeńskie)' : 'Mężczyzna (formy męskie)';
      final fullPrompt = 'Jesteś ekspertem od wymówek po polsku. Płeć: $genderInfo. Osobowość: $personality.\n'
          'Sytuacja: $prompt.\n'
          'Napisz 2 gotowe wiadomości SMS po polsku. Oddziel je znakiem ###. Nie numeruj.';

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_apiKey'},
        body: jsonEncode({'message': fullPrompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true) {
          _generatedMessages = (data['response'] as String).split('###').map((e) => e.trim()).where((e) => e.isNotEmpty && e.length > 10).toList();
        }
      }
      if (_generatedMessages.isEmpty) throw Exception('Pusta');
    } catch (e) {
      debugPrint('Quick FreeLLM error: $e');
      _generatedMessages = [
        _flex('Przepraszam za kłopot — $prompt. Będę tak szybko jak mogę!', gender),
        _flex('Hej, mam mały problem: $prompt. Daj mi kilka minut, zaraz będę!', gender),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  // ==========================================
  // SILNIK OFFLINE (FALLBACK)
  // ==========================================

  String _genitive(String word) {
    final w = word.toLowerCase();
    final map = {
      'matematyka': 'matematyki', 'polski': 'języka polskiego', 'historia': 'historii',
      'fizyka': 'fizyki', 'geografia': 'geografii', 'informatyka': 'informatyki',
      'biologia': 'biologii', 'wf': 'lekcji WF', 'korki': 'korków na drodze',
      'zaspa': 'zaspania', 'zdrowie': 'nagłego pogorszenia zdrowia',
      'problemy techniczne': 'problemów technicznych', 'wypadek': 'wypadku losowego',
      'brak ochoty': 'pilnych spraw osobistych',
    };
    for (final entry in map.entries) {
      if (w.contains(entry.key)) return entry.value;
    }
    return w;
  }

  String _flex(String text, String gender) {
    if (gender == 'Kobieta') {
      return text
        .replaceAll('zaspałem', 'zaspałam').replaceAll('byłem', 'byłam')
        .replaceAll('musiałem', 'musiałam').replaceAll('spóźniony', 'spóźniona')
        .replaceAll('utknąłem', 'utknęłam').replaceAll('zrobiłem', 'zrobiłam')
        .replaceAll('mogłem', 'mogłam').replaceAll('chciałem', 'chciałam')
        .replaceAll('zmuszony', 'zmuszona').replaceAll('gotowy', 'gotowa');
    }
    return text;
  }

  String _neuralAssembly(int seed, String gender, String bio, String personality) {
    final random = Random(seed + DateTime.now().millisecond);
    final intros = _formality > 0.7
        ? ['Szanowni Państwo, uprzejmie informuję, że ', 'Dzień dobry, z przykrością przekazuję, iż ']
        : ['Hej, sorry za kłopot, ale ', 'Słuchaj, mamy problem — '];
    final closings = _formality > 0.6
        ? ['Proszę o wyrozumiałość.', 'Zrobię wszystko, by nadrobić.']
        : ['Daj znać, czy okej!', 'Będę pędzić ile sił!'];
    final bioP = (bio.isNotEmpty && seed == 0) ? 'Jako $bio, ' : '';
    final problem = 'z powodu ${_genitive(_selectedProblem ?? "nagłej sytuacji")}';
    final situation = _selectedSituation == 'Szkoła' && _selectedSubject != null
        ? ' nie mogę być na ${_genitive(_selectedSubject!)}.'
        : ' moja obecność na ${_selectedSituation ?? "spotkaniu"} jest zagrożona.';
    return _flex('$bioP${intros[random.nextInt(intros.length)]}$problem.$situation ${closings[random.nextInt(closings.length)]}', gender);
  }
}
