import 'package:flutter/material.dart';

class ThreeTreesPage extends StatefulWidget {
  const ThreeTreesPage({super.key});

  @override
  State<ThreeTreesPage> createState() => _ThreeTreesPageState();
}

class _ThreeTreesPageState extends State<ThreeTreesPage> {
  int _counter = 0;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('🔵 [Widget build] ThreeTreesPage build 被调用');
    return Scaffold(
      appBar: AppBar(
        title: const Text('三棵树原理'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConceptCard(),
            const SizedBox(height: 16),
            _buildDemoSection(),
            const SizedBox(height: 16),
            _buildTreeComparison(),
            const SizedBox(height: 16),
            _buildLifecycleExplainer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConceptCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget → Element → RenderObject',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flutter 的渲染由三棵树协作完成：',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildTreeRow(
              Icons.widgets,
              Colors.blue,
              'Widget 树',
              '配置信息（蓝图），轻量，可频繁创建销毁。每帧可能都在变。',
            ),
            const SizedBox(height: 8),
            _buildTreeRow(
              Icons.account_tree,
              Colors.green,
              'Element 树',
              '连接 Widget 和 RenderObject 的桥梁。管理生命周期、更新逻辑。',
            ),
            const SizedBox(height: 8),
            _buildTreeRow(
              Icons.brush,
              Colors.orange,
              'RenderObject 树',
              '真正负责布局、绘制的对象。重量级，尽量复用。',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeRow(IconData icon, Color color, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: 20,
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDemoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 交互演示：点击 + 观察重建',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'CounterWidget（自定义 Widget）',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  _CounterDisplay(value: _counter),
                  const SizedBox(height: 8),
                  Text(
                    '当前值: $_counter',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
              icon: Icon(_showDetails ? Icons.expand_less : Icons.expand_more),
              label: Text(_showDetails ? '收起代码说明' : '查看代码与说明'),
            ),
            if (_showDetails) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 发生了什么？', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('1. 点击 FAB → setState() 标记 Element 为 dirty'),
                    Text('2. 下一帧 → Element 调用 rebuild()'),
                    Text('3. build() 方法返回 新的 Widget 树（配置）'),
                    Text('4. Element 对比新旧 Widget：类型相同 → 更新，不同 → 重建'),
                    Text('5. RenderObject 根据更新重新 layout / paint'),
                    SizedBox(height: 8),
                    Text('⭐ 关键点：', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('• Widget 是"蓝图"，每次 build 都可能重新创建'),
                    Text('• Element 是"工人"，对比蓝图，更新 RenderObject'),
                    Text('• RenderObject 是"画家"，真正做布局和绘制，尽量复用'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTreeComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📊 三棵树对比表',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            _ComparisonTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildLifecycleExplainer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🔄 Element 生命周期',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            _LifecycleStep(
              step: '1',
              title: 'createElement()',
              desc: 'Widget 调用 createElement 创建 Element',
              color: Colors.green,
            ),
            _LifecycleStep(
              step: '2',
              title: 'mount()',
              desc: 'Element 被插入到树中，调用 firstBuild()',
              color: Colors.blue,
            ),
            _LifecycleStep(
              step: '3',
              title: 'update()',
              desc: 'Widget 配置变化时，Element 对比并更新 RenderObject',
              color: Colors.orange,
            ),
            _LifecycleStep(
              step: '4',
              title: 'deactivate() / unmount()',
              desc: 'Element 被移除出树，最终销毁',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterDisplay extends SingleChildRenderObjectWidget {
  final int value;

  const _CounterDisplay({required this.value});

  @override
  RenderObject createRenderObject(BuildContext context) {
    debugPrint('🟢 [RenderObject create] _CounterDisplay createRenderObject');
    return _RenderCounterDisplay(value);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCounterDisplay renderObject) {
    debugPrint('🟡 [RenderObject update] _CounterDisplay updateRenderObject, value: $value');
    renderObject.value = value;
  }
}

class _RenderCounterDisplay extends RenderBox {
  int _value;

  _RenderCounterDisplay(this._value);

  int get value => _value;

  set value(int newValue) {
    if (_value != newValue) {
      _value = newValue;
      markNeedsLayout();
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    debugPrint('📐 [Layout] _RenderCounterDisplay performLayout');
    size = const Size(200, 60);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    debugPrint('🎨 [Paint] _RenderCounterDisplay paint, value: $_value');
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = offset & size;
    context.canvas.drawRect(rect.deflate(1), paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Value: $_value',
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      context.canvas,
      offset + Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.2),
      },
      border: TableBorder.all(color: Colors.grey[300]!, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[100]),
          children: const [
            _TableCell(text: '特性', isHeader: true),
            _TableCell(text: 'Widget', isHeader: true, color: Colors.blue),
            _TableCell(text: 'Element', isHeader: true, color: Colors.green),
            _TableCell(text: 'RenderObject', isHeader: true, color: Colors.orange),
          ],
        ),
        const TableRow(children: [
          _TableCell(text: '职责'),
          _TableCell(text: '配置/蓝图', color: Colors.blue),
          _TableCell(text: '桥接/管理', color: Colors.green),
          _TableCell(text: '布局/绘制', color: Colors.orange),
        ]),
        const TableRow(children: [
          _TableCell(text: '重量级'),
          _TableCell(text: '轻量', color: Colors.blue),
          _TableCell(text: '中等', color: Colors.green),
          _TableCell(text: '重量级', color: Colors.orange),
        ]),
        const TableRow(children: [
          _TableCell(text: '创建频率'),
          _TableCell(text: '频繁（每帧）', color: Colors.blue),
          _TableCell(text: '较少（复用）', color: Colors.green),
          _TableCell(text: '很少（尽量复用）', color: Colors.orange),
        ]),
        const TableRow(children: [
          _TableCell(text: '是否可变'),
          _TableCell(text: '不可变（immutable）', color: Colors.blue),
          _TableCell(text: '可变', color: Colors.green),
          _TableCell(text: '可变', color: Colors.orange),
        ]),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final Color? color;

  const _TableCell({required this.text, this.isHeader = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: color ?? (isHeader ? Colors.black87 : Colors.black54),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LifecycleStep extends StatelessWidget {
  final String step;
  final String title;
  final String desc;
  final Color color;

  const _LifecycleStep({
    required this.step,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withOpacity(0.2),
            child: Text(step, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
