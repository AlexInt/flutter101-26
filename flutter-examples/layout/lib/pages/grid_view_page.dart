/// ============================================================
/// 05 - GridView 网格布局
/// ============================================================
/// GridView 将子组件按二维网格排列
///
/// 四种构建方式：
///   1. GridView.count()       - 指定每行/列的固定数量
///   2. GridView.extent()      - 指定每项的最大尺寸，自动计算列数
///   3. GridView.builder()     - 按需构建（大量数据）
///   4. GridView.custom()      - 完全自定义 SliverGridDelegate
///
/// 关键属性（SliverGridDelegate）：
///   - crossAxisCount       : 交叉轴方向的项数（水平滚动=行数，垂直滚动=列数）
///   - mainAxisSpacing      : 主轴方向的间距
///   - crossAxisSpacing     : 交叉轴方向的间距
///   - childAspectRatio     : 子组件宽高比（宽/高）
/// ============================================================

import 'package:flutter/material.dart';

class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('05 - GridView 网格')),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'count'),
                  Tab(text: 'extent'),
                  Tab(text: 'builder'),
                  Tab(text: '不规则网格'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCountGrid(),
                  _buildExtentGrid(),
                  _buildBuilderGrid(),
                  _buildCustomGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Tab 1: GridView.count（固定列数）
  // ─────────────────────────────────────────
  Widget _buildCountGrid() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 3,          // 每行 3 列
      mainAxisSpacing: 12,        // 垂直间距
      crossAxisSpacing: 12,       // 水平间距
      childAspectRatio: 1.0,      // 宽高比 1:1（正方形）
      children: List.generate(12, (index) {
        final colors = [
          Colors.red, Colors.blue, Colors.green, Colors.orange,
          Colors.purple, Colors.teal, Colors.pink, Colors.indigo,
          Colors.cyan, Colors.amber, Colors.lime, Colors.brown,
        ];
        return _buildGridItem('${index + 1}', colors[index % colors.length]);
      }),
    );
  }

  // ─────────────────────────────────────────
  // Tab 2: GridView.extent（按最大尺寸自动计算列数）
  // ─────────────────────────────────────────
  Widget _buildExtentGrid() {
    final icons = [
      (Icons.camera_alt, '相机', Colors.blue),
      (Icons.image, '相册', Colors.green),
      (Icons.mic, '录音', Colors.red),
      (Icons.videocam, '视频', Colors.purple),
      (Icons.location_on, '位置', Colors.orange),
      (Icons.file_present, '文件', Colors.teal),
      (Icons.calendar_today, '日历', Colors.indigo),
      (Icons.alarm, '闹钟', Colors.pink),
      (Icons.cloud, '云端', Colors.cyan),
      (Icons.print, '打印', Colors.brown),
    ];

    return GridView.extent(
      padding: const EdgeInsets.all(16),
      maxCrossAxisExtent: 120,   // 每项最大宽度 120px，自动计算列数
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: icons.map((item) {
        final (icon, label, color) = item;
        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────
  // Tab 3: GridView.builder（按需构建，大数据量）
  // ─────────────────────────────────────────
  Widget _buildBuilderGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 100, // 100 项，按需加载
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,        // 4 列
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,    // 稍高一些（竖长方形）
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.primaries[index % Colors.primaries.length].shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.primaries[index % Colors.primaries.length].shade700,
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  // Tab 4: 不规则网格（不同宽高比）
  // ─────────────────────────────────────────
  Widget _buildCustomGrid() {
    // 使用自定义 SliverGridDelegate 实现不规则网格效果
    // 这里用 2 列但设置较大的 childAspectRatio 展示矩形卡片
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5, // 宽是高的 1.5 倍（横向矩形）
      ),
      itemBuilder: (context, index) {
        final data = [
          ('Flutter', '跨平台 UI 框架', Colors.blue, Icons.flutter_dash),
          ('React', '前端框架', Colors.cyan, Icons.code),
          ('Swift', 'iOS 开发语言', Colors.orange, Icons.apple),
          ('Kotlin', 'Android 开发语言', Colors.purple, Icons.android),
          ('Vue', '渐进式框架', Colors.green, Icons.web),
          ('Django', 'Python Web 框架', Colors.green.shade900, Icons.dns),
          ('Node.js', '后端运行时', Colors.green.shade700, Icons.memory),
          ('Docker', '容器化平台', Colors.blue.shade800, Icons.inventory_2),
        ];

        final (title, subtitle, color, icon) = data[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        );
      },
    );
  }

  /// 网格项组件
  Widget _buildGridItem(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
