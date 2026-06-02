/// ============================================================
/// 02 - Row & Column 线性布局
/// ============================================================
/// Row   : 水平方向排列子组件（类似 iOS HStack / CSS flex-row）
/// Column: 垂直方向排列子组件（类似 iOS VStack / CSS flex-column）
///
/// 主轴对齐   : mainAxisAlignment（Row=水平轴，Column=垂直轴）
/// 交叉轴对齐 : crossAxisAlignment（Row=垂直轴，Column=水平轴）
///
/// mainAxisAlignment 可选值：
///   .start / .end / .center / .spaceBetween / .spaceAround / .spaceEvenly
///
/// crossAxisAlignment 可选值：
///   .start / .end / .center / .stretch / .baseline
/// ============================================================

import 'package:flutter/material.dart';

class RowColumnPage extends StatelessWidget {
  const RowColumnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('02 - Row & Column')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // 示例 1：Row 基础（水平排列）
            // ─────────────────────────────────────────
            _buildSectionTitle('1. Row 基础（水平排列）'),
            _buildDescription('三个色块水平排列，mainAxisAlignment: spaceEvenly'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBox(Colors.red, 'A', 70),
                _buildBox(Colors.green, 'B', 70),
                _buildBox(Colors.blue, 'C', 70),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 2：Row mainAxisAlignment 对比
            // ─────────────────────────────────────────
            _buildSectionTitle('2. Row mainAxisAlignment 对比'),
            _buildDescription('spaceBetween vs spaceAround vs spaceEvenly'),

            _buildLabel('spaceBetween:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildSmallBox(Colors.red), _buildSmallBox(Colors.green), _buildSmallBox(Colors.blue)],
            ),
            const SizedBox(height: 8),

            _buildLabel('spaceAround:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_buildSmallBox(Colors.red), _buildSmallBox(Colors.green), _buildSmallBox(Colors.blue)],
            ),
            const SizedBox(height: 8),

            _buildLabel('spaceEvenly:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildSmallBox(Colors.red), _buildSmallBox(Colors.green), _buildSmallBox(Colors.blue)],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 3：Row crossAxisAlignment 对比
            // ─────────────────────────────────────────
            _buildSectionTitle('3. Row crossAxisAlignment 对比'),
            _buildDescription('交叉轴（垂直方向）对齐方式'),
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBox(Colors.orange, 'start', 60),
                  const SizedBox(width: 8),
                  Container(
                    width: 60, height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                    child: const Text('stretch', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  const SizedBox(width: 8),
                  _buildBox(Colors.teal, 'end', 60, height: 50),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 8),

            // ─────────────────────────────────────────
            // 示例 4：Column 基础（垂直排列）
            // ─────────────────────────────────────────
            _buildSectionTitle('4. Column 基础（垂直排列）'),
            _buildDescription('子组件垂直方向依次排列'),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Column 默认占满父高度，设置 min 只占内容高度
                  children: [
                    _buildBox(Colors.red.shade300, 'Item 1', double.infinity),
                    const SizedBox(height: 8),
                    _buildBox(Colors.green.shade300, 'Item 2', double.infinity),
                    const SizedBox(height: 8),
                    _buildBox(Colors.blue.shade300, 'Item 3', double.infinity),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 5：Row + Column 嵌套组合
            // ─────────────────────────────────────────
            _buildSectionTitle('5. Row + Column 嵌套'),
            _buildDescription('用户信息卡片：水平头像 + 垂直文字'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  // 文字信息（垂直排列）
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('张三', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Flutter 开发工程师', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const SizedBox(height: 2),
                      Text('北京 · 3年经验', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                  const Spacer(), // 弹性占位，把后面的按钮推到右边
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('关注'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 6：mainAxisSize 对比
            // ─────────────────────────────────────────
            _buildSectionTitle('6. mainAxisSize 对比'),
            _buildDescription('max（占满父容器） vs min（只占内容大小）'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // max: 占满父容器宽度
                Container(
                  color: Colors.amber.shade100,
                  child: Row(
                    mainAxisSize: MainAxisSize.max, // 默认值：占满父宽度
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildSmallBox(Colors.amber),
                      const SizedBox(width: 8),
                      _buildSmallBox(Colors.amber.shade700),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // min: 只占内容大小
                Container(
                  color: Colors.cyan.shade100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 只占内容所需大小
                    children: [
                      _buildSmallBox(Colors.cyan),
                      const SizedBox(width: 8),
                      _buildSmallBox(Colors.cyan.shade700),
                    ],
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

  /// 区块标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  /// 区块描述
  Widget _buildDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
    );
  }

  /// 标签
  Widget _buildLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey));
  }

  /// 带文字色块
  Widget _buildBox(Color color, String label, double width, {double height = 60}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  /// 小色块
  Widget _buildSmallBox(Color color) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
    );
  }
}
