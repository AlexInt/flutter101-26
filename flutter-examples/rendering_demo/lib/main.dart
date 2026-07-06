import 'package:flutter/material.dart';
import 'pages/three_trees_page.dart';
import 'pages/custom_render_object_page.dart';
import 'pages/pipeline_page.dart';
import 'pages/layer_repaint_page.dart';

void main() => runApp(const RenderingDemoApp());

class RenderingDemoApp extends StatelessWidget {
  const RenderingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 渲染机制演示',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = <_DemoItem>[
      _DemoItem(
        '01',
        '三棵树原理',
        'Widget → Element → RenderObject 的关系与生命周期',
        Icons.account_tree,
        Colors.blue,
        const ThreeTreesPage(),
      ),
      _DemoItem(
        '02',
        '自定义 RenderObject',
        '手写 RenderBox，理解 layout/paint 底层',
        Icons.brush,
        Colors.orange,
        const CustomRenderObjectPage(),
      ),
      _DemoItem(
        '03',
        '渲染流水线',
        'Build → Layout → Paint → Composite 全流程追踪',
        Icons.linear_scale,
        Colors.green,
        const PipelinePage(),
      ),
      _DemoItem(
        '04',
        'Layer 与重绘',
        'RepaintBoundary、Layer 合成与性能优化',
        Icons.layers,
        Colors.purple,
        const LayerRepaintPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 渲染机制演示'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _DemoCard(item: demos[index]),
      ),
    );
  }
}

class _DemoItem {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  _DemoItem(this.number, this.title, this.subtitle, this.icon, this.color, this.page);
}

class _DemoCard extends StatelessWidget {
  final _DemoItem item;

  const _DemoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.color.withOpacity(0.15),
          child: Icon(item.icon, color: item.color),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(item.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.page),
          );
        },
      ),
    );
  }
}
