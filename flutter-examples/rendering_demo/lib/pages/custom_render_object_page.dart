import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomRenderObjectPage extends StatefulWidget {
  const CustomRenderObjectPage({super.key});

  @override
  State<CustomRenderObjectPage> createState() => _CustomRenderObjectPageState();
}

class _CustomRenderObjectPageState extends State<CustomRenderObjectPage> {
  double _progress = 0.6;
  double _rotation = 0;
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义 RenderObject'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIntroCard(),
            const SizedBox(height: 16),
            _buildCustomProgressDemo(),
            const SizedBox(height: 16),
            _buildCustomRainbowDemo(),
            const SizedBox(height: 16),
            _buildCodeExplainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🖌️ 为什么要自定义 RenderObject？',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '大多数场景用 StatelessWidget / StatefulWidget 就够了，'
              '但当你需要：',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            _Bullet(text: '精确控制布局（自定义排版逻辑）'),
            _Bullet(text: '复杂的自定义绘制（Canvas 直接操作）'),
            _Bullet(text: '极致性能优化（减少 Widget 树层级）'),
            _Bullet(text: '特殊的手势或命中测试逻辑'),
            SizedBox(height: 8),
            Text(
              '这时就需要自定义 RenderObject 了。',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomProgressDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 示例1：自定义进度条 (RenderBox)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '继承 SingleChildRenderObjectWidget，自定义 RenderBox，'
              '实现 performLayout() 和 paint()',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomProgressBar(
                progress: _progress,
                color: _color,
                height: 40,
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _progress,
              onChanged: (v) => setState(() => _progress = v),
              activeColor: _color,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorButton(Colors.blue, '蓝'),
                _colorButton(Colors.green, '绿'),
                _colorButton(Colors.orange, '橙'),
                _colorButton(Colors.purple, '紫'),
                _colorButton(Colors.red, '红'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '当前进度: ${(_progress * 100).toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color, String label) {
    return GestureDetector(
      onTap: () => setState(() => _color = color),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _color == color
              ? Border.all(color: Colors.black, width: 3)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRainbowDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌈 示例2：自定义彩虹转盘 (CustomPainter)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '用 CustomPaint + CustomPainter 也是一种自定义绘制方式，'
              '它是对 RenderObject 的封装，更简单易用。',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: Transform.rotate(
                angle: _rotation,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: RainbowPainter(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _rotation,
              min: 0,
              max: math.pi * 2,
              onChanged: (v) => setState(() => _rotation = v),
            ),
            Text(
              '旋转角度: ${((_rotation * 180) / math.pi).toStringAsFixed(0)}°',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExplainer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📝 核心方法说明',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            _CodeBlock(
              title: '1. performLayout() - 布局阶段',
              code: '''
@override
void performLayout() {
  // 计算自己的大小
  size = constraints.constrain(
    Size(constraints.maxWidth, _height),
  );
  
  // 如果有子节点，布局子节点
  if (child != null) {
    child!.layout(
      BoxConstraints.tight(size),
      parentUsesSize: true,
    );
  }
}''',
              desc: '决定自己和子节点的大小。constraints 是父节点给的约束。',
            ),
            SizedBox(height: 12),
            _CodeBlock(
              title: '2. paint() - 绘制阶段',
              code: '''
@override
void paint(PaintingContext context, Offset offset) {
  // 在 canvas 上绘制
  final rect = offset & size;
  final paint = Paint()..color = _color;
  
  // 画圆角矩形进度条
  context.canvas.drawRRect(
    RRect.fromRectAndRadius(rect, Radius.circular(8)),
    paint,
  );
}''',
              desc: '在 Canvas 上绘制内容。offset 是左上角坐标。',
            ),
            SizedBox(height: 12),
            _CodeBlock(
              title: '3. 何时触发重绘？',
              code: '''
set progress(double newValue) {
  if (_progress != newValue) {
    _progress = newValue;
    markNeedsLayout();  // 大小变了：需要重新布局
    markNeedsPaint();   // 外观变了：需要重新绘制
  }
}''',
              desc: '数据变化时，手动调用 markNeedsLayout / markNeedsPaint 触发更新。',
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String title;
  final String code;
  final String desc;

  const _CodeBlock({required this.title, required this.code, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Colors.greenAccent,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '💡 $desc',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════
// 自定义进度条 Widget + RenderObject
// ══════════════════════════════════════════

class CustomProgressBar extends SingleChildRenderObjectWidget {
  final double progress;
  final Color color;
  final double height;

  const CustomProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 20,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCustomProgressBar(
      progress: progress,
      color: color,
      height: height,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCustomProgressBar renderObject) {
    renderObject
      ..progress = progress
      ..color = color
      ..height = height;
  }
}

class _RenderCustomProgressBar extends RenderBox {
  double _progress;
  Color _color;
  double _height;

  _RenderCustomProgressBar({
    required double progress,
    required Color color,
    required double height,
  })  : _progress = progress,
        _color = color,
        _height = height;

  double get progress => _progress;

  set progress(double value) {
    if (_progress != value) {
      _progress = value;
      markNeedsPaint();
    }
  }

  Color get color => _color;

  set color(Color value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  double get height => _height;

  set height(double value) {
    if (_height != value) {
      _height = value;
      markNeedsLayout();
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    final desiredHeight = _height;
    size = constraints.constrain(
      Size(constraints.maxWidth, desiredHeight),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final rect = offset & size;
    final radius = Radius.circular(size.height / 2);

    // 背景轨道
    final bgPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), bgPaint);

    // 进度条填充
    final progressWidth = rect.width * _progress.clamp(0.0, 1.0);
    final progressRect = Rect.fromLTWH(
      rect.left,
      rect.top,
      progressWidth,
      rect.height,
    );

    final progressPaint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    // 绘制圆角进度（当进度较小时也保持圆角）
    if (progressWidth > size.height / 2) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(progressRect, radius),
        progressPaint,
      );
    } else {
      // 进度很小时，绘制半圆头
      final circleCenter = Offset(rect.left + progressWidth, rect.top + rect.height / 2);
      canvas.drawCircle(circleCenter, progressWidth, progressPaint);
    }

    // 绘制百分比文字
    final textSpan = TextSpan(
      text: '${(_progress * 100).toInt()}%',
      style: TextStyle(
        color: _progress > 0.3 ? Colors.white : _color,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      offset + Offset(
        progressWidth > textPainter.width + 16
            ? progressWidth - textPainter.width - 8
            : progressWidth + 8,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool hitTestSelf(Offset position) => true;
}

// ══════════════════════════════════════════
// 彩虹转盘 CustomPainter
// ══════════════════════════════════════════

class RainbowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    final sweepAngle = (2 * math.pi) / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final rect = Rect.fromCircle(center: center, radius: radius);

      canvas.drawArc(
        rect,
        -math.pi / 2 + i * sweepAngle,
        sweepAngle,
        true,
        paint,
      );
    }

    // 中心白色圆
    final centerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.3, centerPaint);

    // 中心文字
    final textSpan = const TextSpan(
      text: 'Rainbow',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
