import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:usefast/constant.dart';

class ChatSupportPage extends StatefulWidget {
  const ChatSupportPage({Key? key}) : super(key: key);

  @override
  State<ChatSupportPage> createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends State<ChatSupportPage> {
  String chatLink = 'https://tawk.to/chat/6554adf4958be55aeaafcf5d/1hf9cf1c0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Center'),
        backgroundColor: kPrimaryColor,
        centerTitle: false,
        elevation: 5,
      ),
      body: Tawk(
        directChatLink: chatLink,
        visitor: TawkVisitor(
          name: 'Ayoub AMINE',
          email: 'ayoubamine2a@gmail.com',
        ),
        onLoad: () {
          print('Hello Tawk!');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
