/// ============================================================
/// 01 - Container 容器布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('01 - Container 容器'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. 基础 Container'),
              _buildDescription('设置宽度、高度、背景色和圆角'),
              Center(
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Hello Container',
                    style: TextStyle(color: CupertinoColors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Padding & Margin'),
              _buildDescription('padding 控制内边距，margin 控制外边距'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemOrange.withOpacity(0.15),
                  border: Border.all(color: CupertinoColors.systemOrange, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '这段文字有 16px 的 padding 和 20px 的水平 margin',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('3. BoxDecoration 装饰'),
              _buildDescription('渐变色背景 + 阴影效果'),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [CupertinoColors.systemPurple, CupertinoColors.systemPink, CupertinoColors.systemOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    '渐变背景 + 阴影',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('4. 边框样式'),
              _buildDescription('Border、BorderSide 各种边框效果'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemRed, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text('全边框', style: TextStyle(fontSize: 12)),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: CupertinoColors.systemGreen, width: 1),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('下边框', style: TextStyle(fontSize: 12)),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CupertinoColors.systemBlue, width: 1),
                      color: CupertinoColors.systemBlue.withOpacity(0.08),
                    ),
                    alignment: Alignment.center,
                    child: const Text('圆形', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('5. Constraints 约束'),
              _buildDescription('BoxConstraints 限制最小/最大尺寸'),
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    maxWidth: 300,
                    minHeight: 60,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemTeal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CupertinoColors.systemTeal.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'minWidth: 150\nmaxWidth: 300\nminHeight: 60',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('6. Transform 变换'),
              _buildDescription('旋转、缩放、平移效果'),
              Center(
                child: Container(
                  transform: Matrix4.rotationZ(-0.08),
                  width: 180,
                  height: 80,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemIndigo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '旋转 -5°',
                    style: TextStyle(color: CupertinoColors.white, fontSize: 16),
                  ),
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
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CupertinoColors.label),
      ),
    );
  }

  Widget _buildDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(desc, style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
    );
  }
}
