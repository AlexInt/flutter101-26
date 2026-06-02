/// ============================================================
/// 09 - 综合实战：卡片列表页
/// ============================================================
/// 将前面学到的布局组件组合，实现一个完整的实际页面
///
/// 使用的布局组件：
///   - Scaffold + AppBar        : 页面结构
///   - Column + Row             : 线性布局
///   - Stack + Positioned       : 层叠布局（Banner）
///   - Expanded                 : 弹性布局
///   - ListView.builder         : 列表（按需加载）
///   - Container + Decoration   : 装饰与约束
///   - Wrap                     : 流式布局（标签）
///   - SizedBox / Padding       : 间距控制
/// ============================================================

import 'package:flutter/material.dart';

class ComprehensivePage extends StatelessWidget {
  const ComprehensivePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟数据
    final articles = [
      _Article(
        title: 'Flutter 布局系统详解',
        author: '张三',
        category: 'Flutter',
        tags: ['布局', 'Row', 'Column', 'Stack'],
        readTime: '8分钟',
        likes: 156,
        color: Colors.blue,
        icon: Icons.flutter_dash,
      ),
      _Article(
        title: 'Dart 异步编程指南',
        author: '李四',
        category: 'Dart',
        tags: ['async', 'Future', 'Stream'],
        readTime: '12分钟',
        likes: 203,
        color: Colors.purple,
        icon: Icons.code,
      ),
      _Article(
        title: 'Material Design 3 实践',
        author: '王五',
        category: '设计',
        tags: ['Material3', 'Theme', 'UI'],
        readTime: '6分钟',
        likes: 89,
        color: Colors.teal,
        icon: Icons.palette,
      ),
      _Article(
        title: '状态管理方案对比',
        author: '赵六',
        category: '架构',
        tags: ['Provider', 'Riverpod', 'Bloc'],
        readTime: '15分钟',
        likes: 312,
        color: Colors.orange,
        icon: Icons.settings_suggest,
      ),
      _Article(
        title: 'Flutter 动画入门',
        author: '孙七',
        category: 'Flutter',
        tags: ['Animation', 'Hero', '过渡'],
        readTime: '10分钟',
        likes: 178,
        color: Colors.pink,
        icon: Icons.animation,
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ─────────────────────────────────────────
          // 顶部 Banner（Stack + Positioned 层叠布局）
          // ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 渐变背景
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.indigo, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // 内容
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flutter 技术专栏',
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '探索 Flutter 开发的无限可能',
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // 返回按钮
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─────────────────────────────────────────
          // 分类标签（Wrap 流式布局）
          // ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 0,
                children: [
                  _buildCategoryChip('全部', true),
                  _buildCategoryChip('Flutter', false),
                  _buildCategoryChip('Dart', false),
                  _buildCategoryChip('设计', false),
                  _buildCategoryChip('架构', false),
                ],
              ),
            ),
          ),

          // ─────────────────────────────────────────
          // 文章列表（ListView.builder 按需构建）
          // ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildArticleCard(context, articles[index]);
                },
                childCount: articles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 分类标签
  Widget _buildCategoryChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InputChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {},
        selectedColor: Colors.blue.shade100,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  /// 文章卡片（综合使用多种布局组件）
  Widget _buildArticleCard(BuildContext context, _Article article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Column: 垂直排列标题、标签、底部信息
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: 水平排列图标和标题
              Row(
                children: [
                  // 图标（Stack 叠加小圆点）
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: article.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(article.icon, color: article.color, size: 24),
                      ),
                      Positioned(
                        bottom: -2, right: -2,
                        child: Container(
                          width: 14, height: 14,
                          decoration: BoxDecoration(
                            color: article.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Expanded: 标题占据剩余空间
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          article.category,
                          style: TextStyle(color: article.color, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.bookmark_border, color: Colors.grey, size: 20),
                ],
              ),
              const SizedBox(height: 12),

              // Wrap: 标签流式布局
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: article.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('#$tag', style: TextStyle(color: Colors.grey[700], fontSize: 11)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Row: 底部信息栏（作者、阅读时间、点赞）
              Row(
                children: [
                  // 作者头像
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(article.author[0], style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                  const SizedBox(width: 6),
                  Text(article.author, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(article.readTime, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  // Spacer: 将点赞推到右侧
                  const Spacer(),
                  Icon(Icons.favorite_border, size: 16, color: Colors.red[300]),
                  const SizedBox(width: 4),
                  Text('${article.likes}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 文章数据模型
class _Article {
  final String title;
  final String author;
  final String category;
  final List<String> tags;
  final String readTime;
  final int likes;
  final Color color;
  final IconData icon;

  _Article({
    required this.title,
    required this.author,
    required this.category,
    required this.tags,
    required this.readTime,
    required this.likes,
    required this.color,
    required this.icon,
  });
}
