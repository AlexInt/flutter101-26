/// ============================================================
/// 08 - Align & Center 对齐布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class AlignmentPage extends StatelessWidget {
  const AlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('08 - Align & Center'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. Alignment 坐标系'),
              _buildDescription('Alignment 值从 (-1,-1) 到 (1,1)，控制子组件位置'),
              SizedBox(
                height: 250,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.separator, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      _buildAlignDot(Alignment.topLeft, 'topLeft\n(-1,-1)'),
                      _buildAlignDot(Alignment.topCenter, 'topCenter\n(0,-1)'),
                      _buildAlignDot(Alignment.topRight, 'topRight\n(1,-1)'),
                      _buildAlignDot(Alignment.centerLeft, 'centerLeft\n(-1,0)'),
                      _buildAlignDot(Alignment.center, 'center\n(0,0)'),
                      _buildAlignDot(Alignment.centerRight, 'centerRight\n(1,0)'),
                      _buildAlignDot(Alignment.bottomLeft, 'bottomLeft\n(-1,1)'),
                      _buildAlignDot(Alignment.bottomCenter, 'bottomCenter\n(0,1)'),
                      _buildAlignDot(Alignment.bottomRight, 'bottomRight\n(1,1)'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Align 基本用法'),
              _buildDescription('在固定尺寸容器中定位子组件'),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('topLeft', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGreen.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('bottomRight', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('3. Center 居中'),
              _buildDescription('Center 等同于 Align(alignment: Alignment.center)'),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [CupertinoColors.systemPurple.withOpacity(0.15), CupertinoColors.systemPink.withOpacity(0.15)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Center 居中文字',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CupertinoColors.label),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('4. SizedBox 间距控制'),
              _buildDescription('SizedBox 用于创建固定尺寸的间距'),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.separator),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(height: 40, decoration: BoxDecoration(color: CupertinoColors.systemOrange.withOpacity(0.3), borderRadius: BorderRadius.circular(8)), alignment: Alignment.center, child: const Text('Item 1')),
                    const SizedBox(height: 20),
                    Container(height: 40, decoration: BoxDecoration(color: CupertinoColors.systemOrange.withOpacity(0.5), borderRadius: BorderRadius.circular(8)), alignment: Alignment.center, child: const Text('Item 2 (SizedBox h:20)')),
                    const SizedBox(height: 8),
                    Container(height: 40, decoration: BoxDecoration(color: CupertinoColors.systemOrange.withOpacity(0.7), borderRadius: BorderRadius.circular(8)), alignment: Alignment.center, child: const Text('Item 3 (SizedBox h:8)')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('5. FittedBox 自适应缩放'),
              _buildDescription('FittedBox 缩放子组件以适应父容器大小'),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(color: CupertinoColors.systemIndigo.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text('FittedBox', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: CupertinoColors.systemIndigo)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(color: CupertinoColors.systemRed.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                      child: const FittedBox(
                        fit: BoxFit.cover,
                        child: Text('Cover', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: CupertinoColors.systemRed)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('6. Padding 组件'),
              _buildDescription('独立使用 Padding 组件添加内边距'),
              Column(
                children: [
                  Container(
                    color: CupertinoColors.systemTeal.withOpacity(0.12),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('EdgeInsets.all(16)'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    color: CupertinoColors.systemBlue.withOpacity(0.12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Text('EdgeInsets.symmetric(h:32, v:12)'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    color: CupertinoColors.systemPurple.withOpacity(0.12),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 40, top: 8, right: 8, bottom: 20),
                      child: Text('EdgeInsets.only(L:40, T:8, R:8, B:20)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CupertinoColors.label)),
    );
  }

  Widget _buildDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(desc, style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
    );
  }

  Widget _buildAlignDot(Alignment alignment, String label) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBlue.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CupertinoColors.white, fontSize: 9),
          ),
        ),
      ),
    );
  }
}
