import 'dart:io';
import 'package:flutter/material.dart';
import 'tugas_pertemuan.dart';
import 'quiz_pertemuan3.dart';
import 'upload_pengalaman_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> _profileData = {
    'nama': 'Dea Wardini',
    'tentang': 'Belajar Flutter!',
    'pendidikan': 'Informatika - Universitas Pasundan',
    'lokasi': 'Kota Bandung',
    'img': '',
  };

  Map<String, String> _pengalamanData = {
    'judul': 'Project Web Laravel - Acarra',
    'deskripsi': 'Mengelola backend dan database sistem manajemen event.',
    'img': '',
  };

  @override
  Widget build(BuildContext context) {
    bool hasProfileImg = _profileData['img']!.isNotEmpty;
    bool hasPengalamanImg = _pengalamanData['img']!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_profileData['nama']!),
              accountEmail: const Text('deawardini81@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: hasProfileImg ? FileImage(File(_profileData['img']!)) : null,
                child: !hasProfileImg ? const Icon(Icons.person, color: Colors.blue) : null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.work_history),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadPengalamanPage()),
                );
                if (result != null) {
                  setState(() {
                    _pengalamanData = Map<String, String>.from(result);
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              backgroundImage: hasProfileImg ? FileImage(File(_profileData['img']!)) : null,
              child: !hasProfileImg ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
            ),
            const SizedBox(height: 10),
            Text(_profileData['nama']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('233040003'),
            const Divider(height: 30),
            WidgetGallery(icon: Icons.info, judul: 'Tentang', deskripsi: _profileData['tentang']!),
            WidgetGallery(icon: Icons.school, judul: 'Pendidikan', deskripsi: _profileData['pendidikan']!),
            WidgetGallery(icon: Icons.location_on, judul: 'Lokasi', deskripsi: _profileData['lokasi']!),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Pengalaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  hasPengalamanImg
                      ? Image.file(
                    File(_pengalamanData['img']!),
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/pengalaman.png',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network('https://picsum.photos/400/200', fit: BoxFit.cover),
                  ),
                  ListTile(
                    title: Text(_pengalamanData['judul']!),
                    subtitle: Text(_pengalamanData['deskripsi']!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPertemuan3(currentData: _profileData),
            ),
          );
          if (result != null) {
            setState(() {
              _profileData = Map<String, String>.from(result);
            });
          }
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}