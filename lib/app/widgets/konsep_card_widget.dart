import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/konsep_model.dart';

/// Widget Konsep - Card list dengan expandable detail
class KonsepCardWidget extends StatelessWidget {
  final List<KonsepNode> konsep;
  final String layout; // "horizontal" or "vertical"
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceVariant;

  const KonsepCardWidget({
    super.key,
    required this.konsep,
    this.layout = "horizontal",
    this.primaryColor = const Color(0xFF003526),
    this.secondaryColor = const Color(0xFF725C00),
    this.surfaceVariant = const Color(0xFFE4E2DE),
  });

  @override
  Widget build(BuildContext context) {
    if (layout == "horizontal") {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: konsep.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(right: entry.key < konsep.length - 1 ? 12 : 0),
              child: _KonsepCard(
                node: entry.value,
                primaryColor: primaryColor,
                isHorizontal: true,
              ),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      children: konsep
          .map((node) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _KonsepCard(node: node, primaryColor: primaryColor, isHorizontal: false),
              ))
          .toList(),
    );
  }
}

class _KonsepCard extends StatefulWidget {
  final KonsepNode node;
  final Color primaryColor;
  final bool isHorizontal;

  const _KonsepCard({
    required this.node,
    required this.primaryColor,
    required this.isHorizontal,
  });

  @override
  State<_KonsepCard> createState() => _KonsepCardState();
}

class _KonsepCardState extends State<_KonsepCard> {
  bool _isExpanded = false;

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'record_voice_over':
        return Icons.record_voice_over_rounded;
      case 'layers':
        return Icons.layers_rounded;
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'edit_note':
        return Icons.edit_note_rounded;
      case 'pentagon':
        return Icons.pentagon_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'link':
        return Icons.link_rounded;
      case 'keyboard_arrow_down':
        return Icons.keyboard_arrow_down_rounded;
      case 'done_all':
        return Icons.done_all_rounded;
      case 'text_format':
        return Icons.text_format_rounded;
      case 'verified':
        return Icons.verified_rounded;
      case 'fast_forward':
        return Icons.fast_forward_rounded;
      case 'schedule':
        return Icons.schedule_rounded;
      case 'female':
        return Icons.female_rounded;
      case 'swap_horiz':
        return Icons.swap_horiz_rounded;
      case 'add_circle':
        return Icons.add_circle_rounded;
      case 'contact_support':
        return Icons.contact_support_rounded;
      case 'arrow_upward':
        return Icons.arrow_upward_rounded;
      case 'arrow_forward':
        return Icons.arrow_forward_rounded;
      case 'arrow_downward':
        return Icons.arrow_downward_rounded;
      case 'cancel':
        return Icons.cancel_rounded;
      default:
        return Icons.label_important_rounded;
    }
  }

  Color _getIkonColor(String? warna) {
    if (warna == null) return const Color(0xFF4CAF50);
    warna = warna.replaceAll('#', '');
    if (warna.length == 6) warna = 'FF$warna';
    return Color(int.parse(warna, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final ikonWarna = _getIkonColor(widget.node.warnaIkon);
    final detail = widget.node.detail;

    return Container(
      width: widget.isHorizontal ? 300 : null,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ikonWarna.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIcon(widget.node.ikon),
                        color: ikonWarna,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.node.judul ?? '',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: const Color(0xFF1B1C1A),
                            ),
                          ),
                          if (widget.node.subJudul != null)
                            Text(
                              widget.node.subJudul!,
                              style: GoogleFonts.amiri(
                                fontSize: 13,
                                color: ikonWarna,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                    ),
                  ],
                ),

                // Ringkasan
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    widget.node.ringkasan ?? '',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                // Expanded Detail
                if (_isExpanded && detail != null) ...[
                  const Divider(height: 24),
                  _buildDetailContent(detail),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(KonsepDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Deskripsi
        if (detail.deskripsi != null) ...[
          Text(
            detail.deskripsi!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: const Color(0xFF3F4945),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Syarat
        if (detail.syarat != null && detail.syarat!.isNotEmpty) ...[
          Text(
            'Syarat:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF003526),
            ),
          ),
          const SizedBox(height: 4),
          ...detail.syarat!.map((s) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Color(0xFF054D3A))),
                    Expanded(
                      child: Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
        ],

        // Timeline (untuk fi'il)
        if (detail.timeline != null && detail.timeline!.isNotEmpty) ...[
          Text(
            'Timeline:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF003526),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: detail.timeline!.map((t) {
              final warna = _getIkonColor(t.warna);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.nama ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: warna,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      t.arab ?? '',
                      style: GoogleFonts.amiri(
                        fontSize: 12,
                        color: warna,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],

        // Fungsi
        if (detail.fungsi != null && detail.fungsi!.isNotEmpty) ...[
          Text(
            'Fungsi:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF003526),
            ),
          ),
          const SizedBox(height: 4),
          ...detail.fungsi!.map((f) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Color(0xFF054D3A))),
                    if (f.nama != null)
                      Text(
                        '${f.nama}: ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (f.arab != null)
                      Text(
                        f.arab!,
                        style: GoogleFonts.amiri(
                          fontSize: 13,
                          color: const Color(0xFF003526),
                        ),
                      ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
        ],

        // Contoh
        if (detail.contoh != null && detail.contoh!.isNotEmpty) ...[
          Text(
            'Contoh:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF003526),
            ),
          ),
          const SizedBox(height: 4),
          ...detail.contoh!.map((c) {
            final warna = _getIkonColor(c.warnaJenis);
            return Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Row(
                children: [
                  Text(
                    c.arab ?? '',
                    style: GoogleFonts.amiri(
                      fontSize: 14,
                      color: const Color(0xFF003526),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${c.arti ?? ''})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (c.jenis != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: warna.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        c.jenis!,
                        style: TextStyle(
                          fontSize: 10,
                          color: warna,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],

        // Bukan Contoh
        if (detail.bukanContoh != null && detail.bukanContoh!.isNotEmpty) ...[
          Text(
            'Bukan Contoh:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFFF44336),
            ),
          ),
          const SizedBox(height: 4),
          ...detail.bukanContoh!.map((b) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✗ ', style: TextStyle(color: Color(0xFFF44336))),
                    Text(
                      b.arab ?? '',
                      style: GoogleFonts.amiri(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${b.alasan ?? ''})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )),
        ],

        // Huruf
        if (detail.huruf != null && detail.huruf!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: detail.huruf!.map((h) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      h.arab ?? '',
                      style: GoogleFonts.amiri(
                        fontSize: 14,
                        color: const Color(0xFF7B1FA2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      h.arti ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF7B1FA2),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Amil Nashab
        if (detail.amilNashab != null && detail.amilNashab!.isNotEmpty) ...[
          Text(
            'Amil Nashab:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFF42A5F5),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: detail.amilNashab!.map((a) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF42A5F5).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  a.arab ?? '',
                  style: GoogleFonts.amiri(
                    fontSize: 14,
                    color: const Color(0xFF1976D2),
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        // Amil Jazm
        if (detail.amilJazm != null && detail.amilJazm!.isNotEmpty) ...[
          Text(
            'Amil Jazm:',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: const Color(0xFFEF5350),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: detail.amilJazm!.map((a) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF5350).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  a.arab ?? '',
                  style: GoogleFonts.amiri(
                    fontSize: 14,
                    color: const Color(0xFFF44336),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}