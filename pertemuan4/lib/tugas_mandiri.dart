import 'package:flutter/material.dart';

void main() {
  runApp(const TugasMandiriApp());
}

class CatatanTugas {
  String judul;
  String isi;
  String kategori;
  String email;
  final DateTime dibuatPada;

  CatatanTugas({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

class TugasMandiriApp extends StatelessWidget {
  const TugasMandiriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Mandiri P3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomeTugasPage());
          case '/form':
            final mapArgs = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(builder: (_) => FormTugasPage(arguments: mapArgs));
          case '/detail':
            final mapArgs = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DetailTugasPage(
                catatan: mapArgs['catatan'],
                index: mapArgs['index'],
              ),
            );
        }
        return null;
      },
    );
  }
}

class HomeTugasPage extends StatefulWidget {
  const HomeTugasPage({super.key});

  @override
  State<HomeTugasPage> createState() => _HomeTugasPageState();
}

class _HomeTugasPageState extends State<HomeTugasPage> {
  final List<CatatanTugas> _catatan = [
    CatatanTugas(
      judul: 'Tugas Mandiri Pertemuan 3',
      isi: 'Mendukung edit data, filter kategori, dan validasi email pengirim.',
      kategori: 'Tugas',
      email: 'dea@unpas.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  String _filterKategori = 'Semua';
  final _filterOpsi = const ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/form');

    if (hasil is CatatanTugas) {
      setState(() {
        _catatan.add(hasil);
      });
    }
  }

  Future<void> _bukaDetailCatatan(CatatanTugas catatan, int index) async {
    final hasilEdit = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: {'catatan': catatan, 'index': index},
    );

    if (hasilEdit is Map<String, dynamic>) {
      setState(() {
        final idx = hasilEdit['index'] as int;
        _catatan[idx] = hasilEdit['catatan'] as CatatanTugas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listFiltered = _filterKategori == 'Semua'
        ? _catatan
        : _catatan.where((c) => c.kategori == _filterKategori).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Mandiri P3'),
        backgroundColor: Colors.purple.shade100,
        actions: [
          DropdownButton<String>(
            value: _filterKategori,
            underline: const SizedBox(),
            icon: const Icon(Icons.filter_alt),
            items: _filterOpsi
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) => setState(() => _filterKategori = v!),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: listFiltered.isEmpty
          ? const Center(child: Text('Catatan tidak ditemukan.'))
          : ListView.builder(
        itemCount: listFiltered.length,
        itemBuilder: (context, i) {
          final c = listFiltered[i];
          final indeksAsli = _catatan.indexOf(c);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(c.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${c.kategori} • ${c.dibuatPada.day}/${c.dibuatPada.month}/${c.dibuatPada.year}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => setState(() => _catatan.removeAt(indeksAsli)),
              ),
              onTap: () => _bukaDetailCatatan(c, indeksAsli),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        backgroundColor: Colors.purple.shade200,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormTugasPage extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const FormTugasPage({super.key, this.arguments});

  @override
  State<FormTugasPage> createState() => _FormTugasPageState();
}

class _FormTugasPageState extends State<FormTugasPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  bool _isEditMode = false;
  int? _editIndex;
  DateTime? _existingDate;

  @override
  void initState() {
    super.initState();
    final args = widget.arguments;
    if (args != null && args.containsKey('catatan')) {
      _isEditMode = true;
      final oldData = args['catatan'] as CatatanTugas;
      _editIndex = args['index'] as int;

      _judulCtrl.text = oldData.judul;
      _isiCtrl.text = oldData.isi;
      _emailCtrl.text = oldData.email;
      _kategori = oldData.kategori;
      _existingDate = oldData.dibuatPada;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanData = CatatanTugas(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: _isEditMode ? _existingDate! : DateTime.now(),
    );

    Navigator.pop(context, _isEditMode ? {'catatan': catatanData, 'index': _editIndex} : catatanData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Catatan' : 'Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Pengirim', border: OutlineInputBorder()),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                final emailRegex = RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v.trim())) return 'Format email salah';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              items: _kategoriOpsi.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Isi', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _simpan,
              child: Text(_isEditMode ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTugasPage extends StatelessWidget {
  final CatatanTugas catatan;
  final int index;

  const DetailTugasPage({super.key, required this.catatan, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final hasilEdit = await Navigator.pushNamed(
                context,
                '/form',
                arguments: {'catatan': catatan, 'index': index},
              );

              if (hasilEdit != null && context.mounted) {
                Navigator.pop(context, hasilEdit);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(catatan.judul, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Pengirim: ${catatan.email}', style: const TextStyle(color: Colors.purple, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Chip(label: Text(catatan.kategori)),
            const Divider(height: 32),
            Text(catatan.isi, style: const TextStyle(fontSize: 16, height: 1.4)),
          ],
        ),
      ),
    );
  }
}