/// ============================================================
/// 03 - Stack 层叠布局
/// ============================================================
/// Stack 让子组件按层叠放（后面的在上层），适合重叠布局场景
/// 常配合 Positioned 组件精确定位子元素位置
///
/// 核心属性：
///   - alignment     : 非 Positioned 子组件的对齐方式
///   - fit           : 子组件的填充方式
///   - clipBehavior  : 裁剪行为（超出部分是否裁剪）
///
/// Positioned 属性：
///   - top / bottom / left / right : 距离 Stack 边缘的距离
///   - width / height              : 固定宽高
/// ============================================================

import 'package:flutter/material.dart';

class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('03 - Stack 层叠布局')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // 示例 1：基础 Stack（层叠效果）
            // ─────────────────────────────────────────
            _buildSectionTitle('1. 基础 Stack'),
            _buildDescription('子组件按顺序叠放，后添加的在上方'),
            Center(
              child: Stack(
                alignment: Alignment.center, // 非 Positioned 子组件居中对齐
                children: [
                  // 第一层（最底层）
                  Container(width: 200, height: 200, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12))),
                  // 第二层
                  Container(width: 150, height: 150, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12))),
                  // 第三层（最上层）
                  Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 2：Stack + Positioned 精确定位
            // ─────────────────────────────────────────
            _buildSectionTitle('2. Stack + Positioned'),
            _buildDescription('用 Positioned 精确控制子组件在 Stack 中的位置'),
            Center(
              child: SizedBox(
                width: 280,
                height: 200,
                child: Stack(
                  children: [
                    // 背景
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.indigo, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    // 左上角标签
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    // 右下角图标
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                    // 居中文字
                    const Center(
                      child: Text(
                        'Stack 层叠',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 3：头像 + 在线状态徽章
            // ─────────────────────────────────────────
            _buildSectionTitle('3. 头像 + 在线状态徽章'),
            _buildDescription('常见 UI 模式：圆形头像右上角显示在线状态'),
            Center(
              child: Stack(
                clipBehavior: Clip.none, // 允许子组件超出 Stack 边界
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  // 在线状态圆点（超出头像右下角）
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 4：图片上叠加文字（类似封面图）
            // ─────────────────────────────────────────
            _buildSectionTitle('4. 图文叠加（封面效果）'),
            _buildDescription('背景色块模拟图片，底部渐变遮罩 + 文字'),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: Stack(
                  fit: StackFit.expand, // 子组件充满 Stack
                  children: [
                    // 模拟图片背景
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade300, Colors.blue.shade700],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.landscape, size: 80, color: Colors.white54),
                    ),
                    // 底部渐变遮罩
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('标题文字', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('副标题描述内容', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 5：Positioned.fill 充满父容器
            // ─────────────────────────────────────────
            _buildSectionTitle('5. Positioned.fill'),
            _buildDescription('让子组件充满整个 Stack，配合 padding 实现内边距效果'),
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  // 充满 Stack 的背景
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // 只占左半部分
                  Positioned.fill(
                    right: 140, // 右侧留 140px
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('左侧区域', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // 右侧小方块
                  Positioned(
                    right: 16,
                    top: 16,
                    bottom: 16,
                    width: 110,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('右侧', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
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
}
