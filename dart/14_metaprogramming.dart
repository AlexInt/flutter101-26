/// ============================================================
/// 14 - 元编程与代码生成（Metaprogramming & Code Generation）
/// ============================================================
/// Dart 没有像 Swift 的 Macros 或 Kotlin 的 KSP 那样的编译期元编程，
/// 但通过 build_runner + source_gen 生态实现了强大的代码生成能力。
///
/// 核心理念：
/// - 通过注解（Annotation）标记需要生成的代码
/// - build_runner 扫描源码，自动生成 .g.dart / .freezed.dart 文件
/// - 生成代码与手写代码分离，重新生成会覆盖 .g.dart
///
/// 常用代码生成库：
/// - json_serializable → JSON 序列化/反序列化
/// - freezed           → 不可变类、copyWith、union types、相等性
/// - retrofit          → REST API 接口自动生成
/// - drift (moor)      → 类型安全的数据库操作
/// - injectable        → 依赖注入代码生成
/// - auto_route        → 类型安全的路由生成
///
/// 对比：
/// - Swift:   Macros (Swift 5.9+) / Sourcery
/// - Kotlin:  KSP / kapt / annotation processing
/// - TS:      没有标准方案，通常用 ttypescript + transformer
/// - Dart:    build_runner + source_gen + annotation
///
/// 💡 本文件演示代码生成的使用方式和原理
/// ⚠️ 运行前需要配置 pubspec.yaml（见下方注释）
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. 注解（Annotation）— 代码生成的触发器
  // ─────────────────────────────────────────

  // Dart 注解是 const 对象，用 @ 前缀标记
  // 注解本身不做任何事，只是给代码"贴标签"
  // 代码生成器读取这些标签，然后生成对应代码

  print('--- 注解基本语法 ---');

  // 注解可以加在：类、方法、字段、参数、函数上
  // @JsonSerializable()   ← 告诉 json_serializable 生成 toJson/fromJson
  // @freezed              ← 告诉 freezed 生成不可变类代码
  // @deprecated           ← Dart 内置注解，标记已过时
  // @override             ← Dart 内置注解，标记重写

  print('注解只是"标签"，本身不执行任何逻辑');
  print('需要配合 build_runner 才能生效');

  // ─────────────────────────────────────────
  // 2. json_serializable 使用示例 ⭐
  // ─────────────────────────────────────────

  // ❌ 不用代码生成：手写 JSON 序列化（繁琐且易错）
  print('\n--- 手写 JSON 序列化（痛苦）---');

  var userMap = {'name': 'Alice', 'age': 25, 'email': 'alice@example.com'};
  // 手写 fromJson：容易拼错字段名，忘记处理 null
  var manualUser = ManualUser(
    name: userMap['name'] as String,
    age: userMap['age'] as int,
    email: userMap['email'] as String?,
  );
  print('手动解析: ${manualUser.name}, ${manualUser.age}');

  // ✅ 用 json_serializable：自动生成序列化代码
  print('\n--- json_serializable（自动生成）---');

  // 只需要写类定义和注解，fromJson/toJson 自动生成
  // 详见下方 UserJson 类定义（实际项目中 .g.dart 是自动生成的）
  var jsonUser = UserJson.fromJson(userMap);
  print('自动解析: ${jsonUser.name}, ${jsonUser.age}');
  print('序列化回 JSON: ${jsonUser.toJson()}');

  // ─────────────────────────────────────────
  // 3. freezed 使用示例 ⭐
  // ─────────────────────────────────────────

  // freezed 是 Flutter 项目中最常用的代码生成库
  // 自动生成：不可变类、copyWith、== 和 hashCode、toString、JSON

  print('\n--- freezed 风格示例 ---');

  // 模拟 freezed 生成的类（实际项目中由 build_runner 生成）
  var product = Product(name: 'iPhone', price: 999.0, stock: 100);
  print('产品: $product');

  // copyWith（不可变修改）
  var updated = product.copyWith(price: 899.0);
  print('降价后: $updated');
  print('原产品不变: $product');

  // 相等性比较（freezed 自动生成 == 和 hashCode）
  var product2 = Product(name: 'iPhone', price: 999.0, stock: 100);
  print('两个产品相等: ${product == product2}');  // true

  // ─────────────────────────────────────────
  // 4. build_runner 工作流程 ⭐
  // ─────────────────────────────────────────

  print('\n--- build_runner 工作流程 ---');
  print('1. 在代码中写注解（如 @JsonSerializable()）');
  print('2. 运行: dart run build_runner build');
  print('3. build_runner 扫描所有 .dart 文件');
  print('4. 找到注解，调用对应的 Builder 生成代码');
  print('5. 输出到 xxx.g.dart（与源文件同名 + .g.dart）');
  print('');
  print('常用命令：');
  print('  dart run build_runner build        ← 生成一次');
  print('  dart run build_runner watch        ← 监听文件变化自动生成');
  print('  dart run build_runner build --delete-conflicting-outputs ← 强制重新生成');

  // ─────────────────────────────────────────
  // 5. 代码生成原理（source_gen）
  // ─────────────────────────────────────────

  print('\n--- source_gen 原理简述 ---');

  // build_runner 的核心是 source_gen 库
  // 工作流程：
  //
  // 1. 读取源码 → 解析为 AST（抽象语法树）
  // 2. 遍历 AST，找到带特定注解的类/方法
  // 3. 提取类的字段、方法等信息
  // 4. 根据模板生成代码字符串
  // 5. 写入 .g.dart 文件
  //
  // 简化版伪代码：
  //
  // class JsonGenerator extends GeneratorForAnnotation<JsonSerializable> {
  //   @override
  //   String generateForAnnotatedElement(element, annotation, buildStep) {
  //     // element: 被注解的类信息（类名、字段列表等）
  //     // annotation: 注解的参数
  //
  //     var className = element.displayName;
  //     var fields = element.fields;
  //
  //     // 生成 fromJson 方法
  //     var fromJsonCode = '''
  //       factory $className.fromJson(Map<String, dynamic> json) {
  //         return $className(
  //           ${fields.map((f) => '${f.name}: json["${f.name}"] as ${f.type}').join(',\n')}
  //         );
  //       }
  //     ''';
  //
  //     return fromJsonCode;
  //   }
  // }

  print('source_gen 通过解析 AST 提取注解信息，然后生成代码');

  // ─────────────────────────────────────────
  // 6. pubspec.yaml 配置示例
  // ─────────────────────────────────────────

  print('\n--- pubspec.yaml 配置（示例）---');
  print('''
# dependencies:
#   json_annotation: ^4.8.0    ← 注解定义（运行时依赖）
#   freezed_annotation: ^2.4.0 ← freezed 注解

# dev_dependencies:
#   build_runner: ^2.4.0       ← 构建工具（开发时依赖）
#   json_serializable: ^6.7.0  ← JSON 代码生成器
#   freezed: ^2.4.0            ← freezed 代码生成器
''');

  // ─────────────────────────────────────────
  // 7. 手写一个简单的代码生成器（进阶）
  // ─────────────────────────────────────────

  print('--- 自定义注解 + 生成器概念 ---');

  // Step 1: 定义注解
  // class ToStringGenerator {
  //   const ToStringGenerator();
  // }
  // const toStringGenerator = ToStringGenerator();

  // Step 2: 在业务代码中使用
  // @toStringGenerator
  // class Person {
  //   final String name;
  //   final int age;
  // }

  // Step 3: 编写 Builder（source_gen）
  // class ToStringBuilder extends GeneratorForAnnotation<ToStringGenerator> {
  //   @override
  //   String generateForAnnotatedElement(...) {
  //     return 'String toString() => "Person(name: \$name, age: \$age)"';
  //   }
  // }

  // Step 4: 在 build.yaml 中注册
  // builders:
  //   toString_builder:
  //     import: "package:my_package/builder.dart"
  //     builder_factories: ["toStringBuilder"]
  //     build_extensions: {".dart": [".g.dart"]}

  print('自定义生成器 = 定义注解 + 编写 Builder + 注册到 build.yaml');

  // ─────────────────────────────────────────
  // 8. 代码生成 vs 反射（Reflection）
  // ─────────────────────────────────────────

  print('\n--- 代码生成 vs 反射 ---');
  print('');
  print('Dart 故意不支持反射（dart:mirrors 已废弃）：');
  print('  - 反射会阻止 tree shaking（编译器不知道哪些代码会被用到）');
  print('  - 反射增加包体积（需要保留所有元数据）');
  print('  - 反射是运行时开销，代码生成是编译时开销');
  print('');
  print('代码生成的优势：');
  print('  ✅ 编译时检查，错误早发现');
  print('  ✅ 零运行时开销（生成的就是普通代码）');
  print('  ✅ 支持 tree shaking（死代码可被移除）');
  print('  ✅ 生成的代码可以查看和调试');

  // ─────────────────────────────────────────
  // 9. 常见问题与技巧
  // ─────────────────────────────────────────

  print('\n--- 常见坑与技巧 ---');
  print('1. .g.dart 文件要加入版本控制（CI 不会自动运行 build_runner）');
  print('2. 修改注解后必须重新运行 build_runner');
  print('3. 生成失败时：先删除 .g.dart，再用 --delete-conflicting-outputs');
  print('4. part "xxx.g.dart" 必须和源文件配对');
  print('5. freezed 的 union types 替代 sealed class 在某些场景更方便');

  print('\n💡 总结：');
  print('- json_serializable: JSON 序列化自动生成（告别手写 fromJson）');
  print('- freezed: 不可变类 + copyWith + 相等性 + union types（全家桶）');
  print('- build_runner: 代码生成的引擎（dart run build_runner build）');
  print('- 代码生成 > 反射：编译时安全 + 零运行时开销 + 支持 tree shaking');
}

// ═══════════════════════════════════════════
// 手写 JSON 序列化示例（不用代码生成）
// ═══════════════════════════════════════════

class ManualUser {
  final String name;
  final int age;
  final String? email;

  ManualUser({required this.name, required this.age, this.email});

  // 手写 fromJson（容易出错）
  factory ManualUser.fromJson(Map<String, dynamic> json) {
    return ManualUser(
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email'] as String?,
    );
  }

  // 手写 toJson
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'email': email,
  };
}

// ═══════════════════════════════════════════
// json_serializable 风格（模拟生成结果）
// ═══════════════════════════════════════════

// 实际项目中这样写：
//
// import 'package:json_annotation/json_annotation.dart';
// part 'user_json.g.dart';
//
// @JsonSerializable()
// class UserJson {
//   final String name;
//   final int age;
//   final String? email;
//
//   UserJson({required this.name, required this.age, this.email});
//
//   factory UserJson.fromJson(Map<String, dynamic> json) => _$UserJsonFromJson(json);
//   Map<String, dynamic> toJson() => _$UserJsonToJson(this);
// }

// 这里模拟生成的代码（实际由 build_runner 生成到 user_json.g.dart）
class UserJson {
  final String name;
  final int age;
  final String? email;

  UserJson({required this.name, required this.age, this.email});

  // ↓ 以下是 build_runner 自动生成的代码 ↓
  factory UserJson.fromJson(Map<String, dynamic> json) {
    return UserJson(
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }
}

// ═══════════════════════════════════════════
// freezed 风格（模拟生成结果）
// ═══════════════════════════════════════════

// 实际项目中这样写：
//
// import 'package:freezed_annotation/freezed_annotation.dart';
// part 'product.freezed.dart';
//
// @freezed
// class Product with _$Product {
//   const factory Product({
//     required String name,
//     required double price,
//     required int stock,
//   }) = _Product;
//
//   factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
// }

// 这里模拟 freezed 生成的核心功能
class Product {
  final String name;
  final double price;
  final int stock;

  const Product({required this.name, required this.price, required this.stock});

  // freezed 自动生成的 copyWith
  Product copyWith({String? name, double? price, int? stock}) {
    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  // freezed 自动生成 == 和 hashCode
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Product &&
            other.name == name &&
            other.price == price &&
            other.stock == stock);
  }

  @override
  int get hashCode => Object.hash(name, price, stock);

  // freezed 自动生成 toString
  @override
  String toString() => 'Product(name: $name, price: $price, stock: $stock)';
}

// 💡 代码生成工作流：
//
//  ┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
//  │  手写源码          │     │  build_runner    │     │  生成的代码       │
//  │  (user.dart)     │────▶│  扫描注解          │────▶│  (user.g.dart)  │
//  │                 │     │  解析 AST          │     │                │
//  │  @JsonSerializable│    │  生成代码          │     │  _$UserFromJson │
//  │  class User {...} │    │                  │     │  _$UserToJson   │
//  └─────────────────┘     └──────────────────┘     └─────────────────┘
//          │                        │                        │
//          │                        │                        │
//          ▼                        ▼                        ▼
//  ┌──────────────────────────────────────────────────────────────┐
//  │                    编译时合并（part 指令）                       │
//  │         user.dart + user.g.dart → 完整可运行代码               │
//  └──────────────────────────────────────────────────────────────┘
