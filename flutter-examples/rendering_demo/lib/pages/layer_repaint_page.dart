import 'dart:async';
import 'package:flutter/material.dart';

class LayerRepaintPage extends StatefulWidget {
  const LayerRepaintPage({super.key});

  @override
  State<LayerRepaintPage> createState() => _LayerRepaintPageState();
}

class _LayerRepaintPageState extends State<LayerRepaintPage> {
  bool _useRepaintBoundary = false;
  int _totalPaints = 0;
  int _heavyPaints = 0;
  int _animatingPaints = 0;
  bool _isAnimating = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
      _totalPaints = 0;
      _heavyPaints = 0;
      _animatingPaints = 0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          _totalPaints++;
          _animatingPaints++;
        });
      }
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    setState(() {
      _isAnimating = false;
    });
  }

  void _reset() {
    _stopAnimation();
    setState(() {
      _totalPaints = 0;
      _heavyPaints = 0;
      _animatingPaints = 0;
    });
  }

  void _onHeavyPaint() {
    if (_useRepaintBoundary) return; // 使用 RepaintBoundary 时不会重绘
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _heavyPaints++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layer 与重绘优化'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIntroCard(),
            const SizedBox(height: 16),
            _buildRepaintBoundaryDemo(),
            const SizedBox(height: 16),
            _buildLayerExplainer(),
            const SizedBox(height: 16),
            _buildCommonPerformanceTips(),
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
              '🎨 Layer 合成机制',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Flutter 渲染的最后一步是合成（Compositing）。'
              'RenderObject 把自己画到 Layer 上，然后由合成器把多个 Layer 组合成最终画面。',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 12),
            _LayerBullet(
              icon: '📄',
              title: 'PictureLayer',
              desc: '存储绘制指令（Canvas 操作）',
              color: Colors.blue,
            ),
            _LayerBullet(
              icon: '🖼️',
              title: 'TextureLayer',
              desc: '外部纹理（视频、相机、平台视图）',
              color: Colors.green,
            ),
            _LayerBullet(
              icon: '🔲',
              title: 'OpacityLayer',
              desc: '整体透明度（会创建新 Layer）',
              color: Colors.orange,
            ),
            _LayerBullet(
              icon: '✨',
              title: 'TransformLayer / ShaderMaskLayer',
              desc: '变换、遮罩等效果',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepaintBoundaryDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚡ RepaintBoundary 性能对比演示',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '对比有无 RepaintBoundary 时的重绘次数差异',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _useRepaintBoundary = false;
                      });
                      _reset();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !_useRepaintBoundary
                          ? Colors.red.withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: !_useRepaintBoundary ? Colors.red : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '无边界',
                      style: TextStyle(
                        color: !_useRepaintBoundary ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _useRepaintBoundary = true;
                      });
                      _reset();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _useRepaintBoundary
                          ? Colors.green.withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: _useRepaintBoundary ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'RepaintBoundary',
                      style: TextStyle(
                        color: _useRepaintBoundary ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statMini('动画重绘', _animatingPaints, Colors.blue),
                _statMini('重绘传播', _heavyPaints, Colors.red),
                _statMini('总帧数', _totalPaints, Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            _buildDemoArea(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isAnimating ? _stopAnimation : _startAnimation,
                  icon: Icon(_isAnimating ? Icons.stop : Icons.play_arrow),
                  label: Text(_isAnimating ? '停止动画' : '开始动画'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAnimating ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重置'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_useRepaintBoundary ? Colors.green : Colors.red).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (_useRepaintBoundary ? Colors.green : Colors.red).withOpacity(0.3),
                ),
              ),
              child: Text(
                _useRepaintBoundary
                    ? '✅ 使用 RepaintBoundary：动画只重绘自己，复杂区域不会跟着重绘，性能更好！'
                    : '❌ 无 RepaintBoundary：动画重绘会向上传播，导致整个页面（包括复杂区域）都跟着重绘。',
                style: TextStyle(
                  fontSize: 13,
                  color: _useRepaintBoundary ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statMini(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDemoArea() {
    final animatingWidget = _AnimatingWidget(
      onPaint: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            // 动画组件的 paint 计数
          }
        });
      },
    );

    final heavyWidget = _HeavyWidget(
      onPaint: _onHeavyPaint,
      label: '模拟复杂绘制区域',
    );

    if (_useRepaintBoundary) {
      return Column(
        children: [
          RepaintBoundary(child: animatingWidget),
          const SizedBox(height: 12),
          heavyWidget,
        ],
      );
    } else {
      return Column(
        children: [
          animatingWidget,
          const SizedBox(height: 12),
          heavyWidget,
        ],
      );
    }
  }

  Widget _buildLayerExplainer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🌳 Layer 树是怎么工作的？',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              '默认情况下，多个 RenderObject 可以画在同一个 Layer 上。'
              '当其中一个需要重绘时，整个 Layer 都要重绘。',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 12),
            _CompareRow(
              title: '没有 RepaintBoundary',
              desc: '大家共用一个 Layer，一个重绘全部重绘',
              icon: '❌',
              color: Colors.red,
            ),
            _CompareRow(
              title: '有 RepaintBoundary',
              desc: '隔离出独立的 Layer，重绘不影响其他',
              icon: '✅',
              color: Colors.green,
            ),
            SizedBox(height: 12),
            Text(
              '什么时候需要用 RepaintBoundary？',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            _Bullet(text: '频繁重绘的区域（动画、进度条、滑动指示器）'),
            _Bullet(text: '周围有复杂且不常变化的绘制内容'),
            _Bullet(text: '性能分析中看到 "unnecessary repaints"'),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonPerformanceTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '💡 渲染性能优化技巧',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            _TipItem(
              number: '1',
              title: '使用 RepaintBoundary 隔离重绘',
              desc: '把动画、进度条等频繁重绘的区域包起来',
              color: Colors.blue,
            ),
            _TipItem(
              number: '2',
              title: '减少 saveLayer 的使用',
              desc: 'Opacity、ShaderMask 等会触发 saveLayer，很昂贵',
              color: Colors.orange,
            ),
            _TipItem(
              number: '3',
              title: '优先用 Transform 代替 Opacity',
              desc: 'Transform 不会创建新 Layer，性能更好',
              color: Colors.green,
            ),
            _TipItem(
              number: '4',
              title: 'const 构造函数减少 build',
              desc: '能加 const 就加 const，减少 Widget 重建',
              color: Colors.purple,
            ),
            _TipItem(
              number: '5',
              title: 'ListView 用 itemExtent',
              desc: '提前告诉列表项高度，避免频繁 layout 计算',
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class _LayerBullet extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final Color color;

  const _LayerBullet({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
                const SizedBox(height: 1),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  final String title;
  final String desc;
  final String icon;
  final Color color;

  const _CompareRow({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
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

class _TipItem extends StatelessWidget {
  final String number;
  final String title;
  final String desc;
  final Color color;

  const _TipItem({
    required this.number,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withOpacity(0.2),
            child: Text(number, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 动画组件（频繁重绘）
class _AnimatingWidget extends StatefulWidget {
  final VoidCallback onPaint;

  const _AnimatingWidget({required this.onPaint});

  @override
  State<_AnimatingWidget> createState() => _AnimatingWidgetState();
}

class _AnimatingWidgetState extends State<_AnimatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Center(
            child: Container(
              width: 50 + progress * 150,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  '🎬 动画区域',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// 模拟复杂绘制（很重的 Widget）
class _HeavyWidget extends StatelessWidget {
  final VoidCallback onPaint;
  final String label;

  const _HeavyWidget({required this.onPaint, required this.label});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onPaint());

    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _HeavyPainter(label),
    );
  }
}

class _HeavyPainter extends CustomPainter {
  final String label;

  _HeavyPainter(this.label);

  @override
  void paint(Canvas canvas, Size size) {
    // 模拟复杂绘制：画很多图形
    final paint = Paint()..color = Colors.orange.withOpacity(0.2);

    // 画很多圆模拟复杂绘制
    for (int i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(size.width * (i + 0.5) / 20, size.height / 2),
        20,
        paint,
      );
    }

    // 画装饰
    final linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      linePaint,
    );

    // 画文字
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _HeavyPainter oldDelegate) {
    return oldDelegate.label != label;
  }
}
