# MyPortfolio Mobile

[![Flutter CI](https://github.com/Dafiq24/myportofolio_mobile/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/Dafiq24/myportofolio_mobile/actions/workflows/flutter-ci.yml)

MyPortfolio Mobile adalah aplikasi Flutter milik **Sultan Noor Dafiq** (`2506600713`, PBP E). Proyek ini menjadi antarmuka mobile untuk pengembangan lanjutan portofolio yang sebelumnya dibuat menggunakan Django.

- Repositori Flutter: [Dafiq24/myportofolio_mobile](https://github.com/Dafiq24/myportofolio_mobile)
- Repositori Django: [Dafiq24/myportfolio](https://github.com/Dafiq24/myportfolio)

## Daftar Isi

- [Menjalankan Proyek](#menjalankan-proyek)
- [Struktur Proyek](#struktur-proyek)
- [Tutorial 8](#tutorial-8)
- [Tugas Individu 7](#tugas-individu-7)
- [Tutorial 9](#tutorial-9)
- [Tugas Individu 8](#tugas-individu-8)
- [Tutorial 10](#tutorial-10)
- [Transparansi Penggunaan AI](#transparansi-penggunaan-ai)
- [Pertanyaan Reflektif Tugas 7](#pertanyaan-reflektif-tugas-7)
- [Pertanyaan Reflektif Tugas 8](#pertanyaan-reflektif-tugas-8)

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
dart run build_runner build
flutter doctor -v
flutter devices
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

`API_BASE_URL` dapat diarahkan ke backend lain menggunakan `--dart-define`. Nilai bawaan `http://10.0.2.2:8000` ditujukan untuk Android Emulator. File hasil generator `*.g.dart` tidak disimpan di Git, sehingga `dart run build_runner build` wajib dijalankan setelah clone atau perubahan model JSON.

Pada sesi `flutter run`, tekan `r` untuk hot reload, `R` untuk hot restart, dan `q` untuk menghentikan aplikasi.

### Validasi

```powershell
dart run build_runner build
flutter analyze
flutter test
git diff --check
```

Hasil terakhir sebelum dokumentasi ini dibuat:

- `flutter analyze`: tidak menemukan masalah.
- `flutter test`: seluruh 16 unit dan widget test lulus.
- `git diff --check`: tidak menemukan whitespace error; peringatan LF ke CRLF hanya berkaitan dengan normalisasi line ending Git di Windows.
- GitHub Actions: job kualitas dan build APK lulus; artifact release tersedia dari workflow `Flutter CI`.

## Struktur Proyek

```text
lib/
├── config.dart
├── main.dart
├── models/
│   └── project.dart
├── screens/
│   ├── experience_form.dart
│   ├── login.dart
│   ├── menu.dart
│   ├── project_detail.dart
│   ├── project_form.dart
│   └── project_list.dart
├── services/
│   └── api_client.dart
├── state/
│   └── auth_state.dart
├── utils/
│   └── auth_guard.dart
└── widgets/
    ├── left_drawer.dart
    └── project_card.dart
test/
├── api_client_test.dart
├── auth_flow_test.dart
├── experience_form_test.dart
├── project_list_test.dart
├── project_model_test.dart
└── widget_test.dart
```

`main.dart` bertanggung jawab atas konfigurasi aplikasi dan tema. Folder `screens` menyimpan setiap halaman, sedangkan folder `widgets` menyimpan drawer dan kartu aksi yang digunakan kembali. Pemisahan ini membuat navigasi dan pengujian setiap fitur lebih mudah dikembangkan.

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

## Tutorial 9

### Dokumentasi Tutorial 9

#### (17/11/2026)

Struktur aplikasi dirapikan dengan memisahkan halaman ke folder `screens` dan komponen yang digunakan kembali ke folder `widgets`. Dependensi `material_ui` ditambahkan dan impor Material diseragamkan. `LeftDrawer` dibuat sebagai drawer bersama yang menyediakan navigasi ke Home dan Add Project, sedangkan `ProjectCard` memisahkan representasi data aksi dari tampilan kartunya.

Halaman `ProjectFormPage` dibuat sebagai `StatefulWidget` karena perlu mengelola nilai input dan validasi. Form menggunakan `GlobalKey<FormState>`, beberapa `TextFormField`, pilihan kategori, tombol simpan, dan `AlertDialog` yang merangkum seluruh data setelah validasi berhasil. Halaman utama tetap responsif dan tombol Tambah Proyek membuka form menggunakan `Navigator.push()`.

Implementasi tutorial diperiksa melalui widget test, `flutter analyze`, pengujian visual pada Chrome, dan pemeriksaan diff. Fondasi drawer dipublikasikan pada commit [`c4e1718`](https://github.com/Dafiq24/myportofolio_mobile/commit/c4e17181fd733373ff787adf83bb8011ba53c2b6), sedangkan form proyek tervalidasi dipublikasikan pada commit [`069fe93`](https://github.com/Dafiq24/myportofolio_mobile/commit/069fe9334253252ef13c02961de3a3b6ba355841).

## Tugas Individu 8

### Dokumentasi Tugas 8

#### (17/11/2026)

Tugas 8 diterapkan pada bagian **Experience** agar konsisten dengan model portofolio Django. Halaman `ExperienceFormPage` memiliki delapan input: role title, organization, display period, timeline position, description, employment type, documentation image URL, dan related skills. Nilai employment type menggunakan pilihan yang sama dengan model web: internship, research, volunteer, part-time, full-time, dan freelance.

Validasi tidak hanya memeriksa tipe input. Role title dan description wajib diisi; panjang teks dibatasi sesuai kebutuhan field; timeline position harus berupa bilangan bulat antara 0 dan 32767; dan URL dokumentasi opsional, tetapi jika diisi harus memakai skema `http` atau `https`. Setelah semua nilai valid, `AlertDialog` menampilkan seluruh isi form dan tombol OK menutup dialog sekaligus mereset form.

Kartu Tambah Experience pada halaman utama membuka form dengan `Navigator.push()` sehingga tombol Back dapat mengembalikan pengguna ke Home. Drawer bersama menyediakan Home, Add Experience, dan Add Project menggunakan `Navigator.pushReplacement()` agar perpindahan menu mengganti route aktif. Aksi kartu dimodelkan menggunakan enum `HomepageAction`, sehingga logika route tidak bergantung pada teks label.

Widget test mencakup validasi kosong, angka di luar rentang, URL tidak valid, dialog data valid, reset form, navigasi dari kartu, tombol Back, navigasi drawer, dan kembali ke Home. Seluruh pengujian lulus, `flutter analyze` tidak menemukan masalah, pemeriksaan visual di Chrome dinyatakan aman, dan hash commit lokal telah diverifikasi sama dengan branch `origin/main`.

Perubahan utama dipublikasikan melalui:

- [`ec9edeb`](https://github.com/Dafiq24/myportofolio_mobile/commit/ec9edeb1d9f9cbce3485509c0d46ab9b9ad6e3a2): form Experience dan validasinya.
- [`8720b6c`](https://github.com/Dafiq24/myportofolio_mobile/commit/8720b6cba0b31268f81050c6fda89c6720ccb8b5): integrasi navigasi kartu, drawer, dan pengujian route.

### Status Implementasi Tugas 8

- [x] Membuat halaman form baru untuk data Experience.
- [x] Menggunakan lebih dari tiga elemen input dan menyesuaikannya dengan model portofolio.
- [x] Memvalidasi input wajib, panjang teks, bilangan bulat, rentang nilai, dan URL.
- [x] Menampilkan seluruh data valid melalui pop-up.
- [x] Menghubungkan kartu Tambah Experience ke halaman form.
- [x] Menggunakan drawer bersama untuk Home, Add Experience, dan Add Project.
- [x] Menambahkan pengujian form serta navigasi.
- [x] Menjalankan `flutter test`, `flutter analyze`, dan pemeriksaan visual.
- [x] Melengkapi refleksi dan transparansi penggunaan AI.

## Tutorial 10

### Dokumentasi Tutorial 10

#### (24/11/2026)

Tutorial 10 menghubungkan aplikasi Flutter dengan Django REST Framework menggunakan model `Project`. Backend mendapatkan model, migration, serializer, endpoint publik untuk membaca data, mutasi khusus superuser, autentikasi token, logout token, CORS, registrasi admin, serta regression test. Implementasi backend dipublikasikan pada commit [`ce5f553`](https://github.com/Dafiq24/myportfolio/commit/ce5f5538b12f8cc9d658391cf4415e90463923cb).

Pada Flutter, konfigurasi `API_BASE_URL` dibuat menggunakan `String.fromEnvironment` agar alamat lokal, emulator, dan production tidak ditulis permanen dalam logika aplikasi. Model `Project` menggunakan `json_serializable` dengan `FieldRename.snake`, sehingga `techStack`, `projectUrl`, dan `projectImageUrl` dipetakan ke kontrak JSON Django. ID hanya dibaca dari server dan tidak dikirim saat membuat proyek. Fondasi dependensi, model, Android networking, generator, dan test kontrak dipublikasikan pada commit [`7752d6c`](https://github.com/Dafiq24/myportofolio_mobile/commit/7752d6c8d194f85abd8785f3f892dbb39ff6ccad).

`ApiClient` menangani HTTP serta validasi status respons. Halaman daftar Project menggunakan `FutureBuilder` dan menyediakan loading indicator, pesan error beserta tombol retry, empty state, pull-to-refresh, daftar data, dan navigasi detail. Halaman detail mengambil satu Project berdasarkan UUID dan menampilkan judul, teknologi, tautan, gambar opsional, serta deskripsi. Fitur baca publik dan pengujiannya dipublikasikan pada commit [`cb9f36d`](https://github.com/Dafiq24/myportofolio_mobile/commit/cb9f36d42248f4fbd6e46a76c3f9fdf630eabd0a).

Autentikasi dikelola oleh `AuthState` melalui Provider. Pengguna yang membuka form terlindungi diarahkan ke halaman login, lalu token dikirim menggunakan header `Authorization: Token ...`. Form Project kini mengirim POST sungguhan ke Django. Respons `401` membersihkan sesi lokal, sedangkan `403` mempertahankan sesi dan menjelaskan bahwa akun tersebut bukan pemilik portofolio. Logout menghapus token di server dan state aplikasi. Integrasi autentikasi serta mutation dipublikasikan pada commit [`db4942f`](https://github.com/Dafiq24/myportofolio_mobile/commit/db4942f153ee7d57ab58afbd1b42d138ab12c6f7).

### Kontrak API Project

| Operasi | Method dan endpoint | Akses |
| --- | --- | --- |
| Login token | `POST /api/v1/auth/token/` | Publik dengan username dan password valid |
| Logout token | `POST /api/v1/auth/logout/` | Token terautentikasi |
| Daftar Project | `GET /api/v1/projects/` | Publik |
| Detail Project | `GET /api/v1/projects/<uuid>/` | Publik |
| Tambah Project | `POST /api/v1/projects/` | Superuser pemilik portofolio |
| Ubah Project | `PUT/PATCH /api/v1/projects/<uuid>/` | Superuser pemilik portofolio |
| Hapus Project | `DELETE /api/v1/projects/<uuid>/` | Superuser pemilik portofolio |

### Continuous Integration

Workflow `Flutter CI` menggunakan reusable workflow `VeryGoodOpenSource/very_good_workflows` untuk memasang dependency, membuat ulang kode JSON, memeriksa format, menjalankan analyzer, dan mengeksekusi seluruh test dari checkout bersih. Job berikutnya membangun APK release dengan backend PWS dan mengunggah `app-release.apk` sebagai artifact `myportofolio-mobile-apk`.

Workflow diperkenalkan pada commit [`176949b`](https://github.com/Dafiq24/myportofolio_mobile/commit/176949bda6e2fcb758064051d116db7951611227). Run pertama berhasil menyelesaikan kedua job dan menghasilkan artifact APK sekitar 23,98 MB. Bukti eksekusi tersedia pada [Flutter CI run #45405811452](https://github.com/Dafiq24/myportofolio_mobile/actions/runs/45405811452).

### Status Implementasi Tutorial 10

- [x] Menyediakan Project API publik dan mutasi terlindungi pada Django.
- [x] Mengaktifkan token authentication, logout token, dan CORS.
- [x] Menggunakan model JSON hasil generator dengan field yang sesuai serializer.
- [x] Menampilkan daftar serta detail Project dari API.
- [x] Menangani loading, error, retry, empty state, dan refresh.
- [x] Melindungi form menggunakan login token dan Provider.
- [x] Mengirim Project baru ke Django dan menangani `401` serta `403`.
- [x] Menambahkan unit test, MockClient test, dan widget test.
- [x] Menjalankan 16 test dan analyzer tanpa masalah.
- [x] Menjalankan CI serta menghasilkan artifact APK release.

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
| Tutorial 9 | Memeriksa dokumen tutorial terbaru dan struktur repositori sebelum menambahkan navigasi serta form. | Membantu memisahkan `screens` dan `widgets`, membuat drawer bersama, form proyek, validasi, dialog, dan test. | Form dijalankan di Chrome, seluruh nilai dialog diperiksa, dan perubahan dipisahkan menjadi commit fondasi serta commit form. |
| Form Experience | Menyesuaikan form Tugas 8 dengan field model Experience pada proyek Django. | Membantu menyusun delapan input, pilihan kategori, batas panjang, validasi rentang bilangan, dan validasi URL. | Kasus invalid dan valid diuji langsung; kegagalan test akibat tombol di luar viewport diperbaiki dengan menggulir form pada test. |
| Navigasi Tugas 8 | Menghubungkan kartu dan drawer tanpa merusak navigasi Home dan Add Project. | Menyarankan enum `HomepageAction`, `Navigator.push()` untuk kartu, `pushReplacement()` untuk drawer, dan test Back/Home. | Semua jalur diuji dari terminal dan browser, lalu hash lokal dan GitHub dibandingkan setelah push. |
| Finalisasi Tugas 8 | Mengaudit rubrik, kode final, riwayat commit, hasil test, dan pertanyaan refleksi. | Membantu menyusun dokumentasi serta jawaban yang merujuk pada implementasi nyata. | Klaim README dicocokkan dengan file final dan hasil pengujian pengguna sebelum commit dokumentasi. |
| Tutorial 10 backend | Mencocokkan kebutuhan token authentication, CORS, Project API, dan izin pemilik dengan Django yang sudah ada. | Membantu membuat model, serializer, endpoint, permission, migration, dan regression test tanpa merusak API Experience atau Certification. | System check, migration check, test API, PWS deployment, serta kesamaan hash GitHub dan PWS diverifikasi sebelum beralih ke Flutter. |
| Tutorial 10 Flutter | Mengintegrasikan model Project, API publik, detail, autentikasi token, POST, logout, dan penanganan sesi secara bertahap. | Membantu menyusun konfigurasi environment, model generated JSON, ApiClient, Provider, UI states, navigation guard, dan MockClient tests. | Setiap chapter diuji melalui analyzer, seluruh test, browser, backend lokal, commit terpisah, dan pemeriksaan hash remote. |
| Tutorial 10 CI | Menyiapkan workflow kualitas dan artifact APK ketika build Gradle lokal terganggu timeout Maven. | Membantu mengonfigurasi reusable Very Good Workflow, generator sebelum analyze/test, build release, serta upload artifact. | Run GitHub Actions diperiksa langsung hingga kedua job sukses dan artifact APK benar-benar tersedia. |

### Evaluasi kritis dan koreksi manual

- Implementasi grid pertama mengikuti bentuk tutorial terlalu literal dan menimbulkan overflow pada layar Chrome yang lebar. Masalah baru terlihat melalui pengujian visual, lalu diperbaiki dengan `SingleChildScrollView` dan `childAspectRatio` responsif.
- Eksekusi `flutter test` dari lingkungan AI sempat gagal karena pembatasan akses direktori sementara. AI tidak menganggap test lulus tanpa bukti; pengujian dijalankan ulang melalui terminal lokal dan seluruh test dinyatakan lulus.
- Data `Burhan`, NPM, kelas, label tombol, dan warna dari contoh awal dikoreksi manual agar sesuai identitas Sultan Noor Dafiq dan tema Experience pada portofolio.
- Saran AI selalu ditinjau karena AI dapat menghasilkan asumsi yang benar secara umum tetapi tidak sesuai rubrik, lingkungan Windows, atau kode aktual proyek.

Integrasi Project kini sudah membaca dan menyimpan data melalui API Django dengan autentikasi token. Keterbatasan berikutnya berada pada bagian Experience: form masih menampilkan dialog lokal dan daftar Experience belum dikonsumsi oleh Flutter. Integrasi penuh Experience menjadi ruang lingkup Tugas Individu 9.

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

## Pertanyaan Reflektif Tugas 8

### 1. Jelaskan perbedaan antara `Navigator.push()` dan `Navigator.pushReplacement()` pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi MyPortfolio?

`Navigator.push()` menambahkan route baru di atas route aktif sehingga route sebelumnya tetap berada di stack. Karena itu, tombol Back dapat menutup route baru dan menampilkan halaman sebelumnya. Pada aplikasi ini, kartu Tambah Experience dan Tambah Proyek menggunakan `push()` karena pengguna wajar kembali ke menu setelah mengisi atau membatalkan form.

`Navigator.pushReplacement()` mengganti route aktif dengan route baru. Route yang diganti tidak menjadi tujuan tombol Back. Drawer menggunakan metode ini untuk berpindah antara Home, Add Experience, dan Add Project karena menu tersebut merepresentasikan tujuan utama yang setara; mengganti route mencegah tumpukan halaman drawer yang sama terus bertambah setiap kali pengguna berpindah menu.

### 2. Bagaimana kamu memanfaatkan hierarchy widget seperti `Scaffold`, `AppBar`, dan `Drawer` untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

Setiap halaman utama menggunakan `Scaffold` sebagai kerangka dasar. `AppBar` ditempatkan melalui properti `appBar`, `LeftDrawer` melalui properti `drawer`, dan konten khusus halaman melalui `body`. Dengan hierarchy tersebut, Home, Project Form, dan Experience Form memiliki posisi judul, tombol hamburger, warna AppBar, dan perilaku navigasi yang konsisten walaupun isi `body` berbeda.

`LeftDrawer` dipisahkan menjadi satu widget yang digunakan kembali pada ketiga halaman. Perubahan daftar menu cukup dilakukan pada satu file dan otomatis berlaku pada seluruh halaman. `AppBar` mengambil warna dari `Theme.of(context).colorScheme.primary`, sehingga struktur halaman dan identitas visual tetap seragam.

### 3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti `Padding`, `SingleChildScrollView`, dan `ListView` saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

`Padding` memberi ruang antara tepi layar dan elemen input sehingga label, border, serta pesan validasi tidak berhimpitan. Pada `ExperienceFormPage`, konten form diberi padding 16 piksel dan setiap input dipisahkan dengan `SizedBox` agar mudah dipindai.

`SingleChildScrollView` membuat seluruh form dapat digulir ketika tinggi layar tidak cukup, keyboard muncul, atau pesan validasi menambah tinggi konten. Widget ini juga digunakan di dalam dialog agar rangkuman delapan field tetap dapat dibaca pada layar pendek. `ListView` cocok untuk kumpulan item vertikal yang panjang dan dapat digulir; pada aplikasi ini, `LeftDrawer` memakai `ListView` agar header dan semua opsi navigasi tetap dapat diakses jika menu bertambah atau ruang layar terbatas.

### 4. Bagaimana kamu menyesuaikan warna tema agar aplikasi MyPortfolio memiliki identitas visual yang konsisten dengan brand portofolio?

Tema global dibuat pada `MaterialApp` menggunakan `ColorScheme.fromSeed` dengan indigo sebagai `seedColor` dan amber sebagai warna sekunder. Indigo memberi kesan profesional dan menjadi warna utama AppBar serta header drawer, sementara amber dapat digunakan sebagai aksen yang kontras. Karena halaman mengambil warna dari `Theme.of(context)`, perubahan skema global dapat diterapkan tanpa mengubah setiap widget satu per satu.

Kartu aksi tetap memiliki warna semantik yang mudah dibedakan: biru untuk melihat Experience, hijau untuk menambah Experience, indigo untuk menambah proyek, dan merah untuk Logout. Teks serta ikon pada kartu menggunakan warna putih agar kontras. Kombinasi tema global dan warna aksi ini menjaga identitas MyPortfolio sekaligus membantu pengguna mengenali fungsi tombol.
