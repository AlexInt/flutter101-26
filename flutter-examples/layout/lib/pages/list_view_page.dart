/// ============================================================
/// 04 - ListView 列表布局（iOS 风格）
/// ============================================================

import 'package:flutter/cupertino.dart';

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('04 - ListView 列表'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoCard('直接传入 children', '适合少量、固定的列表项，所有项都会一次性构建', CupertinoIcons.list_bullet),
            const SizedBox(height: 12),
            _buildListTile(CupertinoIcons.house, '首页', '返回首页'),
            Container(height: 0.5, color: CupertinoColors.separator),
            _buildListTile(CupertinoIcons.gear, '设置', '应用设置'),
            Container(height: 0.5, color: CupertinoColors.separator),
            _buildListTile(CupertinoIcons.info_circle_fill, '关于', '版本信息'),
            Container(height: 0.5, color: CupertinoColors.separator),
  
            _ToggleTile(key: const ValueKey('toggle_notification'), icon: CupertinoIcons.bell_fill, title: '启用通知', subtitle: '接收推送消息', initialValue: true),
            _ToggleTile(key: const ValueKey('toggle_darkmode'), icon: CupertinoIcons.moon_fill, title: '深色模式', subtitle: '使用深色主题', initialValue: false),
            const SizedBox(height: 24),

            _buildSectionTitle('Builder 模式'),
            _buildDescription('按需构建，适合大量数据'),
            ...List.generate(10, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 1))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text('${i + 1}', style: const TextStyle(color: CupertinoColors.systemBlue, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('列表项 ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('这是第 ${i + 1} 条数据的描述', style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
                        ],
                      ),
                    ),
                    const Icon(CupertinoIcons.ellipsis, size: 18, color: CupertinoColors.tertiaryLabel),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            _buildSectionTitle('Separated 模式'),
            _buildDescription('带分隔线的联系人列表'),
            ..._buildContactList(),
            const SizedBox(height: 24),

            _buildSectionTitle('水平滚动列表'),
            _buildDescription('scrollDirection: Axis.horizontal'),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  final labels = ['美食', '旅行', '音乐', '电影', '运动', '读书', '游戏', '购物'];
                  final icons = [CupertinoIcons.lab_flask, CupertinoIcons.airplane, CupertinoIcons.music_note_2, CupertinoIcons.film, CupertinoIcons.sportscourt, CupertinoIcons.book, CupertinoIcons.game_controller, CupertinoIcons.bag];
                  final colors = [CupertinoColors.systemRed, CupertinoColors.systemBlue, CupertinoColors.systemPurple, CupertinoColors.systemOrange, CupertinoColors.systemGreen, CupertinoColors.systemBrown, CupertinoColors.systemIndigo, CupertinoColors.systemPink];
                  return Container(
                    width: 95,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: colors[index].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors[index].withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icons[index], size: 36, color: colors[index]),
                        const SizedBox(height: 8),
                        Text(labels[index], style: TextStyle(color: colors[index], fontWeight: FontWeight.w600, fontSize: 13)),
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
    );
  }

  List<Widget> _buildContactList() {
    final contacts = [
      ('Alice', '在线', CupertinoColors.systemGreen),
      ('Bob', '5分钟前', CupertinoColors.systemGrey),
      ('Charlie', '昨天', CupertinoColors.systemGrey),
      ('David', '在线', CupertinoColors.systemGreen),
      ('Eva', '2小时前', CupertinoColors.systemOrange),
      ('Frank', '离线', CupertinoColors.systemRed),
      ('Grace', '在线', CupertinoColors.systemGreen),
    ];

    return contacts.asMap().entries.map((entry) {
      final index = entry.key;
      final (name, status, statusColor) = entry.value;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: index < contacts.length - 1
              ? const Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5))
              : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(name[0], style: const TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600, fontSize: 16)),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(
                      color: statusColor,
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
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(status, style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chat_bubble, size: 18, color: CupertinoColors.tertiaryLabel),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemBlue, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
              ],
            ),
          ),
          const Icon(CupertinoIcons.forward, size: 16, color: CupertinoColors.tertiaryLabel),
        ],
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

/// 独立的 StatefulWidget，让每个 Switch 能独立管理自己的开关状态
class _ToggleTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool initialValue;

  const _ToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.initialValue = false,
  });

  @override
  State<_ToggleTile> createState() => _ToggleTileState();
}

class _ToggleTileState extends State<_ToggleTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            _value = !_value;
          });
        },
        child: Row(
          children: [
            Icon(widget.icon, color: CupertinoColors.systemOrange, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle, style: const TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel)),
                ],
              ),
            ),
            CupertinoSwitch(
              value: _value,
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
