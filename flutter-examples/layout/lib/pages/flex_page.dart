/// ============================================================
/// 06 - Flex 弹性布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('06 - Flex 弹性布局'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. Expanded 基础'),
              _buildDescription('两个 Expanded 平分空间，第三个固定宽度'),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: _buildFlexBox(CupertinoColors.systemBlue, 'Expanded\nflex:1')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFlexBox(CupertinoColors.systemGreen, 'Expanded\nflex:1')),
                    const SizedBox(width: 8),
                    SizedBox(width: 80, child: _buildFlexBox(CupertinoColors.systemRed, '固定\n80px')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Expanded 不同 flex 比例'),
              _buildDescription('flex:1 vs flex:2 vs flex:3，按比例分配空间'),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _buildFlexBox(CupertinoColors.systemOrange, 'flex:1')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _buildFlexBox(CupertinoColors.systemOrange.withOpacity(0.7), 'flex:2')),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: _buildFlexBox(CupertinoColors.systemRed, 'flex:3')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('3. Flexible vs Expanded'),
              _buildDescription('Expanded 强制填满，Flexible(fit: loose) 保持内容大小'),
              _buildLabel('Expanded（强制填满）:'),
              SizedBox(
                height: 55,
                child: Row(
                  children: [
                    Expanded(child: _buildFlexBox(CupertinoColors.systemPurple, 'Expanded')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFlexBox(CupertinoColors.systemPurple.withOpacity(0.6), 'Expanded')),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildLabel('Flexible fit: loose（不强制填满）:'),
              SizedBox(
                height: 55,
                child: Row(
                  children: [
                    Flexible(fit: FlexFit.loose, child: _buildFlexBox(CupertinoColors.systemTeal, 'loose')),
                    const SizedBox(width: 8),
                    Flexible(fit: FlexFit.loose, child: _buildFlexBox(CupertinoColors.systemTeal.withOpacity(0.6), 'loose')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('4. Spacer 用法'),
              _buildDescription('Spacer 占据弹性空间，将其他组件推到两侧'),
              _buildLabel('两端对齐:'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 55,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.bars, color: CupertinoColors.secondaryLabel),
                    const Spacer(),
                    const Text('标题', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    const Icon(CupertinoIcons.ellipsis, color: CupertinoColors.secondaryLabel),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildLabel('左侧固定 + 右侧弹性:'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 55,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.search, color: CupertinoColors.secondaryLabel),
                    SizedBox(width: 12),
                    Text('搜索...', style: TextStyle(color: CupertinoColors.tertiaryLabel, fontSize: 15)),
                    Spacer(),
                    Icon(CupertinoIcons.mic_fill, color: CupertinoColors.secondaryLabel),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('5. Column 中使用 Expanded'),
              _buildDescription('垂直方向按比例分配空间'),
              SizedBox(
                height: 250,
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Container(
                        decoration: BoxDecoration(color: CupertinoColors.systemBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: const Text('侧栏\n固定 100px', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: _buildFlexBox(CupertinoColors.systemIndigo, 'flex:1 头部')),
                          const SizedBox(height: 8),
                          Expanded(flex: 3, child: _buildFlexBox(CupertinoColors.systemIndigo.withOpacity(0.6), 'flex:3 内容区')),
                          const SizedBox(height: 8),
                          Expanded(flex: 1, child: _buildFlexBox(CupertinoColors.systemIndigo.withOpacity(0.3), 'flex:1 底部', textColor: CupertinoColors.label)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('6. 实际场景：聊天输入框'),
              _buildDescription('Expanded 让输入框弹性填满剩余空间'),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.plus_circle, color: CupertinoColors.tertiaryLabel),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('输入消息...', style: TextStyle(color: CupertinoColors.tertiaryLabel)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.arrow_up_circle_fill, color: CupertinoColors.systemBlue),
                  ],
                ),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CupertinoColors.label)),
    );
  }

  Widget _buildFlexBox(Color color, String label, {Color textColor = CupertinoColors.white}) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
