import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../providers/profile_provider.dart';

class TeachAiScreen extends StatefulWidget {
  const TeachAiScreen({Key? key}) : super(key: key);

  @override
  State<TeachAiScreen> createState() => _TeachAiScreenState();
}

class _TeachAiScreenState extends State<TeachAiScreen> {
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _bioCtrl = TextEditingController(text: profile.userBio);
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    super.dispose();
  }

  void _save(ProfileProvider profile) {
    profile.setUserBio(_bioCtrl.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI zapamiętało informacje o Tobie!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Ucz AI [BETA]'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Tło premium
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(top: -40, right: -40, child: _buildOrb(180, Colors.cyanAccent.withOpacity(0.15))),
          Positioned(bottom: 200, left: -50, child: _buildOrb(220, Colors.purpleAccent.withOpacity(0.1))),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child: const Text('FUNKCJA BETA', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Opowiedz AI o sobie',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dzięki tym informacjom Twoje wymówki będą brzmiały naturalnie i dedykowanie.',
                    style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.6), height: 1.5),
                  ),
                  const SizedBox(height: 32),

                  // Pole Bio
                  const Text('Twój profil (kim jesteś, co robisz?):', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: TextField(
                          controller: _bioCtrl,
                          maxLines: 8,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Np. "Jestem studentem informatyki, mam psa o imieniu Azor, często spóźniam się przez korki na wjeździe do Poznania..."',
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text('Twoja płeć (wpływa na gramatykę):', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildGenderCard('Mężczyzna', Icons.male, profile),
                      const SizedBox(width: 12),
                      _buildGenderCard('Kobieta', Icons.female, profile),
                    ],
                  ),
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Zapisz w pamięci AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF755BFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => _save(profile),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(String gender, IconData icon, ProfileProvider profile) {
    bool selected = profile.gender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => profile.setGender(gender),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF755BFF).withOpacity(0.2) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? const Color(0xFF755BFF) : Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? const Color(0xFF755BFF) : Colors.grey, size: 32),
              const SizedBox(height: 8),
              Text(gender, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }
}
