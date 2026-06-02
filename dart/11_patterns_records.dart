/// ============================================================
/// 11 - 模式匹配与 Record（Dart 3 新特性）
/// ============================================================
/// Dart 3 引入了强大的模式匹配和 Record 类型，
/// 让代码更加表达力强大、更接近函数式编程风格。
///
/// 对比：
/// - Swift: enum associated values, pattern matching
/// - TS:    discriminated unions, 没有原生 pattern matching
/// - Dart:  sealed class + switch expression + Record
///
/// 💡 运行方式：dart run 11_patterns_records.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. Record 类型（Dart 3）
  // ─────────────────────────────────────────

  // Record 是匿名的、不可变的、带命名或无命名的元组
  // 类似 Swift 的 tuple，但更强大

  // 无命名 Record
  var point = (1.0, 2.0);
  print('Point: $point');
  print('X: ${point.$1}, Y: ${point.$2}');  // 用 $1, $2 访问

  // 带命名 Record
  var user = (name: 'Alice', age: 25);
  print('User: $user');
  print('Name: ${user.name}, Age: ${user.age}');

  // 函数返回 Record
  var (lat, lng) = getLocation();
  print('Location: lat=$lat, lng=$lng');

  // Record 作为函数参数
  printUserInfo((name: 'Bob', age: 30, email: 'bob@example.com'));

  // ─────────────────────────────────────────
  // 2. 解构赋值（Destructuring）
  // ─────────────────────────────────────────

  // 解构 List
  var list = [10, 20, 30];
  var [a, b, c] = list;
  print('a=$a, b=$b, c=$c');

  // 解构 Map（需要显式类型）
  var map = {'name': 'Alice', 'age': '25'};
  var {'name': name2, 'age': age2} = map;
  print('name=$name2, age=$age2');

  // 解构 Record
  var (x, y, z) = (1, 2, 3);
  print('x=$x, y=$y, z=$z');

  // 忽略某些值（用 _ ）
  var [first, _, last2] = [10, 20, 30];
  print('first=$first, last=$last2');

  // ─────────────────────────────────────────
  // 3. Switch 表达式（Pattern Matching）⭐
  // ─────────────────────────────────────────

  // 类似 Swift 的 switch 表达式
  // 传统 switch 只能执行语句，switch 表达式可以返回值

  // 基于值的匹配
  String command = 'open';
  var description = switch (command) {
    'open' => '打开',
    'close' => '关闭',
    'save' => '保存',
    _ => '未知',
  };
  print('Command: $description');

  // 基于类型的匹配（类似 Swift 的 type casting）
  Shape shape = Circle(5);
  var area = switch (shape) {
    Circle(radius: var r) => 3.14 * r * r,
    Rectangle(width: var w, height: var h) => w * h,
    Triangle(base: var b, height: var h) => 0.5 * b * h,
  };
  print('Area: $area');

  // 基于 Record 的匹配
  var status = (200, 'OK');
  var message = switch (status) {
    (200, var msg) => 'Success: $msg',
    (404, var msg) => 'Not Found: $msg',
    (var code, _) => 'Error: code $code',
  };
  print('Status: $message');

  // 多值匹配（||）
  int weekday = 6;
  var dayType = switch (weekday) {
    6 || 7 => '周末',
    _ => '工作日',
  };
  print('Day: $dayType');

  // 条件守卫（when）
  int score = 85;
  var grade = switch (score) {
    >= 90 => '优秀',
    >= 80 && < 90 => '良好',
    >= 60 && < 80 => '及格',
    _ => '不及格',
  };
  print('Grade: $grade');

  // ─────────────────────────────────────────
  // 4. 模式匹配在 if/for 中使用
  // ─────────────────────────────────────────

  // if-case 模式匹配
  Object? value = 'Hello World';
  if (value case String s) {
    print('String value: ${s.toUpperCase()}');
  }

  // for 中使用模式匹配
  var pairs = [(1, 'one'), (2, 'two'), (3, 'three')];
  for (var (num, word) in pairs) {
    print('$num: $word');
  }

  // ─────────────────────────────────────────
  // 5. sealed class + 穷举匹配
  // ─────────────────────────────────────────

  // sealed class 确保所有子类在同一文件中定义
  // switch 匹配时编译器会检查是否穷举所有情况

  NetworkState state = Loading();

  var ui = switch (state) {
    Loading() => '显示加载动画...',
    Success(data: var d) => '显示数据: $d',
    Error(msg: var m) => '显示错误: $m',
  };
  print('UI: $ui');

  // 模拟不同的状态
  for (var s in [Loading(), Success('User data'), Error('Network timeout')]) {
    var result = switch (s) {
      Loading() => '⏳ Loading...',
      Success(data: var d) => '✅ Data: $d',
      Error(msg: var m) => '❌ Error: $m',
    };
    print(result);
  }

  // ─────────────────────────────────────────
  // 6. 实际应用示例
  // ─────────────────────────────────────────

  print('\n--- 实际示例：解析 JSON-like 数据 ---');

  var jsonData = [
    {'type': 'text', 'content': 'Hello'},
    {'type': 'image', 'url': 'photo.jpg', 'width': 100},
    {'type': 'video', 'url': 'movie.mp4', 'duration': 120},
  ];

  for (var item in jsonData) {
    var type = item['type'];
    var output = switch (type) {
      'text' => '📝 Text: ${item['content']}',
      'image' => '🖼️ Image: ${item['url']} (${item['width']}px)',
      'video' => '🎬 Video: ${item['url']} (${item['duration']}s)',
      _ => '❓ Unknown type: $type',
    };
    print(output);
  }
}

// ═══════════════════════════════════════════
// 辅助类型定义
// ═══════════════════════════════════════════

// sealed class 用于表示互斥的状态（类似 Swift 的 enum with associated values）
sealed class NetworkState {}

class Loading extends NetworkState {}

class Success extends NetworkState {
  final String data;
  Success(this.data);
}

class Error extends NetworkState {
  final String msg;
  Error(this.msg);
}

// Shape 示例
sealed class Shape {}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);
}

class Triangle extends Shape {
  final double base, height;
  Triangle(this.base, this.height);
}

// ─────────────────────────────────────────
// 辅助函数
// ─────────────────────────────────────────

(double, double) getLocation() => (37.7749, -122.4194);

void printUserInfo(({String name, int age, String email}) info) {
  print('User: ${info.name}, Age: ${info.age}, Email: ${info.email}');
}

// 💡 模式匹配最佳实践：
//
// 1. 用 sealed class 表示互斥的状态/类型
// 2. 用 switch 表达式替代 if-else 链
// 3. 编译器会检查 sealed class 的穷举性（漏写分支会报 warning）
// 4. Record 适合临时组合不同类型的数据（替代创建一次性类）
// 5. 解构赋值让代码更简洁：var (a, b) = (1, 2)
