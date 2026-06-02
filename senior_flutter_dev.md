# Flutter 移动端资深开发应具备的能力

## 一、基础功底（地基）

- **Dart 深度掌握**：async/await、Stream、Isolate、Zone、泛型、扩展方法、元编程、tree shaking 原理
- **Flutter 渲染机制**：Widget → Element → RenderObject 三棵树、Build/Layout/Paint 流程、Layer 合成
- **状态管理选型**：Provider / Riverpod / Bloc / GetX，至少精通 1-2 种，理解设计权衡
- **路由与导航**：Navigator 2.0、声明式路由、路由拦截与权限控制

## 二、性能优化（资深分水岭）

- **DevTools 熟练度**：Performance、Memory、Timeline 能看懂火焰图
- **首屏优化**：启动白屏、闪屏、懒加载、预加载策略
- **列表性能**：ListView/GridView/CustomScrollView 复用原理，Sliver 体系
- **渲染优化**：const 构造、RepaintBoundary、避免 setState 滥用、节流防抖
- **包体积优化**：tree shaking、字体裁剪、split debug info、R8/ProGuard

## 三、架构能力

- **分层架构**：Presentation / Domain / Data 三层，或 Clean Architecture
- **模块化**：package 拆分、feature 模块、monorepo（melos）实践
- **依赖注入**：get_it / injectable / Riverpod DI
- **响应式/适配**：ScreenUtil、LayoutBuilder、媒体查询、折叠屏适配

## 四、工程化

- **CI/CD**：fastlane、Jenkins/GitHub Actions、自动化打包发版
- **测试体系**：Unit + Widget + Integration 三层测试，Golden Test、Mockito
- **代码规范**：lint 规则（very_good_analysis）、提交规范、Code Review
- **混合开发**：Flutter 与原生（Android/iOS）双向通信（Platform Channel、FFI）

## 五、平台原生能力

- **Android 端**：Gradle 配置、ABI 拆分、权限处理、厂商兼容（小米/华为推送）
- **iOS 端**：CocoaPods、证书管理、Info.plist、App Store 审核坑
- **系统集成**：相机/相册/定位/蓝牙/推送/支付 SDK 接入

## 六、进阶加分项

- **Flutter Web/Desktop**：理解多端差异
- **Flutter Engine 定制**：修改引擎、Skia 渲染、Impeller 适配
- **插件开发**：自己写 Plugin、Platform View
- **动画体系**：Tween、AnimationController、Hero、自定义 Physics
- **国际化与无障碍**：i18n、a11y 支持
- **安全**：代码混淆、加固、敏感信息存储（flutter_secure_storage）

## 七、软实力

- **问题定位能力**：能从现象反推到 Skia/Engine 层
- **源码阅读**：至少通读 Flutter 核心源码一次（RenderObject、SchedulerBinding）
- **技术决策**：能在多个方案中给出理由和取舍
- **团队影响力**：制定规范、带新人、推动架构升级

---
