import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/models/chat_user.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: _appBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              // stream: APIs.getAllUsers(),
              stream: null,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // for loading data
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  // return const Center(child: CircularProgressIndicator());
                  //   after loaded data to show
                  case ConnectionState.active:
                  case ConnectionState.done:
                    // final data = snapshot.data?.docs;
                    // _list =
                    //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    //         [];
                    final _list = ['hi', 'hello'];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Text('Message: ${_list[index]}');
                            // return Text('Name: ${list[0]}');
                          });
                    } else {
                      return const Center(
                          child: Text(
                        'Say Hii!👋',
                        style: TextStyle(fontSize: 20),
                      ));
                    }
                }
              },
            ),
          ),
          _chatInput()
        ],
      ),
    );
  }

  // APP BAR
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          // BACK BTN
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Theme.of(context).colorScheme.secondary,
          ),
          //
          // USER PROFILE PICTURE
          ClipOval(
            child: CachedNetworkImage(
              width: mq.height * 0.045,
              height: mq.height * 0.045,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
                  const Icon(CupertinoIcons.person),
            ),
          ),
          // ADDING EXTRA SPACE
          const SizedBox(
            width: 10,
          ),
          // NAME OF USER
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              // LAST SEEN/TYPING
              const Text(
                'Last seen not available',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

//   CHAT INPUT
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.005, horizontal: mq.width * 0.02),
      child: Row(
        children: [
          // INPUT FIELD AND BTNS
          Expanded(
            child: Card(
              elevation: 3,
              child: Row(
                children: [
                  // EMOJI BTN
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.emoji_emotions),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type something...',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary))),
                  ),
                  // GALLERY BTN
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.image),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  // CAMERA BTN
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.camera_alt),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),

          // SEND MSG BTN
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            color: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.arrow_upward,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
