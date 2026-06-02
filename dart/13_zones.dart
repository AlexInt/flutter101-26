/// ============================================================
/// 13 - Zone：Dart 的异步执行区域与错误隔离
/// ============================================================
/// Zone 是 Dart 中一个容易被忽视但非常重要的概念。
/// 它是异步回调的执行环境，可以拦截未捕获的异常、
/// 打印日志、注入变量等。
///
/// 核心作用：
/// 1. 捕获异步中未处理的异常（Flutter 崩溃监控的核心）
/// 2. 为异步代码注入上下文变量（类似 Swift 的 EnvironmentValues）
/// 3. 拦截/重写 print 等全局函数
/// 4. 自定义异步回调的错误处理行为
///
/// 对比：
/// - Node.js: process.on('uncaughtException'), AsyncLocalStorage
/// - Swift:   没有直接等价物，类似 Combine 的 catch 或 TaskGroup
/// - TS:      try-catch + AsyncLocalStorage (Node 14+)
/// - Dart:    Zone / runZonedGuarded / runZoned
///
/// 💡 运行方式：dart run 13_zones.dart
/// ============================================================

import 'dart:async';

Future<void> main() async {
  // ─────────────────────────────────────────
  // 1. 什么是 Zone？
  // ─────────────────────────────────────────

  // Zone 是 Dart 异步代码的执行上下文
  // 每个异步回调（Future.then、Timer、Stream.listen）
  // 都在创建它的那个 Zone 中执行
  //
  // 类比理解：
  // - Zone 就像一个"房间"，你在房间里设置的规则
  //   对房间里所有异步操作都生效
  // - 子 Zone 可以继承父 Zone 的设置，也可以覆盖

  print('--- Zone 基本概念 ---');
  print('当前 Zone: ${Zone.current}');  // 根 Zone

  // runZoned：在指定的 Zone 中运行代码
  runZoned(() {
    print('在自定义 Zone 中运行');
    print('当前 Zone: ${Zone.current}');
  });

  // ─────────────────────────────────────────
  // 2. runZonedGuarded：捕获未处理的异常 ⭐
  // ─────────────────────────────────────────

  // 这是 Zone 最重要的用途！
  // Flutter 的 FlutterError.onError 和 Crashlytics 都基于此

  print('\n--- runZonedGuarded（全局异常捕获）---');

  // ❌ 不用 Zone 的情况：未捕获的异步异常会导致程序崩溃
  // Future.microtask(() => throw Exception('未捕获的异常！'));

  // ✅ 使用 runZonedGuarded：所有未捕获的异常都会被拦截
  runZonedGuarded(() {
    // 在这个 Zone 中运行的所有代码
    // 如果有未捕获的异常，会被下面的 onError 回调捕获

    // 模拟一个未处理的异步异常
    Future.delayed(Duration(milliseconds: 100), () {
      throw Exception('异步任务中的未捕获异常');
    });

    // 模拟微任务中的异常
    scheduleMicrotask(() {
      throw Exception('微任务中的未捕获异常');
    });

    print('（等待异步异常被捕获...）');
  }, (error, stackTrace) {
    // 所有未捕获的异常都会到这里
    print('🚨 捕获到未处理异常: $error');
    // 实际项目中：上报到 Crashlytics / Sentry
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });

  // 等待异步操作完成
  await Future.delayed(Duration(milliseconds: 300));

  // ─────────────────────────────────────────
  // 3. Zone 拦截 print（自定义日志）
  // ─────────────────────────────────────────

  print('\n--- Zone 拦截 print ---');

  // 可以在 Zone 中拦截 print，统一添加前缀、写入文件等
  runZoned(
    () {
      print('普通日志');         // 实际输出: [LOG] 普通日志
      print('调试信息');         // 实际输出: [LOG] 调试信息

      // 嵌套 Zone 可以进一步定制
      runZoned(() {
        print('嵌套 Zone 日志'); // 实际输出: [DEBUG] 嵌套 Zone 日志
      }, zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          parent.print(zone, '[DEBUG] $line');
        },
      ));
    },
    zoneSpecification: ZoneSpecification(
      // 拦截 print 函数
      print: (self, parent, zone, line) {
        // self: 当前 Zone
        // parent: 父 Zone（可以用 parent.print 输出到真实控制台）
        // line: 原始打印内容
        parent.print(zone, '[LOG] $line');
      },
    ),
  );

  // ─────────────────────────────────────────
  // 4. Zone Values（注入上下文变量）
  // ─────────────────────────────────────────

  // 类似 React Context / Swift EnvironmentValues / TS AsyncLocalStorage
  // 在 Zone 中设置的值，该 Zone 内所有异步回调都能访问

  print('\n--- Zone Values（上下文注入）---');

  // 定义 Zone 的 key（通常用私有变量）
  const requestIdKey = #requestId;
  const userIdKey = #userId;

  await runZoned(() async {
    // Zone 内的任何地方（包括异步回调）都能拿到这些值
    print('Request ID: ${Zone.current[requestIdKey]}');
    print('User ID: ${Zone.current[userIdKey]}');

    // 即使在异步回调中也能访问（Zone 会自动传递）
    await Future.delayed(Duration(milliseconds: 50), () {
      print('异步回调中 - Request ID: ${Zone.current[requestIdKey]}');
    });

    // 嵌套的异步操作也能访问
    await _nestedAsyncCall();
  }, zoneValues: {
    requestIdKey: 'REQ-001',
    userIdKey: 'User-42',
  });

  // ─────────────────────────────────────────
  // 5. Zone 拦截 Future 和 Timer
  // ─────────────────────────────────────────

  print('\n--- Zone 拦截 Future/Timer ---');

  var futureCount = 0;
  var timerCount = 0;

  await runZoned(() async {
    // 在这个 Zone 中创建的所有 Future 和 Timer 都会被追踪
    await Future.value(42);
    await Future.delayed(Duration(milliseconds: 50));
    Timer(Duration(milliseconds: 10), () {});
    Timer(Duration(milliseconds: 20), () {});

    // 等待 Timer 执行完
    await Future.delayed(Duration(milliseconds: 100));
  }, zoneSpecification: ZoneSpecification(
    // 拦截 Future 的创建
    registerCallback: <R>(self, parent, zone, f) {
      futureCount++;
      return parent.registerCallback(zone, f);
    },
    // 拦截 Timer 的创建
    createTimer: (self, parent, zone, duration, callback) {
      timerCount++;
      return parent.createTimer(zone, duration, callback);
    },
    createPeriodicTimer: (self, parent, zone, period, callback) {
      timerCount++;
      return parent.createPeriodicTimer(zone, period, callback);
    },
  ));

  print('Zone 中创建的回调数: $futureCount');
  print('Zone 中创建的 Timer 数: $timerCount');

  // ─────────────────────────────────────────
  // 6. Flutter 中的实际应用 ⭐
  // ─────────────────────────────────────────

  print('\n--- Flutter 实际应用场景 ---');

  // 场景 1：全局错误捕获（main.dart 中的标准写法）
  //
  // void main() {
  //   runZonedGuarded(() {
  //     runApp(MyApp());
  //   }, (error, stackTrace) {
  //     // 上报到 Crashlytics / Sentry / 自建监控系统
  //     FirebaseCrashlytics.instance.recordError(error, stackTrace);
  //   });
  // }

  // 场景 2：FlutterError.onError（Widget 层错误）
  //
  // void main() {
  //   FlutterError.onError = (details) {
  //     // Widget build 过程中的错误
  //     FirebaseCrashlytics.instance.recordFlutterError(details);
  //   };
  //
  //   runZonedGuarded(() {
  //     runApp(MyApp());
  //   }, (error, stackTrace) {
  //     // 异步错误（Zone 未捕获的）
  //     FirebaseCrashlytics.instance.recordError(error, stackTrace);
  //   });
  // }

  // 场景 3：自定义日志系统
  //
  // runZoned(() {
  //   runApp(MyApp());
  // }, zoneSpecification: ZoneSpecification(
  //   print: (self, parent, zone, line) {
  //     // 统一日志格式，写入文件、上报等
  //     final timestamp = DateTime.now().toIso8601String();
  //     parent.print(zone, '[$timestamp] $line');
  //     // FileLogger.write(line);  // 写入日志文件
  //   },
  // ));

  print('💡 Flutter 中 Zone 的两个核心用途：');
  print('  1. runZonedGuarded → 全局异步异常捕获');
  print('  2. ZoneSpecification.print → 统一日志拦截');

  // ─────────────────────────────────────────
  // 7. Zone.fork（手动创建子 Zone）
  // ─────────────────────────────────────────

  print('\n--- Zone.fork（手动创建子 Zone）---');

  var parentZone = Zone.current.fork(
    zoneValues: {#level: 'parent'},
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        parent.print(zone, '[Parent Zone] $line');
      },
    ),
  );

  parentZone.run(() {
    print('在父 Zone 中');  // [Parent Zone] 在父 Zone 中

    var childZone = Zone.current.fork(
      zoneValues: {#level: 'child'},
    );

    childZone.run(() {
      print('在子 Zone 中');  // [Parent Zone] 在子 Zone 中（继承了 print 拦截）
      print('Zone level: ${Zone.current[#level]}');  // child（子 Zone 覆盖）
    });
  });

  print('\n💡 Zone 总结：');
  print('- runZonedGuarded: 捕获异步未处理异常（Flutter 必备）');
  print('- zoneValues: 注入上下文变量（类似依赖注入）');
  print('- ZoneSpecification: 拦截 print、Timer、Future 等');
  print('- Zone.fork: 创建子 Zone（继承+覆盖）');
}

// ═══════════════════════════════════════════
// 辅助函数
// ═══════════════════════════════════════════

const _requestIdKey = #requestId;

Future<void> _nestedAsyncCall() async {
  await Future.delayed(Duration(milliseconds: 50));
  // 即使嵌套很深，Zone 值依然可以访问
  print('深层异步中 - Request ID: ${Zone.current[_requestIdKey]}');
}

// 💡 Zone 嵌套结构示意：
//
//  ┌──────────────────────────────────────┐
//  │  Root Zone（根 Zone）                  │
//  │  ┌──────────────────────────────────┐│
//  │  │  Zone A（runZonedGuarded）        ││
//  │  │  onError: 捕获异常 → Crashlytics ││
//  │  │  ┌──────────────────────────┐    ││
//  │  │  │  Zone B（子 Zone）        │    ││
//  │  │  │  values: {userId: '42'}  │    ││
//  │  │  │  继承 A 的 onError       │    ││
//  │  │  └──────────────────────────┘    ││
//  │  └──────────────────────────────────┘│
//  └──────────────────────────────────────┘
//
//  规则：
//  - 子 Zone 继承父 Zone 的 zoneSpecification
//  - 子 Zone 可以覆盖父 Zone 的 zoneValues
//  - 异步回调在创建它的 Zone 中执行（Zone 自动传递）
