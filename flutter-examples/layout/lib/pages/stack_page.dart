/// ============================================================
/// 03 - Stack 层叠布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('03 - Stack 层叠布局'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. 基础 Stack'),
              _buildDescription('子组件按顺序叠放，后添加的在上方'),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 200, height: 200, decoration: BoxDecoration(color: CupertinoColors.systemBlue, borderRadius: BorderRadius.circular(14))),
                    Container(width: 150, height: 150, decoration: BoxDecoration(color: CupertinoColors.systemGreen, borderRadius: BorderRadius.circular(14))),
                    Container(width: 100, height: 100, decoration: BoxDecoration(color: CupertinoColors.systemRed, borderRadius: BorderRadius.circular(14))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Stack + Positioned'),
              _buildDescription('用 Positioned 精确控制子组件在 Stack 中的位置'),
              Center(
                child: SizedBox(
                  width: 280,
                  height: 200,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [CupertinoColors.systemIndigo, CupertinoColors.systemPurple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('NEW', style: TextStyle(color: CupertinoColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(CupertinoIcons.heart_fill, color: CupertinoColors.systemRed, size: 18),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Stack 层叠',
                          style: TextStyle(color: CupertinoColors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('3. 头像 + 在线状态徽章'),
              _buildDescription('常见 UI 模式：圆形头像右上角显示在线状态'),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(CupertinoIcons.person_fill, size: 50, color: CupertinoColors.systemBlue),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: CupertinoColors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('4. 图文叠加（封面效果）'),
              _buildDescription('背景色块模拟图片，底部渐变遮罩 + 文字'),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [CupertinoColors.systemTeal.withOpacity(0.6), CupertinoColors.systemBlue],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(CupertinoIcons.photo_fill, size: 80, color: CupertinoColors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                            gradient: LinearGradient(
                              colors: [CupertinoColors.transparent, CupertinoColors.black.withOpacity(0.6)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('标题文字', style: TextStyle(color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('副标题描述内容', style: TextStyle(color: CupertinoColors.white, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('5. Positioned.fill'),
              _buildDescription('让子组件充满整个 Stack，配合 padding 实现内边距效果'),
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemOrange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      right: 140,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text('左侧区域', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      bottom: 16,
                      width: 110,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemOrange.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text('右侧', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
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
}
