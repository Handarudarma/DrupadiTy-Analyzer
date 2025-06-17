<h1 align="center"> Drupadity Analyzer </h1> <br>
<p align="center">
  <a href="https://github.com/Handarudarma/DrupadiTy-Analyzer"> <img alt="Drupadity Analyzer Logo" title="Drupadity Analyzer" src="https://raw.githubusercontent.com/Handarudarma/DrupadiTy-Analyzer/main/Drupadity/assets/icon/app_icon.png" width="450">
  </a>
</p>

<p align="center">
  Analisis Keamanan APK di Genggaman Anda. Dibangun dengan Flutter.
</p>

## Table of Contents

- [Pendahuluan](#pendahuluan)
- [Fitur Utama](#fitur-utama)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Status Proyek](#status-proyek)
- [Proses Pembangunan (Build Process)](#proses-pembangunan-build-process)
- [Desain (Figma)](#desain-figma)
- [Kontributor](#kontributor)
- [Masukan](#masukan)
- [Ucapan Terima Kasih](#ucapan-terima-kasih)

## Pendahuluan

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Drupadity Analyzer adalah aplikasi mobile yang inovatif dan powerful, dirancang untuk membantu Anda menganalisis keamanan file APK. Dengan kemampuan untuk menilai tingkat kerentanan terhadap malware dan mendeteksi program jahat lainnya, aplikasi ini berfungsi mirip dengan Mobile Security Framework (MOBSF) yang terkenal, membawa kekuatan analisis keamanan langsung ke perangkat mobile Anda.

Aplikasi ini bertujuan untuk memberikan lapisan keamanan tambahan bagi seluruh lapisan masyarakat yang ingin memastikan integritas aplikasi yang mereka instal.

**Saat ini sedang dalam pengembangan aktif dan ditargetkan untuk segera rilis di Play Store/App Store.**

<p align="center">
  <img src="https://raw.githubusercontent.com/Handarudarma/DrupadiTy-Analyzer/main/Drupadity/assets/tampilan/tampilan.png" alt="Screenshot Tampilan Aplikasi Drupadity Analyzer" width="600">
</p>

## Fitur Utama

Berikut adalah beberapa fitur unggulan yang ditawarkan oleh Drupadity Analyzer:

* **Login Aman dengan Google:** Memungkinkan pengguna untuk masuk ke aplikasi dengan mudah dan aman menggunakan akun Google mereka melalui Firebase Authentication.
* **Analisis APK Komprehensif:** Fitur inti aplikasi yang memungkinkan pengguna mengunggah file APK untuk dianalisis.
* **Deteksi Malware & Kerentanan:** Menganalisis APK untuk mendeteksi potensi malware, program jahat, dan mengidentifikasi tingkat keamanan serta kerentanan yang mungkin ada.
* **Laporan Analisis PDF:** Pengguna dapat mengunduh hasil analisis APK dalam format PDF yang mudah dibaca dan dibagikan.

<p align="center">
  </p>

## Teknologi yang Digunakan

Proyek ini dibangun menggunakan teknologi-teknologi modern dan powerful:

* **Flutter:** Framework UI open-source dari Google untuk membangun aplikasi mobile, web, dan desktop secara native dari satu codebase.
* **Dart:** Bahasa pemrograman yang digunakan oleh Flutter.
* **MOBSF API:** Mengintegrasikan dengan API Mobile Security Framework (MOBSF) untuk melakukan analisis APK secara mendalam.
* **Firebase Authentication:** Digunakan untuk sistem login yang aman dan mudah dengan integrasi Google Auth.

## Status Proyek

Drupadity Analyzer saat ini **sedang dalam pengembangan aktif**. Kami terus berupaya untuk meningkatkan fitur dan stabilitas aplikasi, dengan target untuk **segera rilis di Google Play Store dan Apple App Store**.

## Proses Pembangunan (Build Process)

Untuk menjalankan proyek ini di lingkungan pengembangan Anda:

1.  **Pastikan Anda memiliki Flutter SDK terinstal.** Ikuti panduan instalasi resmi Flutter: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2.  **Kloning repositori ini:**
    ```bash
    git clone [https://github.com/Handarudarma/DrupadiTy-Analyzer.git](https://github.com/Handarudarma/DrupadiTy-Analyzer.git)
    ```
3.  **Masuk ke direktori proyek:**
    ```bash
    cd DrupadiTy-Analyzer/Drupadity
    ```
    *Catatan: Struktur proyek ini memiliki folder `Drupadity` di dalamnya, yang merupakan root proyek Flutter Anda.*
4.  **Instal dependensi Flutter:**
    ```bash
    flutter pub get
    ```
5.  **Jalankan aplikasi:**
    * Untuk Android: `flutter run`
    * Untuk iOS (membutuhkan Mac): `flutter run`

**Konfigurasi Firebase:**
Proyek ini menggunakan Firebase Authentication. Anda perlu mengkonfigurasi proyek Firebase Anda sendiri:
* Buat proyek di [Firebase Console](https://console.firebase.google.com/).
* Tambahkan aplikasi Android dan/atau iOS ke proyek Firebase Anda.
* Unduh file `google-services.json` (untuk Android) dan `GoogleService-Info.plist` (untuk iOS) dan letakkan di lokasi yang sesuai di proyek Flutter Anda (`android/app/` dan `ios/Runner/`).
* Aktifkan metode otentikasi Google di Firebase Console Anda.

## Desain (Figma)

Anda dapat melihat desain UI/UX lengkap dari aplikasi Drupadity Analyzer melalui link Figma berikut:

* [Link Figma Desain Drupadity Analyzer](https://www.figma.com/design/1TG3xAFdTo0oah6fi8ir7L/MOCKUP-PROYEK-TI?node-id=0-1&p=f&t=47h28SjcbFhH5Dw1-0)

## Kontributor

Proyek ini dibuat oleh:
1. Handaru Darma Putra (222104004)
2. Muhammad Nasikh Afifuddin (222104009)
3. Ahmad Fazal (222104010)
4. Yerly Ania Saputri (222104002)
5. Ahmad Ansori (222104001)

Jika Anda ingin berkontribusi pada proyek ini, silakan ajukan Pull Request atau [ajukan isu baru](https://github.com/Handarudarma/DrupadiTy-Analyzer/issues/new) untuk diskusi.

## Masukan

Kami sangat menghargai masukan dan saran Anda. Jangan ragu untuk [mengajukan isu baru](https://github.com/Handarudarma/DrupadiTy-Analyzer/issues/new) jika Anda menemukan bug, memiliki pertanyaan, atau ingin mengajukan fitur baru.

## Ucapan Terima Kasih

Terima kasih kepada semua pihak yang telah mendukung dan memberikan inspirasi dalam pengembangan proyek Drupadity Analyzer ini.
