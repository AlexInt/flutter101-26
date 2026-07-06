/// ============================================================
/// 07 - Wrap 流式布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class WrapPage extends StatelessWidget {
  const WrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('07 - Wrap 流式布局'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. 基础 Wrap（标签云）'),
              _buildDescription('子组件自动换行，适合标签类 UI'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('Flutter', CupertinoColors.systemBlue),
                  _buildTag('React', CupertinoColors.systemCyan),
                  _buildTag('Vue.js', CupertinoColors.systemGreen),
                  _buildTag('Angular', CupertinoColors.systemRed),
                  _buildTag('Swift', CupertinoColors.systemOrange),
                  _buildTag('Kotlin', CupertinoColors.systemPurple),
                  _buildTag('TypeScript', CupertinoColors.systemIndigo),
                  _buildTag('Python', CupertinoColors.systemYellow),
                  _buildTag('Rust', CupertinoColors.systemBrown),
                  _buildTag('Go', CupertinoColors.systemTeal),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Wrap alignment 对比'),
              _buildDescription('alignment 控制每行的水平对齐方式'),

              _buildLabel('alignment: start'),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.start, children: _buildSmallTags(5)),
              const SizedBox(height: 12),

              _buildLabel('alignment: center'),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: _buildSmallTags(5)),
              const SizedBox(height: 12),

              _buildLabel('alignment: spaceBetween'),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.spaceBetween, children: _buildSmallTags(5)),
              const SizedBox(height: 12),

              _buildLabel('alignment: spaceEvenly'),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.spaceEvenly, children: _buildSmallTags(5)),
              const SizedBox(height: 24),

              _buildSectionTitle('3. 技能标签卡片'),
              _buildDescription('实际 UI 场景：用户技能展示'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('技能标签', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: [
                        _buildSkillTag('Flutter', CupertinoIcons.star_fill, CupertinoColors.systemBlue),
                        _buildSkillTag('Dart', CupertinoIcons.chevron_left_slash_chevron_right, CupertinoColors.systemIndigo),
                        _buildSkillTag('Firebase', CupertinoIcons.flame_fill, CupertinoColors.systemOrange),
                        _buildSkillTag('REST API', CupertinoIcons.cloud_fill, CupertinoColors.systemGreen),
                        _buildSkillTag('State Mgmt', CupertinoIcons.gear, CupertinoColors.systemPurple),
                        _buildSkillTag('Animations', CupertinoIcons.wand_stars, CupertinoColors.systemPink),
                        _buildSkillTag('Testing', CupertinoIcons.ant, CupertinoColors.systemRed),
                        _buildSkillTag('CI/CD', CupertinoIcons.rocket, CupertinoColors.systemTeal),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('4. 垂直方向 Wrap'),
              _buildDescription('direction: vertical，先竖向排列再换列'),
              SizedBox(
                height: 180,
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(12, (index) {
                    final colors = [
                      CupertinoColors.systemRed, CupertinoColors.systemBlue, CupertinoColors.systemGreen, CupertinoColors.systemOrange,
                      CupertinoColors.systemPurple, CupertinoColors.systemTeal, CupertinoColors.systemPink, CupertinoColors.systemIndigo,
                      CupertinoColors.systemYellow, CupertinoColors.systemBrown, CupertinoColors.systemMint, CupertinoColors.systemCyan,
                    ];
                    return Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.w600, color: colors[index % colors.length])),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('5. 筛选栏（Filter Chips）'),
              _buildDescription('使用自定义 Chip 样式'),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  _buildFilterChip('全部', true),
                  _buildFilterChip('Flutter', false),
                  _buildFilterChip('React Native', false),
                  _buildFilterChip('iOS', true),
                  _buildFilterChip('Android', false),
                  _buildFilterChip('Web', false),
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(fontSize: 13, color: CupertinoColors.tertiaryLabel, fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  List<Widget> _buildSmallTags(int count) {
    return List.generate(count, (index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemTeal.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('Tag ${index + 1}', style: const TextStyle(fontSize: 12, color: CupertinoColors.systemTeal)),
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
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? CupertinoColors.systemBlue.withOpacity(0.12) : CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(20),
        border: selected ? Border.all(color: CupertinoColors.systemBlue.withOpacity(0.3)) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? CupertinoColors.systemBlue : CupertinoColors.secondaryLabel,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}
