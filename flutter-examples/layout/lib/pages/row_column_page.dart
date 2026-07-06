/// ============================================================
/// 02 - Row & Column 线性布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class RowColumnPage extends StatelessWidget {
  const RowColumnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('02 - Row & Column'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. Row 基础（水平排列）'),
              _buildDescription('三个色块水平排列，mainAxisAlignment: spaceEvenly'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox(CupertinoColors.systemRed, 'A', 70),
                  _buildBox(CupertinoColors.systemGreen, 'B', 70),
                  _buildBox(CupertinoColors.systemBlue, 'C', 70),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Row mainAxisAlignment 对比'),
              _buildDescription('spaceBetween vs spaceAround vs spaceEvenly'),

              _buildLabel('spaceBetween:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildSmallBox(CupertinoColors.systemRed), _buildSmallBox(CupertinoColors.systemGreen), _buildSmallBox(CupertinoColors.systemBlue)],
              ),
              const SizedBox(height: 8),

              _buildLabel('spaceAround:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [_buildSmallBox(CupertinoColors.systemRed), _buildSmallBox(CupertinoColors.systemGreen), _buildSmallBox(CupertinoColors.systemBlue)],
              ),
              const SizedBox(height: 8),

              _buildLabel('spaceEvenly:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_buildSmallBox(CupertinoColors.systemRed), _buildSmallBox(CupertinoColors.systemGreen), _buildSmallBox(CupertinoColors.systemBlue)],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('3. Row crossAxisAlignment 对比'),
              _buildDescription('交叉轴（垂直方向）对齐方式'),
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBox(CupertinoColors.systemOrange, 'start', 60),
                    const SizedBox(width: 8),
                    Container(
                      width: 60, height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: CupertinoColors.systemPurple, borderRadius: BorderRadius.circular(10)),
                      child: const Text('stretch', style: TextStyle(color: CupertinoColors.white, fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    _buildBox(CupertinoColors.systemTeal, 'end', 60, height: 50),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(height: 0.5, color: CupertinoColors.separator),
              const SizedBox(height: 8),

              _buildSectionTitle('4. Column 基础（垂直排列）'),
              _buildDescription('子组件垂直方向依次排列'),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.separator),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBox(CupertinoColors.systemRed.withOpacity(0.6), 'Item 1', double.infinity),
                      const SizedBox(height: 8),
                      _buildBox(CupertinoColors.systemGreen.withOpacity(0.6), 'Item 2', double.infinity),
                      const SizedBox(height: 8),
                      _buildBox(CupertinoColors.systemBlue.withOpacity(0.6), 'Item 3', double.infinity),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('5. Row + Column 嵌套'),
              _buildDescription('用户信息卡片：水平头像 + 垂直文字'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(CupertinoIcons.person_fill, size: 28, color: CupertinoColors.systemBlue),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('张三', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Flutter 开发工程师', style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('北京 · 3年经验', style: TextStyle(color: CupertinoColors.tertiaryLabel, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minSize: 0,
                      onPressed: () {},
                      child: const Text('关注', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('6. mainAxisSize 对比'),
              _buildDescription('max（占满父容器） vs min（只占内容大小）'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: CupertinoColors.systemYellow.withOpacity(0.15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildSmallBox(CupertinoColors.systemYellow),
                        const SizedBox(width: 8),
                        _buildSmallBox(CupertinoColors.systemYellow.withOpacity(0.7)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    color: CupertinoColors.systemTeal.withOpacity(0.15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSmallBox(CupertinoColors.systemTeal),
                        const SizedBox(width: 8),
                        _buildSmallBox(CupertinoColors.systemTeal.withOpacity(0.7)),
                      ],
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

  Widget _buildLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 12, color: CupertinoColors.tertiaryLabel));
  }

  Widget _buildBox(Color color, String label, double width, {double height = 60}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: const TextStyle(color: CupertinoColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSmallBox(Color color) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
    );
  }
}
