/// ============================================================
/// 05 - 空安全（Null Safety）
/// ============================================================
/// Dart 的空安全机制在 2021 年正式启用（Dart 2.12+），
/// 和 Swift 的 Optional 非常相似，但有一些 Dart 独有的特性。
///
/// 对比：
/// - Swift: Optional<String>、String?、!、?、??
/// - TS:    string | null | undefined、!、?、??
/// - Dart:  String?（nullable）、String（non-nullable）
///
/// 💡 运行方式：dart run 05_null_safety.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. Nullable vs Non-nullable
  // ─────────────────────────────────────────

  // 默认情况下，变量不能为 null（non-nullable）
  String name = 'Flutter';
  // name = null;  // ❌ 编译错误！

  // 加 ? 表示可以为 null（nullable）
  String? nullableName;   // 初始值为 null
  nullableName = 'Dart';
  nullableName = null;    // ✅ OK

  print('name: $name, nullableName: $nullableName');

  // 💡 核心原则：
  // - Dart 默认一切 non-nullable（比 Swift 更严格，Swift 需要 ?）
  // - 只有显式标注 ? 的类型才能赋值 null
  // - 这和 TS 的 strictNullChecks 类似

  // ─────────────────────────────────────────
  // 2. 安全访问 ?.（可选链）
  // ─────────────────────────────────────────

  String? email;

  // ❌ 不能直接访问属性（可能是 null）
  // email.length;  // 编译错误

  // ✅ 用 ?. 安全访问（类似 Swift 的 ?、TS 的 ?.）
  int? length = email?.length;   // null，因为 email 是 null
  print('Length: $length');

  email = 'dart@example.com';
  length = email?.length;        // 16
  print('Length: $length');

  // 链式安全访问
  String? upper = email?.toUpperCase();
  print('Upper: $upper');

  // ─────────────────────────────────────────
  // 3. 空值合并 ?? & 空值赋值 ??=
  // ─────────────────────────────────────────

  String? userInput;

  // ?? 空值合并（和 Swift/TS 一样）
  String displayName = userInput ?? '默认用户';
  print('Display: $displayName');

  // ??= 仅在 null 时赋值
  String? cache;
  cache ??= 'computed value';  // cache 是 null，所以赋值
  cache ??= 'other value';     // cache 不是 null，不赋值
  print('Cache: $cache');

  // ─────────────────────────────────────────
  // 4. 强制解包 !（Force Unwrap）
  // ─────────────────────────────────────────

  String? value = 'Hello';

  // ! 断言不为 null（类似 Swift 的 !）
  String nonNull = value!;  // 如果 value 是 null 会抛异常
  print('Force unwrap: $nonNull');

  // ⚠️ 谨慎使用！如果确实是 null，运行时会崩溃
  // 推荐优先使用 ?? 或 ?. 而不是 !

  // ─────────────────────────────────────────
  // 5. late 关键字（延迟初始化）
  // ─────────────────────────────────────────

  // 场景：变量一定会被初始化，但不是在声明时
  // 类似 Swift 的 implicitly unwrapped optional（但更安全）
  late String description;
  // 这里可以先不赋值，但在使用前必须赋值
  description = 'This is a late variable';
  print('Late: $description');

  // late + 初始化表达式：第一次访问时才计算（惰性求值）
  late String expensive = _computeExpensive();
  print('Before access');          // 先打印这个
  print('Expensive: $expensive');  // 这时才调用 _computeExpensive()

  // ⚠️ 如果在赋值前访问 late 变量，会抛出 LateInitializationError
  // late String notInitialized;
  // print(notInitialized);  // ❌ 运行时异常

  // ─────────────────────────────────────────
  // 6. required 关键字
  // ─────────────────────────────────────────

  // 在命名参数中，required 表示必须传值（不能省略，不能为 null）
  void createUser({required String name, required int age}) {
    print('User: $name, Age: $age');
  }
  createUser(name: 'Alice', age: 25);

  // 没有 required 的命名参数必须有默认值或是 nullable
  // void ok({String name = 'default'}) {}  ✅
  // void ok({String? name}) {}             ✅
  // void ok({String name}) {}              ❌ 编译错误

  // ─────────────────────────────────────────
  // 7. 类型提升（Type Promotion）
  // ─────────────────────────────────────────

  String? maybeString;

  // null 检查后，Dart 会自动提升类型（类似 Swift 的 if let）
  if (maybeString != null) {
    // 在这个分支中，maybeString 的类型自动变为 String（非 null）
    print(maybeString.toUpperCase());  // ✅ 不需要 ?. 或 !
  }

  // Swift 对比：
  // Swift: if let unwrapped = maybeString { unwrapped.uppercased() }
  // Dart:  if (maybeString != null) { maybeString.toUpperCase() }
  // Dart 不需要创建新变量，直接在原变量上提升！

  // ─────────────────────────────────────────
  // 8. 常见模式总结
  // ─────────────────────────────────────────

  String? nullable = 'Hello';

  // 模式1: 提供默认值
  String result1 = nullable ?? 'default';

  // 模式2: 安全链式调用
  int? result2 = nullable?.length;

  // 模式3: 安全调用方法
  String? result3 = nullable?.toUpperCase();

  // 模式4: null 检查后使用（自动提升）
  if (nullable != null) {
    print(nullable.length);  // 直接用，无需 ?. 或 !
  }

  // 模式5: 强制解包（慎用！）
  // String result5 = nullable!;

  // 模式6: 空值赋值
  // nullable ??= 'fallback';

  // 模式7: late 延迟初始化
  // late String definitelyWillBeSet;

  print('\n--- All patterns ---');
  print('1: $result1');
  print('2: $result2');
  print('3: $result3');

  // ─────────────────────────────────────────
  // 9. 集合中的 null
  // ─────────────────────────────────────────

  // List<String?> 表示列表可以包含 null
  List<String?> nullableList = ['hello', null, 'world'];
  print('Nullable list: $nullableList');

  // List<String>? 表示列表本身可以为 null（但元素不能为 null）
  List<String>? nullableListRef = ['hello', 'world'];
  nullableListRef = null;
  print('Nullable ref: $nullableListRef');

  // Map 中 value 为 null
  Map<String, int?> nullableMap = {'a': 1, 'b': null};
  print('Nullable map: $nullableMap');
}

// 模拟耗时计算
String _computeExpensive() {
  print('Computing...');
  return 'expensive result';
}
