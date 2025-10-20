import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/api/api.dart';
import 'package:mychat/models/chat_user.dart';
import 'package:mychat/models/message.dart';

import '../helper/my_date_util.dart';
import '../main.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // LAST MESSAGE - IF NO MSG THEN NULL
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            // FOR NAVIGATING TO CHAT SCREEN
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessages(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return ListTile(
                  // profile pic
                  leading: ClipOval(
                    child: CachedNetworkImage(
                      width: mq.height * 0.05,
                      height: mq.height * 0.05,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) =>
                          const Icon(CupertinoIcons.person),
                    ),
                  ),
                  // user name
                  title: Text(widget.user.name),
                  // last message
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'Image'
                            : _message!.msg
                        : widget.user.about,
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  // last message time
                  trailing: _message == null
                      ? null //SHOW NOTHING WHEN NO MESSAGE
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          // SHOW GREEN DOT FOR UNREAD MESSAGE
                          ? Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ))
                          // SHOW TIME FOR LAST MESSAGE
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                  context, _message!.sent),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                );
              })),
    );
  }
}
