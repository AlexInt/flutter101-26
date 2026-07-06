/// ============================================================
/// 05 - GridView 网格布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('05 - GridView 网格'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('1. GridView.count（固定列数）'),
              _buildDescription('每行 3 列，正方形网格'),
              SizedBox(
                height: 320,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(12, (index) {
                    final colors = [
                      CupertinoColors.systemRed, CupertinoColors.systemBlue, CupertinoColors.systemGreen, CupertinoColors.systemOrange,
                      CupertinoColors.systemPurple, CupertinoColors.systemTeal, CupertinoColors.systemPink, CupertinoColors.systemIndigo,
                      CupertinoColors.systemYellow, CupertinoColors.systemBrown, CupertinoColors.systemMint, CupertinoColors.systemCyan,
                    ];
                    return Container(
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text('${index + 1}', style: const TextStyle(color: CupertinoColors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. GridView.extent（自动计算列数）'),
              _buildDescription('每项最大宽度 120px，自动计算列数'),
              SizedBox(
                height: 280,
                child: GridView.extent(
                  maxCrossAxisExtent: 120,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    (CupertinoIcons.camera_fill, '相机', CupertinoColors.systemBlue),
                    (CupertinoIcons.photo_fill, '相册', CupertinoColors.systemGreen),
                    (CupertinoIcons.mic_fill, '录音', CupertinoColors.systemRed),
                    (CupertinoIcons.videocam_fill, '视频', CupertinoColors.systemPurple),
                    (CupertinoIcons.location_fill, '位置', CupertinoColors.systemOrange),
                    (CupertinoIcons.doc_fill, '文件', CupertinoColors.systemTeal),
                    (CupertinoIcons.calendar, '日历', CupertinoColors.systemIndigo),
                    (CupertinoIcons.alarm_fill, '闹钟', CupertinoColors.systemPink),
                  ].map((item) {
                    final (icon, label, color) = item;
                    return Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 32, color: color),
                          const SizedBox(height: 8),
                          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('3. GridView.builder（按需构建）'),
              _buildDescription('100 项，按需加载'),
              SizedBox(
                height: 250,
                child: GridView.builder(
                  itemCount: 20,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final colors = [
                      CupertinoColors.systemRed, CupertinoColors.systemBlue, CupertinoColors.systemGreen, CupertinoColors.systemOrange,
                      CupertinoColors.systemPurple, CupertinoColors.systemTeal, CupertinoColors.systemPink, CupertinoColors.systemIndigo,
                    ];
                    final color = colors[index % colors.length];
                    return Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('4. 不规则网格（横向矩形卡片）'),
              _buildDescription('childAspectRatio: 1.5，宽是高的 1.5 倍'),
              SizedBox(
                height: 260,
                child: GridView.builder(
                  itemCount: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    final data = [
                      ('Flutter', '跨平台 UI 框架', CupertinoColors.systemBlue, CupertinoIcons.star_fill),
                      ('React', '前端框架', CupertinoColors.systemCyan, CupertinoIcons.chevron_left_slash_chevron_right),
                      ('Swift', 'iOS 开发语言', CupertinoColors.systemOrange, CupertinoIcons.chevron_left_slash_chevron_right),
                      ('Kotlin', 'Android 语言', CupertinoColors.systemPurple, CupertinoIcons.antenna_radiowaves_left_right),
                      ('Vue', '渐进式框架', CupertinoColors.systemGreen, CupertinoIcons.globe),
                      ('Django', 'Python Web', CupertinoColors.systemGreen.withOpacity(0.8), CupertinoIcons.cloud_upload),
                      ('Node.js', '后端运行时', CupertinoColors.systemGreen.withOpacity(0.6), CupertinoIcons.command),
                      ('Docker', '容器化平台', CupertinoColors.systemBlue.withOpacity(0.8), CupertinoIcons.cube_box),
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: CupertinoColors.white, size: 24),
                          const SizedBox(height: 8),
                          Text(title, style: const TextStyle(color: CupertinoColors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(subtitle, style: const TextStyle(color: CupertinoColors.white, fontSize: 11)),
                        ],
                      ),
                    );
                  },
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
