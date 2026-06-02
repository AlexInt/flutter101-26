/// ============================================================
/// 06 - 类与面向对象：构造函数、继承、抽象类、接口
/// ============================================================
/// Dart 是纯面向对象语言：一切皆对象（包括 int、String）。
/// Dart 只支持单继承，但支持 mixin 和多接口实现。
///
/// 对比：
/// - Swift: class / struct / protocol / extension
/// - TS:    class / interface / abstract class
/// - OC:    @interface / @implementation / @protocol
///
/// 💡 运行方式：dart run 06_classes.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. 基本类定义
  // ─────────────────────────────────────────

  var user = User('Alice', 25);
  user.greet();
  print('Age in months: ${user.ageInMonths}');

  // 命名构造函数
  var anonymous = User.anonymous();
  anonymous.greet();

  // const 构造函数（编译期常量）
  const point = Point(1.0, 2.0);
  const samePoint = Point(1.0, 2.0);
  print('Same object: ${identical(point, samePoint)}');  // true!

  // ─────────────────────────────────────────
  // 2. 继承
  // ─────────────────────────────────────────

  var dog = Dog('旺财', 3);
  dog.speak();        // 旺财 says: 汪汪!
  dog.describe();     // Name: 旺财, Age: 3

  var cat = Cat('咪咪', 2);
  cat.speak();        // 咪咪 says: 喵喵~

  // 多态
  List<Animal> animals = [dog, cat];
  for (var animal in animals) {
    animal.speak();   // 运行时调用各自的 speak
  }

  // ─────────────────────────────────────────
  // 3. 抽象类 & 接口
  // ─────────────────────────────────────────

  var circle = Circle(5);
  print('Circle area: ${circle.area}');
  print('Circle shape: ${circle.describe()}');

  var rect = Rectangle(4, 6);
  print('Rectangle area: ${rect.area}');

  // 多态使用接口
  List<Shape> shapes = [circle, rect];
  for (var shape in shapes) {
    print('${shape.describe()} - Area: ${shape.area}');
  }

  // ─────────────────────────────────────────
  // 4. Getter / Setter
  // ─────────────────────────────────────────

  var temp = Temperature(36.5);
  print('Celsius: ${temp.celsius}');
  print('Fahrenheit: ${temp.fahrenheit}');

  temp.fahrenheit = 100;
  print('New Celsius: ${temp.celsius}');

  // ─────────────────────────────────────────
  // 5. 静态成员
  // ─────────────────────────────────────────

  var mathUtil1 = MathUtil();
  var mathUtil2 = MathUtil();
  MathUtil.instanceCount;  // 2（创建了两个实例）

  print('PI: ${MathUtil.pi}');          // 静态常量
  print('Instances: ${MathUtil.instanceCount}');
  print('Add: ${MathUtil.add(2, 3)}');  // 静态方法

  // ─────────────────────────────────────────
  // 6. 运算符重载
  // ─────────────────────────────────────────

  var v1 = Vector(1, 2);
  var v2 = Vector(3, 4);
  var v3 = v1 + v2;
  print('Vector: $v3');  // Vector(4, 6)
  print('Scaled: ${v1 * 3}');  // Vector(3, 6)
}

// ─────────────────────────────────────────
// 基本类
// ─────────────────────────────────────────

class User {
  // 字段
  String name;
  int age;

  // ── 主构造函数 ──
  // 语法糖：this.name 直接赋值给同名字段（类似 Swift 的 self.name = name）
  User(this.name, this.age);

  // ── 命名构造函数 ──（Dart 独有！用于替代函数重载）
  // 类似 Swift 的 convenience init，但更灵活
  User.anonymous()
      : name = 'Anonymous',
        age = 0;

  // 或者用 redirecting constructor（重定向构造函数）
  // User.guest() : this('Guest', 0);

  // ── const 构造函数 ──
  // 所有字段必须 final，用于创建编译期常量
  // const User.constant(this.name, this.age);

  // ── 方法 ──
  void greet() {
    print('Hello, I am $name, $age years old');
  }

  // ── Getter ──（计算属性，类似 Swift 的 computed property）
  int get ageInMonths => age * 12;

  // ── 重写 toString ──（类似 Swift 的 CustomStringConvertible）
  @override
  String toString() => 'User($name, $age)';
}

// ─────────────────────────────────────────
// const 构造函数示例
// ─────────────────────────────────────────

class Point {
  final double x;
  final double y;
  const Point(this.x, this.y);

  @override
  String toString() => 'Point($x, $y)';
}

// ─────────────────────────────────────────
// 继承
// ─────────────────────────────────────────

// 基类
class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  void speak() {
    print('$name makes a sound');
  }

  void describe() {
    print('Name: $name, Age: $age');
  }
}

// 子类（用 extends 继承，类似 Swift/TS/OC）
class Dog extends Animal {
  // 构造函数调用 super（类似 Swift 的 super.init）
  Dog(super.name, super.age);
  // 旧写法：Dog(String name, int age) : super(name, age);

  @override
  void speak() {
    print('$name says: 汪汪!');
  }
}

class Cat extends Animal {
  Cat(super.name, super.age);

  @override
  void speak() {
    print('$name says: 喵喵~');
  }
}

// ─────────────────────────────────────────
// 抽象类（类似 TS 的 abstract class，Swift 的 protocol + 默认实现）
// ─────────────────────────────────────────

abstract class Shape {
  // 抽象 getter（子类必须实现）
  double get area;

  // 可以有具体方法（带默认实现）
  String describe() => 'Shape with area $area';
}

// 实现抽象类
class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double get area => 3.14159 * radius * radius;
}

class Rectangle extends Shape {
  double width, height;
  Rectangle(this.width, this.height);

  @override
  double get area => width * height;
}

// ─────────────────────────────────────────
// 接口实现（Dart 没有 interface 关键字！）
// ─────────────────────────────────────────

// 💡 Dart 中每个类都隐式定义了一个接口
// 用 implements 实现接口（类似 Swift 的 protocol、TS 的 interface）

abstract class Drawable {
  void draw();
  void resize(double factor);
}

// 实现接口
class ImageView implements Drawable {
  String src;
  double scale;

  ImageView(this.src, {this.scale = 1.0});

  @override
  void draw() => print('Drawing image: $src');

  @override
  void resize(double factor) {
    scale *= factor;
    print('Resized to $scale');
  }
}

// ─────────────────────────────────────────
// Getter & Setter
// ─────────────────────────────────────────

class Temperature {
  double _celsius;  // _ 前缀表示私有（Dart 的访问控制是按库级别，不是类级别）

  Temperature(this._celsius);

  // Getter
  double get celsius => _celsius;
  double get fahrenheit => _celsius * 9 / 5 + 32;

  // Setter
  set celsius(double value) => _celsius = value;
  set fahrenheit(double value) => _celsius = (value - 32) * 5 / 9;

  @override
  String toString() => '${_celsius.toStringAsFixed(1)}°C';
}

// ─────────────────────────────────────────
// 静态成员 & 单例模式
// ─────────────────────────────────────────

class MathUtil {
  // 静态常量（类似 Swift 的 static let）
  static const pi = 3.14159265358979;

  // 静态变量
  static int instanceCount = 0;

  MathUtil() {
    instanceCount++;
  }

  // 静态方法
  static int add(int a, int b) => a + b;
  static int multiply(int a, int b) => a * b;
}

// ─────────────────────────────────────────
// 运算符重载
// ─────────────────────────────────────────

class Vector {
  final double x;
  final double y;

  const Vector(this.x, this.y);

  // 重载 + 运算符
  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);

  // 重载 * 运算符（标量乘法）
  Vector operator *(double scalar) => Vector(x * scalar, y * scalar);

  @override
  String toString() => 'Vector($x, $y)';
}

// ─────────────────────────────────────────
// 💡 私有成员说明
// ─────────────────────────────────────────

// Dart 没有 public/private/protected 关键字！
// 以 _ 开头的标识符是库私有的（library-private）
// - _name: 只在当前文件（库）内可访问
// - name:  所有导入者都可以访问
//
// 这和 Swift/TS/OC 都不同：
// - Swift: private / fileprivate / internal / public
// - TS:    private / protected / public
// - OC:    @private / @protected / @public (instance variable)
// - Dart:  _ 前缀 = 库级别私有，无前缀 = 公开
