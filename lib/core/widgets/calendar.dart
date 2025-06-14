import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';

// Estrutura do Calendario
class DatePicker {
  static Future<String?> showCustomDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String format = 'dd/MM/yyyy',
  }) async {
    // Localização em pt-br
    Intl.defaultLocale = 'pt_BR';

    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      confirmText: 'CONFIRMAR',
      cancelText: 'CANCELAR',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:Colors.orange, // Circulo do dia selecionado no calendario
              onPrimary:Colors.black, // Numero do dia selecionado no calendario
              onSurface: Styles.fontColor, // Demais textos do calendario
              surface: Styles.backgroundColor, // Background
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Styles.fontColor, // Texto cancelar e confirmar
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return DateFormat(format).format(picked);
    }
    return null;
  }
}
