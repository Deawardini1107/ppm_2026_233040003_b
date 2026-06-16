import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPengalamanPage extends StatefulWidget {
  const UploadPengalamanPage({super.key});

  @override
  State<UploadPengalamanPage> createState() => _UploadPengalamanPageState();
}

class _UploadPengalamanPageState extends State<UploadPengalamanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pilihGambarPengalaman() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _simpanPengalaman() {
    if (_judulController.text.isNotEmpty) {
      Navigator.pop(context, {
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'img': _imagePath ?? '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Pengalaman'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pilihGambarPengalaman,
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                  image: _imagePath != null
                      ? DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover)
                      : null,
                ),
                child: _imagePath == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    SizedBox(height: 5),
                    Text('Ketuk untuk pilih gambar', style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Pengalaman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simpanPengalaman,
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