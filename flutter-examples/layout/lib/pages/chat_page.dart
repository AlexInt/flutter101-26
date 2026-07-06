import 'package:flutter/cupertino.dart';

/// 聊天室示例页面（iOS 风格）
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final List<ChatMessage> _messages = [
    ChatMessage(text: '早上好！', isMe: false, time: '08:00', avatar: 'A'),
    ChatMessage(text: '早上好！今天天气不错', isMe: true, time: '08:01', avatar: 'Me'),
    ChatMessage(text: '是啊，阳光明媚', isMe: false, time: '08:02', avatar: 'A'),
    ChatMessage(text: '你今天有什么安排吗？', isMe: false, time: '08:03', avatar: 'A'),
    ChatMessage(text: '上午要处理一些工作上的事情，下午打算出去走走', isMe: true, time: '08:05', avatar: 'Me'),
    ChatMessage(text: '不错不错，劳逸结合', isMe: false, time: '08:06', avatar: 'A'),
    ChatMessage(text: '对了，上次你说的那个项目怎么样了？', isMe: false, time: '08:08', avatar: 'A'),
    ChatMessage(text: '进展顺利，已经完成了大部分功能开发', isMe: true, time: '08:10', avatar: 'Me'),
    ChatMessage(text: '太好了！期待看到成品', isMe: false, time: '08:11', avatar: 'A'),
    ChatMessage(text: '预计下周就能上线测试了', isMe: true, time: '08:12', avatar: 'Me'),
    ChatMessage(text: '太棒了！到时候一定要告诉我', isMe: false, time: '08:13', avatar: 'A'),
    ChatMessage(text: '没问题！', isMe: true, time: '08:15', avatar: 'Me'),
    ChatMessage(text: '对了，中午一起吃饭吗？', isMe: false, time: '09:30', avatar: 'A'),
    ChatMessage(text: '好啊！想吃什么？', isMe: true, time: '09:31', avatar: 'Me'),
    ChatMessage(text: '听说附近新开了一家川菜馆，想去试试', isMe: false, time: '09:32', avatar: 'A'),
    ChatMessage(text: '可以啊，我也想吃辣的了', isMe: true, time: '09:33', avatar: 'Me'),
    ChatMessage(text: '那就这么定了，中午12点楼下见', isMe: false, time: '09:35', avatar: 'A'),
    ChatMessage(text: '好的，不见不散！', isMe: true, time: '09:36', avatar: 'Me'),
  ];

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _inputFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inputFocusNode.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _scrollToBottom();
  }

  void _onFocusChange() {
    if (_inputFocusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _isAutoScrolling = true;
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      )
          .then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _isAutoScrolling = false;
        });
      });
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isMe: true,
        time: _getCurrentTime(),
        avatar: 'Me',
      ));
    });

    _inputController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToBottom();
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.back, size: 20),
              SizedBox(width: 4),
              Text('返回'),
            ],
          ),
        ),
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGreen,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('A', style: TextStyle(color: CupertinoColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('好友A', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text('在线', style: TextStyle(fontSize: 11, color: CupertinoColors.systemGreen)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.only(right: 8),
              onPressed: () {},
              child: const Icon(CupertinoIcons.phone, size: 22),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: const Icon(CupertinoIcons.video_camera, size: 22),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: _hideKeyboard,
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollStartNotification>(
                  onNotification: (notification) {
                    if (!_isAutoScrolling) {
                      _hideKeyboard();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageItem(_messages[index]);
                    },
                  ),
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!message.isMe)
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(message.avatar, style: const TextStyle(color: CupertinoColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? CupertinoColors.systemBlue : CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? CupertinoColors.white : CupertinoColors.label,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(
                      color: message.isMe ? CupertinoColors.white.withOpacity(0.7) : CupertinoColors.tertiaryLabel,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (message.isMe)
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemBlue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('Me', style: TextStyle(color: CupertinoColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(top: BorderSide(color: CupertinoColors.separator)),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () {},
            child: const Icon(CupertinoIcons.smiley, color: CupertinoColors.tertiaryLabel, size: 26),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: CupertinoTextField(
                controller: _inputController,
                focusNode: _inputFocusNode,
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                placeholder: '输入消息...',
                placeholderStyle: const TextStyle(color: CupertinoColors.tertiaryLabel),
                decoration: null,
                style: const TextStyle(height: 1.3),
                padding: const EdgeInsets.symmetric(vertical: 8),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () {},
            child: const Icon(CupertinoIcons.mic_fill, color: CupertinoColors.tertiaryLabel, size: 26),
          ),
          const SizedBox(width: 8),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minSize: 0,
            borderRadius: BorderRadius.circular(20),
            onPressed: _sendMessage,
            child: const Text('发送', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String avatar;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatar,
  });
}
