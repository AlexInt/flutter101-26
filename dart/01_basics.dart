/// ============================================================
/// 01 - 基础语法：变量、类型、常量、字符串
/// ============================================================
/// 面向有 TS / Swift / OC 经验的开发者，快速上手 Dart
///
/// 💡 运行方式：dart run 01_basics.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. 变量声明
  // ─────────────────────────────────────────

  // Dart 是强类型语言，但支持类型推断（类似 Swift 的 let/var、TS 的 const/let）
  var name = 'Flutter';       // 自动推断为 String（类似 Swift 的 var name = "Flutter"）
  String framework = 'Dart';  // 显式声明类型（类似 TS 的 let framework: string = "Dart"）

  // final: 运行时不可变的常量（类似 Swift 的 let，TS 的 const）
  final version = 3;          // 类型推断为 int
  final double pi = 3.14159;  // 显式类型

  // const: 编译期常量（比 final 更严格，值必须在编译时确定）
  const maxCount = 100;
  const appName = 'MyApp';

  // 💡 final vs const:
  // - final: 第一次赋值后不可变，值可以在运行时确定
  // - const: 编译期常量，值必须在编写代码时就知道
  // - 类比 Swift: final ≈ let, const ≈ static let
  // - 类比 TS:   final ≈ readonly, const ≈ const（但 Dart 的 const 更严格）

  print('Hello, $name! Framework: $framework');
  print('Version: $version, Pi: $pi, MaxCount: $maxCount');

  // ─────────────────────────────────────────
  // 2. 基本数据类型
  // ─────────────────────────────────────────

  // int - 整数（64位，没有大小限制的困扰）
  int age = 25;
  int hexValue = 0xFF;       // 十六进制

  // double - 浮点数（64位双精度）
  double price = 19.99;
  double scientific = 1.5e3;  // 科学计数法 = 1500.0

  // num - int 和 double 的父类型（类似 TS 的 number）
  num someNumber = 42;
  someNumber = 3.14;  // OK! num 可以接受 int 或 double

  // bool - 布尔值（注意：Dart 中只有 true/false，没有"truthy/falsy"）
  bool isActive = true;
  // if (1) {}  // ❌ 编译错误！不像 TS/JS 那样有隐式转换

  // String - 字符串（UTF-16，不可变）
  String greeting = 'Hello';
  String anotherGreeting = "Hello";  // 单引号双引号都行
  // 类比：Swift 只有双引号, TS 单双引号都行, OC 用 @"Hello"

  print('int: $age, double: $price, num: $someNumber, bool: $isActive');

  // ─────────────────────────────────────────
  // 3. 字符串操作
  // ─────────────────────────────────────────

  // 字符串插值（类似 TS 的 `${expr}`，Swift 的 `\(expr)`）
  String message = 'My name is $name, I am $age years old';

  // 表达式插值需要用 ${}
  String calc = '2 + 3 = ${2 + 3}';
  String upper = 'Name in uppercase: ${name.toUpperCase()}';

  // 多行字符串（用三个引号，类似 TS 的反引号 ``）
  String multiline = '''
这是第一行
这是第二行
这是第三行
''';

  // 原始字符串（不转义，类似 Swift 的 #"..."#）
  String raw = r'换行符是 \n，不会被转义';

  // 字符串拼接
  String part1 = 'Hello';
  String part2 = 'World';
  String combined = part1 + ' ' + part2;       // 用 + 拼接
  String repeated = 'ha' * 3;                   // 'hahaha'（重复字符串）

  // 字符串常用属性/方法
  print('Length: ${greeting.length}');          // 长度
  print('Upper: ${greeting.toUpperCase()}');    // 大写
  print('Contains: ${greeting.contains('ell')}'); // 包含
  print('Substring: ${greeting.substring(1, 3)}'); // 子串 [1,3) → 'el'
  print('Split: ${'a,b,c'.split(',')}');        // 分割 → ['a', 'b', 'c']
  print('Trim: ${'  hi  '.trim()}');            // 去空格 → 'hi'
  print('Replace: ${greeting.replaceAll('l', 'L')}'); // 替换 → 'HeLLo'
  print('StartsWith: ${greeting.startsWith('He')}');  // 是否以...开头

  print('\n$message');
  print(calc);
  print(raw);
  print(repeated);

  // ─────────────────────────────────────────
  // 4. 类型转换
  // ─────────────────────────────────────────

  // String → int
  int? parsedInt = int.tryParse('42');       // 安全转换，失败返回 null
  // 类比 Swift: Int("42"), TS: parseInt("42")

  // String → double
  double? parsedDouble = double.tryParse('3.14');

  // int/double → String
  String intStr = 42.toString();
  String doubleStr = 3.14159.toStringAsFixed(2); // '3.14'（指定小数位数）

  // num 类型检查
  num value = 42;
  print('is int: ${value is int}');          // true（类似 Swift 的 is 检查）
  print('is double: ${value is double}');    // false

  print('Parsed int: $parsedInt, double: $parsedDouble');
  print('ToString: $intStr, Fixed: $doubleStr');

  // ─────────────────────────────────────────
  // 5. 类型注解 vs 类型推断 —— 什么时候用哪个？
  // ─────────────────────────────────────────

  // ✅ 推荐：简单赋值让 Dart 推断
  var count = 10;           // 明显是 int，无需写 int count = 10

  // ✅ 推荐：函数返回值和参数建议显式声明
  // （后面 02_functions.dart 会详细讲）

  // ✅ 推荐：集合类型不明确时显式声明
  List<String> names = [];  // 空集合必须声明类型

  // 💡 Dart 的类型系统 vs 其他语言：
  // - Dart 像 Swift：强类型 + 类型推断
  // - Dart 不像 TS：没有 structural typing（结构化类型），用 nominal typing
  // - Dart 没有隐式类型转换：int 不能自动变 double，String 不能变 bool
}
