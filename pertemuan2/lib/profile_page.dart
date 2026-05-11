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
  String? _currentImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Dea Wardini'),
              accountEmail: const Text('deawardini81@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _currentImg != null ? NetworkImage(_currentImg!) : null,
                child: _currentImg == null ? const Icon(Icons.person, color: Colors.blue) : null,
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadPengalamanPage()));
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
              backgroundImage: _currentImg != null ? NetworkImage(_currentImg!) : null,
              child: _currentImg == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
            ),
            const SizedBox(height: 10),
            const Text('Dea Wardini', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('233040003'),
            const Divider(height: 30),
            WidgetGallery(icon: Icons.school, judul: 'Pendidikan', deskripsi: 'Informatika - Universitas pasundan'),
            WidgetGallery(icon: Icons.location_on, judul: 'Lokasi', deskripsi: 'Kota Bandung'),

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
                  Image.asset(
                    'assets/pengalaman.png',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network('https://picsum.photos/400/200', fit: BoxFit.cover),
                  ),
                  const ListTile(
                    title: Text('Project Web Laravel - Acarra'),
                    subtitle: Text('Mengelola backend dan database sistem manajemen event.'),
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
            MaterialPageRoute(builder: (context) => const QuizPertemuan3()),
          );
          if (result != null) {
            setState(() {
              _currentImg = result;
            });
          }
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}