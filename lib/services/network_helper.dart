import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NetworkHelper {
  /// Fast check if the device currently has active internet access
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 3),
        onTimeout: () => [],
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Displays an attractive alert dialog informing the user that internet is required
  static void showNoInternetDialog(BuildContext context, {String? title, String? message}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: isDark ? const Color(0xFF093B2A) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, color: Color(0xFFD4AF37), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'يتطلب اتصالاً بالإنترنت',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF0B4C35),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message ?? 'يتطلب هذا القسم اتصالاً بالإنترنت لتشغيل وتحميل الصوتيات والمرئيات. يرجى تفعيل شبكة الواي فاي أو بيانات الهاتف والمحاولة مجدداً.',
          style: GoogleFonts.cairo(
            fontSize: 13,
            height: 1.6,
            color: isDark ? Colors.white70 : const Color(0xFF2C3E35),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF06261B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              ),
              child: Text(
                'حسناً',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
