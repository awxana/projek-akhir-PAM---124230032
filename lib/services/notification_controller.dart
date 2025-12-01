import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {

  /// 1. Inisialisasi Notifikasi
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      // null means use the default app icon
      null, 
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
        )
      ],
      // Gunakan ini untuk debug notifikasi di console
      debug: true, 
    );
  }

  /// 2. Request Izin (Penting untuk Android 13+)
  static Future<void> startListeningNotificationEvents() async {
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Event listener methods (Harus static / top-level function)
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Aksi ketika notifikasi diklik
    // Bisa navigasi ke halaman lain disini
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Logika ketika notifikasi dibuat
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Logika ketika notifikasi tampil di layar
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Logika ketika user swipe/hapus notifikasi
  }

  /// 3. Fungsi Memunculkan Notifikasi
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    
    if (!isAllowed) {
      // Jika izin belum diberikan, minta izin
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1, // -1 means random ID
        channelKey: 'basic_channel',
        title: 'Halo Valorant Player! 🎮',
        body: 'Cek item terbaru di toko: Hoodie & Mousepad tersedia!',
        notificationLayout: NotificationLayout.BigPicture,
        timeoutAfter: const Duration(seconds: 10),
        wakeUpScreen: true, // Menyalakan layar
      fullScreenIntent: true, // Memaksa tampil (tergantung versi Android)
      category: NotificationCategory.Call, // Kategori Call biasanya memicu pop-up prioritas tinggi
        // Contoh menggunakan asset yang ada di pubspec Anda (perlu setup khusus untuk gambar besar)
        // bigPicture: 'asset://assets/valorant-logo.png', 
      ),
    );
  }
}