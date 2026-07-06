/// ============================================================
/// 09 - 综合实战：卡片列表页（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class ComprehensivePage extends StatelessWidget {
  const ComprehensivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = [
      _Article(
        title: 'Flutter 布局系统详解',
        author: '张三',
        category: 'Flutter',
        tags: ['布局', 'Row', 'Column', 'Stack'],
        readTime: '8分钟',
        likes: 156,
        color: CupertinoColors.systemBlue,
        icon: CupertinoIcons.star_fill,
      ),
      _Article(
        title: 'Dart 异步编程指南',
        author: '李四',
        category: 'Dart',
        tags: ['async', 'Future', 'Stream'],
        readTime: '12分钟',
        likes: 203,
        color: CupertinoColors.systemPurple,
        icon: CupertinoIcons.chevron_left_slash_chevron_right,
      ),
      _Article(
        title: 'Cupertino Design 实践',
        author: '王五',
        category: '设计',
        tags: ['Cupertino', 'Theme', 'UI'],
        readTime: '6分钟',
        likes: 89,
        color: CupertinoColors.systemTeal,
        icon: CupertinoIcons.paintbrush,
      ),
      _Article(
        title: '状态管理方案对比',
        author: '赵六',
        category: '架构',
        tags: ['Provider', 'Riverpod', 'Bloc'],
        readTime: '15分钟',
        likes: 312,
        color: CupertinoColors.systemOrange,
        icon: CupertinoIcons.gear,
      ),
      _Article(
        title: 'Flutter 动画入门',
        author: '孙七',
        category: 'Flutter',
        tags: ['Animation', 'Hero', '过渡'],
        readTime: '10分钟',
        likes: 178,
        color: CupertinoColors.systemPink,
        icon: CupertinoIcons.wand_stars,
      ),
    ];

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          // 顶部 Banner
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [CupertinoColors.systemBlue, CupertinoColors.systemIndigo, CupertinoColors.systemPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flutter 技术专栏',
                          style: TextStyle(color: CupertinoColors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '探索 Flutter 开发的无限可能',
                          style: TextStyle(color: CupertinoColors.white.withOpacity(0.85), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 8,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 分类标签
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

          // 文章列表
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

  Widget _buildCategoryChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, _Article article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: article.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(article.icon, color: article.color, size: 22),
                  ),
                  Positioned(
                    bottom: -2, right: -2,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: article.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: CupertinoColors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              const Icon(CupertinoIcons.bookmark, color: CupertinoColors.tertiaryLabel, size: 20),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: article.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('#$tag', style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 11)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey4,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(article.author[0], style: const TextStyle(fontSize: 10, color: CupertinoColors.white)),
              ),
              const SizedBox(width: 6),
              Text(article.author, style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(CupertinoIcons.clock, size: 14, color: CupertinoColors.tertiaryLabel),
              const SizedBox(width: 4),
              Text(article.readTime, style: const TextStyle(color: CupertinoColors.tertiaryLabel, fontSize: 12)),
              const Spacer(),
              const Icon(CupertinoIcons.heart, size: 16, color: CupertinoColors.systemRed),
              const SizedBox(width: 4),
              Text('${article.likes}', style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

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
