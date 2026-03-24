import 'package:flutter/material.dart';
import 'dart:ui';

class PanicCard extends StatelessWidget {
  const PanicCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => _buildPanicSheet(ctx),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [const Color(0xFFFF4949).withOpacity(0.9), const Color(0xFFB71C1C).withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 56),
                SizedBox(height: 16),
                Text(
                  'PANIKA — Spóźnię się!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Naciśnij, by natychmiast wygenerować wymówkę',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanicSheet(BuildContext context) {
    final messages = [
      'Przepraszam za spóźnienie, tramwaj mi uciekł sprzed nosa. Będę za 10 minut!',
      'Hej, mam mały problem z dojazdem — korki na całym mieście. Zaraz będę, przepraszam!',
      'Sorki, alarm nie zadzwonił. Jestem już w drodze, najszybciej jak mogę!',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text('⚡ Wymówka Błyskawiczna', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          ...messages.map((msg) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4))),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.cyanAccent, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Skopiowano do schowka!'), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
