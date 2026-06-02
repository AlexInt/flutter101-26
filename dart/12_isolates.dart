/// ============================================================
/// 12 - Isolate：Dart 的多线程并行计算
/// ============================================================
/// Dart 是单线程的（基于 event loop），但可以通过 Isolate
/// 实现真正的多线程并行计算。
///
/// 核心概念：
/// - 每个 Isolate 有自己独立的内存空间和 event loop
/// - Isolate 之间不共享内存，只能通过消息通信
/// - 类似 iOS 的 GCD / Android 的线程池，但更安全（无锁）
///
/// 对比：
/// - Swift:  DispatchQueue / Task (Swift Concurrency)
/// - TS:     Web Worker / Worker Threads (Node.js)
/// - Java:   Thread / ExecutorService
/// - Dart:   Isolate（独立内存 + 消息传递）
///
/// 💡 运行方式：dart run 12_isolates.dart
/// ⚠️ 注意：Isolate 在 Flutter Web 上不可用（Web 用 Web Worker）
/// ============================================================

import 'dart:isolate';
import 'dart:math';

Future<void> main() async {
  // ─────────────────────────────────────────
  // 1. 为什么需要 Isolate？
  // ─────────────────────────────────────────

  // Dart 主线程（main isolate）同时处理 UI 渲染和代码逻辑
  // 如果执行 CPU 密集型任务，UI 就会卡顿（掉帧）
  //
  // 场景举例：
  // - 解析超大 JSON 文件（> 1MB）
  // - 图片压缩/处理
  // - 复杂数学计算（加密、哈希）
  // - 数据库大量数据处理
  //
  // 解决方案：把这些任务放到另一个 Isolate 中执行

  print('--- 主线程阻塞演示 ---');

  // 模拟 CPU 密集任务（会阻塞主线程）
  var stopwatch = Stopwatch()..start();
  var sumSync = heavyComputation(40000000);
  stopwatch.stop();
  print('同步计算结果: $sumSync, 耗时: ${stopwatch.elapsedMilliseconds}ms');
  print('⚠️ 这段时间内主线程完全被阻塞！UI 无法响应');

  // ─────────────────────────────────────────
  // 2. Isolate.run()（Dart 2.19+ 推荐方式）⭐
  // ─────────────────────────────────────────

  // 最简单的方式：把计算丢到另一个 Isolate 执行
  // 类似 Swift 的 Task.detached 或 DispatchQueue.global().async

  print('\n--- Isolate.run()（推荐）---');

  stopwatch.reset();
  stopwatch.start();
  // Isolate.run() 会自动创建 Isolate、执行函数、返回结果、销毁 Isolate
  var sumAsync = await Isolate.run(() => heavyComputation(40000000));
  stopwatch.stop();
  print('Isolate 计算结果: $sumAsync, 耗时: ${stopwatch.elapsedMilliseconds}ms');
  print('✅ 主线程不会被阻塞！');

  // ─────────────────────────────────────────
  // 3. 多个 Isolate 并行计算
  // ─────────────────────────────────────────

  print('\n--- 多 Isolate 并行 ---');

  stopwatch.reset();
  stopwatch.start();

  // 同时启动多个 Isolate 并行计算（类似 Promise.all 但是真正并行）
  var results = await Future.wait([
    Isolate.run(() => heavyComputation(20000000)),
    Isolate.run(() => heavyComputation(20000000)),
    Isolate.run(() => heavyComputation(20000000)),
  ]);
  stopwatch.stop();
  print('3个 Isolate 并行结果: $results');
  print('总耗时: ${stopwatch.elapsedMilliseconds}ms（接近单个的耗时，因为是并行）');

  // ─────────────────────────────────────────
  // 4. Isolate.spawn()（更底层的控制）
  // ─────────────────────────────────────────

  // 适合需要长期运行的 Isolate 或需要多次通信的场景

  print('\n--- Isolate.spawn()（底层 API）---');

  // 创建一个接收端口，用于接收 Isolate 发来的消息
  var receivePort = ReceivePort();

  // 启动一个新的 Isolate，传入接收端口的 sendPort
  var isolate = await Isolate.spawn(
    _isolateEntry,        // Isolate 的入口函数
    receivePort.sendPort, // 传递给新 Isolate 的参数
  );

  // 监听来自 Isolate 的消息
  await for (var message in receivePort) {
    print('收到消息: $message');
    if (message == 'done') break;
  }

  // 清理资源
  receivePort.close();
  isolate.kill(priority: Isolate.immediate);

  // ─────────────────────────────────────────
  // 5. 双向通信（SendPort / ReceivePort）
  // ─────────────────────────────────────────

  // Isolate 之间通过 SendPort 发送消息，ReceivePort 接收消息
  // 类似 iOS 的 NSXPCConnection 或 Android 的 Messenger

  print('\n--- 双向通信 ---');

  var mainReceivePort = ReceivePort();

  await Isolate.spawn(
    _bidirectionalEntry,
    mainReceivePort.sendPort,
  );

  // 先拿到新 Isolate 的 SendPort
  var isolateSendPort = await mainReceivePort.first as SendPort;

  // 创建一个新的接收端口来接收后续消息
  var responsePort = ReceivePort();

  // 通过 SendPort 向 Isolate 发送请求
  isolateSendPort.send({'command': 'calculate', 'value': 42, 'replyTo': responsePort.sendPort});

  var response = await responsePort.first;
  print('计算响应: $response');  // 42 * 42 = 1764

  responsePort.close();
  mainReceivePort.close();

  // ─────────────────────────────────────────
  // 6. 实际应用：JSON 解析（Flutter 常见场景）
  // ─────────────────────────────────────────

  print('\n--- 模拟 JSON 大文件解析 ---');

  // 模拟一个大的 JSON 字符串
  var largeJson = _generateLargeJson(10000);
  print('JSON 字符串长度: ${largeJson.length} 字符');

  stopwatch.reset();
  stopwatch.start();
  // 在主线程解析（会阻塞）
  var mainResult = _parseJson(largeJson);
  stopwatch.stop();
  print('主线程解析耗时: ${stopwatch.elapsedMilliseconds}ms');

  stopwatch.reset();
  stopwatch.start();
  // 在 Isolate 中解析（不阻塞主线程）
  var isolateResult = await Isolate.run(() => _parseJson(largeJson));
  stopwatch.stop();
  print('Isolate 解析耗时: ${stopwatch.elapsedMilliseconds}ms');
  print('解析结果条数: ${isolateResult.length}');

  // ─────────────────────────────────────────
  // 7. compute()（Flutter 提供的便捷方法）
  // ─────────────────────────────────────────

  // Flutter 的 foundation 库提供了 compute() 函数
  // 本质上是 Isolate.spawn 的封装，用起来更简洁
  //
  // import 'package:flutter/foundation.dart';
  //
  // var result = await compute(heavyComputation, 40000000);
  //
  // ⚠️ 注意：compute() 传入的函数必须是顶层函数或静态方法
  //    不能是闭包（因为闭包捕获了外部变量，无法跨 Isolate 传递）

  // ─────────────────────────────────────────
  // 8. Isolate 的限制与注意事项
  // ─────────────────────────────────────────

  print('\n--- Isolate 注意事项 ---');
  print('1. Isolate 之间不共享内存（无法直接传递对象引用）');
  print('2. 传递的数据会被深拷贝（大对象传递有性能开销）');
  print('3. 不能使用闭包作为 Isolate 入口函数');
  print('4. 不能传递 Socket、File 等系统资源');
  print('5. 每个 Isolate 约 1-2MB 内存开销，不要创建太多');
  print('6. Flutter Web 不支持 Isolate（用 Web Worker 替代）');

  // ─────────────────────────────────────────
  // 9. Isolate 命名与调试
  // ─────────────────────────────────────────

  print('\n--- Isolate 调试信息 ---');
  var debugInfo = await Isolate.run(() {
    return 'Isolate name: ${Isolate.current.debugName}';
  }, debugName: 'MyWorkerIsolate');
  print(debugInfo);

  print('\n💡 总结：');
  print('- 简单任务：用 Isolate.run()，一行搞定');
  print('- 需要多次通信：用 Isolate.spawn() + SendPort/ReceivePort');
  print('- Flutter 项目：用 compute() 最方便');
  print('- 性能敏感：考虑 TransferableTypedData 避免深拷贝');
}

// ═══════════════════════════════════════════
// 辅助函数
// ═══════════════════════════════════════════

/// CPU 密集型计算（求和 1+2+...+n）
int heavyComputation(int n) {
  var sum = 0;
  for (var i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

/// Isolate.spawn 的入口函数（必须是顶层函数或静态方法）
void _isolateEntry(SendPort sendPort) {
  // 在新 Isolate 中执行的代码
  var result = 0;
  for (var i = 0; i < 5; i++) {
    result += i;
    sendPort.send('进度: $i, 累计: $result');
  }
  sendPort.send('done');
}

/// 双向通信的入口函数
void _bidirectionalEntry(SendPort mainSendPort) {
  var isolateReceivePort = ReceivePort();
  // 把自己的 SendPort 发给主 Isolate
  mainSendPort.send(isolateReceivePort.sendPort);

  // 监听主 Isolate 发来的请求
  isolateReceivePort.listen((message) {
    if (message is Map) {
      var command = message['command'];
      var value = message['value'] as int;
      var replyTo = message['replyTo'] as SendPort;

      if (command == 'calculate') {
        replyTo.send(value * value);
      }
    }
  });
}

/// 生成模拟的大型 JSON 字符串
String _generateLargeJson(int count) {
  var buffer = StringBuffer('[');
  for (var i = 0; i < count; i++) {
    if (i > 0) buffer.write(',');
    buffer.write('{"id":$i,"name":"item_$i","value":${i * 3.14}}');
  }
  buffer.write(']');
  return buffer.toString();
}

/// 简单的 JSON 解析（模拟，不依赖 dart:convert 避免 Isolate 限制演示）
List<Map<String, dynamic>> _parseJson(String jsonStr) {
  // 这里简化为只统计条数（实际项目用 jsonDecode）
  var count = 0;
  var i = 0;
  while ((i = jsonStr.indexOf('"id"', i)) != -1) {
    count++;
    i++;
  }
  // 模拟一些 CPU 开销
  var random = Random(count);
  for (var j = 0; j < 100000; j++) {
    random.nextDouble();
  }
  return List.generate(count, (i) => {'id': i, 'name': 'item_$i'});
}

// 💡 Isolate 架构示意：
//
//  ┌─────────────────────┐     ┌─────────────────────┐
//  │   Main Isolate       │     │   Worker Isolate     │
//  │                     │     │                     │
//  │  ┌───────────────┐  │     │  ┌───────────────┐  │
//  │  │  Event Loop   │  │     │  │  Event Loop   │  │
//  │  │  ┌─────────┐  │  │     │  │  ┌─────────┐  │  │
//  │  │  │Microtask │  │  │     │  │  │Microtask │  │  │
//  │  │  │  Queue   │  │  │     │  │  │  Queue   │  │  │
//  │  │  └─────────┘  │  │     │  │  └─────────┘  │  │
//  │  │  ┌─────────┐  │  │     │  │  ┌─────────┐  │  │
//  │  │  │ Event   │  │  │     │  │  │ Event   │  │  │
//  │  │  │  Queue   │  │  │     │  │  │  Queue   │  │  │
//  │  │  └─────────┘  │  │     │  │  └─────────┘  │  │
//  │  └───────────────┘  │     │  └───────────────┘  │
//  │                     │     │                     │
//  │  独立内存空间 A       │     │  独立内存空间 B       │
//  │  (不能直接访问 B)    │     │  (不能直接访问 A)    │
//  └────────┬────────────┘     └────────┬────────────┘
//           │      SendPort/ReceivePort  │
//           └──────────消息通信──────────┘
