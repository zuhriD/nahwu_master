import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/diagram_model.dart';

/// Widget diagram menggunakan CustomPainter
class DiagramWidget extends StatelessWidget {
  final DiagramModel diagram;

  const DiagramWidget({super.key, required this.diagram});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: _buildDiagramByType(),
    );
  }

  Widget _buildDiagramByType() {
    switch (diagram.subTipe) {
      case 'radial_tree':
        return _RadialTreeDiagram(diagram: diagram);
      case 'horizontal_tree':
        return _HorizontalTreeDiagram(diagram: diagram);
      case 'flow_diagram':
        return _FlowDiagram(diagram: diagram);
      case 'timeline_vertical':
        return _TimelineDiagram(diagram: diagram);
      case 'badge_circle':
        return _BadgeCircleDiagram(diagram: diagram);
      case 'cross_diagram':
        return _CrossDiagram(diagram: diagram);
      default:
        return _RadialTreeDiagram(diagram: diagram);
    }
  }
}

/// Diagram Radial Tree - node pusat dengan cabang melingkar
class _RadialTreeDiagram extends StatelessWidget {
  final DiagramModel diagram;

  const _RadialTreeDiagram({required this.diagram});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: CustomPaint(
        painter: _RadialTreePainter(diagram: diagram),
        child: Container(),
      ),
    );
  }
}

class _RadialTreePainter extends CustomPainter {
  final DiagramModel diagram;

  _RadialTreePainter({required this.diagram});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) * 0.35;

    // Draw center node
    if (diagram.center != null) {
      _drawCircleNode(
        canvas,
        centerX,
        centerY,
        diagram.center!.style?.ukuran ?? 80,
        diagram.center!.style?.warnaLingkaran ?? '#2E7D32',
        diagram.center!.style?.warnaTeks ?? '#FFFFFF',
        diagram.center!.label ?? '',
        diagram.center!.style?.fontSize ?? 16,
        diagram.center!.style?.bold ?? true,
      );
    }

    // Draw child nodes in circular arrangement
    final nodes = diagram.nodes ?? [];
    final angleStep = 2 * math.pi / nodes.length;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final angle = i * angleStep - math.pi / 2;
      final nodeX = centerX + radius * math.cos(angle);
      final nodeY = centerY + radius * math.sin(angle);

      // Draw connector line
      if (node.connector != null) {
        _drawConnector(
          canvas,
          centerX,
          centerY,
          nodeX,
          nodeY,
          node.connector!.warna ?? '#A5D6A7',
          node.connector!.tebal ?? 2,
        );
      }

      // Draw node
      _drawCircleNode(
        canvas,
        nodeX,
        nodeY,
        node.style?.ukuran ?? 60,
        node.style?.warnaLingkaran ?? '#81C784',
        node.style?.warnaTeks ?? '#1B5E20',
        node.label ?? '',
        node.style?.fontSize ?? 13,
        node.style?.bold ?? true,
      );
    }
  }

  void _drawCircleNode(
    Canvas canvas,
    double x,
    double y,
    double size,
    String colorHex,
    String textColorHex,
    String text,
    double fontSize,
    bool bold,
  ) {
    final paint = Paint()
      ..color = _hexToColor(colorHex)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), size / 2, paint);

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: _hexToColor(textColorHex),
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  void _drawConnector(
    Canvas canvas,
    double x1,
    double y1,
    double x2,
    double y2,
    String colorHex,
    double thickness,
  ) {
    final paint = Paint()
      ..color = _hexToColor(colorHex)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    // Draw arrow head
    final angle = math.atan2(y2 - y1, x2 - x1);
    final arrowLength = 8.0;
    final arrowAngle = math.pi / 6;

    final path = Path();
    path.moveTo(x2, y2);
    path.lineTo(
      x2 - arrowLength * math.cos(angle - arrowAngle),
      y2 - arrowLength * math.sin(angle - arrowAngle),
    );
    path.moveTo(x2, y2);
    path.lineTo(
      x2 - arrowLength * math.cos(angle + arrowAngle),
      y2 - arrowLength * math.sin(angle + arrowAngle),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = _hexToColor(colorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness,
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Diagram Horizontal Tree - node dengan cabang horizontal
class _HorizontalTreeDiagram extends StatelessWidget {
  final DiagramModel diagram;

  const _HorizontalTreeDiagram({required this.diagram});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            painter: _HorizontalTreePainter(diagram: diagram),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          );
        },
      ),
    );
  }
}

class _HorizontalTreePainter extends CustomPainter {
  final DiagramModel diagram;

  _HorizontalTreePainter({required this.diagram});

  @override
  void paint(Canvas canvas, Size size) {
    if (diagram.nodes == null || diagram.nodes!.isEmpty) return;

    final rootX = size.width * 0.2;
    final rootY = size.height / 2;

    final childX = size.width * 0.8;
    final spacingY = size.height / (diagram.nodes!.length + 1);

    // Draw child nodes
    for (int i = 0; i < diagram.nodes!.length; i++) {
      final node = diagram.nodes![i];
      final nodeY = spacingY * (i + 1);
      final warna = node.style?.warnaLingkaran ?? '#1976D2';

      // Draw connector line
      final paint = Paint()
        ..color = _hexToColor(node.connector?.warna ?? '#90CAF9')
        ..style = PaintingStyle.stroke
        ..strokeWidth = node.connector?.tebal ?? 1.5;

      final path = Path();
      path.moveTo(rootX + 40, rootY);
      path.cubicTo(
        rootX + 80, rootY,
        childX - 80, nodeY,
        childX - 35, nodeY,
      );
      canvas.drawPath(path, paint);

      // Draw node
      _drawRoundedRect(
        canvas,
        childX - 35,
        nodeY - 30,
        70,
        60,
        warna,
        node.label ?? '',
        node.style?.fontSize ?? 13,
        node.style?.bold ?? true,
      );
    }

    // Draw center (first node)
    if (diagram.center != null) {
      _drawRoundedRect(
        canvas,
        rootX - 40,
        rootY - 35,
        80,
        70,
        diagram.center!.style?.warnaLingkaran ?? '#2E7D32',
        diagram.center!.label ?? '',
        diagram.center!.style?.fontSize ?? 14,
        diagram.center!.style?.bold ?? true,
      );
    }
  }

  void _drawRoundedRect(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
    String colorHex,
    String text,
    double fontSize,
    bool bold,
  ) {
    final paint = Paint()
      ..color = _hexToColor(colorHex)
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      const Radius.circular(16),
    );
    canvas.drawRRect(rect, paint);

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x + (width - textPainter.width) / 2,
          y + (height - textPainter.height) / 2),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Diagram Flow - 4 cabang dari pusat
class _FlowDiagram extends StatelessWidget {
  final DiagramModel diagram;

  const _FlowDiagram({required this.diagram});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: CustomPaint(
        painter: _FlowDiagramPainter(diagram: diagram),
        child: Container(),
      ),
    );
  }
}

class _FlowDiagramPainter extends CustomPainter {
  final DiagramModel diagram;

  _FlowDiagramPainter({required this.diagram});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerNodeY = size.height * 0.25;
    final childNodeY = size.height * 0.75;
    
    final nodes = diagram.nodes ?? [];
    final spacingX = size.width / (nodes.length + 1);

    // Draw nodes in a row
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final nodeX = spacingX * (i + 1);
      final warna = node.style?.warnaLingkaran ?? '#26A69A';

      // Draw connector
      if (diagram.center != null) {
        final paint = Paint()
          ..color = _hexToColor(node.connector?.warna ?? '#80CBC4')
          ..style = PaintingStyle.stroke
          ..strokeWidth = node.connector?.tebal ?? 2;

        final path = Path();
        path.moveTo(centerX, centerNodeY + 40);
        path.cubicTo(
          centerX, centerNodeY + 80,
          nodeX, childNodeY - 80,
          nodeX, childNodeY - 30,
        );
        canvas.drawPath(path, paint);
      }

      // Draw node
      _drawRoundedBox(
        canvas,
        nodeX - 35,
        childNodeY - 40,
        70,
        60,
        warna,
        node.label ?? '',
        node.style?.fontSize ?? 12,
      );
    }

    // Draw center
    if (diagram.center != null) {
      _drawCircle(
        canvas,
        centerX,
        centerNodeY,
        diagram.center!.style?.ukuran ?? 80,
        diagram.center!.style?.warnaLingkaran ?? '#00695C',
        diagram.center!.label ?? '',
        diagram.center!.style?.fontSize ?? 16,
      );
    }
  }

  void _drawCircle(Canvas canvas, double x, double y, double size,
      String colorHex, String text, double fontSize) {
    final paint = Paint()
      ..color = _hexToColor(colorHex)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), size / 2, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  void _drawRoundedBox(Canvas canvas, double x, double y, double w, double h,
      String colorHex, String text, double fontSize) {
    final paint = Paint()
      ..color = _hexToColor(colorHex)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w, h), const Radius.circular(12)),
      paint,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(x + (w - tp.width) / 2, y + (h - tp.height) / 2));
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Diagram Timeline Vertical
class _TimelineDiagram extends StatelessWidget {
  final DiagramModel diagram;

  const _TimelineDiagram({required this.diagram});

  @override
  Widget build(BuildContext context) {
    if (diagram.nodes == null) return const SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < diagram.nodes!.length; i++) ...[
          if (i > 0)
            Container(
              width: 2,
              height: 24,
              color: _hexToColor(
                  diagram.nodes![i].connector?.warna ?? '#FFAB91'),
            ),
          _buildTimelineNode(diagram.nodes![i]),
        ],
      ],
    );
  }

  Widget _buildTimelineNode(DiagramNode node) {
    final warna = node.style?.warnaLingkaran ?? '#FF7043';
    final ukuran = node.style?.ukuran ?? 50;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: ukuran,
            height: ukuran,
            decoration: BoxDecoration(
              color: _hexToColor(warna),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                node.arab ?? node.label ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: node.style?.fontSize ?? 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.label ?? '',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    color: _hexToColor(warna),
                  ),
                ),
                Text(
                  node.waktu ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

/// Badge Circle Diagram
class _BadgeCircleDiagram extends StatelessWidget {
  final DiagramModel diagram;

  const _BadgeCircleDiagram({required this.diagram});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: CustomPaint(
        painter: _BadgeCirclePainter(diagram: diagram),
        child: Container(),
      ),
    );
  }
}

class _BadgeCirclePainter extends CustomPainter {
  final DiagramModel diagram;

  _BadgeCirclePainter({required this.diagram});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) * 0.35;

    // Center
    if (diagram.center != null) {
      _drawCircle(
        canvas,
        centerX,
        centerY,
        diagram.center!.style?.ukuran ?? 80,
        diagram.center!.style?.warnaLingkaran ?? '#1565C0',
        diagram.center!.label ?? '',
        diagram.center!.style?.fontSize ?? 16,
      );
    }

    final nodes = diagram.nodes ?? [];
    final angleStep = 2 * math.pi / nodes.length;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final angle = i * angleStep - math.pi / 2;
      final nodeX = centerX + radius * math.cos(angle);
      final nodeY = centerY + radius * math.sin(angle);

      _drawCircle(
        canvas,
        nodeX,
        nodeY,
        node.style?.ukuran ?? 55,
        node.style?.warnaLingkaran ?? '#42A5F5',
        node.arab ?? node.label ?? '',
        node.style?.fontSize ?? 12,
      );
    }
  }

  void _drawCircle(Canvas canvas, double x, double y, double size,
      String colorHex, String text, double fontSize) {
    final paint = Paint()
      ..color = _hexToColor(colorHex)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), size / 2, paint);

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(x - tp.width / 2, y - tp.height / 2),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Cross Diagram (untuk huruf)
class _CrossDiagram extends StatelessWidget {
  final DiagramModel diagram;

  const _CrossDiagram({required this.diagram});

  @override
  Widget build(BuildContext context) {
    if (diagram.nodes == null) return const SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Center
        if (diagram.center != null) _buildCenterNode(diagram.center!),
        // Child nodes in 2x2 grid
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: diagram.nodes!.map((n) => _buildNode(n)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterNode(DiagramCenter node) {
    final warna = node.style?.warnaLingkaran ?? '#7B1FA2';
    final ukuran = node.style?.ukuran ?? 70;

    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        color: _hexToColor(warna),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            node.label ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: node.style?.fontSize ?? 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (node.subLabel != null)
            Text(
              node.subLabel!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNode(DiagramNode node) {
    final warna = node.style?.warnaLingkaran ?? '#7B1FA2';
    final ukuran = node.style?.ukuran ?? 70;

    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        color: _hexToColor(warna),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            node.label ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: node.style?.fontSize ?? 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (node.subLabel != null)
            Text(
              node.subLabel!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

/// Helper: Convert hex string to Color
Color diagramHexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
