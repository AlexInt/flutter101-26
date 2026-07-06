/// ============================================================
/// Flutter Layout 布局示例 - 主入口（iOS 风格）
/// ============================================================
/// 涵盖 Flutter 常用布局组件：
///   1. Container      - 容器（padding/margin/decoration）
///   2. Row & Column   - 线性布局（水平/垂直）
///   3. Stack          - 层叠布局
///   4. ListView       - 列表布局
///   5. GridView       - 网格布局
///   6. Flex 弹性布局   - Expanded / Flexible / Spacer
///   7. Wrap           - 流式布局（自动换行）
///   8. Align & Center - 对齐布局
///   9. 综合实战       - 卡片列表页
///
/// 💡 运行方式：flutter run -t lib/main.dart
/// ============================================================

import 'package:flutter/cupertino.dart';
import 'pages/container_page.dart';
import 'pages/row_column_page.dart';
import 'pages/stack_page.dart';
import 'pages/list_view_page.dart';
import 'pages/grid_view_page.dart';
import 'pages/flex_page.dart';
import 'pages/wrap_page.dart';
import 'pages/alignment_page.dart';
import 'pages/comprehensive_page.dart';
import 'pages/chat_page.dart';

void main() => runApp(const LayoutApp());

class LayoutApp extends StatelessWidget {
  const LayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Layout 示例',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}

/// ─────────────────────────────────────────
/// 首页：导航到各个布局示例
/// ─────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例列表数据
    final examples = <_ExampleItem>[
      _ExampleItem('01', 'Container', '容器布局：padding / margin / decoration',
          CupertinoIcons.square_fill, const ContainerPage()),
      _ExampleItem('02', 'Row & Column', '线性布局：水平排列 & 垂直排列',
          CupertinoIcons.rectangle_grid_2x2, const RowColumnPage()),
      _ExampleItem(
          '03', 'Stack', '层叠布局：组件重叠与定位', CupertinoIcons.layers_fill, const StackPage()),
      _ExampleItem(
          '04', 'ListView', '列表布局：垂直/水平滚动列表', CupertinoIcons.list_bullet, const ListViewPage()),
      _ExampleItem('05', 'GridView', '网格布局：二维网格排列',
          CupertinoIcons.grid_circle_fill, const GridViewPage()),
      _ExampleItem('06', 'Flex 弹性布局', 'Expanded / Flexible / Spacer 用法',
          CupertinoIcons.arrow_left_right, const FlexPage()),
      _ExampleItem(
          '07', 'Wrap', '流式布局：自动换行排列', CupertinoIcons.text_alignleft, const WrapPage()),
      _ExampleItem('08', 'Align & Center', '对齐与居中定位',
          CupertinoIcons.viewfinder, const AlignmentPage()),
      _ExampleItem('09', '综合实战', '卡片列表页：多种布局组合',
          CupertinoIcons.rectangle_stack_fill, const ComprehensivePage()),
      _ExampleItem(
          '10', '微信聊天室', '聊天界面：消息发送与展示', CupertinoIcons.chat_bubble_fill, const ChatPage()),
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flutter Layout 布局示例'),
      ),
      child: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: examples.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = examples[index];
            return _ExampleCard(item: item);
          },
        ),
      ),
    );
  }
}

/// 示例数据模型
class _ExampleItem {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  _ExampleItem(this.number, this.title, this.subtitle, this.icon, this.page);
}

/// 示例卡片组件
class _ExampleCard extends StatelessWidget {
  final _ExampleItem item;

  const _ExampleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => item.page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                item.number,
                style: const TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.forward,
              size: 18,
              color: CupertinoColors.tertiaryLabel,
            ),
          ],
        ),
      ),
    );
  }
}
