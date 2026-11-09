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

#### (19.38 09/11/2026)

Audit akhir membandingkan implementasi dengan setiap ketentuan Tugas 7. Pemeriksaan kode memastikan seluruh identitas dan aksi berasal dari data proyek sendiri, tiap aksi membawa warna unik, dan pesan `SnackBar` dibentuk secara dinamis dari nama tombol. Inventaris widget juga ditinjau langsung dari `main.dart` dan `menu.dart` agar jawaban reflektif tidak menyebut komponen yang tidak digunakan.

Validasi akhir dilakukan melalui `flutter analyze`, `flutter test`, pemeriksaan visual pada Chrome, dan `git diff --check`. Seluruh widget test lulus dan analyzer tidak menemukan masalah. Peringatan konversi LF ke CRLF pada Windows bukan error kode maupun whitespace.

### Status Implementasi

- [x] Menampilkan NPM, nama, dan kelas pemilik aplikasi.
- [x] Menampilkan sekurang-kurangnya tiga kartu aksi.
- [x] Memberikan warna berbeda untuk setiap kartu aksi.
- [x] Menampilkan pesan `SnackBar` sesuai nama tombol.
- [x] Memisahkan halaman menu dari titik masuk aplikasi.
- [x] Menambahkan widget test untuk perilaku utama.
- [x] Memastikan `flutter analyze` tidak menemukan masalah.
- [x] Melengkapi jawaban reflektif setelah implementasi final diaudit.
- [x] Melengkapi log prompting dan evaluasi penggunaan AI pada finalisasi tugas.

## Transparansi Penggunaan AI

AI digunakan sebagai pendamping belajar, bukan sebagai pengganti verifikasi. Bantuan AI mencakup penjelasan konsep Flutter, diagnosis lingkungan pengembangan, penyusunan struktur awal widget, saran pengujian, peninjauan keluaran terminal, dan penyusunan dokumentasi. Pemilik proyek tetap menentukan identitas, konteks tombol, warna, struktur commit, serta keputusan akhir atas setiap perubahan.

### Strategi prompting

Prompt diberikan secara bertahap dengan menyertakan tujuan chapter, kondisi proyek terbaru, keluaran terminal atau tangkapan layar, batasan tugas, dan hasil yang diharapkan. Setiap saran AI kemudian diperiksa melalui kode, analyzer, test, Git, dan browser sebelum diterima. Pola ini lebih efektif daripada meminta seluruh tugas diselesaikan dalam satu prompt karena kesalahan dapat ditemukan pada chapter yang kecil dan mudah ditelusuri.

### Log prompting

| Tahap | Ringkasan prompt atau konteks | Bantuan AI | Verifikasi dan keputusan manual |
| --- | --- | --- | --- |
| Pemahaman tugas | Membaca Tutorial 8 dan Tugas 7, lalu menjelaskan konsep dan urutan pengerjaan secara bertahap. | Merangkum kebutuhan setup, struktur widget, kartu aksi, `SnackBar`, Git, README, dan refleksi. | Ketentuan dicocokkan kembali dengan dokumen tugas dan pengerjaan dipisah per chapter. |
| Setup Flutter | Menganalisis `flutter doctor -v` serta pesan Android Studio dan Android SDK. | Menjelaskan komponen Android yang diperlukan dan bahwa Visual Studio tidak wajib untuk target Chrome atau Android. | Android toolchain akhirnya berstatus siap dan aplikasi contoh berhasil dijalankan di Chrome. |
| Implementasi tutorial | Membuat halaman menu mengikuti tutorial dengan pemisahan `main.dart` dan `menu.dart`. | Membantu menyusun `MyApp`, `MyHomePage`, `InfoCard`, `ItemHomepage`, `ItemCard`, dan widget test. | Kode diperiksa, dijalankan di Chrome, dianalisis, dan dites sebelum commit. |
| Koreksi tampilan | Meninjau tangkapan layar yang menunjukkan garis overflow kuning-hitam. | Mengidentifikasi keterbatasan rasio grid dan menyarankan layout responsif serta area gulir. | Perbaikan diterapkan dan tangkapan layar berikutnya tidak lagi menunjukkan overflow. |
| Personalisasi Tugas 7 | Mengganti data tutorial dengan NPM, nama, kelas, serta tiga aksi portofolio yang berbeda warna. | Membantu memodelkan warna sebagai properti item dan memperbarui test. | Identitas, warna, teks, dan pesan tombol diperiksa langsung pada browser dan test. |
| Finalisasi | Mengaudit implementasi dan menyusun dokumentasi, disclosure, log prompting, serta jawaban reflektif. | Membantu membuat inventaris widget dan menjelaskan konsep berdasarkan kode final. | Setiap jawaban disesuaikan dengan `main.dart` dan `menu.dart`, bukan sekadar jawaban generik. |

### Evaluasi kritis dan koreksi manual

- Implementasi grid pertama mengikuti bentuk tutorial terlalu literal dan menimbulkan overflow pada layar Chrome yang lebar. Masalah baru terlihat melalui pengujian visual, lalu diperbaiki dengan `SingleChildScrollView` dan `childAspectRatio` responsif.
- Eksekusi `flutter test` dari lingkungan AI sempat gagal karena pembatasan akses direktori sementara. AI tidak menganggap test lulus tanpa bukti; pengujian dijalankan ulang melalui terminal lokal dan seluruh test dinyatakan lulus.
- Data `Burhan`, NPM, kelas, label tombol, dan warna dari contoh awal dikoreksi manual agar sesuai identitas Sultan Noor Dafiq dan tema Experience pada portofolio.
- Saran AI selalu ditinjau karena AI dapat menghasilkan asumsi yang benar secara umum tetapi tidak sesuai rubrik, lingkungan Windows, atau kode aktual proyek.

Keterbatasan saat ini adalah kartu aksi baru menampilkan `SnackBar` dan belum berpindah ke halaman lain. Hal ini disengaja karena navigasi dan integrasi data belum menjadi ruang lingkup Tugas 7.

## Pertanyaan Reflektif Tugas 7

### 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan parent-child antar-widget direpresentasikan.

Widget tree adalah susunan hierarkis seluruh widget yang membentuk antarmuka Flutter. Setiap widget dapat menghasilkan satu atau beberapa widget anak melalui metode `build()`. Hubungan tersebut ditulis melalui properti seperti `home`, `body`, `child`, dan `children`.

Pada proyek ini, `MyApp` menghasilkan `MaterialApp`, kemudian properti `home` menunjuk ke `MyHomePage`. `MyHomePage` membangun `Scaffold`; `Scaffold` memiliki `AppBar` dan `SingleChildScrollView`; di dalamnya terdapat `Padding`, `Column`, `Row`, kartu informasi, dan grid kartu aksi. Perubahan pada widget induk dapat memengaruhi konfigurasi serta proses pembangunan ulang subtree anaknya.

### 2. Sebutkan seluruh widget yang digunakan dalam proyek ini dan jelaskan fungsinya masing-masing.

Widget yang digunakan secara langsung dalam `main.dart` dan `menu.dart` adalah:

- `MyApp`: root widget buatan sendiri yang mengatur aplikasi.
- `MaterialApp`: menyediakan konfigurasi aplikasi Material, tema, judul, navigator, dan halaman awal.
- `MyHomePage`: halaman menu utama buatan sendiri.
- `Scaffold`: kerangka dasar halaman Material.
- `AppBar`: bilah judul di bagian atas halaman.
- `SingleChildScrollView`: memungkinkan isi halaman digulir ketika ruang vertikal tidak cukup.
- `Padding`: memberi jarak di sekeliling widget anak.
- `Column`: menyusun widget secara vertikal.
- `Row`: menyusun widget secara horizontal.
- `Center`: memosisikan widget anak di tengah.
- `SizedBox`: memberi jarak berukuran tetap.
- `Text`: menampilkan judul, identitas, sapaan, dan label tombol.
- `GridView.count`: menyusun kartu aksi dalam grid tiga kolom.
- `InfoCard`: widget buatan sendiri untuk kartu NPM, nama, dan kelas.
- `Card`: memberi tampilan kartu Material pada informasi pengguna.
- `Container`: mengatur ukuran, padding, dan ruang isi.
- `ItemCard`: widget buatan sendiri untuk merepresentasikan satu aksi.
- `Material`: menyediakan permukaan, warna, radius, dan dukungan efek Material.
- `InkWell`: menangani ketukan sekaligus memberikan efek ripple.
- `Icon`: menampilkan ikon tiap aksi.
- `SnackBar`: menampilkan notifikasi sementara setelah kartu ditekan.

`ThemeData`, `ColorScheme`, `TextStyle`, `EdgeInsets`, `BorderRadius`, dan `ItemHomepage` juga digunakan, tetapi semuanya merupakan objek konfigurasi atau model data, bukan widget. `ScaffoldMessenger` adalah mekanisme untuk mengakses state dan menampilkan `SnackBar`, bukan widget yang dibuat langsung dalam tree proyek ini.

### 3. Apa fungsi `MaterialApp` pada aplikasi Flutter dan mengapa widget tersebut ditempatkan di bagian atas widget tree?

`MaterialApp` menjadi pembungkus utama aplikasi berbasis Material Design. Pada proyek ini, widget tersebut mengatur `title`, `ThemeData`, skema warna, Material 3, dan `home`. Selain itu, `MaterialApp` menyiapkan layanan tingkat aplikasi seperti navigasi, tema, lokalisasi dasar, dan arah teks untuk widget turunannya.

Widget ini ditempatkan dekat root agar konfigurasi tersebut dapat diwariskan ke seluruh subtree. Contohnya, `Theme.of(context)` di dalam `MyHomePage` dapat menemukan tema yang disediakan oleh `MaterialApp`. Jika ditempatkan terlalu rendah, widget di atasnya tidak dapat mengakses konfigurasi Material tersebut.

### 4. Jelaskan perbedaan `StatelessWidget` dan `StatefulWidget`. Kapan masing-masing widget sebaiknya digunakan?

`StatelessWidget` digunakan ketika tampilan hanya bergantung pada data konfigurasi yang diterima dan widget tidak menyimpan state internal yang berubah selama masa hidupnya. Jika datanya berubah, induk harus membangun widget itu kembali dengan konfigurasi baru. `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard` pada proyek ini merupakan `StatelessWidget` karena seluruh data ditentukan sejak objek dibuat dan ketukan hanya memunculkan `SnackBar` tanpa mengubah isi kartu.

`StatefulWidget` digunakan ketika widget perlu menyimpan data yang berubah dan perubahan tersebut harus memperbarui tampilan melalui `setState()` atau mekanisme pengelolaan state lain. Contohnya adalah penghitung, checkbox, status loading, input form yang dinamis, atau daftar yang berubah setelah mengambil data. Tugas ini belum memerlukannya karena tidak ada state layar yang berubah secara permanen.

### 5. Apa yang dimaksud dengan `BuildContext` dan mengapa nilainya penting ketika membangun maupun berinteraksi dengan widget tree?

`BuildContext` adalah referensi ke lokasi suatu widget di dalam widget tree. Context memungkinkan Flutter mencari ancestor terdekat dan data yang diwariskan dari atas tree. Karena merepresentasikan posisi, context dari dua widget berbeda dapat menemukan ancestor yang berbeda pula.

Dalam proyek ini, `Theme.of(context)` memakai context untuk mencari tema dari `MaterialApp`, `MediaQuery.sizeOf(context)` memperoleh ukuran layar, dan `ScaffoldMessenger.of(context)` menemukan messenger yang menampilkan `SnackBar`. Oleh karena itu, context harus berasal dari lokasi yang berada di bawah provider atau ancestor yang ingin diakses. Context yang berada di atas `MaterialApp` atau `ScaffoldMessenger` tidak akan menemukan layanan turunannya.

### 6. Jelaskan perbedaan hot reload dan hot restart pada Flutter, termasuk pengaruh keduanya terhadap state aplikasi.

Hot reload memasukkan perubahan kode Dart ke aplikasi yang sedang berjalan lalu membangun ulang widget tree sambil mempertahankan state yang sudah ada. Fitur ini cepat dan cocok untuk perubahan tampilan, teks, warna, atau isi metode `build()`. Namun, perubahan pada inisialisasi tertentu, fungsi `main()`, atau struktur yang memerlukan pembuatan state baru mungkin tidak sepenuhnya diterapkan.

Hot restart memulai ulang aplikasi Dart dari fungsi `main()` dan membuang seluruh state runtime, tetapi tidak melakukan build native penuh seperti menghentikan lalu membangun aplikasi dari awal. Hot restart digunakan ketika perubahan harus menjalankan kembali proses inisialisasi atau ketika state lama membuat hasil pengujian tidak representatif. Pada terminal `flutter run`, proyek ini menggunakan `r` untuk hot reload dan `R` untuk hot restart.
