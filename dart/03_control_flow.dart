/// ============================================================
/// 03 - 控制流：条件判断、循环、switch
/// ============================================================
/// Dart 的控制流和其他语言非常相似，但有一些独特的语法糖。
///
/// 💡 运行方式：dart run 03_control_flow.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. if / else if / else
  // ─────────────────────────────────────────

  int score = 85;

  if (score >= 90) {
    print('优秀');
  } else if (score >= 80) {
    print('良好');       // ← 会执行
  } else if (score >= 60) {
    print('及格');
  } else {
    print('不及格');
  }

  // 💡 注意：条件必须是 bool 类型！
  // if (score) {}     // ❌ 不像 TS/JS 可以用 truthy 值
  // if (score > 0) {} // ✅ 必须显式比较

  // ─────────────────────────────────────────
  // 2. 三元运算符 & 空值合并
  // ─────────────────────────────────────────

  // 三元运算符（和 TS/Swift 完全一样）
  String status = score >= 60 ? '及格' : '不及格';
  print('Status: $status');

  // 空值合并 ??（类似 TS 的 ?? ，Swift 的 ??）
  String? nullableName;
  String displayName = nullableName ?? '默认用户';
  print('Display: $displayName');  // 默认用户

  // 空值赋值 ??=（如果为 null 则赋值）
  String? username;
  username ??= 'anonymous';
  print('Username: $username');  // anonymous
  username ??= 'other';          // 已经不是 null，不会赋值
  print('Username: $username');  // anonymous

  // ─────────────────────────────────────────
  // 3. 条件赋值 & 级联运算符
  // ─────────────────────────────────────────

  // 级联运算符 ..（Dart 独有！可以在同一个对象上连续操作）
  // 类似 Swift 的链式调用，但更灵活
  var buffer = StringBuffer();
  buffer
    ..write('Hello')
    ..write(' ')
    ..write('World')
    ..writeln('!');
  print(buffer.toString());  // Hello World!

  // 类比 TS：你需要写多次 buffer.write(...)
  // 类比 Swift：需要每个方法都返回 self 才能链式调用
  // Dart 的 .. 不需要方法返回任何东西！

  // ─────────────────────────────────────────
  // 4. for 循环
  // ─────────────────────────────────────────

  // 经典 for 循环
  for (int i = 0; i < 5; i++) {
    // print(i);  // 0, 1, 2, 3, 4
  }

  // for-in 循环（遍历集合，类似 Swift 的 for-in，TS 的 for...of）
  var fruits = ['苹果', '香蕉', '橙子'];
  for (var fruit in fruits) {
    print('Fruit: $fruit');
  }

  // forEach（函数式遍历，不能 break/continue）
  fruits.forEach((fruit) => print('forEach: $fruit'));

  // for with index（带索引遍历）
  for (var i = 0; i < fruits.length; i++) {
    print('$i: ${fruits[i]}');
  }

  // 💡 Dart 3 新语法：使用 .indexed（类似 Swift 的 enumerated()）
  for (var (index, fruit) in fruits.indexed) {
    print('[$index] $fruit');
  }

  // ─────────────────────────────────────────
  // 5. while & do-while
  // ─────────────────────────────────────────

  int count = 3;
  while (count > 0) {
    print('Countdown: $count');
    count--;
  }

  // do-while（至少执行一次）
  int n = 0;
  do {
    print('do-while: n = $n');
    n++;
  } while (n < 3);

  // ─────────────────────────────────────────
  // 6. switch 语句
  // ─────────────────────────────────────────

  String command = 'open';

  // 传统 switch（注意：Dart 不需要 break，不会 fall-through）
  switch (command) {
    case 'open':
      print('Opening...');  // ← 会执行
    case 'close':
      print('Closing...');  // ← 不会执行！不像 C/OC 需要 break
    case 'save':
      print('Saving...');
    default:
      print('Unknown command');
  }

  // 💡 如果需要 fall-through，用 continue label
  switch (command) {
    case 'open':
      print('Opening with fall-through...');
      continue alsoClose;
    alsoClose:
    case 'close':
      print('Also closing...');
    default:
      print('Done');
  }

  // ─────────────────────────────────────────
  // 7. Switch 表达式（Dart 3 新特性）⭐
  // ─────────────────────────────────────────

  // 类似 Swift 的 switch 表达式，可以直接赋值
  String description = switch (command) {
    'open'  => '打开文件',
    'close' => '关闭文件',
    'save'  => '保存文件',
    _       => '未知命令',   // _ 是默认分支（类似 Swift 的 default）
  };
  print('Command: $description');

  // 支持多值匹配
  String dayType = switch (DateTime.now().weekday) {
    6 || 7 => '周末',       // || 表示"或"
    _       => '工作日',
  };
  print('Today is: $dayType');

  // 支持条件守卫（when）
  int age = 20;
  String category = switch (age) {
    < 13        => '儿童',
    >= 13 && < 18 => '青少年',
    >= 18 && < 60 => '成年人',
    _            => '老年人',
  };
  print('Category: $category');

  // ─────────────────────────────────────────
  // 8. 集合中的控制流（Dart 独有！Flutter 必备！）
  // ─────────────────────────────────────────

  bool showAdmin = true;
  bool isLoggedIn = true;

  // 在 List 字面量中使用 if/for（Flutter 的 Widget 树中极其常见！）
  var menuItems = [
    '首页',
    '消息',
    if (isLoggedIn) '个人中心',        // 条件添加元素
    if (showAdmin) '管理后台',
    for (var i = 1; i <= 3; i++) '项目$i',  // 循环添加元素
  ];
  print('Menu: $menuItems');
  // [首页, 消息, 个人中心, 管理后台, 项目1, 项目2, 项目3]

  // 在 Map 字面量中也可以用
  var config = {
    'debug': true,
    if (isLoggedIn) 'user': 'currentUser',
    'theme': 'dark',
  };
  print('Config: $config');

  // 💡 这些语法在 Flutter 中非常重要：
  // Column(
  //   children: [
  //     Text('Title'),
  //     if (isLoading) CircularProgressIndicator(),
  //     for (var item in items) ListTile(title: Text(item)),
  //   ],
  // )

  // ─────────────────────────────────────────
  // 9. break & continue & label
  // ─────────────────────────────────────────

  // break: 跳出当前循环
  for (var i = 0; i < 10; i++) {
    if (i == 3) break;
    // print(i);  // 0, 1, 2
  }

  // continue: 跳过本次迭代
  for (var i = 0; i < 5; i++) {
    if (i == 2) continue;
    // print(i);  // 0, 1, 3, 4
  }

  // label: 跳出多层嵌套（谨慎使用）
  outerLoop:
  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      if (i == 1 && j == 1) break outerLoop;
      print('i=$i, j=$j');
    }
  }
}
