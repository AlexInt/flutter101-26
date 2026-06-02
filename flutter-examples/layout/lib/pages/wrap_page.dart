/// ============================================================
/// 07 - Wrap 流式布局
/// ============================================================
/// Wrap 让子组件自动换行（当一行放不下时，移到下一行）
/// 适合标签（Tag）列表、图片网格等场景
///
/// 核心属性：
///   - direction   : 排列方向（horizontal / vertical）
///   - spacing     : 主轴方向的间距
///   - runSpacing  : 交叉轴方向的间距（行间距）
///   - alignment   : 主轴对齐方式
///   - runAlignment: 交叉轴对齐方式
///   - crossAxisAlignment: 每一行的交叉轴对齐
/// ============================================================

import 'package:flutter/material.dart';

class WrapPage extends StatelessWidget {
  const WrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('07 - Wrap 流式布局')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // 示例 1：基础 Wrap（标签云）
            // ─────────────────────────────────────────
            _buildSectionTitle('1. 基础 Wrap（标签云）'),
            _buildDescription('子组件自动换行，适合标签类 UI'),
            Wrap(
              spacing: 8,      // 水平间距
              runSpacing: 8,   // 垂直间距（行间距）
              children: [
                _buildTag('Flutter', Colors.blue),
                _buildTag('React', Colors.cyan),
                _buildTag('Vue.js', Colors.green),
                _buildTag('Angular', Colors.red),
                _buildTag('Swift', Colors.orange),
                _buildTag('Kotlin', Colors.purple),
                _buildTag('TypeScript', Colors.blue.shade700),
                _buildTag('Python', Colors.yellow.shade800),
                _buildTag('Rust', Colors.deepOrange),
                _buildTag('Go', Colors.teal),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 2：不同 alignment 对比
            // ─────────────────────────────────────────
            _buildSectionTitle('2. Wrap alignment 对比'),
            _buildDescription('alignment 控制每行的水平对齐方式'),

            _buildLabel('alignment: start'),
            Wrap(
              spacing: 8, runSpacing: 8,
              alignment: WrapAlignment.start,
              children: _buildSmallTags(5),
            ),
            const SizedBox(height: 12),

            _buildLabel('alignment: center'),
            Wrap(
              spacing: 8, runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _buildSmallTags(5),
            ),
            const SizedBox(height: 12),

            _buildLabel('alignment: spaceBetween'),
            Wrap(
              spacing: 8, runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: _buildSmallTags(5),
            ),
            const SizedBox(height: 12),

            _buildLabel('alignment: spaceEvenly'),
            Wrap(
              spacing: 8, runSpacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              children: _buildSmallTags(5),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 3：技能标签（实际场景）
            // ─────────────────────────────────────────
            _buildSectionTitle('3. 技能标签卡片'),
            _buildDescription('实际 UI 场景：用户技能展示'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('技能标签', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: [
                      _buildSkillTag('Flutter', Icons.flutter_dash, Colors.blue),
                      _buildSkillTag('Dart', Icons.code, Colors.blue.shade700),
                      _buildSkillTag('Firebase', Icons.local_fire_department, Colors.amber.shade700),
                      _buildSkillTag('REST API', Icons.cloud, Colors.green),
                      _buildSkillTag('State Mgmt', Icons.settings_suggest, Colors.purple),
                      _buildSkillTag('Animations', Icons.animation, Colors.pink),
                      _buildSkillTag('Testing', Icons.bug_report, Colors.orange),
                      _buildSkillTag('CI/CD', Icons.rocket_launch, Colors.indigo),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 4：垂直方向的 Wrap
            // ─────────────────────────────────────────
            _buildSectionTitle('4. 垂直方向 Wrap'),
            _buildDescription('direction: vertical，先竖向排列再换列'),
            SizedBox(
              height: 180,
              child: Wrap(
                direction: Axis.vertical, // 垂直方向排列
                spacing: 8,
                runSpacing: 8,
                children: List.generate(12, (index) {
                  return Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.primaries[index % Colors.primaries.length].shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 5：带图标的筛选栏
            // ─────────────────────────────────────────
            _buildSectionTitle('5. 筛选栏（Filter Chips）'),
            _buildDescription('使用 Flutter 内置的 FilterChip 组件'),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('全部'),
                  selected: true,
                  onSelected: (_) {},
                  selectedColor: Colors.blue.shade100,
                ),
                FilterChip(
                  label: const Text('Flutter'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('React Native'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('iOS'),
                  selected: true,
                  onSelected: (_) {},
                  selectedColor: Colors.blue.shade100,
                ),
                FilterChip(
                  label: const Text('Android'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('Web'),
                  selected: false,
                  onSelected: (_) {},
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  List<Widget> _buildSmallTags(int count) {
    return List.generate(count, (index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text('Tag ${index + 1}', style: const TextStyle(fontSize: 12)),
      );
    });
  }

  Widget _buildSkillTag(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
