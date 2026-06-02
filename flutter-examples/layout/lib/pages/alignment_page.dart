/// ============================================================
/// 08 - Align & Center 对齐布局
/// ============================================================
/// Align   : 将子组件对齐到父容器的指定位置
/// Center  : Align 的特例（等同于 alignment: Alignment.center）
///
/// Alignment 坐标系（-1 到 1）：
///   topLeft(-1,-1)    topCenter(0,-1)    topRight(1,-1)
///   centerLeft(-1,0)  center(0,0)        centerRight(1,0)
///   bottomLeft(-1,1)  bottomCenter(0,1)  bottomRight(1,1)
///
/// 其他对齐组件：
///   - Padding      : 添加内边距
///   - SizedBox     : 固定尺寸或间距
///   - ConstrainedBox: 添加尺寸约束
///   - FittedBox    : 缩放子组件以适应父容器
/// ============================================================

import 'package:flutter/material.dart';

class AlignmentPage extends StatelessWidget {
  const AlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('08 - Align & Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // 示例 1：Alignment 九宫格展示
            // ─────────────────────────────────────────
            _buildSectionTitle('1. Alignment 坐标系'),
            _buildDescription('Alignment 值从 (-1,-1) 到 (1,1)，控制子组件位置'),
            SizedBox(
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // topLeft
                    _buildAlignDot(Alignment.topLeft, 'topLeft\n(-1,-1)'),
                    // topCenter
                    _buildAlignDot(Alignment.topCenter, 'topCenter\n(0,-1)'),
                    // topRight
                    _buildAlignDot(Alignment.topRight, 'topRight\n(1,-1)'),
                    // centerLeft
                    _buildAlignDot(Alignment.centerLeft, 'centerLeft\n(-1,0)'),
                    // center
                    _buildAlignDot(Alignment.center, 'center\n(0,0)'),
                    // centerRight
                    _buildAlignDot(Alignment.centerRight, 'centerRight\n(1,0)'),
                    // bottomLeft
                    _buildAlignDot(Alignment.bottomLeft, 'bottomLeft\n(-1,1)'),
                    // bottomCenter
                    _buildAlignDot(Alignment.bottomCenter, 'bottomCenter\n(0,1)'),
                    // bottomRight
                    _buildAlignDot(Alignment.bottomRight, 'bottomRight\n(1,1)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 2：Align 基本用法
            // ─────────────────────────────────────────
            _buildSectionTitle('2. Align 基本用法'),
            _buildDescription('在固定尺寸容器中定位子组件'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('topLeft', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('bottomRight', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 3：Center 组件
            // ─────────────────────────────────────────
            _buildSectionTitle('3. Center 居中'),
            _buildDescription('Center 等同于 Align(alignment: Alignment.center)'),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.pink.shade100]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Center 居中文字',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 4：SizedBox 间距
            // ─────────────────────────────────────────
            _buildSectionTitle('4. SizedBox 间距控制'),
            _buildDescription('SizedBox 用于创建固定尺寸的间距'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(height: 40, decoration: BoxDecoration(color: Colors.orange.shade200, borderRadius: BorderRadius.circular(6)), alignment: Alignment.center, child: const Text('Item 1')),
                  const SizedBox(height: 20), // 垂直间距
                  Container(height: 40, decoration: BoxDecoration(color: Colors.orange.shade300, borderRadius: BorderRadius.circular(6)), alignment: Alignment.center, child: const Text('Item 2 (SizedBox h:20)')),
                  const SizedBox(height: 8),
                  Container(height: 40, decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(6)), alignment: Alignment.center, child: const Text('Item 3 (SizedBox h:8)')),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 5：FittedBox 自适应缩放
            // ─────────────────────────────────────────
            _buildSectionTitle('5. FittedBox 自适应缩放'),
            _buildDescription('FittedBox 缩放子组件以适应父容器大小'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                    child: const FittedBox(
                      fit: BoxFit.contain, // 保持比例缩放，完整显示
                      child: Text('FittedBox', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: const FittedBox(
                      fit: BoxFit.cover, // 保持比例填满（可能裁剪）
                      child: Text('Cover', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 6：Padding 组件
            // ─────────────────────────────────────────
            _buildSectionTitle('6. Padding 组件'),
            _buildDescription('独立使用 Padding 组件添加内边距'),
            Column(
              children: [
                // EdgeInsets.all - 四边相同
                Container(
                  color: Colors.teal.shade100,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('EdgeInsets.all(16)'),
                  ),
                ),
                const SizedBox(height: 8),
                // EdgeInsets.symmetric - 水平/垂直
                Container(
                  color: Colors.blue.shade100,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: Text('EdgeInsets.symmetric(h:32, v:12)'),
                  ),
                ),
                const SizedBox(height: 8),
                // EdgeInsets.only - 每边单独设置
                Container(
                  color: Colors.purple.shade100,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
    );
  }

  /// Alignment 指示点
  Widget _buildAlignDot(Alignment alignment, String label) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ),
    );
  }
}
