/// ============================================================
/// 07 - Mixin、Extension、Enum
/// ============================================================
/// 这些是 Dart 中非常实用的高级特性，在 Flutter 中大量使用。
///
/// 对比：
/// - Swift: protocol extension / extension / enum
/// - TS:    没有 mixin（用组合模拟）/ 没有 extension / enum
/// - OC:    category / category / NS_ENUM
///
/// 💡 运行方式：dart run 07_mixins_extensions.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. Mixin（混入）⭐ Dart 独有杀手锏
  // ─────────────────────────────────────────

  // Mixin 允许你"混入"多个类的功能（解决单继承限制）
  // 类似 Swift 的 protocol + extension 默认实现
  // Flutter 中到处都是：with TickerProviderStateMixin, WidgetsBindingObserver

  var robot = Robot();
  robot.name = 'Robo-1';
  robot.walk();     // 来自 Walker mixin
  robot.swim();     // 来自 Swimmer mixin
  robot.greet();    // 来自自己的方法

  // Flutter 真实示例：
  // class MyState extends State<MyWidget>
  //     with TickerProviderStateMixin {
  //   // TickerProviderStateMixin 提供了 createTicker() 等方法
  // }

  // ─────────────────────────────────────────
  // 2. Mixin on（限定混入目标）
  // ─────────────────────────────────────────

  // 普通 mixin 可以混入到任何类上，但有时 mixin 内部依赖了某个父类的方法，
  // 如果混入到一个不相关的类上，调用时就会报错。
  // `on` 关键字就是用来解决这个问题的：限定 mixin 只能用在某个类的子类上。

  // 下面的 Loggable mixin 用了 `on BaseWidget`，
  // 意味着只有 BaseWidget 的子类才能 with Loggable
  var btn = LogButton();
  btn.render();   // 来自 BaseWidget（父类）
  btn.log('用户点击了按钮');  // 来自 Loggable mixin，内部调用了 render()

  // ❌ 如果用在不相关的类上，编译期就会报错：
  // class Dog with Loggable {}  // Error: 'Loggable' can't be mixed onto...
  // 因为 Dog 不是 BaseWidget 的子类

  // 💡 Flutter 中的真实场景：
  // mixin TickerProviderStateMixin on State {
  //   // 内部依赖了 State 的方法（setState 等），所以用 on 限定
  //   // 只有 State<StatefulWidget> 的子类才能使用这个 mixin
  // }
  // class _MyPageState extends State<MyPage> with TickerProviderStateMixin {}

  // ─────────────────────────────────────────
  // 3. Extension（扩展方法）
  // ─────────────────────────────────────────

  // 给已有类型添加方法，无需修改源码（类似 Swift 的 extension，OC 的 category）

  // 给 String 添加方法
  print('hello world'.capitalize());         // Hello world
  print('hello'.isPalindrome);               // false
  print('racecar'.isPalindrome);             // true

  // 给 int 添加方法
  print(5.isEven);                           // false
  print(3.days);                             // Duration: 3天
  print(2.hours + 30.minutes);               // Duration: 2小时30分钟

  // 给 List<int> 添加方法
  print([3, 1, 4, 1, 5].sum);               // 14
  print([3, 1, 4, 1, 5].average);           // 2.8

  // 💡 Extension vs Swift Extension vs OC Category:
  // - Dart:   extension on Type { }  — 按文件导入，可能有冲突
  // - Swift:  extension Type { }     — 全局可见
  // - OC:     @interface Type (Name) — 全局可见，运行时方法

  // ─────────────────────────────────────────
  // 4. Extension 的高级用法
  // ─────────────────────────────────────────

  // 带类型参数的 extension
  var result = [1, 2, 3, 4, 5].chunked(2);
  print('Chunked: $result');  // [[1, 2], [3, 4], [5]]

  // Extension on nullable type
  String? nullStr;
  print(nullStr.orEmpty());   // '' (空字符串)
  print('hello'.orEmpty());   // 'hello'

  // ─────────────────────────────────────────
  // 5. Enum（枚举）
  // ─────────────────────────────────────────

  // 简单枚举（类似 Swift 的 enum，TS 的 enum）
  print('Today: ${Day.monday}');
  print('Day index: ${Day.monday.index}');  // 0（从0开始）
  print('Day name: ${Day.monday.name}');    // 'monday'

  // 所有枚举值
  for (var day in Day.values) {
    print('  $day (index: ${day.index})');
  }

  // 从字符串转枚举
  var parsed = Day.values.firstWhere(
    (d) => d.name == 'friday',
    orElse: () => Day.monday,
  );
  print('Parsed: $parsed');

  // ─────────────────────────────────────────
  // 6. 增强枚举（Enhanced Enum）⭐ Dart 2.17+
  // ─────────────────────────────────────────

  // 枚举可以有字段、方法、构造函数（类似 Swift 的带关联值的 enum，但更强大）
  print('Red hex: ${AppColor.red.hex}');
  print('Blue hex: ${AppColor.blue.hex}');
  print('Red is dark: ${AppColor.red.isDark}');

  // 枚举方法调用
  for (var color in AppColor.values) {
    print('${color.name}: ${color.hex} (dark: ${color.isDark})');
  }

  // ─────────────────────────────────────────
  // 7. sealed class（密封类）⭐ Dart 3
  // ─────────────────────────────────────────

  // 类似 Swift 的 enum with associated values / Kotlin 的 sealed class
  // 用于模式匹配时确保穷举

  Shape2 shape = Circle2(5);
  var desc = switch (shape) {
    Circle2(radius: var r) => '圆形，半径 $r',
    Rectangle2(width: var w, height: var h) => '矩形，${w}x$h',
    Triangle2(base: var b, height: var h) => '三角形，底 $b 高 $h',
  };
  print('Shape: $desc');

  // 另一个示例
  Result<int> result2 = Success(42);
  var message = switch (result2) {
    Success(value: var v) => '成功: $v',
    Error(msg: var m) => '失败: $m',
    Loading() => '加载中...',
  };
  print('Result: $message');
}

// ═══════════════════════════════════════════
// Mixin 定义
// ═══════════════════════════════════════════

// 基本 mixin
mixin Walker {
  void walk() => print('$runtimeType is walking');
}

mixin Swimmer {
  void swim() => print('$runtimeType is swimming');
}

mixin Flyer {
  void fly() => print('$runtimeType is flying');
}

// 使用 with 混入多个 mixin
class Robot with Walker, Swimmer {
  String name = '';
  void greet() => print('$name says hello!');
}

class Duck with Walker, Swimmer, Flyer {}

// ── 限定 mixin（on 关键字）──
//
// 问题场景：
//   假设你写了一个 mixin Loggable，里面有方法 log() 调用了 render()。
//   如果不加 on，任何类都能 with Loggable，但如果那个类没有 render()，
//   运行时就会崩溃。
//
// 解决方案：用 `on` 声明「我这个 mixin 依赖哪个父类」
//   mixin Loggable on BaseWidget { ... }
//   → 编译器保证：只有 BaseWidget 的子类才能 with Loggable
//
// 对比：
//   - Swift: protocol + extension 天然要求遵循者实现特定方法
//   - TS:    没有 mixin，用 class implements interface 约束
//   - OC:    category 没有这种编译期检查，运行时才知道方法是否存在

class BaseWidget {
  void render() => print('[BaseWidget] rendering...');
}

// Loggable 依赖 BaseWidget，用 on 限定
mixin Loggable on BaseWidget {
  void log(String message) {
    render();  // ✅ 安全！编译器保证使用 Loggable 的类一定有 render()
    print('[LOG] $message');
  }
}

// ✅ LogButton 继承了 BaseWidget，可以使用 Loggable
class LogButton extends BaseWidget with Loggable {}

// ❌ 下面这行会编译报错（取消注释可以看到错误）：
// class PlainClass with Loggable {}  // Error: can't be mixed

// ═══════════════════════════════════════════
// Extension 定义
// ═══════════════════════════════════════════

// 给 String 扩展
extension StringExtension on String {
  /// 首字母大写
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 是否回文
  bool get isPalindrome {
    final reversed = split('').reversed.join('');
    return this == reversed;
  }
}

// 给 int 扩展
extension IntExtension on int {
  /// 转换为 Duration（天）
  Duration get days => Duration(days: this);

  /// 转换为 Duration（小时）
  Duration get hours => Duration(hours: this);

  /// 转换为 Duration（分钟）
  Duration get minutes => Duration(minutes: this);
}

// 给 List<int> 扩展
extension IntListExtension on List<int> {
  /// 求和
  int get sum => fold(0, (a, b) => a + b);

  /// 平均值
  double get average => isEmpty ? 0 : sum / length;
}

// 泛型 extension
extension ListExtension<T> on List<T> {
  /// 分块
  List<List<T>> chunked(int size) {
    var chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

// Nullable 类型的 extension
extension NullableStringExtension on String? {
  /// 如果为 null 则返回空字符串
  String orEmpty() => this ?? '';
}

// ═══════════════════════════════════════════
// Enum 定义
// ═══════════════════════════════════════════

// 简单枚举
enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

// 增强枚举（Dart 2.17+）
enum AppColor {
  red(hex: '#FF0000', isDark: false),
  green(hex: '#00FF00', isDark: false),
  blue(hex: '#0000FF', isDark: true),
  black(hex: '#000000', isDark: true),
  white(hex: '#FFFFFF', isDark: false);

  // 字段
  final String hex;
  final bool isDark;

  // 构造函数（必须 const）
  const AppColor({required this.hex, required this.isDark});
}

// ═══════════════════════════════════════════
// sealed class（Dart 3）
// ═══════════════════════════════════════════

// 密封类：所有子类必须在同一文件中定义
// 配合 switch 模式匹配使用时，编译器可以检查是否穷举
sealed class Shape2 {}

class Circle2 extends Shape2 {
  final double radius;
  Circle2(this.radius);
}

class Rectangle2 extends Shape2 {
  final double width, height;
  Rectangle2(this.width, this.height);
}

class Triangle2 extends Shape2 {
  final double base, height;
  Triangle2(this.base, this.height);
}

// 结果类型（类似 Swift 的 Result）
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

class Error<T> extends Result<T> {
  final String msg;
  Error(this.msg);
}

class Loading<T> extends Result<T> {}
