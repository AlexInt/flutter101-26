/// ============================================================
/// 04 - 集合：List、Map、Set 及常用操作
/// ============================================================
/// Dart 的集合类型和 TS/Swift 非常相似：
/// - List   ≈ Swift Array  / TS Array
/// - Map    ≈ Swift Dictionary / TS Map / Record
/// - Set    ≈ Swift Set / TS Set
///
/// 💡 运行方式：dart run 04_collections.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. List（列表/数组）
  // ─────────────────────────────────────────

  // 创建方式
  var numbers = [1, 2, 3, 4, 5];           // 类型推断为 List<int>
  List<String> names = ['Alice', 'Bob'];    // 显式声明
  var empty = <int>[];                      // 空列表需要类型标注
  var filled = List.filled(5, 0);           // [0, 0, 0, 0, 0]
  var generated = List.generate(5, (i) => i * 2);  // [0, 2, 4, 6, 8]

  // 基本操作
  numbers.add(6);                // 末尾添加
  numbers.insert(0, 0);         // 指定位置插入
  numbers.remove(3);            // 删除第一个匹配的元素
  numbers.removeAt(0);          // 按索引删除
  numbers.removeLast();         // 删除最后一个

  print('List: $numbers');
  print('Length: ${numbers.length}');
  print('First: ${numbers.first}');
  print('Last: ${numbers.last}');
  print('Contains 4: ${numbers.contains(4)}');

  // 索引访问（类似 TS/Swift 的 []）
  print('Index 0: ${numbers[0]}');
  numbers[0] = 100;              // 修改

  // 💡 安全访问：Dart 没有 numbers[safeIndex] 的语法糖
  // 需要自己检查索引，或用扩展方法

  // 切片（sublist，类似 Swift 的前缀/后缀操作）
  var sliced = numbers.sublist(1, 3);  // [1,3) 范围的元素
  print('Sublist: $sliced');

  // 排序
  var sortable = [3, 1, 4, 1, 5, 9];
  sortable.sort();               // 原地排序: [1, 1, 3, 4, 5, 9]
  sortable.sort((a, b) => b.compareTo(a));  // 降序
  print('Sorted: $sortable');

  // 反转
  var reversed = numbers.reversed.toList();
  print('Reversed: $reversed');

  // ─────────────────────────────────────────
  // 2. List 的函数式操作（链式调用）
  // ─────────────────────────────────────────

  var scores = [85, 92, 78, 95, 88, 72, 96];

  // 链式调用：过滤 → 排序 → 取前3
  var topThree = scores
      .where((s) => s >= 80)           // 过滤 >= 80
      .toList()                         // 需要 toList() 才能 sort
    ..sort((a, b) => b.compareTo(a))   // 降序排序（用级联）
    ;
  var result = topThree.take(3).toList();  // 取前3
  print('Top 3: $result');

  // map 转换类型
  var stringScores = scores.map((s) => '$s分').toList();
  print('String scores: $stringScores');

  // expand（flatMap）：将每个元素映射为多个元素
  var pairs = [1, 2, 3].expand((n) => [n, n * 10]).toList();
  print('Expand: $pairs');  // [1, 10, 2, 20, 3, 30]

  // toList / toSet 转换
  var uniqueSorted = [3, 1, 4, 1, 5].toSet().toList()..sort();
  print('Unique sorted: $uniqueSorted');

  // ─────────────────────────────────────────
  // 3. 解构赋值（Dart 3 新特性）
  // ─────────────────────────────────────────

  var list = [10, 20, 30];
  var [a, b, c] = list;         // 解构！类似 TS 的 const [a, b, c] = list
  print('a=$a, b=$b, c=$c');

  // 可以跳过某些元素
  var [first, _, third] = list;  // _ 表示忽略
  print('first=$first, third=$third');

  // ─────────────────────────────────────────
  // 4. Map（字典/哈希表）
  // ─────────────────────────────────────────

  // 创建
  var person = {
    'name': 'Alice',
    'age': '25',
    'city': 'Beijing',
  };

  // 显式类型
  Map<String, int> scores2 = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92,
  };

  // 基本操作
  print('Name: ${person['name']}');           // 取值（可能为 null）
  person['email'] = 'alice@example.com';      // 添加/修改
  person.remove('city');                       // 删除

  print('Keys: ${person.keys}');              // 所有 key
  print('Values: ${person.values}');          // 所有 value
  print('Contains key: ${person.containsKey('name')}');
  print('Length: ${person.length}');

  // 遍历
  person.forEach((key, value) {
    print('$key: $value');
  });

  // 更现代的遍历
  for (var entry in person.entries) {
    print('${entry.key} = ${entry.value}');
  }

  // Dart 3 解构
  for (var MapEntry(key: k, value: v) in person.entries) {
    print('$k -> $v');
  }

  // putIfAbsent: 如果 key 不存在则添加
  scores2.putIfAbsent('David', () => 0);
  print('Scores: $scores2');

  // update: 更新已有值
  scores2.update('Alice', (score) => score + 5);
  scores2.update('Unknown', (score) => 0, ifAbsent: () => 60);
  print('Updated scores: $scores2');

  // map: 转换 Map
  var doubled = scores2.map((name, score) => MapEntry(name, score * 2));
  print('Doubled: $doubled');

  // 合并 Map
  var defaults = {'theme': 'light', 'lang': 'zh'};
  var custom = {'theme': 'dark'};
  var merged = {...defaults, ...custom};  // 展开运算符（类似 TS 的 ...）
  print('Merged: $merged');  // {theme: dark, lang: zh}

  // ─────────────────────────────────────────
  // 5. Set（集合，无重复元素）
  // ─────────────────────────────────────────

  var setA = {1, 2, 3, 4, 5};
  var setB = {4, 5, 6, 7, 8};

  // 集合运算
  print('Union: ${setA.union(setB)}');           // 并集 {1,2,3,4,5,6,7,8}
  print('Intersection: ${setA.intersection(setB)}'); // 交集 {4,5}
  print('Difference: ${setA.difference(setB)}');     // 差集 {1,2,3}

  // 基本操作
  setA.add(6);
  setA.remove(1);
  print('Contains 3: ${setA.contains(3)}');
  print('Set: $setA');

  // ─────────────────────────────────────────
  // 6. 展开运算符（Spread Operator）⭐
  // ─────────────────────────────────────────

  // ... 展开（类似 TS 的 ...）
  var list1 = [1, 2, 3];
  var list2 = [0, ...list1, 4, 5];
  print('Spread: $list2');  // [0, 1, 2, 3, 4, 5]

  // ...? 安全展开（如果为 null 则忽略）
  List<int>? nullList;
  var safe = [0, ...?nullList, 1];
  print('Safe spread: $safe');  // [0, 1]

  // ─────────────────────────────────────────
  // 7. 不可变集合
  // ─────────────────────────────────────────

  // const 列表（编译期不可变）
  const constList = [1, 2, 3];
  // constList.add(4);  // ❌ 编译错误

  // unmodifiable 列表（运行时不可变）
  var unmodifiable = List.unmodifiable([1, 2, 3]);
  // unmodifiable.add(4);  // ❌ 运行时异常

  // 💡 Flutter 中常用 const 构造 Widget 以提升性能：
  // const EdgeInsets.all(8.0)
  // const SizedBox(height: 16)
}
