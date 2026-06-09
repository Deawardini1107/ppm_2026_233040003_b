import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QuizPertemuan3 extends StatefulWidget {
  const QuizPertemuan3({super.key});

  @override
  State<QuizPertemuan3> createState() => _QuizPertemuan3State();
}

class _QuizPertemuan3State extends State<QuizPertemuan3> {
  String? _imagePath;

  Future<void> _pilihGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _imagePath != null ? NetworkImage(_imagePath!) : null,
              child: _imagePath == null ? const Icon(Icons.person, size: 50) : null,
            ),
            TextButton(
              onPressed: _pilihGambar,
              child: const Text('Ganti Foto Profil'),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _imagePath),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}