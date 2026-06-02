/// ============================================================
/// 08 - 泛型（Generics）
/// ============================================================
/// Dart 的泛型和 TS/Swift 非常相似，用于编写类型安全的可复用代码。
///
/// 对比：
/// - TS:    <T>, <T extends Foo>, <K, V>
/// - Swift: <T>, <T: Protocol>, <Key, Value>
/// - Dart:  <T>, <T extends Foo>, <K, V>（几乎一模一样）
///
/// 💡 运行方式：dart run 08_generics.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. 泛型类
  // ─────────────────────────────────────────

  // 基本泛型类（类似 Swift 的 struct Stack<T>）
  var intStack = Stack<int>();
  intStack.push(1);
  intStack.push(2);
  intStack.push(3);
  print('Pop: ${intStack.pop()}');     // 3
  print('Peek: ${intStack.peek()}');   // 2
  print('Size: ${intStack.size}');     // 2

  var stringStack = Stack<String>();
  stringStack.push('hello');
  stringStack.push('world');

  // ─────────────────────────────────────────
  // 2. 泛型约束（extends）
  // ─────────────────────────────────────────

  // 限制 T 必须是 Comparable 的子类型
  var maxInt = max(3, 7);
  var maxStr = max('apple', 'banana');
  print('Max int: $maxInt');     // 7
  print('Max str: $maxStr');     // banana

  // ─────────────────────────────────────────
  // 3. 泛型方法
  // ─────────────────────────────────────────

  // 泛型函数（类似 TS 的 <T>(a: T, b: T): T）
  var firstInt = first([10, 20, 30]);
  var firstStr = first(['a', 'b', 'c']);
  print('First int: $firstInt');   // 10
  print('First str: $firstStr');   // a

  // 类型推断通常可以省略泛型参数
  var firstExplicit = first<double>([1.5, 2.5]);
  print('First explicit: $firstExplicit');

  // ─────────────────────────────────────────
  // 4. 泛型在实际中的应用
  // ─────────────────────────────────────────

  // API 响应包装器（Flutter 中非常常见！）
  var success = ApiResponse<User>.success(User('Alice', 25));
  var error = ApiResponse<User>.error('Network error');
  var loading = ApiResponse<User>.loading();

  success.handle(
    onSuccess: (user) => print('User: ${user.name}'),
    onError: (msg) => print('Error: $msg'),
    onLoading: () => print('Loading...'),
  );

  // ─────────────────────────────────────────
  // 5. 泛型缓存
  // ─────────────────────────────────────────

  var cache = Cache<String>();
  cache.set('key1', 'value1');
  cache.set('key2', 'value2');
  print('Get: ${cache.get('key1')}');

  // 类型安全的缓存
  var userCache = Cache<User>();
  userCache.set('current', User('Bob', 30));
  print('Cached user: ${userCache.get('current')?.name}');

  // ─────────────────────────────────────────
  // 6. 多类型参数
  // ─────────────────────────────────────────

  var pair = Pair('name', 42);
  print('Pair: ${pair.first} = ${pair.second}');

  // 泛型函数 + 多类型参数
  var swapped = swap(1, 'hello');
  print('Swapped: ${swapped.first}, ${swapped.second}');

  // ─────────────────────────────────────────
  // 7. Flutter 中的泛型使用（预览）
  // ─────────────────────────────────────────

  // Flutter 中泛型无处不在：
  // - Navigator.push<T>(context, route)    → 页面跳转带返回值类型
  // - Provider.of<T>(context)              → 依赖注入
  // - FutureBuilder<T>(future, builder)    → 异步构建 Widget
  // - StreamBuilder<T>(stream, builder)    → 流数据构建 Widget
  // - TextEditingController extends ValueNotifier<String>

  // 模拟 Provider 风格的状态管理
  var store = Store<int>(initialValue: 0);
  store.addListener((value) => print('State changed: $value'));
  store.setState(42);
  print('Current state: ${store.state}');
}

// ═══════════════════════════════════════════
// 泛型类定义
// ═══════════════════════════════════════════

/// 栈（后进先出）
class Stack<T> {
  final List<T> _items = [];

  void push(T item) => _items.add(item);

  T? pop() => _items.isEmpty ? null : _items.removeLast();

  T? peek() => _items.isEmpty ? null : _items.last;

  int get size => _items.length;

  bool get isEmpty => _items.isEmpty;
}

/// 泛型约束：T 必须实现 Comparable
T max<T extends Comparable<T>>(T a, T b) {
  return a.compareTo(b) >= 0 ? a : b;
}

/// 泛型方法
T first<T>(List<T> list) {
  if (list.isEmpty) throw Exception('List is empty');
  return list.first;
}

// ─────────────────────────────────────────
// API 响应包装器（Flutter 常用模式）
// ─────────────────────────────────────────

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  ApiResponse._({this.data, this.error, this.isLoading = false});

  factory ApiResponse.success(T data) => ApiResponse._(data: data);
  factory ApiResponse.error(String error) => ApiResponse._(error: error);
  factory ApiResponse.loading() => ApiResponse._(isLoading: true);

  void handle({
    void Function(T data)? onSuccess,
    void Function(String error)? onError,
    void Function()? onLoading,
  }) {
    if (isLoading) {
      onLoading?.call();
    } else if (error != null) {
      onError?.call(error!);
    } else if (data != null) {
      onSuccess?.call(data!);
    }
  }
}

// ─────────────────────────────────────────
// 泛型缓存
// ─────────────────────────────────────────

class Cache<T> {
  final Map<String, T> _store = {};

  void set(String key, T value) => _store[key] = value;

  T? get(String key) => _store[key];

  void remove(String key) => _store.remove(key);

  void clear() => _store.clear();

  bool contains(String key) => _store.containsKey(key);
}

// ─────────────────────────────────────────
// Pair / 多类型参数
// ─────────────────────────────────────────

class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}

// 泛型方法：交换两个值的类型
Pair<B, A> swap<A, B>(A a, B b) => Pair(b, a);

// ─────────────────────────────────────────
// 简单 User 类
// ─────────────────────────────────────────

class User {
  final String name;
  final int age;

  User(this.name, this.age);

  @override
  String toString() => 'User($name, $age)';
}

// ─────────────────────────────────────────
// 简单状态管理（模拟 Provider 风格）
// ─────────────────────────────────────────

class Store<T> {
  T _state;
  final List<void Function(T)> _listeners = [];

  Store({required T initialValue}) : _state = initialValue;

  T get state => _state;

  void setState(T newState) {
    _state = newState;
    for (var listener in _listeners) {
      listener(newState);
    }
  }

  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }
}
