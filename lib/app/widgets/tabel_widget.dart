import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/tabel_model.dart';

/// Widget Tabel - DataTable Flutter dengan styling custom
class TabelWidget extends StatelessWidget {
  final TabelModel tabel;

  const TabelWidget({super.key, required this.tabel});

  Color _hexToColor(String? hex) {
    if (hex == null) return Colors.black;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  TextAlign _getTextAlign(String? align) {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  FontWeight _getFontWeight(String? weight) {
    switch (weight) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      default:
        return FontWeight.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tabel.kolom == null || tabel.baris == null) {
      return const SizedBox();
    }

    final headerStyle = tabel.header?.style;
    final headerBgColor = _hexToColor(headerStyle?.warnaBackground);
    final headerTextColor = _hexToColor(headerStyle?.warnaTeks);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          if (tabel.header != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tabel.header!.label != null)
                    Text(
                      tabel.header!.label!,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: headerTextColor,
                      ),
                    ),
                  if (tabel.header!.deskripsi != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      tabel.header!.deskripsi!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: headerTextColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(
              height: 1,
              color: headerBgColor.withValues(alpha: 0.2),
            ),
          ],

          // DataTable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                headerBgColor.withValues(alpha: 0.1),
              ),
              dataRowColor: WidgetStateProperty.resolveWith((states) {
                return null; // Use custom row colors
              }),
              headingRowHeight: 48,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 56,
              horizontalMargin: 16,
              columnSpacing: 16,
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              columns: tabel.kolom!.asMap().entries.map((entry) {
                final col = entry.value;
                final style = col.style;
                return DataColumn(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      col.nama ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: style?.fontSize ?? 13,
                        fontWeight: _getFontWeight(style?.fontWeight),
                        color: _hexToColor(style?.warnaTeks ?? '#0D47A1'),
                      ),
                      textAlign: _getTextAlign(style?.textAlign),
                    ),
                  ),
                );
              }).toList(),
              rows: tabel.baris!.asMap().entries.map((entry) {
                final row = entry.value;
                final isEven = entry.key % 2 == 0;
                final rowBgColor = row.style?.warnaBackground;
                final bgColor = rowBgColor != null
                    ? _hexToColor(rowBgColor)
                    : (isEven
                        ? Colors.white
                        : Colors.grey.withValues(alpha: 0.03));

                return DataRow(
                  color: WidgetStateProperty.all(bgColor),
                  cells: row.sel?.asMap().entries.map((cellEntry) {
                        final colIdx = cellEntry.key;
                        final cellValue = cellEntry.value;
                        final colStyle = tabel.kolom!.length > colIdx
                            ? tabel.kolom![colIdx].style
                            : null;

                        // Check if cell contains Arabic text
                        final isArabic = _containsArabic(cellValue);

                        return DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              cellValue,
                              style: isArabic
                                  ? GoogleFonts.amiri(
                                      fontSize: colStyle?.fontSize ?? 14,
                                      fontWeight:
                                          _getFontWeight(colStyle?.fontWeight),
                                      color: _hexToColor(
                                          colStyle?.warnaTeks ?? '#1B1C1A'),
                                    )
                                  : GoogleFonts.plusJakartaSans(
                                      fontSize: colStyle?.fontSize ?? 13,
                                      fontWeight:
                                          _getFontWeight(colStyle?.fontWeight),
                                      color: _hexToColor(
                                          colStyle?.warnaTeks ?? '#1B1C1A'),
                                    ),
                              textAlign: _getTextAlign(colStyle?.textAlign),
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                );
              }).toList(),
            ),
          ),

          // Footer Section
          if (tabel.footer != null) ...[
            Divider(
              height: 1,
              color: headerBgColor.withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                tabel.footer!.label ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: tabel.footer!.style?.fontSize ?? 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _containsArabic(String text) {
    // Simple check for Arabic characters
    final arabicRegex = RegExp(r'[؀-ۿ]');
    return arabicRegex.hasMatch(text);
  }
}

/// Simple data table builder without model
class SimpleDataTable extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  final Color headerBgColor;
  final Color headerTextColor;
  final bool isArabicColumn;

  const SimpleDataTable({
    super.key,
    this.title = '',
    required this.headers,
    required this.rows,
    this.headerBgColor = const Color(0xFFE8F5E9),
    this.headerTextColor = const Color(0xFF1B5E20),
    this.isArabicColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: headerTextColor,
                ),
              ),
            ),
            Divider(height: 1, color: headerBgColor.withValues(alpha: 0.3)),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(headerBgColor.withValues(alpha: 0.3)),
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 24,
              columns: headers
                  .map((h) => DataColumn(
                        label: Text(
                          h,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: headerTextColor,
                          ),
                        ),
                      ))
                  .toList(),
              rows: rows
                  .asMap()
                  .entries
                  .map((entry) => DataRow(
                        color: WidgetStateProperty.all(
                          entry.key.isEven
                              ? Colors.white
                              : Colors.grey.withValues(alpha: 0.03),
                        ),
                        cells: entry.value
                            .map((cell) => DataCell(
                                  isArabicColumn &&
                                          entry.value.indexOf(cell) == 0
                                      ? Text(
                                          cell,
                                          style: GoogleFonts.amiri(
                                            fontSize: 14,
                                            color: const Color(0xFF1B5E20),
                                          ),
                                        )
                                      : Text(cell),
                                ))
                            .toList(),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
