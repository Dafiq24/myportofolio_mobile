# MyPortfolio Mobile

MyPortfolio Mobile adalah aplikasi Flutter milik **Sultan Noor Dafiq** (`2506600713`, PBP E). Proyek ini menjadi antarmuka mobile untuk pengembangan lanjutan portofolio yang sebelumnya dibuat menggunakan Django.

- Repositori Flutter: [Dafiq24/myportofolio_mobile](https://github.com/Dafiq24/myportofolio_mobile)
- Repositori Django: [Dafiq24/myportfolio](https://github.com/Dafiq24/myportfolio)

## Daftar Isi

- [Menjalankan Proyek](#menjalankan-proyek)
- [Struktur Awal Proyek](#struktur-awal-proyek)
- [Tutorial 8](#tutorial-8)
- [Tugas Individu 7](#tugas-individu-7)
- [Transparansi Penggunaan AI](#transparansi-penggunaan-ai)
- [Pertanyaan Reflektif Tugas 7](#pertanyaan-reflektif-tugas-7)

## Menjalankan Proyek

### Prasyarat

- Flutter SDK dan Dart SDK
- Android Studio beserta Android SDK untuk pengembangan Android
- Chrome untuk menjalankan target web
- Git

Status lingkungan pengembangan saat proyek dibuat:

- Flutter 3.47.9 (stable)
- Dart 3.13.7
- Android SDK 36.0.0
- Chrome tersedia sebagai perangkat Flutter

Visual Studio belum dipasang karena proyek ini tidak menargetkan aplikasi desktop Windows. Kondisi tersebut tidak menghambat pengembangan melalui Chrome maupun Android.

### Instalasi dan eksekusi

```powershell
git clone https://github.com/Dafiq24/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter doctor -v
flutter devices
flutter run -d chrome
```

Pada sesi `flutter run`, tekan `r` untuk hot reload, `R` untuk hot restart, dan `q` untuk menghentikan aplikasi.

### Validasi

```powershell
flutter analyze
flutter test
git diff --check
```

Hasil terakhir sebelum dokumentasi ini dibuat:

- `flutter analyze`: tidak menemukan masalah.
- `flutter test`: seluruh widget test lulus.
- `git diff --check`: tidak menemukan whitespace error; peringatan LF ke CRLF hanya berkaitan dengan normalisasi line ending Git di Windows.

## Struktur Awal Proyek

```text
lib/
├── main.dart       # titik masuk aplikasi, tema, dan MaterialApp
└── menu.dart       # halaman utama serta komponen kartu informasi dan aksi
test/
└── widget_test.dart
```

`main.dart` bertanggung jawab atas konfigurasi aplikasi, sedangkan `menu.dart` menyimpan tampilan menu agar kode lebih terpisah dan mudah dikembangkan pada tugas berikutnya.

## Tutorial 8

### Dokumentasi Tutorial 8

#### (19.05 - 19.24 09/11/2026)

Lingkungan Flutter diperiksa melalui `flutter doctor -v`. Android Studio, command-line tools, Android SDK, emulator, platform tools, dan lisensi Android disiapkan hingga Android toolchain dinyatakan siap. Chrome juga diverifikasi sebagai perangkat yang dapat dipakai untuk menjalankan aplikasi.

Proyek Flutter `myportofolio_mobile` kemudian dibuat sebagai repositori terpisah dari proyek Django. Struktur contoh bawaan diuji lebih dahulu, lalu halaman utama dipisahkan ke `menu.dart`. `MyHomePage`, `InfoCard`, dan `ItemCard` dibuat sebagai `StatelessWidget` yang dapat digunakan kembali. Setiap kartu aksi menampilkan `SnackBar` dengan pola pesan `Kamu telah menekan tombol [Nama Tombol]!`.

Saat pengujian browser, grid awal sempat mengalami overflow pada layar Chrome yang lebar. Tata letak kemudian diperbaiki menggunakan rasio kartu responsif dan area yang dapat digulir. Koreksi manual ini memastikan tampilan tetap stabil tanpa mengubah perilaku tombol.

Implementasi tutorial divalidasi dengan `flutter analyze`, `flutter test`, dan pemeriksaan diff sebelum dipublikasikan pada commit [`37c7738`](https://github.com/Dafiq24/myportofolio_mobile/commit/37c7738bfd26a1487ddeeb33545598c738927fe9).

### Catatan Tutorial 8

- `MaterialApp` menyediakan konfigurasi tingkat aplikasi, tema, dan halaman awal.
- `Scaffold` menyediakan struktur visual halaman Material seperti `AppBar` dan isi halaman.
- Komponen kartu dipisahkan agar data dan presentasi tidak ditulis berulang kali.
- `SnackBar` ditampilkan melalui `ScaffoldMessenger` menggunakan konteks widget saat tombol ditekan.
- Hot reload mempertahankan state yang sedang berjalan, sedangkan hot restart memulai ulang state aplikasi.

## Tugas Individu 7

### Dokumentasi Tugas 7

#### (19.24 - 19.32 09/11/2026)

Halaman utama dipersonalisasi dengan identitas berikut:

- Nama: Sultan Noor Dafiq
- NPM: 2506600713
- Kelas: PBP E

Tiga kartu aksi dibuat sesuai konteks portofolio: **Lihat Experience**, **Tambah Experience**, dan **Logout**. Warna unik disimpan langsung sebagai bagian dari data setiap item—biru, hijau, dan merah—sehingga `ItemCard` tidak memerlukan percabangan berdasarkan nama tombol.

Widget test diperbarui untuk memeriksa identitas, jumlah kartu, warna tiap aksi, ketiadaan data tutorial lama, dan pesan `SnackBar`. Pengujian browser juga memastikan tata letak tidak lagi overflow. Perubahan dipublikasikan melalui commit [`028cee4`](https://github.com/Dafiq24/myportofolio_mobile/commit/028cee4d11caa8c14bd6929163443a6babaae9c8).

### Status Implementasi

- [x] Menampilkan NPM, nama, dan kelas pemilik aplikasi.
- [x] Menampilkan sekurang-kurangnya tiga kartu aksi.
- [x] Memberikan warna berbeda untuk setiap kartu aksi.
- [x] Menampilkan pesan `SnackBar` sesuai nama tombol.
- [x] Memisahkan halaman menu dari titik masuk aplikasi.
- [x] Menambahkan widget test untuk perilaku utama.
- [x] Memastikan `flutter analyze` tidak menemukan masalah.
- [ ] Melengkapi jawaban reflektif setelah implementasi final diaudit.
- [ ] Melengkapi log prompting dan evaluasi penggunaan AI pada finalisasi tugas.

## Transparansi Penggunaan AI

AI digunakan sebagai pendamping belajar untuk menjelaskan konsep Flutter secara bertahap, membantu menyusun implementasi awal, mengusulkan pengujian, dan meninjau hasil terminal serta tangkapan layar. Keputusan akhir tetap diverifikasi melalui dokumentasi tugas, pemeriksaan kode, pengujian otomatis, dan pengujian browser oleh pengembang.

Catatan koreksi penting yang sudah ditemukan:

- Tampilan grid pertama mengikuti bentuk tutorial terlalu literal dan menimbulkan overflow di layar lebar. Masalah diketahui dari pengujian visual, lalu tata letaknya diperbaiki secara responsif.
- Eksekusi `flutter test` dari lingkungan AI pernah terhambat pembatasan akses direktori sementara. Hasil tidak diasumsikan berhasil; pengujian dijalankan ulang dari terminal lokal dan seluruh test terbukti lulus.
- Data contoh tutorial diganti secara manual dengan identitas dan konteks Experience milik pemilik proyek.

Log prompting lengkap, bagian yang dibantu AI, hasil evaluasi, keterbatasan, dan perbaikan manual akan dirapikan pada chapter final agar merepresentasikan seluruh proses pengerjaan Tugas 7.

## Pertanyaan Reflektif Tugas 7

Pertanyaan berikut sengaja dicantumkan sejak awal. Jawabannya akan ditulis setelah seluruh implementasi dan audit akhir selesai.

1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan parent-child antar-widget direpresentasikan.
2. Sebutkan seluruh widget yang digunakan dalam proyek ini dan jelaskan fungsinya masing-masing.
3. Apa fungsi `MaterialApp` pada aplikasi Flutter dan mengapa widget tersebut ditempatkan di bagian atas widget tree?
4. Jelaskan perbedaan `StatelessWidget` dan `StatefulWidget`. Kapan masing-masing widget sebaiknya digunakan?
5. Apa yang dimaksud dengan `BuildContext` dan mengapa nilainya penting ketika membangun maupun berinteraksi dengan widget tree?
6. Jelaskan perbedaan hot reload dan hot restart pada Flutter, termasuk pengaruh keduanya terhadap state aplikasi.
