import 'package:flutter/material.dart';

class WidgetGallery extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String deskripsi;

  const WidgetGallery({
    super.key,
    required this.icon,
    required this.judul,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(deskripsi),
      ),
    );
  }
}