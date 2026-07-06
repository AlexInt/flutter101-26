import 'package:flutter/material.dart';

class PipelinePage extends StatefulWidget {
  const PipelinePage({super.key});

  @override
  State<PipelinePage> createState() => _PipelinePageState();
}

class _PipelinePageState extends State<PipelinePage> {
  int _counter = 0;
  int _buildCount = 0;
  int _layoutCount = 0;
  int _paintCount = 0;
  List<String> _logs = [];
  bool _isAutoAnimating = false;
  int _currentStage = -1;

  final List<_StageInfo> _stages = const [
    _StageInfo('Build', '构建 Widget 树', Icons.build, Colors.blue),
    _StageInfo('Layout', '计算布局大小', Icons.straighten, Colors.orange),
    _StageInfo('Paint', '绘制到 Layer', Icons.brush, Colors.green),
    _StageInfo('Composite', '合成上屏', Icons.layers, Colors.purple),
  ];

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '[${DateTime.now().millisecondsSinceEpoch % 10000}] $message');
      if (_logs.length > 30) _logs = _logs.sublist(0, 30);
    });
  }

  Future<void> _runPipeline() async {
    if (_isAutoAnimating) return;
    _isAutoAnimating = true;

    for (int i = 0; i < _stages.length; i++) {
      setState(() {
        _currentStage = i;
      });
      _addLog('▶ 开始阶段: ${_stages[i].name} - ${_stages[i].desc}');
      await Future.delayed(const Duration(milliseconds: 800));
    }

    setState(() {
      _counter++;
      _buildCount++;
      _layoutCount++;
      _paintCount++;
      _currentStage = -1;
    });
    _addLog('✅ 一帧完成！counter = $_counter');
    _isAutoAnimating = false;
  }

  void _triggerRebuild() {
    setState(() {
      _counter++;
      _buildCount++;
    });
    _addLog('🔵 setState() → 标记 dirty，等待下一帧重建');
  }

  void _triggerRelayout() {
    setState(() {
      _layoutCount++;
    });
    _addLog('🟠 markNeedsLayout() → 标记需要重新布局');
  }

  void _triggerRepaint() {
    setState(() {
      _paintCount++;
    });
    _addLog('🟢 markNeedsPaint() → 标记需要重新绘制');
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('渲染流水线'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildPipelineVisual(),
            const SizedBox(height: 16),
            _buildControlButtons(),
            const SizedBox(height: 16),
            _buildDemoWidget(),
            const SizedBox(height: 16),
            _buildLogPanel(),
            const SizedBox(height: 16),
            _buildConstraintsExplainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 渲染统计',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('Build', _buildCount, Colors.blue),
                _statItem('Layout', _layoutCount, Colors.orange),
                _statItem('Paint', _paintCount, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPipelineVisual() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔄 渲染流水线动画',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (int i = 0; i < _stages.length; i++) ...[
                  Expanded(child: _stageCard(i)),
                  if (i < _stages.length - 1)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stageCard(int index) {
    final stage = _stages[index];
    final isActive = _currentStage == index;
    final isDone = _currentStage > index;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? stage.color.withOpacity(0.15)
            : isDone
                ? Colors.green.withOpacity(0.08)
                : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? stage.color
              : isDone
                  ? Colors.green
                  : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isDone ? Icons.check_circle : stage.icon,
            color: isActive
                ? stage.color
                : isDone
                    ? Colors.green
                    : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            stage.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? stage.color
                  : isDone
                      ? Colors.green
                      : Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stage.desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🎮 控制面板',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _runPipeline,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('播放完整流水线'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                OutlinedButton.icon(
                  onPressed: _triggerRebuild,
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  label: const Text('setState (Build)'),
                ),
                OutlinedButton.icon(
                  onPressed: _triggerRelayout,
                  icon: const Icon(Icons.straighten, color: Colors.orange),
                  label: const Text('markNeedsLayout'),
                ),
                OutlinedButton.icon(
                  onPressed: _triggerRepaint,
                  icon: const Icon(Icons.brush, color: Colors.green),
                  label: const Text('markNeedsPaint'),
                ),
                TextButton.icon(
                  onPressed: _clearLogs,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('清空日志'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 实际 Widget 演示',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '点击下方按钮，观察控制台日志和统计数字变化',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Center(
              child: _TrackedContainer(
                counter: _counter,
                onBuild: () => _addLog('  🔵 build() 被调用'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _triggerRebuild,
                child: Text('Counter: $_counter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📝 渲染日志',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${_logs.length} 条',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _logs.isEmpty ? 1 : _logs.length,
                itemBuilder: (context, index) {
                  if (_logs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '等待操作...\n点击上方按钮触发渲染',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _logs[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.greenAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConstraintsExplainer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📐 约束原理：Constraints go down, Sizes go up',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            _ConstraintStep(
              step: '1',
              title: '约束向下传递',
              desc: '父节点给子节点传约束（最大/最小宽高），子节点必须遵守。',
              direction: '↓',
              color: Colors.blue,
            ),
            _ConstraintStep(
              step: '2',
              title: '尺寸向上返回',
              desc: '子节点在约束内决定自己的大小，然后把尺寸告诉父节点。',
              direction: '↑',
              color: Colors.green,
            ),
            _ConstraintStep(
              step: '3',
              title: '父节点决定位置',
              desc: '父节点拿到所有子节点的尺寸后，决定每个子节点放在哪里。',
              direction: '📍',
              color: Colors.orange,
            ),
            SizedBox(height: 12),
            Text(
              '⭐ 关键理解：Flutter 的布局是单次遍历（O(n)），从上往下传约束，从下往上传尺寸，父节点最终决定位置。这就是为什么 Flutter 布局性能这么好。',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageInfo {
  final String name;
  final String desc;
  final IconData icon;
  final Color color;

  const _StageInfo(this.name, this.desc, this.icon, this.color);
}

class _ConstraintStep extends StatelessWidget {
  final String step;
  final String title;
  final String desc;
  final String direction;
  final Color color;

  const _ConstraintStep({
    required this.step,
    required this.title,
    required this.desc,
    required this.direction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
                Row(
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
                    const SizedBox(width: 8),
                    Text(direction, style: TextStyle(fontSize: 18, color: color)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 追踪 build 调用的自定义 Widget
class _TrackedContainer extends StatefulWidget {
  final int counter;
  final VoidCallback onBuild;

  const _TrackedContainer({required this.counter, required this.onBuild});

  @override
  State<_TrackedContainer> createState() => _TrackedContainerState();
}

class _TrackedContainerState extends State<_TrackedContainer> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onBuild();
    });

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1 + (widget.counter % 10) * 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.widgets, color: Colors.blue, size: 32),
            const SizedBox(height: 4),
            Text(
              'Value: ${widget.counter}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
