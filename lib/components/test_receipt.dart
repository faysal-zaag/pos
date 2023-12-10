import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

void testReceipt(NetworkPrinter printer) {
  printer.text(
      'Boss Sojib Vai', styles: const PosStyles(align: PosAlign.center, bold: true));
  printer.text('Faysal Ahmed',
      styles: const PosStyles(align: PosAlign.center));
  printer.text('Software Engineer',
      styles: const PosStyles(bold: true, reverse: true));

  printer.feed(2);
  printer.cut();
}