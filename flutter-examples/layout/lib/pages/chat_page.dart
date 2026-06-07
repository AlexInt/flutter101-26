import 'package:flutter/material.dart';

/// 微信聊天室示例页面
/// 
/// 这是一个模拟微信聊天界面的完整实现，包含以下功能：
/// - 消息列表展示（支持自己和他人的消息）
/// - 消息输入和发送
/// - 键盘弹出/收起时自动滚动到最新消息
/// - 点击空白区域收起键盘
/// - 用户滚动时自动收起键盘
/// - 安全区适配（支持刘海屏等设备）
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

/// ChatPage 的状态管理类
/// 
/// 使用 WidgetsBindingObserver 来监听屏幕尺寸变化（键盘弹出/收起）
class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  /// 消息列表 - 存储所有聊天消息
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: '早上好！',
      isMe: false,
      time: '08:00',
      avatar: 'A',
    ),
    ChatMessage(
      text: '早上好！今天天气不错',
      isMe: true,
      time: '08:01',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '是啊，阳光明媚',
      isMe: false,
      time: '08:02',
      avatar: 'A',
    ),
    ChatMessage(
      text: '你今天有什么安排吗？',
      isMe: false,
      time: '08:03',
      avatar: 'A',
    ),
    ChatMessage(
      text: '上午要处理一些工作上的事情，下午打算出去走走',
      isMe: true,
      time: '08:05',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '不错不错，劳逸结合',
      isMe: false,
      time: '08:06',
      avatar: 'A',
    ),
    ChatMessage(
      text: '对了，上次你说的那个项目怎么样了？',
      isMe: false,
      time: '08:08',
      avatar: 'A',
    ),
    ChatMessage(
      text: '进展顺利，已经完成了大部分功能开发',
      isMe: true,
      time: '08:10',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '太好了！期待看到成品',
      isMe: false,
      time: '08:11',
      avatar: 'A',
    ),
    ChatMessage(
      text: '预计下周就能上线测试了',
      isMe: true,
      time: '08:12',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '太棒了！到时候一定要告诉我',
      isMe: false,
      time: '08:13',
      avatar: 'A',
    ),
    ChatMessage(
      text: '没问题！',
      isMe: true,
      time: '08:15',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '对了，中午一起吃饭吗？',
      isMe: false,
      time: '09:30',
      avatar: 'A',
    ),
    ChatMessage(
      text: '好啊！想吃什么？',
      isMe: true,
      time: '09:31',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '听说附近新开了一家川菜馆，想去试试',
      isMe: false,
      time: '09:32',
      avatar: 'A',
    ),
    ChatMessage(
      text: '可以啊，我也想吃辣的了',
      isMe: true,
      time: '09:33',
      avatar: 'Me',
    ),
    ChatMessage(
      text: '那就这么定了，中午12点楼下见',
      isMe: false,
      time: '09:35',
      avatar: 'A',
    ),
    ChatMessage(
      text: '好的，不见不散！',
      isMe: true,
      time: '09:36',
      avatar: 'Me',
    ),
  ];

  /// 文本输入控制器 - 管理输入框的文本内容
  final TextEditingController _inputController = TextEditingController();
  
  /// 滚动控制器 - 控制消息列表的滚动位置
  final ScrollController _scrollController = ScrollController();
  
  /// 焦点节点 - 管理输入框的焦点状态（获得/失去焦点）
  final FocusNode _inputFocusNode = FocusNode();
  
  /// 自动滚动标志 - 用于区分用户手动滚动和程序自动滚动
  /// true: 程序正在自动滚动，此时不应收起键盘
  /// false: 用户手动滚动，应收起键盘
  bool _isAutoScrolling = false;

  /// 初始化方法 - 在组件创建时调用
  @override
  void initState() {
    super.initState();
    // 添加屏幕尺寸变化观察者，用于监听键盘弹出/收起
    WidgetsBinding.instance.addObserver(this);
    // 监听输入框焦点变化
    _inputFocusNode.addListener(_onFocusChange);
  }

  /// 销毁方法 - 在组件销毁时调用，清理资源
  @override
  void dispose() {
    // 移除屏幕尺寸变化观察者
    WidgetsBinding.instance.removeObserver(this);
    // 释放焦点节点资源
    _inputFocusNode.dispose();
    // 释放文本控制器资源
    _inputController.dispose();
    // 释放滚动控制器资源
    _scrollController.dispose();
    super.dispose();
  }

  /// 屏幕尺寸变化回调 - 当键盘弹出或收起时触发
  /// 
  /// 此方法会在键盘状态改变时被调用，我们在这里立即滚动到最新消息
  /// 这样可以让滚动动画与键盘弹出动画同时进行，提升用户体验
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 键盘状态变化时，立即滚动到底部（不等待布局完成）
    _scrollToBottom();
  }

  /// 焦点变化处理函数
  /// 
  /// 当输入框获得焦点时（用户点击输入框），立即滚动到最新消息
  /// 这样用户可以看到最新的聊天记录，同时键盘开始弹出
  void _onFocusChange() {
    if (_inputFocusNode.hasFocus) {
      // 获得焦点时立即滚动到底部，让滚动和键盘弹出同时进行
      _scrollToBottom();
    }
  }

  /// 滚动到消息列表底部
  /// 
  /// 使用 animateTo 实现平滑滚动效果，并设置自动滚动标志
  /// 以防止在自动滚动过程中误触发键盘收起逻辑
  void _scrollToBottom() {
    // 检查滚动控制器是否已附加到 ListView
    if (_scrollController.hasClients) {
      // 设置自动滚动标志，防止用户滚动检测干扰
      _isAutoScrolling = true;
      
      // 执行平滑滚动动画到最大滚动位置（即底部）
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent, // 滚动目标位置
        duration: const Duration(milliseconds: 300), // 动画持续时间
        curve: Curves.easeOut, // 缓动曲线，使动画更自然
      )
          .then((_) {
        // 滚动动画完成后，延迟重置自动滚动标志
        // 延迟是为了确保不会立即被用户滚动检测覆盖
        Future.delayed(const Duration(milliseconds: 100), () {
          _isAutoScrolling = false;
        });
      });
    }
  }

  /// 收起键盘
  /// 
  /// 通过取消焦点来隐藏键盘
  void _hideKeyboard() {
    // 取消当前焦点，从而收起键盘
    FocusScope.of(context).unfocus();
  }

  /// 发送消息
  /// 
  /// 处理用户发送消息的完整流程：
  /// 1. 获取并验证输入文本
  /// 2. 将新消息添加到消息列表
  /// 3. 清空输入框
  /// 4. 滚动到最新消息位置
  void _sendMessage() {
    // 获取输入文本并去除首尾空格
    final text = _inputController.text.trim();
    
    // 如果输入为空，直接返回，不发送空消息
    if (text.isEmpty) return;

    // 更新状态，将新消息添加到列表末尾
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isMe: true, // 标记为自己发送的消息
        time: _getCurrentTime(), // 获取当前时间
        avatar: 'Me', // 自己的头像标识
      ));
    });

    // 清空输入框内容
    _inputController.clear();

    // 发送消息后，等待 UI 更新完成再滚动到底部
    // 使用 addPostFrameCallback 确保在新的消息渲染完成后再执行滚动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 检查组件是否仍然挂载，避免在组件销毁后执行操作
      if (mounted) {
        _scrollToBottom();
      }
    });
  }

  /// 获取当前时间字符串
  /// 
  /// 返回格式为 "HH:mm" 的时间字符串，例如 "09:30"
  String _getCurrentTime() {
    final now = DateTime.now();
    // 使用 padLeft 确保小时和分钟都是两位数
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  /// 构建页面 UI
  /// 
  /// 整体结构：
  /// - Scaffold: 提供基本的页面结构（AppBar + Body）
  /// - GestureDetector: 检测点击空白区域以收起键盘
  /// - Column: 垂直布局，包含消息列表和输入区域
  ///   - Expanded + ListView: 可滚动的消息列表
  ///   - SafeArea + InputArea: 带安全区保护的输入区域
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 顶部应用栏，显示聊天对象信息
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF07C160),
              child: Text(
                'A',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '好友A',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '在线',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      // 主体内容区域
      body: GestureDetector(
        // 点击空白区域时收起键盘
        onTap: _hideKeyboard,
        // 设置为 translucent 使得点击透明区域也能触发事件
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            // 消息列表区域 - 使用 Expanded 占据剩余空间
            Expanded(
              // 监听滚动开始事件，用于检测用户手动滚动
              child: NotificationListener<ScrollStartNotification>(
                onNotification: (notification) {
                  // 只有用户主动滚动时才收起键盘，程序自动滚动时不收起
                  // 这样可以避免自动滚动时误触发键盘收起
                  if (!_isAutoScrolling) {
                    _hideKeyboard();
                  }
                  // 返回 false 表示继续传递通知给其他监听器
                  return false;
                },
                // 消息列表，使用 builder 模式高效渲染大量消息
                child: ListView.builder(
                  controller: _scrollController, // 绑定滚动控制器
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length, // 消息总数
                  itemBuilder: (context, index) {
                    // 为每条消息构建 UI
                    return _buildMessageItem(_messages[index]);
                  },
                ),
              ),
            ),
            // 输入区域 - 使用 SafeArea 确保在刘海屏设备上不被遮挡
            SafeArea(
              top: false, // 不需要顶部安全区（AppBar 已处理）
              child: _buildInputArea(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建单条消息的 UI
  /// 
  /// 根据消息类型（自己/他人）显示不同的样式和布局：
  /// - 他人的消息：左对齐，白色气泡，左侧显示头像
  /// - 自己的消息：右对齐，绿色气泡，右侧显示头像
  Widget _buildMessageItem(ChatMessage message) {
    // 使用 Align 实现消息的左右对齐
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8), // 消息之间的垂直间距
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end, // 底部对齐，使气泡和头像底部平齐
          // 根据消息类型设置主轴对齐方式
          mainAxisAlignment:
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // 他人的头像（仅在非自己消息时显示）
            if (!message.isMe)
              Container(
                margin: const EdgeInsets.only(right: 8), // 头像与气泡的间距
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF07C160), // 微信绿
                  child: Text(
                    message.avatar,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            // 消息气泡容器
            Container(
              // 限制最大宽度为屏幕宽度的 70%，避免消息过长
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                // 自己发的消息用绿色，他人发的用白色
                color: message.isMe ? const Color(0xFF07C160) : Colors.white,
                borderRadius: BorderRadius.circular(18), // 圆角气泡
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12, // 轻微阴影
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                // 根据消息类型设置交叉轴对齐
                crossAxisAlignment: message.isMe
                    ? CrossAxisAlignment.end // 自己的消息：右对齐
                    : CrossAxisAlignment.start, // 他人的消息：左对齐
                children: [
                  // 消息文本
                  Text(
                    message.text,
                    style: TextStyle(
                      // 自己的消息文字为白色，他人为深色
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                      height: 1.4, // 行高
                    ),
                  ),
                  const SizedBox(height: 4), // 文本与时间的间距
                  // 消息时间
                  Text(
                    message.time,
                    style: TextStyle(
                      // 时间文字颜色较浅
                      color: message.isMe ? Colors.white70 : Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // 自己的头像（仅在自己消息时显示）
            if (message.isMe)
              Container(
                margin: const EdgeInsets.only(left: 8), // 气泡与头像的间距
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF1890FF), // 蓝色头像背景
                  child: Text(
                    'Me',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建底部输入区域
  /// 
  /// 包含：表情按钮 + 输入框 + 语音按钮 + 发送按钮
  /// 使用 SafeArea 包裹以确保在刘海屏设备上的正确显示
  Widget _buildInputArea() {
    return Container(
      // 输入区域的内外边距
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white, // 白色背景
        border: Border(top: BorderSide(color: Colors.grey[200]!)), // 顶部边框分隔线
      ),
      child: Row(
        children: [
          // 表情按钮 - 点击可打开表情选择器（当前未实现）
          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
            onPressed: () {},
          ),
          // 输入框 - 使用 Expanded 占据剩余空间
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100], // 浅灰色背景
                borderRadius: BorderRadius.circular(20), // 圆角
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: TextField(
                controller: _inputController, // 绑定文本控制器
                focusNode: _inputFocusNode, // 绑定焦点节点
                maxLines: 5, // 最多显示 5 行
                minLines: 1, // 最少显示 1 行
                keyboardType: TextInputType.multiline, // 多行文本键盘
                textInputAction: TextInputAction.send, // 键盘右下角显示"发送"按钮
                decoration: const InputDecoration(
                  hintText: '输入消息...', // 提示文本
                  border: InputBorder.none, // 无边框
                  hintStyle: TextStyle(color: Colors.grey), // 提示文本样式
                  contentPadding: EdgeInsets.symmetric(vertical: 4), // 内容内边距
                ),
                style: const TextStyle(height: 1.3), // 文本行高
                onSubmitted: (_) => _sendMessage(), // 按下发送键时发送消息
              ),
            ),
          ),
          // 语音按钮 - 点击可录制语音消息（当前未实现）
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.grey),
            onPressed: () {},
          ),
          // 发送按钮 - 点击发送消息
          Container(
            margin: const EdgeInsets.only(left: 8), // 与前面元素的间距
            child: ElevatedButton(
              onPressed: _sendMessage, // 点击触发送消息
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF07C160), // 微信绿
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 圆角按钮
                ),
              ),
              child: const Text(
                '发送',
                style: TextStyle(color: Colors.white), // 白色文字
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 消息数据模型
/// 
/// 封装单条聊天消息的所有信息
class ChatMessage {
  /// 消息文本内容
  final String text;
  
  /// 是否为自已发送的消息
  /// true: 自己发送的消息（右侧显示，绿色气泡）
  /// false: 他人发送的消息（左侧显示，白色气泡）
  final bool isMe;
  
  /// 消息发送时间，格式为 "HH:mm"
  final String time;
  
  /// 头像标识符（用于显示头像上的文字）
  final String avatar;

  /// 构造函数 - 所有参数均为必填
  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatar,
  });
}
