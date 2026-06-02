/// ============================================================
/// 01 - Container 容器布局
/// ============================================================
/// Container 是 Flutter 中最常用的布局组件之一
/// 它整合了 padding、margin、decoration、约束等常用属性
///
/// 核心属性：
///   - padding    : 内边距（内容到边框的距离）
///   - margin     : 外边距（组件到其他组件的距离）
///   - decoration : 装饰（背景色、边框、圆角、渐变等）
///   - width/height: 固定尺寸
///   - constraints: 约束（最小/最大宽高）
///   - alignment  : 子组件对齐方式
///   - transform  : 变换（旋转、缩放、平移）
/// ============================================================

import 'package:flutter/material.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('01 - Container 容器')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────
            // 示例 1：基础 Container（背景色 + 圆角）
            // ─────────────────────────────────────────
            _buildSectionTitle('1. 基础 Container'),
            _buildDescription('设置宽度、高度、背景色和圆角'),
            Center(
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                // alignment: 控制子组件在容器内的对齐方式
                alignment: Alignment.center,
                child: const Text(
                  'Hello Container',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 2：padding 和 margin
            // ─────────────────────────────────────────
            _buildSectionTitle('2. Padding & Margin'),
            _buildDescription('padding 控制内边距，margin 控制外边距'),
            Container(
              // margin: 组件外部间距（与周围元素的距离）
              margin: const EdgeInsets.symmetric(horizontal: 20),
              // padding: 组件内部间距（内容与边框的距离）
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '这段文字有 16px 的 padding 和 20px 的水平 margin',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 3：BoxDecoration 装饰（渐变 + 阴影）
            // ─────────────────────────────────────────
            _buildSectionTitle('3. BoxDecoration 装饰'),
            _buildDescription('渐变色背景 + 阴影效果'),
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  // 线性渐变
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pink, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  // 阴影
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text(
                  '渐变背景 + 阴影',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 4：边框样式
            // ─────────────────────────────────────────
            _buildSectionTitle('4. 边框样式'),
            _buildDescription('Border、BorderSide 各种边框效果'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 四周边框
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('全边框', style: TextStyle(fontSize: 12)),
                ),
                // 只有底部边框
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.green, width: 3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('下边框', style: TextStyle(fontSize: 12)),
                ),
                // 圆形边框
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                    color: Colors.blue.shade50,
                  ),
                  alignment: Alignment.center,
                  child: const Text('圆形', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 5：constraints 约束
            // ─────────────────────────────────────────
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
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal),
                ),
                child: const Text(
                  'minWidth: 150\nmaxWidth: 300\nminHeight: 60',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // 示例 6：transform 变换
            // ─────────────────────────────────────────
            _buildSectionTitle('6. Transform 变换'),
            _buildDescription('旋转、缩放、平移效果'),
            Center(
              child: Container(
                // 旋转 5 度
                transform: Matrix4.rotationZ(-0.08),
                width: 180,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '旋转 -5°',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
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
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 区块描述
  Widget _buildDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
    );
  }
}
