/// ============================================================
/// 06 - Flex 弹性布局（Expanded / Flexible / Spacer）
/// ============================================================
/// Flutter 的弹性布局基于 Flex 组件（Row/Column 都是 Flex 的子类）
///
/// Expanded:
///   - 强制占满剩余空间（flex 参数控制比例）
///   - 子组件会被拉伸填满分配的空间
///
/// Flexible:
///   - 可以选择是否填满（fit: loose/tight）
///   - loose: 子组件保持自身大小，不超过分配空间
///   - tight: 类似 Expanded，强制填满
///
/// Spacer:
///   - 占位弹性空间（Expanded 的简化版，内部为空）
///   - 用于在 Row/Column 中推动其他组件
///
/// flex 参数：控制弹性比例，如 flex:2 的空间是 flex:1 的两倍
/// ============================================================

import 'package:flutter/material.dart';

class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('06 - Flex 弹性布局')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // 示例 1：Expanded 基础用法
            // ─────────────────────────────────────────
            _buildSectionTitle('1. Expanded 基础'),
            _buildDescription('两个 Expanded 平分空间，第三个固定宽度'),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: _buildFlexBox(Colors.blue, 'Expanded\nflex:1'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFlexBox(Colors.green, 'Expanded\nflex:1'),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: _buildFlexBox(Colors.red, '固定\n80px'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 2：Expanded 不同 flex 比例
            // ─────────────────────────────────────────
            _buildSectionTitle('2. Expanded 不同 flex 比例'),
            _buildDescription('flex:1 vs flex:2 vs flex:3，按比例分配空间'),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildFlexBox(Colors.orange, 'flex:1'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildFlexBox(Colors.deepOrange, 'flex:2'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: _buildFlexBox(Colors.red, 'flex:3'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 3：Flexible vs Expanded
            // ─────────────────────────────────────────
            _buildSectionTitle('3. Flexible vs Expanded'),
            _buildDescription('Expanded 强制填满，Flexible(fit: loose) 保持内容大小'),
            _buildLabel('Expanded（强制填满）:'),
            SizedBox(
              height: 55,
              child: Row(
                children: [
                  Expanded(child: _buildFlexBox(Colors.purple, 'Expanded')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFlexBox(Colors.purple.shade300, 'Expanded')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildLabel('Flexible fit: loose（不强制填满）:'),
            SizedBox(
              height: 55,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose, // 子组件保持自身大小，不超过分配空间
                    child: _buildFlexBox(Colors.teal, 'loose'),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: _buildFlexBox(Colors.teal.shade300, 'loose'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 4：Spacer 推动组件
            // ─────────────────────────────────────────
            _buildSectionTitle('4. Spacer 用法'),
            _buildDescription('Spacer 占据弹性空间，将其他组件推到两侧'),
            _buildLabel('两端对齐:'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.black54),
                  const Spacer(), // 占据中间所有空间
                  const Text('标题', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.black54),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildLabel('左侧固定 + 右侧弹性:'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 12),
                  Text('搜索...', style: TextStyle(color: Colors.black54, fontSize: 15)),
                  Spacer(), // 弹性空间推到右边
                  Icon(Icons.mic, color: Colors.black54),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 5：Column 中使用 Expanded
            // ─────────────────────────────────────────
            _buildSectionTitle('5. Column 中使用 Expanded'),
            _buildDescription('垂直方向按比例分配空间'),
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  // 左侧：固定宽度
                  SizedBox(
                    width: 100,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: const Text('侧栏\n固定 100px', textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 右侧：弹性填充，内部分为三行
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildFlexBox(Colors.indigo, 'flex:1 头部'),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          flex: 3,
                          child: _buildFlexBox(Colors.indigo.shade300, 'flex:3 内容区'),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          flex: 1,
                          child: _buildFlexBox(Colors.indigo.shade100, 'flex:1 底部', textColor: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 6：实际场景 - 聊天输入框
            // ─────────────────────────────────────────
            _buildSectionTitle('6. 实际场景：聊天输入框'),
            _buildDescription('Expanded 让输入框弹性填满剩余空间'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, color: Colors.grey),
                  const SizedBox(width: 8),
                  // Expanded 让输入框占据中间所有空间
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('输入消息...', style: TextStyle(color: Colors.black45)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.send, color: Colors.blue),
                ],
              ),
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }

  Widget _buildFlexBox(Color color, String label, {Color textColor = Colors.white}) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
