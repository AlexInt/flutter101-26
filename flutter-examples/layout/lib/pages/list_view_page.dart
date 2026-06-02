/// ============================================================
/// 04 - ListView 列表布局
/// ============================================================
/// ListView 是最常用的滚动列表组件
///
/// 四种构建方式：
///   1. ListView()            - 直接传入 children（适合少量固定项）
///   2. ListView.builder()    - 按需构建（适合大量/动态数据，有复用机制）
///   3. ListView.separated()  - 带分隔线的列表
///   4. ListView.custom()     - 完全自定义（使用 SliverChildDelegate）
///
/// 关键属性：
///   - scrollDirection : 滚动方向（vertical / horizontal）
///   - reverse         : 是否反向排列
///   - shrinkWrap      : 是否收缩到内容大小（嵌套在 Column 中时需要）
///   - physics         : 滚动物理效果
/// ============================================================

import 'package:flutter/material.dart';

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('04 - ListView 列表')),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            // Tab 栏
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: '基础列表'),
                  Tab(text: 'Builder'),
                  Tab(text: 'Separated'),
                  Tab(text: '水平列表'),
                ],
              ),
            ),
            // Tab 内容
            Expanded(
              child: TabBarView(
                children: [
                  _buildBasicList(),
                  _buildBuilderList(),
                  _buildSeparatedList(),
                  _buildHorizontalList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Tab 1: 基础 ListView（直接传 children）
  // ─────────────────────────────────────────
  Widget _buildBasicList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard('直接传入 children', '适合少量、固定的列表项，所有项都会一次性构建', Icons.list),
        const SizedBox(height: 12),
        // 使用 ListTile 组件（Flutter 内置的列表项组件）
        const ListTile(
          leading: Icon(Icons.home, color: Colors.blue),
          title: Text('首页'),
          subtitle: Text('返回首页'),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.settings, color: Colors.grey),
          title: Text('设置'),
          subtitle: Text('应用设置'),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info, color: Colors.green),
          title: Text('关于'),
          subtitle: Text('版本信息'),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(),
        // CheckboxListTile
        CheckboxListTile(
          value: true,
          onChanged: (_) {},
          title: const Text('启用通知'),
          subtitle: const Text('接收推送消息'),
          secondary: const Icon(Icons.notifications, color: Colors.orange),
        ),
        // SwitchListTile
        SwitchListTile(
          value: true,
          onChanged: (_) {},
          title: const Text('深色模式'),
          subtitle: const Text('使用深色主题'),
          secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Tab 2: ListView.builder（按需构建，有复用）
  // ─────────────────────────────────────────
  Widget _buildBuilderList() {
    // 模拟数据
    final items = List.generate(50, (i) => '列表项 ${i + 1}');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      // itemBuilder: 按需创建每一项（类似 RecyclerView / UITableViewCell 复用）
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            title: Text(items[index]),
            subtitle: Text('这是第 ${index + 1} 条数据的描述'),
            trailing: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  // Tab 3: ListView.separated（带分隔线）
  // ─────────────────────────────────────────
  Widget _buildSeparatedList() {
    final contacts = [
      ('Alice', '在线', Colors.green),
      ('Bob', '5分钟前', Colors.grey),
      ('Charlie', '昨天', Colors.grey),
      ('David', '在线', Colors.green),
      ('Eva', '2小时前', Colors.orange),
      ('Frank', '离线', Colors.red),
      ('Grace', '在线', Colors.green),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      // separatorBuilder: 在每一项之间插入分隔组件
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final (name, status, statusColor) = contacts[index];
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.primaries[index % Colors.primaries.length].shade200,
                child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              // 在线状态点
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 14, height: 14,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(status),
          trailing: const Icon(Icons.chat_bubble_outline, size: 20),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  // Tab 4: 水平 ListView
  // ─────────────────────────────────────────
  Widget _buildHorizontalList() {
    final categories = [
      ('美食', Icons.restaurant, Colors.red),
      ('旅行', Icons.flight, Colors.blue),
      ('音乐', Icons.music_note, Colors.purple),
      ('电影', Icons.movie, Colors.orange),
      ('运动', Icons.sports_soccer, Colors.green),
      ('读书', Icons.book, Colors.brown),
      ('游戏', Icons.sports_esports, Colors.indigo),
      ('购物', Icons.shopping_bag, Colors.pink),
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('水平滚动列表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        // 水平方向的 ListView
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 水平滚动
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final (label, icon, color) = categories[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 40, color: color),
                    const SizedBox(height: 8),
                    Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }

  /// 信息卡片
  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Card(
      color: Colors.blue.shade50,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
