import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat/helper/my_date_util.dart';
import 'package:mychat/models/chat_user.dart';
import 'package:mychat/models/message.dart';
import 'package:mychat/screens/view_profile_screen.dart';
import 'package:mychat/widgets/message_card.dart';

import '../api/api.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //FOR HANDLING MESSAGE TEXT CHANGES
  final _textController = TextEditingController();
  //  _showEmojis --- FOR SHOWING EMOJIS
  // _isUploading --- FOR CHECKING IF IMAGE IS UPLOADING
  bool _showEmojis = false, _isUploading = false;
  // FOR STORING ALL THE MESSAGES
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: !_showEmojis, // IF EMOJI KEYBOARD IS SHOWING BLOCK POP
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _showEmojis) {
            setState(() => _showEmojis = false); // CLOSE EMOJI KEYBOARD
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // FOR LOADING DATA
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const SizedBox();
                      //   AFTER LOADING DATA TO SHOW
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        // print(_list);
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * 0.01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
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

              // PROGRESS INDICATOR FOR SHOWING UPLOADING
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )),
              _chatInput(),
              if (_showEmojis)
                SizedBox(
                  height: mq.height * 0.35,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: const Config(
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        emojiSizeMax: 32,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // APP BAR
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child: StreamBuilder(
        stream: APIs.combinesUserInfo(widget.user),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            // while loading or null, return an empty/skeleton UI
            return const SizedBox();
          }
          final data = snapshot.data!;
          final isTyping = data['isTyping'] ?? false;
          final isOnline = data['is_online'] ?? false;
          final name = data['name'] ?? '';
          final image = data['image'] ?? '';
          final lastActive = data['last_active'] ?? '';

          String statusText;
          if (isTyping) {
            statusText = 'typing...';
          } else if (isOnline) {
            statusText = 'Online';
          } else if (lastActive == null) {
            statusText = 'recently';
          } else {
            statusText = '${MyDateUtil.getLastActiveTime(context, lastActive)}';
          }
          return Row(
            children: [
              // BACK BTN
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Theme.of(context).colorScheme.secondary,
              ),

              // USER PROFILE PICTURE
              ClipOval(
                child: CachedNetworkImage(
                  width: mq.height * 0.045,
                  height: mq.height * 0.045,
                  imageUrl: image.isNotEmpty ? image : (widget.user.image),
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
                    name.isNotEmpty ? name : widget.user.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  // LAST SEEN/TYPING/Online
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              )
            ],
          );
        },
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
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmojis = !_showEmojis);
                    },
                    icon: const Icon(Icons.emoji_emotions),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Expanded(
                    child: TextField(
                        controller: _textController,
                        onChanged: (val) => APIs.onUserTyping(widget.user),
                        textCapitalization: TextCapitalization.sentences,
                        onTap: () {
                          if (_showEmojis) {
                            setState(() => _showEmojis = !_showEmojis);
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type something...',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary))),
                  ),
                  // ATTACHMENT BTN
                  IconButton(
                    onPressed: () {
                      _attchmentBottomSheet();
                    },
                    icon: const Icon(Icons.attach_file),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),

          // SEND MSG BTN
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  // ON FIRST MESSAGE ADD USER TO MY USER COLLECTION
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  // REGULAR SEND MSG FN.
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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

  // BOTTOM SHEET FOR ATTACHMENTS
  void _attchmentBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mq.height * 0.03, bottom: mq.height * 0.05),
            children: [
              Text(
                'Pick attachment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary),
              ),
              // FOR EXTRA SPACE
              SizedBox(
                height: mq.height * 0.02,
              ),
              // BUTTONS TO SELECT IMAGE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // GALLERY BTN
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final ImagePicker picker = ImagePicker();
                      // PICK SINGLE/MULTIPLE IMAGE(S).
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      //  UPLOADING AND SENDING IMAGE ONE BY ONE
                      for (var i in images) {
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      size: 50,
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  // CAMERA BTN
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 50,
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  IconButton(
                      onPressed: () {},
                      color: Theme.of(context).colorScheme.secondary,
                      icon: const Icon(
                        Icons.location_on,
                        size: 50,
                      ))
                ],
              )
            ],
          );
        });
  }
}
