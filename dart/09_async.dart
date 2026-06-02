/// ============================================================
/// 09 - 异步编程：Future、async/await、Stream
/// ============================================================
/// Dart 是单线程的（有 event loop），异步编程是核心能力。
///
/// 对比：
/// - TS:    Promise / async-await / Observable (RxJS)
/// - Swift: Combine (Publisher/Subscriber) / async-await (Swift 5.5)
/// - Dart:  Future / async-await / Stream
///
/// 💡 运行方式：dart run 09_async.dart
/// ============================================================

import 'dart:async';

Future<void> main() async {
  // ─────────────────────────────────────────
  // 1. Future（类似 TS 的 Promise）
  // ─────────────────────────────────────────

  // Future 表示一个异步操作的结果
  // 状态：未完成(pending) → 完成(completed with value) / 失败(completed with error)

  // 基本用法
  print('--- Future 基本用法 ---');
  var future = fetchData();
  print('请求已发送...');  // 先打印这个
  var data = await future;  // 等待结果
  print('收到数据: $data');

  // ─────────────────────────────────────────
  // 2. async/await（和 TS 几乎一样！）
  // ─────────────────────────────────────────

  print('\n--- async/await ---');
  var user = await fetchUser(1);
  print('User: ${user['name']}');

  // 多个异步操作
  var profile = await fetchProfile(user['id'] as int);
  print('Profile: $profile');

  // 链式异步操作（优雅写法）
  var fullData = await _loadUserFullData(1);
  print('Full data: $fullData');

  // ─────────────────────────────────────────
  // 3. Future 的链式调用（类似 Promise.then）
  // ─────────────────────────────────────────

  print('\n--- Future 链式调用 ---');

  // then 链（不推荐，async/await 更清晰）
  fetchData()
      .then((data) => 'Processed: $data')
      .then((result) => print(result))
      .catchError((error) => print('Error: $error'));

  // ─────────────────────────────────────────
  // 4. 并发执行多个 Future
  // ─────────────────────────────────────────

  print('\n--- 并发执行 ---');

  // Future.wait：等待所有 Future 完成（类似 Promise.all）
  var results = await Future.wait([
    fetchData(),
    fetchUser(2),
    fetchProfile(2),
  ]);
  print('All done: ${results.length} results');

  // Future.any：返回最先完成的结果（类似 Promise.race）
  var fastest = await Future.any([
    _delayedResult('slow', Duration(seconds: 2)),
    _delayedResult('fast', Duration(milliseconds: 100)),
    _delayedResult('medium', Duration(seconds: 1)),
  ]);
  print('Fastest: $fastest');

  // ─────────────────────────────────────────
  // 5. Stream（数据流）⭐
  // ─────────────────────────────────────────

  // Stream 是异步事件的序列（类似 TS 的 Observable，Swift 的 AsyncSequence）
  // Flutter 中 StreamBuilder 大量使用

  print('\n--- Stream 基本用法 ---');

  // 监听 Stream
  var stream = countStream(5);
  await for (var value in stream) {
    print('Stream value: $value');
  }

  // ─────────────────────────────────────────
  // 6. Stream 的变换操作
  // ─────────────────────────────────────────

  print('\n--- Stream 变换 ---');

  // map / where / take（和 List 操作类似）
  var numbers = countStream(10);
  var processed = numbers
      .where((n) => n % 2 == 0)       // 偶数
      .map((n) => n * 10)             // 乘10
      .take(3);                        // 只取3个

  await for (var value in processed) {
    print('Processed: $value');  // 20, 40, 60
  }

  // ─────────────────────────────────────────
  // 7. StreamController（手动控制流）
  // ─────────────────────────────────────────

  print('\n--- StreamController ---');

  var controller = StreamController<String>();

  // 监听
  controller.stream.listen(
    (data) => print('Received: $data'),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Stream closed'),
  );

  // 添加数据
  controller.add('Hello');
  controller.add('World');
  controller.addError('Oops!');
  controller.close();

  // 等待所有事件处理完
  await Future.delayed(Duration(milliseconds: 100));

  // ─────────────────────────────────────────
  // 8. broadcast stream（多监听者）
  // ─────────────────────────────────────────

  print('\n--- Broadcast Stream ---');

  var broadcastController = StreamController<String>.broadcast();

  // 可以有多个监听者（普通 stream 只能有一个）
  broadcastController.stream.listen((data) => print('Listener 1: $data'));
  broadcastController.stream.listen((data) => print('Listener 2: $data'));

  broadcastController.add('Hello everyone!');
  await Future.delayed(Duration(milliseconds: 100));
  broadcastController.close();

  // ─────────────────────────────────────────
  // 9. 实际应用：模拟网络请求
  // ─────────────────────────────────────────

  print('\n--- 模拟实际场景 ---');

  // 模拟登录 → 获取用户信息 → 获取订单列表
  try {
    var token = await login('admin', '123');
    print('Login token: $token');

    var userInfo = await getUserInfo(token);
    print('User info: $userInfo');

    var orders = await getOrders(token);
    print('Orders: $orders');
  } catch (e) {
    print('Login failed: $e');
  }

  // ─────────────────────────────────────────
  // 10. 超时处理
  // ─────────────────────────────────────────

  print('\n--- 超时处理 ---');
  try {
    var result = await fetchData()
        .timeout(Duration(seconds: 2));
    print('With timeout: $result');
  } catch (e) {
    print('Timeout: $e');
  }
}

// ═══════════════════════════════════════════
// 模拟异步函数
// ═══════════════════════════════════════════

/// 模拟网络请求
Future<String> fetchData() async {
  await Future.delayed(Duration(milliseconds: 500));
  return 'Server data loaded!';
}

/// 模拟获取用户信息
Future<Map<String, dynamic>> fetchUser(int id) async {
  await Future.delayed(Duration(milliseconds: 300));
  return {'id': id, 'name': 'User $id', 'age': 25};
}

/// 模拟获取用户详情
Future<Map<String, dynamic>> fetchProfile(int userId) async {
  await Future.delayed(Duration(milliseconds: 200));
  return {'userId': userId, 'email': 'user$userId@example.com', 'role': 'admin'};
}

/// 链式异步
Future<Map<String, dynamic>> _loadUserFullData(int id) async {
  var user = await fetchUser(id);
  var profile = await fetchProfile(user['id'] as int);
  return {...user, ...profile};  // 合并两个 Map
}

/// 延迟返回结果
Future<String> _delayedResult(String label, Duration delay) async {
  await Future.delayed(delay);
  return label;
}

/// 模拟 Stream（类似定时器发出的事件）
Stream<int> countStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    yield i;  // yield 发出一个值（类似 Swift 的 AsyncSequence）
  }
}

// ─────────────────────────────────────────
// 模拟登录流程
// ─────────────────────────────────────────

Future<String> login(String username, String password) async {
  await Future.delayed(Duration(milliseconds: 500));
  if (username == 'admin' && password == '123') {
    return 'token_abc123';
  }
  throw Exception('Invalid credentials');
}

Future<Map<String, String>> getUserInfo(String token) async {
  await Future.delayed(Duration(milliseconds: 300));
  return {'name': 'Admin', 'email': 'admin@example.com'};
}

Future<List<String>> getOrders(String token) async {
  await Future.delayed(Duration(milliseconds: 200));
  return ['Order #001', 'Order #002', 'Order #003'];
}

// 💡 async* vs async:
// - async 函数返回 Future<T>，产生单个异步结果
// - async* 函数返回 Stream<T>，产生异步事件序列
// - yield 发出单个值（类似 Stream 的 add）
// - yield* 发出另一个 Stream 的所有值
