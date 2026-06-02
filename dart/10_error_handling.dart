/// ============================================================
/// 10 - 异常处理
/// ============================================================
/// Dart 使用 try-catch-finally 处理异常（和 TS/Java 类似）。
/// Dart 没有 checked exceptions（不像 Java 需要在方法签名声明 throws）。
///
/// 对比：
/// - TS:    try/catch/finally, throw new Error()
/// - Swift: do/try/catch, throw MyError.xxx
/// - OC:    @try/@catch/@finally, NSException
/// - Dart:  try/catch/finally, throw Exception()
///
/// 💡 运行方式：dart run 10_error_handling.dart
/// ============================================================

Future<void> main() async {
  // ─────────────────────────────────────────
  // 1. try-catch 基础
  // ─────────────────────────────────────────

  print('--- try-catch 基础 ---');

  try {
    var result = 10 ~/ 0;  // ~/ 是整数除法，除以0会抛异常
    print(result);
  } catch (e) {
    print('Caught error: $e');
  }

  // ─────────────────────────────────────────
  // 2. catch 带 StackTrace
  // ─────────────────────────────────────────

  print('\n--- StackTrace ---');

  try {
    throw Exception('Something went wrong!');
  } catch (e, stackTrace) {
    print('Error: $e');
    // print('Stack: $stackTrace');  // 取消注释可以看到堆栈
  }

  // ─────────────────────────────────────────
  // 3. on 捕获特定异常类型
  // ─────────────────────────────────────────

  print('\n--- 特定异常捕获 ---');

  try {
    riskyOperation(2);
  } on FormatException {
    // 只捕获 FormatException（不需要 error 变量）
    print('Format error occurred');
  } on RangeError catch (e) {
    // 捕获 RangeError 并获取 error 变量
    print('Range error: $e');
  } on Exception catch (e) {
    // 兜底：捕获所有 Exception
    print('General exception: $e');
  } catch (e) {
    // 最终兜底：捕获所有错误（包括 Error）
    print('Unknown error: $e');
  }

  // ─────────────────────────────────────────
  // 4. rethrow（重新抛出）
  // ─────────────────────────────────────────

  print('\n--- rethrow ---');

  try {
    try {
      throw FormatException('Bad format');
    } on FormatException catch (e) {
      print('Inner catch: $e');
      // 做一些处理后重新抛出
      rethrow;  // 和 TS 的 throw e 不同，rethrow 保留原始 stack trace
    }
  } catch (e) {
    print('Outer catch: $e');
  }

  // ─────────────────────────────────────────
  // 5. finally
  // ─────────────────────────────────────────

  print('\n--- finally ---');

  try {
    print('Opening resource...');
    throw Exception('Oops!');
  } catch (e) {
    print('Error: $e');
  } finally {
    // 无论是否异常，finally 都会执行
    print('Closing resource... (always runs)');
  }

  // ─────────────────────────────────────────
  // 6. 自定义异常类
  // ─────────────────────────────────────────

  print('\n--- 自定义异常 ---');

  try {
    withdraw(100, balance: 50);
  } on InsufficientBalance catch (e) {
    print('${e.message}: needed ${e.required}, available ${e.available}');
  }

  try {
    validateAge(-5);
  } on ValidationError catch (e) {
    print('Validation: ${e.field} - ${e.message}');
  }

  // ─────────────────────────────────────────
  // 7. 异步异常处理
  // ─────────────────────────────────────────

  print('\n--- 异步异常处理 ---');

  // async/await 中的 try-catch
  await _asyncErrorDemo();

  // Future.catchError 处理
  riskyAsyncOperation()
      .then((value) => print('Value: $value'))
      .catchError((error) => print('Async error: $error'));

  // ─────────────────────────────────────────
  // 8. 常见错误处理模式
  // ─────────────────────────────────────────

  print('\n--- 常见模式 ---');

  // 模式1: 返回 null 而非抛异常（类似 Swift 的 try?）
  var parsed = safeParseInt('not a number');
  print('Safe parse: $parsed');  // null

  var parsed2 = safeParseInt('42');
  print('Safe parse: $parsed2');  // 42

  // 模式2: Result 模式（避免异常控制流）
  var result = divide(10, 3);
  result.when(
    success: (value) => print('10/3 = $value'),
    failure: (error) => print('Error: $error'),
  );

  var result2 = divide(10, 0);
  result2.when(
    success: (value) => print('10/0 = $value'),
    failure: (error) => print('Error: $error'),
  );

  // 模式3: 全局错误处理（Flutter 中使用）
  // Flutter.runZonedGuarded(() {
  //   runApp(MyApp());
  // }, (error, stack) {
  //   // 记录崩溃日志
  //   FirebaseCrashlytics.instance.recordError(error, stack);
  // });
}

// ═══════════════════════════════════════════
// 辅助函数
// ═══════════════════════════════════════════

void riskyOperation(int type) {
  switch (type) {
    case 1:
      throw FormatException('Invalid format');
    case 2:
      throw RangeError('Index out of range');
    case 3:
      throw Exception('Generic error');
  }
}

Future<String> riskyAsyncOperation() async {
  await Future.delayed(Duration(milliseconds: 100));
  throw Exception('Async operation failed!');
}

Future<void> _asyncErrorDemo() async {
  try {
    await riskyAsyncOperation();
  } catch (e) {
    print('Async caught: $e');
  }
}

// ─────────────────────────────────────────
// 自定义异常
// ─────────────────────────────────────────

// 💡 Dart 异常类通常实现 Exception 接口
// 但技术上可以 throw 任何对象（不推荐）

class InsufficientBalance implements Exception {
  final String message;
  final double required;
  final double available;

  InsufficientBalance(this.message, {required this.required, required this.available});

  @override
  String toString() => 'InsufficientBalance: $message';
}

class ValidationError implements Exception {
  final String field;
  final String message;

  ValidationError(this.field, this.message);

  @override
  String toString() => 'ValidationError($field): $message';
}

double withdraw(double amount, {required double balance}) {
  if (amount > balance) {
    throw InsufficientBalance(
      '余额不足',
      required: amount,
      available: balance,
    );
  }
  return balance - amount;
}

void validateAge(int age) {
  if (age < 0 || age > 150) {
    throw ValidationError('age', '年龄必须在 0-150 之间');
  }
}

// ─────────────────────────────────────────
// 安全解析（返回 null 模式）
// ─────────────────────────────────────────

int? safeParseInt(String input) {
  return int.tryParse(input);  // Dart 自带的 tryParse 就是这个模式
}

// ─────────────────────────────────────────
// Result 模式
// ─────────────────────────────────────────

sealed class AppResult<T> {
  const AppResult();

  void when({
    required void Function(T value) success,
    required void Function(String error) failure,
  });
}

class AppSuccess<T> extends AppResult<T> {
  final T value;
  const AppSuccess(this.value);

  @override
  void when({
    required void Function(T value) success,
    required void Function(String error) failure,
  }) {
    success(value);
  }
}

class AppFailure<T> extends AppResult<T> {
  final String error;
  const AppFailure(this.error);

  @override
  void when({
    required void Function(T value) success,
    required void Function(String error) failure,
  }) {
    failure(error);
  }
}

AppResult<double> divide(double a, double b) {
  if (b == 0) return const AppFailure('Division by zero');
  return AppSuccess(a / b);
}

// 💡 Dart 异常处理的注意事项：
//
// 1. 不要用异常做流程控制（性能差，语义不清）
// 2. 优先用 nullable 返回值表示"可能的失败"
// 3. 对于预期的错误场景，考虑 Result 模式
// 4. try-catch 粒度要合适，不要一个大的 try 包裹所有代码
// 5. 始终在 finally 中清理资源（文件、网络连接等）
// 6. Flutter 中用 FlutterError.onError 和 runZonedGuarded 做全局错误处理
