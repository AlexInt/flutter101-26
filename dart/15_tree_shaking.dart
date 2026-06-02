/// ============================================================
/// 15 - Tree Shaking 原理与 Dart/Flutter 包体积优化
/// ============================================================
/// Tree Shaking 是编译器自动移除未使用代码（Dead Code）的技术。
/// 理解它对 Flutter 应用的包体积优化至关重要。
///
/// 核心原理：
/// - 编译器从入口（main）开始，追踪所有被引用的代码
/// - 没有被任何路径引用到的代码，会被"摇掉"（不打包）
/// - 前提：代码必须是静态可分析的（不能有动态反射）
///
/// 对比：
/// - JS/Webpack: 基于 ES Module 的 import/export 静态分析
/// - Swift:     LLVM Dead Code Elimination
/// - Kotlin:    R8/ProGuard shrinking
/// - Dart:      dart2js / AOT 编译器的 tree shaking
///
/// 💡 运行方式：dart run 15_tree_shaking.dart
/// ============================================================

void main() {
  // ─────────────────────────────────────────
  // 1. Tree Shaking 是什么？
  // ─────────────────────────────────────────

  print('--- Tree Shaking 概念 ---');

  // 想象你有一棵大树，树上有很多分支（代码）
  // 只有从树根（main 函数）能走到的分支是"活的"
  // 走不到的分支就是"死代码"，编译器会把它们"摇掉"
  //
  // 举例：你导入了一个有 100 个函数的库
  // 但只用了其中 3 个 → 编译器只打包这 3 个函数
  // 剩余 97 个被 tree shaking 移除

  print('Tree Shaking = 自动移除未使用的代码');
  print('目标：减小最终产物的体积');

  // ─────────────────────────────────────────
  // 2. Dart 的两种编译模式与 Tree Shaking
  // ─────────────────────────────────────────

  print('\n--- 编译模式 ---');

  // Dart 有两种编译方式，tree shaking 的效果不同：
  //
  // 1. JIT（Just-In-Time，开发模式）
  //    - flutter run（debug/profile 模式）
  //    - 不做 tree shaking（为了快速编译和热重载）
  //    - 所有代码都会编译，体积较大
  //
  // 2. AOT（Ahead-Of-Time，发布模式）
  //    - flutter build --release
  //    - 做完整的 tree shaking
  //    - 只编译被使用的代码，体积更小
  //
  // 3. dart2js（Web 编译）
  //    - flutter build web
  //    - 也做 tree shaking（类似 JS 的 dead code elimination）

  print('JIT (debug) → 不 tree shake → 编译快，体积大');
  print('AOT (release) → 完整 tree shake → 编译慢，体积小');

  // ─────────────────────────────────────────
  // 3. 什么代码会被 Tree Shake 掉？
  // ─────────────────────────────────────────

  print('\n--- 会被移除的代码 ---');

  // ✅ 会被 tree shake 掉（安全移除）：

  // 1) 未使用的顶层函数
  // unusedTopLevelFunction() { ... }
  // 如果没有任何地方调用，会被移除

  // 2) 未使用的类的字段和方法
  // class BigClass {
  //   void usedMethod() { ... }     ← 被调用，保留
  //   void unusedMethod() { ... }   ← 未被调用，移除
  // }

  // 3) 未使用的导入
  // import 'package:huge_lib/huge_lib.dart';
  // 如果 huge_lib 中没有任何东西被使用，整个 import 被忽略

  // 4) 未使用的类
  // class NeverUsed { ... }
  // 从未被实例化或引用，整个类被移除

  print('✅ 未使用的函数、方法、字段、类、导入 → 会被移除');

  // ─────────────────────────────────────────
  // 4. 什么代码不会被 Tree Shake？（重要！）
  // ─────────────────────────────────────────

  print('\n--- 不会被移除的代码（tree shaking 的敌人）---');

  // ❌ 以下内容会阻止 tree shaking：

  // 1) 反射（dart:mirrors）
  //    - 编译器无法静态分析反射调用了什么
  //    - 所以所有代码都必须保留（这就是 Dart 废弃 mirrors 的原因）
  //    - Flutter 直接禁止使用 dart:mirrors

  // 2) 动态调用（dynamic 类型）
  //    - dynamic obj = getSomething();
  //    - obj.someMethod();  ← 编译器不知道 obj 的真实类型
  //    - 可能所有实现了 someMethod 的类都要保留

  // 3) 字符串形式的查找
  //    - 通过字符串动态查找类或方法
  //    - 编译器无法追踪

  print('❌ 反射 (dart:mirrors) → 阻止 tree shaking（Flutter 已禁用）');
  print('❌ dynamic 类型滥用 → 编译器无法确定类型，保守保留');
  print('❌ 字符串动态查找 → 无法静态分析');

  // ─────────────────────────────────────────
  // 5. 实际演示：Tree Shaking 效果
  // ─────────────────────────────────────────

  print('\n--- Tree Shaking 效果演示 ---');

  // 假设这是一个库文件（library.dart）：
  //
  // class UsedClass {
  //   void doWork() => print('working');
  //   void unusedMethod() => print('never called');
  // }
  //
  // class NeverUsedClass {
  //   void something() => print('never instantiated');
  // }
  //
  // void usedFunction() => print('used');
  // void unusedFunction() => print('unused');

  // 如果你的 main.dart 只用了：
  // import 'library.dart';
  // void main() {
  //   UsedClass().doWork();
  //   usedFunction();
  // }

  // Tree shaking 后的结果：
  // ✅ 保留: UsedClass, UsedClass.doWork, usedFunction
  // ❌ 移除: UsedClass.unusedMethod, NeverUsedClass, unusedFunction

  // 只使用了工具类的一个方法
  var result = MathUtils.add(10, 20);
  print('MathUtils.add(10, 20) = $result');
  // Tree shaking 后：只保留 add 方法
  // subtract、multiply、divide 都会被移除

  // ─────────────────────────────────────────
  // 6. Flutter 包体积优化实战
  // ─────────────────────────────────────────

  print('\n--- Flutter 包体积优化 ---');

  // 1) 使用 --split-debug-info（分离调试信息）
  //    flutter build apk --split-debug-info=./debug-info
  //    → 把调试符号从发布包中分离，APK 体积减少 30-50%

  // 2) 使用 --obfuscate（代码混淆）
  //    flutter build apk --obfuscate --split-debug-info=./debug-info
  //    → 缩短类名/方法名，进一步减小体积 + 反逆向

  // 3) 字体裁剪（Font Subsetting）
  //    Flutter 默认会自动裁剪只用到字符的字体子集
  //    pubspec.yaml 中声明的图标字体也会被裁剪

  // 4) 移除未使用的资源
  //    检查 pubspec.yaml 中是否有未使用的依赖
  //    检查 assets 目录中是否有未使用的图片

  // 5) 使用 deferred loading（延迟加载）
  //    import 'package:huge_lib/huge_lib.dart' deferred as huge;
  //    await huge.loadLibrary();  // 按需加载
  //    huge.someFunction();

  print('包体积优化清单：');
  print('  1. --split-debug-info → 分离调试符号');
  print('  2. --obfuscate → 混淆代码');
  print('  3. 移除未使用的依赖和 assets');
  print('  4. 大库用 deferred loading');
  print('  5. 避免滥用 dynamic');

  // ─────────────────────────────────────────
  // 7. Deferred Loading（延迟加载）
  // ─────────────────────────────────────────

  print('\n--- Deferred Loading ---');

  // 对于特别大的库，可以用 deferred 延迟加载
  // 这些代码不会包含在主包中，需要时才下载/加载
  //
  // import 'package:heavy_charts/heavy_charts.dart' deferred as charts;
  //
  // Future<void> showChart() async {
  //   await charts.loadLibrary();  // 首次调用时加载
  //   charts.renderChart();
  // }
  //
  // 适用场景：
  // - 某些页面用到的大型图表库（只在进入该页面时加载）
  // - 高级功能模块（不是所有用户都需要）

  print('deferred loading: 大库按需加载，减小初始包体积');

  // ─────────────────────────────────────────
  // 8. 如何检查 Tree Shaking 效果
  // ─────────────────────────────────────────

  print('\n--- 检查包体积 ---');

  // 1) 查看 APK 大小分析
  //    flutter build apk --analyze-size
  //    → 生成 size-analysis.json，详细列出每个模块的体积

  // 2) 查看 Web 产物
  //    flutter build web
  //    检查 build/web/main.dart.js 的大小

  // 3) 使用 DevTools
  //    flutter pub global activate devtools
  //    → 内置的 Size Analysis 工具

  print('检查命令：');
  print('  flutter build apk --analyze-size');
  print('  flutter build ios --analyze-size');
  print('  → 生成 size-analysis 报告');

  // ─────────────────────────────────────────
  // 9. 最佳实践总结
  // ─────────────────────────────────────────

  print('\n--- Tree Shaking 最佳实践 ---');
  print('✅ 使用具体类型而非 dynamic');
  print('✅ 避免 dart:mirrors（Flutter 已禁用）');
  print('✅ 代码生成优于反射（json_serializable, freezed）');
  print('✅ 大库使用 deferred loading');
  print('✅ 定期清理未使用的依赖');
  print('✅ 发布时用 --split-debug-info');
  print('✅ 用 --analyze-size 检查体积');

  print('\n💡 总结：');
  print('- Tree Shaking = 编译器自动移除未使用的代码');
  print('- AOT (release) 模式下生效，JIT (debug) 不生效');
  print('- 反射和 dynamic 是 tree shaking 的敌人');
  print('- 代码生成（build_runner）天然支持 tree shaking');
  print('- 配合 --split-debug-info 和 --obfuscate 进一步优化');
}

// ═══════════════════════════════════════════
// 演示用工具类（只有 add 被使用，其余会被 tree shake）
// ═══════════════════════════════════════════

class MathUtils {
  /// 被使用的方法 → 保留
  static int add(int a, int b) => a + b;

  /// 未被使用 → tree shaking 会移除
  static int subtract(int a, int b) => a - b;

  /// 未被使用 → tree shaking 会移除
  static int multiply(int a, int b) => a * b;

  /// 未被使用 → tree shaking 会移除
  static double divide(int a, int b) => a / b;
}

/// 未被使用的函数 → tree shaking 会移除
// ignore: unused_element
String _neverCalled() {
  return 'This function is never called and will be tree-shaken';
}

/// 未被使用的类 → tree shaking 会移除
// ignore: unused_element
class _DeadCode {
  void doSomething() {
    print('This class is never instantiated');
  }

  void doSomethingElse() {
    print('All of this will be removed by tree shaking');
  }
}

// 💡 Tree Shaking 工作流程示意：
//
//  编译前（所有代码）：
//
//  main.dart          library.dart
//  ┌──────────┐      ┌────────────────────┐
//  │ main()   │      │ UsedClass          │
//  │  ├─ A()  │─────▶│  ├─ usedMethod()   │ ← 被调用
//  │  └─ B()  │      │  └─ unusedMethod() │ ← 未被调用
//  │          │      │                    │
//  │          │      │ NeverUsedClass     │ ← 从未被引用
//  │          │      │  └─ something()    │
//  │          │      │                    │
//  │          │      │ usedFunction()     │ ← 未被调用
//  │          │      │ unusedFunction()   │ ← 未被调用
//  └──────────┘      └────────────────────┘
//
//  Tree Shaking 后（只有被引用的代码）：
//
//  ┌──────────┐      ┌────────────────┐
//  │ main()   │      │ UsedClass      │
//  │  ├─ A()  │─────▶│  └─ usedMethod │
//  │  └─ B()  │      └────────────────┘
//  └──────────┘
//
//  移除了: unusedMethod, NeverUsedClass, usedFunction, unusedFunction
