import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Simple parental confirmation before any purchase or store interaction.
Future<bool> showParentalGate() async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        '👨‍👩‍👧 Parent check',
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Are you a parent or guardian?\nThis will open the purchase screen.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 15),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('No', style: GoogleFonts.poppins(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B2FBE),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Yes, continue',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
    barrierDismissible: false,
  );
  return result ?? false;
}
