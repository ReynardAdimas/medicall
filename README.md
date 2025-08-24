# MediCal

MediCall adalah aplikasi mobile berbasis digital yang awalnya dirancang untuk memfasilitasi sebuah klinik kesehatan untuk membantu mengelola proses bisnis mulai dari pendaftaran pasien, arsip riwayat pasien, hingga pasien telah selesai diperiksa. Aplikasi ini juga menyediakan pengelolaan bagi inventaris obat yang tersedia di klinik. 


![Slide 16_9 - 1](https://github.com/user-attachments/assets/7aa3e9e4-40aa-47d4-963e-b84fda5b44ff)

# Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Struktur Proyek](#struktur-proyek)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Persyaratan Sistem](#persyaratan-sistem)
  - [Untuk Pengembangan](#untuk-pengembangan)
  - [Untuk Pengguna](#untuk-pengguna)
- [Database](#database)
- [Instalasi dan Menjalankan Proyek](#instalasi-dan-menjalankan-proyek)
- [Kontribusi](#kontribusi)
- [Lisensi](#lisensi)
- [Tim Pengembang](#tim-pengembang)

## Fitur Utama

MediCall menawarkan serangkaian fitur yang bertujuan untuk meningkatkan kenyamanan dan aksesibilitas layanan kesehatan:

* **Autentikasi dan Registrasi Pengguna**: Memungkinkan pengguna untuk mendaftar, masuk, dan mengelola sesi mereka. Dilengkapi dengan alur registrasi bertahap untuk melengkapi data diri pasien.
* **Dasbor Pengguna dan Admin**: Tampilan dasbor yang berbeda untuk pengguna umum dan admin, menyediakan akses cepat ke fitur-fitur relevan.
* **Manajemen Profil Pasien**: Pengguna dapat melihat dan mengedit data profil mereka termasuk nama, umur, gender, pekerjaan, alamat, dan nomor telepon. Juga mendukung perhitungan BMI.
* **Pendaftaran Kunjungan Online**: Pasien dapat mendaftar untuk kunjungan dengan memilih tanggal dan mengisi keluhan, mengurangi antrean di klinik.
* **Manajemen Kunjungan (Admin)**: Admin dapat melihat daftar pasien yang belum diperiksa dan jadwal kunjungan, serta memperbarui status kunjungan.
* **Diagnosis dan Pemberian Obat (Admin)**: Admin dapat memasukkan diagnosis untuk pasien dan mencatat obat yang diberikan dari inventaris.
* **Inventaris Obat**: Admin dapat menambah dan memperbarui stok obat dalam inventaris klinik.
* **Riwayat Kunjungan dan Diagnosis**: Pasien dapat melihat riwayat jadwal kunjungan dan diagnosis yang diberikan oleh bidan.
* **Kalkulator Kehamilan dan Imunisasi**: Fitur untuk menghitung masa subur dan hari perkiraan lahir (HPL), serta informasi mengenai jadwal imunisasi anak.
* **Layanan Darurat**: Integrasi dengan WhatsApp untuk layanan darurat.
* **Tentang Aplikasi**: Halaman informasi mengenai MediCall.

## Struktur Proyek

Struktur direktori utama proyek ini diatur sebagai berikut: 
```
medicall/
├── android/            # Konfigurasi Android Native
├── ios/                # Konfigurasi iOS Native
├── lib/                # Kode sumber utama aplikasi Flutter
│   ├── auth/           # Layanan dan gerbang autentikasi
│   ├── daftarPasien/   # Halaman dan logika untuk daftar pasien (admin)
│   │   └── pages/
│   ├── jadwalKunjungan/# Halaman dan logika untuk jadwal kunjungan (admin)
│   │   └── pages/
│   ├── models/         # Definisi model data (KunjunganDetailPasien, Obat, RekamMedis)
│   ├── obat/           # Logika dan halaman untuk manajemen obat
│   │   └── pages/
│   ├── pages/          # Halaman utama aplikasi (dashboard, profil, pengaturan, dll.)
│   ├── pendaftaranPasien/# Logika dan halaman untuk pendaftaran kunjungan
│   │   └── pages/
│   └── riwayatKunjungan/# Halaman dan logika untuk riwayat kunjungan pasien (admin)
│       └── pages/
├── linux/              # Konfigurasi Linux Desktop
├── macos/              # Konfigurasi macOS Desktop
├── test/               # File untuk pengujian
├── web/                # Konfigurasi Web
├── windows/            # Konfigurasi Windows Desktop
└── pubspec.yaml        # File konfigurasi dependensi dan metadata proyek Flutter 
```
## Teknologi yang Digunakan

* **Framework**: Flutter (Dart)
* **Database**: Supabase
* **IDE**: Android Studio
* **Version Control**: Git

## Persyaratan Sistem

### Untuk Pengembangan

* **Hardware**:
    * Laptop dengan prosesor min. Intel i7 / AMD Ryzen 7
    * RAM 8GB (disarankan 16GB)
    * SSD 256GB
* **Software**:
    * Android Studio
    * Flutter SDK
    * Git

### Untuk Pengguna

* **Smartphone Android/iOS**:
    * Minimal Android 7.0 
    * RAM 2GB+
    * Penyimpanan kosong minimal 8GB
    * Layar minimal 5.5 inci

## Database

Aplikasi ini menggunakan Supabase sebagai backend database. Berikut adalah entitas dan atribut utama yang digunakan:

**Entitas dan Atribut Utama:**

* **pasien**: `nama`, `gender`, `umur`, `pekerjaan`, `alamat`, `nomerhp` (UNIQUE), `user_id` (PK, UUID dari Supabase Auth)
* **kunjungan**: `id` (PK), `tanggal_kunjungan`, `keluhan`, `id_pasien` (FK ke `pasien.user_id`), `status_diterima` (boolean), `status_kunjungan` (string, e.g., 'waiting', 'done', 'rejected')
* **rekam_medis**: `id` (PK), `kunjungan_id` (FK ke `kunjungan.id`), `nama_pasien`, `keluhan`, `diagnosa`, `tanggal_kunjungan`, `status_kunjungan` (boolean, indicates if patient is examined)
* **obat**: `id` (PK), `nama`, `stok`
* **rekam_medis_obat**: `rekam_medis_id` (FK), `obat_id` (FK), `jumlah_digunakan`

**Relasi Antar Entitas:**

* `pasien` 1 : N `kunjungan`
* `kunjungan` 1 : 1 `rekam_medis` (setelah kunjungan diperiksa)
* `rekam_medis` 1 : N `rekam_medis_obat`
* `obat` 1 : N `rekam_medis_obat`

## Instalasi dan Menjalankan Proyek

Untuk menjalankan proyek ini di lingkungan pengembangan Anda:

1.  **Clone repositori:**
    ```bash
    git clone [https://github.com/reynardadimas/medicall.git](https://github.com/reynardadimas/medicall.git)
    cd medicall
    ```
2.  **Dapatkan dependensi Flutter:**
    ```bash
    flutter pub get
    ```
3.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

Pastikan Anda telah menginstal Flutter SDK dan mengonfigurasi lingkungan pengembangan Anda (Android Studio/VS Code) dengan benar. Anda juga perlu mengkonfigurasi Supabase URL dan Anon Key di `lib/main.dart` sesuai dengan proyek Supabase Anda.

## Kontribusi

Kami menyambut kontribusi dari komunitas. Jika Anda ingin berkontribusi, silakan ikuti langkah-langkah berikut:

1.  Fork repositori ini.
2.  Buat branch baru untuk fitur Anda (`git checkout -b feature/nama-fitur-baru`).
3.  Lakukan perubahan Anda dan commit (`git commit -m 'feat: tambahkan fitur X'`).
4.  Push ke branch Anda (`git push origin feature/nama-fitur-baru`).
5.  Buat Pull Request.

## Lisensi

Lisensi untuk proyek ini tidak secara eksplisit didefinisikan dalam file yang disediakan.

## Tim Pengembang

Proyek ini dikembangkan oleh:

* Andhika Kusuma Wardhana (123230041)
* Reynard Adimas Nabil (123230079)
