# Flutter Layout 布局示例

Flutter 常用布局组件示例项目，涵盖容器、线性、层叠、列表、网格、弹性、流式、对齐等布局方式，以及综合实战案例。

## 功能特性

- 10 个完整的布局示例页面
- Material 3 设计风格
- 清晰的代码结构与注释
- 首页导航卡片，一键跳转到对应示例

## 示例列表

| 序号 | 名称 | 说明 |
| --- | --- | --- |
| 01 | Container | 容器布局：padding / margin / decoration |
| 02 | Row & Column | 线性布局：水平排列 & 垂直排列 |
| 03 | Stack | 层叠布局：组件重叠与定位 |
| 04 | ListView | 列表布局：垂直/水平滚动列表 |
| 05 | GridView | 网格布局：二维网格排列 |
| 06 | Flex 弹性布局 | Expanded / Flexible / Spacer 用法 |
| 07 | Wrap | 流式布局：自动换行排列 |
| 08 | Align & Center | 对齐与居中定位 |
| 09 | 综合实战 | 卡片列表页：多种布局组合 |
| 10 | 微信聊天室 | 聊天界面：消息发送与展示 |

## 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 运行项目

```bash
flutter run -t lib/main.dart
```

## 项目结构

```
lib/
├── main.dart              # 主入口 & 首页导航
└── pages/
    ├── alignment_page.dart      # 对齐布局
    ├── chat_page.dart           # 聊天室页面
    ├── comprehensive_page.dart  # 综合实战
    ├── container_page.dart      # 容器布局
    ├── flex_page.dart           # 弹性布局
    ├── grid_view_page.dart      # 网格布局
    ├── list_view_page.dart      # 列表布局
    ├── row_column_page.dart     # 线性布局
    ├── stack_page.dart          # 层叠布局
    └── wrap_page.dart           # 流式布局
```

## 相关资源

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Flutter 布局指南](https://docs.flutter.dev/ui/layout)

