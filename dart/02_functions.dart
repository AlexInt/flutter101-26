/// ============================================================
/// 02 - 函数：定义、参数、返回值、高阶函数
/// ============================================================
/// Dart 的函数是一等公民（first-class），可以赋值给变量、
/// 作为参数传递、作为返回值——和 TS/Swift 一样。
///
/// 💡 运行方式：dart run 02_functions.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. 基本函数定义
  // ─────────────────────────────────────────

  // 完整写法（类似 Swift 的 func，TS 的 function）
  String greet(String name) {
    return 'Hello, $name!';
  }
  print(greet('Flutter'));

  // 箭头函数（单表达式简写，类似 TS 的箭头函数）
  // TS:   const add = (a: number, b: number): number => a + b;
  // Swift: let add = { (a: Int, b: Int) -> Int in a + b }
  int add(int a, int b) => a + b;
  print('2 + 3 = ${add(2, 3)}');

  // void 函数（无返回值）
  void sayHi(String name) {
    print('Hi, $name');
  }
  sayHi('Dart');

  // ─────────────────────────────────────────
  // 2. 参数类型详解
  // ─────────────────────────────────────────

  // --- 2a. 位置参数（Required Positional）---
  // 和大多数语言一样，按顺序传递
  String fullName(String first, String last) {
    return '$first $last';
  }
  print(fullName('John', 'Doe'));

  // --- 2b. 可选位置参数（Optional Positional）---
  // 用 [] 包裹，可省略（类似 TS 的 ? 可选参数）
  // TS: function greet(name: string, title?: string)
  String greetWithTitle(String name, [String? title]) {
    if (title != null) {
      return 'Hello, $title $name';
    }
    return 'Hello, $name';
  }
  print(greetWithTitle('Alice'));              // Hello, Alice
  print(greetWithTitle('Alice', 'Dr.'));       // Hello, Dr. Alice

  // --- 2c. 命名参数（Named Parameters）⭐ 重点 ---
  // 用 {} 包裹，调用时必须写参数名（Flutter 中大量使用！）
  // 类比 Swift: 调用时写参数名 greet(name: "Bob", age: 20)
  // 类比 TS:    传对象 { name: "Bob", age: 20 }
  void createUser({required String name, int age = 0, String role = 'user'}) {
    print('User: $name, Age: $age, Role: $role');
  }

  // 调用时参数顺序不重要，可读性极强
  createUser(name: 'Bob', age: 25, role: 'admin');
  createUser(name: 'Eve');                     // 使用默认值
  createUser(age: 30, name: 'Charlie');        // 顺序随意！

  // --- 2d. 命名参数 + 默认值 ---
  // required 关键字标记必传参数（没有默认值时必须传）
  // 没有 required 的参数必须有默认值或为 nullable
  Widget buildButton({
    required String label,      // 必传
    Color color = Color.blue,   // 有默认值
    VoidCallback? onPressed,    // nullable（可选）
  }) {
    print('Button: $label, Color: $color');
    return Widget(label);
  }

  buildButton(label: 'Submit');
  buildButton(label: 'Cancel', color: Color.red);

  // ─────────────────────────────────────────
  // 3. 函数作为参数（高阶函数）
  // ─────────────────────────────────────────

  // 类似 Swift 的闭包参数，TS 的回调函数
  void doOperation(int a, int b, int Function(int, int) operation) {
    print('Result: ${operation(a, b)}');
  }

  doOperation(10, 5, (a, b) => a + b);   // 15
  doOperation(10, 5, (a, b) => a * b);   // 50

  // typedef 给函数类型起别名（类似 TS 的 type）
  // TS: type Transformer = (input: string) => string
  // Swift: typealias Transformer = (String) -> String

  // ─────────────────────────────────────────
  // 4. 匿名函数 & 闭包
  // ─────────────────────────────────────────

  // 匿名函数（lambda）
  var multiply = (int a, int b) => a * b;
  print('multiply: ${multiply(3, 4)}');

  // 闭包：函数可以捕获外部变量（和 TS/Swift 一样）
  Function makeCounter() {
    int count = 0;
    return () => ++count;
  }

  var counter = makeCounter();
  print(counter());  // 1
  print(counter());  // 2
  print(counter());  // 3

  // ─────────────────────────────────────────
  // 5. 常用高阶函数示例
  // ─────────────────────────────────────────

  var numbers = [1, 2, 3, 4, 5];

  // map: 映射（类似 Swift 的 map，TS 的 Array.map）
  var doubled = numbers.map((n) => n * 2).toList();
  print('map: $doubled');  // [2, 4, 6, 8, 10]

  // where: 过滤（类似 Swift 的 filter，TS 的 Array.filter）
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('where: $evens');  // [2, 4]

  // reduce: 归约（类似 Swift 的 reduce，TS 的 Array.reduce）
  var sum = numbers.reduce((a, b) => a + b);
  print('reduce sum: $sum');  // 15

  // fold: 带初始值的 reduce
  var product = numbers.fold(1, (a, b) => a * b);
  print('fold product: $product');  // 120

  // any / every
  print('any > 3: ${numbers.any((n) => n > 3)}');      // true
  print('every > 0: ${numbers.every((n) => n > 0)}');   // true

  // forEach（无返回值，仅执行副作用）
  numbers.forEach((n) => print('  number: $n'));

  // ─────────────────────────────────────────
  // 6. 函数重载？不存在的！
  // ─────────────────────────────────────────

  // ❌ Dart 不支持函数重载（不像 Swift/OC/Java）
  // 替代方案：使用可选参数或命名参数

  // 不好 ❌ (不支持)
  // void log(String message) {}
  // void log(String message, int level) {}

  // 好的 ✅
  // void log(String message, {int level = 0}) {}
}

// ─────────────────────────────────────────
// 辅助类（用于上面的示例）
// ─────────────────────────────────────────

class Color {
  final String name;
  const Color(this.name);
  static const red = Color('red');
  static const blue = Color('blue');
  @override
  String toString() => name;
}

class Widget {
  final String label;
  Widget(this.label);
}

typedef VoidCallback = void Function();
