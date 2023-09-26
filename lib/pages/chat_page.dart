// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_flutter_chat/pages/text_field.dart';
// import 'package:firebase_flutter_chat/services/chat/chat_service.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   final String receiverUserEmail;
//   final String receiverUserId;

//   const ChatPage(
//       {super.key,
//       required this.receiverUserEmail,
//       required this.receiverUserId});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   void sendMessage() async {
//     //only send message
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(
//           widget.receiverUserId, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.receiverUserEmail)),
//       body: Column(
//         children: [
//           //messages
//           Expanded(
//             child: _buildMessageList(),
//           ),
// //user input
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

// //build message list
//   Widget _buildMessageList() {
//     return StreamBuilder(
//         stream: _chatService.getMessages(
//             widget.receiverUserId, _firebaseAuth.currentUser!.uid),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error${snapshot.error}');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text('Loading...');
//           }

//           return ListView(
//             children: snapshot.data!.docs
//                 .map((document) => _buildMessageItem(document))
//                 .toList(),
//           );
//         });
//   }

// // build message item
//   Widget _buildMessageItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//     var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
//         ? Alignment.centerRight
//         : Alignment.bottomLeft;

//     return Container(
//       alignment: alignment,
//       child: Column(children: [
//         Text(data['senderEmail']),
//         Text(data['messae']),
//       ]),
//     );
//   }

// //build message input

//   Widget _buildMessageInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: MyTextField(
//               controller: _messageController,
//               hintText: 'Enter message',
//               obscureText: false),
//         ),
//         IconButton(
//           onPressed: sendMessage,
//           icon: const  Icon(
//             Icons.arrow_upward,
//             size: 40,
//           ),
//         )
//       ],
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

    final String receiverUserEmail;
  final String receiverUserId;

 const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  TextEditingController messageController = TextEditingController();

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: StreamBuilder(
              stream: db.collection('messages').snapshots(),
              builder: (context, snapshots) {
                if (snapshots.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List messages = List.from(snapshots.data!.docs);

                messages.sort((a, b) =>
                    (a.data()['created'] as Timestamp)
                        .compareTo(b.data()['created'] as Timestamp) *
                    -1);

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data();

                    return messageTile(data['text'], data['from'],
                        (data['created'] as Timestamp).toDate());
                  },
                );
              }),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(flex: 6, child: inputField()),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }

  void sendMessage() async {
    String messageText = messageController.text;

    if (messageText.isNotEmpty) {
      await db.collection('messages').add({
        'text': messageController.text,
        'from': 'Gurgen',
        'created': Timestamp.fromDate(DateTime.now())
      });

      messageController.clear();
    }
  }

  Widget inputField() {
    return TextField(
      controller: messageController,
      decoration: const InputDecoration(
        hintText: 'Type Here...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  Widget messageTile(String text, String from, DateTime date) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'from $from ${date.toIso8601String()}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
