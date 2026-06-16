import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File;

class QuizPertemuan3 extends StatefulWidget {
  final Map<String, String> currentData;

  const QuizPertemuan3({super.key, required this.currentData});

  @override
  State<QuizPertemuan3> createState() => _QuizPertemuan3State();
}

class _QuizPertemuan3State extends State<QuizPertemuan3> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _tentangController;
  late TextEditingController _pendidikanController;
  late TextEditingController _lokasiController;
  String? _imagePath;
  Uint8List? _webImage; // Untuk menampung data gambar khusus di web (Chrome)

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.currentData['nama']);
    _tentangController = TextEditingController(text: widget.currentData['tentang']);
    _pendidikanController = TextEditingController(text: widget.currentData['pendidikan']);
    _lokasiController = TextEditingController(text: widget.currentData['lokasi']);
    _imagePath = widget.currentData['img']!.isNotEmpty ? widget.currentData['img'] : null;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tentangController.dispose();
    _pendidikanController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<void> _pilihGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Jika dijalankan di web (Chrome), baca file sebagai bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imagePath = pickedFile.name; // Simpan nama file sebagai penanda
        });
      } else {
        // Jika dijalankan di HP / Emulator Android
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    }
  }

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'nama': _namaController.text,
        'tentang': _tentangController.text,
        'pendidikan': _pendidikanController.text,
        'lokasi': _lokasiController.text,
        'img': _imagePath ?? '',
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Foto Profil', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                // Logika menampilkan gambar sesuai platform (Web vs Mobile)
                backgroundImage: kIsWeb && _webImage != null
                    ? MemoryImage(_webImage!)
                    : (_imagePath != null && !kIsWeb
                    ? FileImage(File(_imagePath!))
                    : null),
                child: (_imagePath == null && (!kIsWeb || _webImage == null))
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
              TextButton.icon(
                onPressed: _pilihGambar,
                icon: const Icon(Icons.image),
                label: const Text('Ganti Foto dari Galeri'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tentangController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Bio / Tentang',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _pendidikanController,
                decoration: const InputDecoration(
                  labelText: 'Pendidikan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanPerubahan,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}