import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:mychat/helper/my_date_util.dart';
import 'package:mychat/models/message.dart';

import '../api/api.dart';
import '../helper/dialogs.dart';
import '../main.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      child: isMe ? _sentMessage() : _receivedMessage(),
      onLongPress: () {
        _showBottomSheet(isMe);
      },
    );
  }

  //
  // RECEIVED MESSAGE CARD DESIGN
  Widget _receivedMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // MESSAGE CONTENT
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.03
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.03),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(CupertinoIcons.photo),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            MyDateUtil.getFormattedTime(context, widget.message.sent),
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 13),
          ),
        )
      ],
    );
  }

  // SENT MESSAGE CARD DESIGN
  Widget _sentMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: mq.width * 0.04),
          child: Row(
            children: [
              // DOUBLE TICK BLUE ICON FOR READ MSG
              if (widget.message.read.isNotEmpty)
                const Icon(
                  Icons.done_all,
                  color: Colors.blue,
                ),
              // ADDING SOME SPACE
              const SizedBox(
                width: 2,
              ),
              // SENT TIME
              Text(
                MyDateUtil.getFormattedTime(context, widget.message.sent),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13),
              ),
            ],
          ),
        ),
        // MESSAGE CONTENT
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.03
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.03),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(CupertinoIcons.photo),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // BOTTOM SHEET FOR VIEW/MODIFY MESSAGE DETAILS
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                // BLACK DIVIDER
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8)),
                  height: 4,
                  margin: EdgeInsets.symmetric(
                      horizontal: mq.width * 0.4, vertical: mq.height * 0.014),
                ),

                widget.message.type == Type.text
                    ? // COPY TEXT
                    _OptionItem(
                        icon: const Icon(
                          Icons.copy_all_rounded,
                          color: Colors.blue,
                        ),
                        name: 'Copy Text',
                        onTap: () {
                          Clipboard.setData(
                                  ClipboardData(text: widget.message.msg))
                              .then((value) {
                            Navigator.of(context)
                                .pop(); //FOR CLOSING BOTTOM SHEET
                            Dialogs.showSnackBar(
                                context, 'Message Copied'); //SHOWING WORK DONE
                          });
                        })
                    :
                    // SAVE IMG TO GALLERY
                    _OptionItem(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.blue,
                        ),
                        name: 'Save Image to Gallery',
                        onTap: () async {
                          try {
                            await GallerySaver.saveImage(widget.message.msg,
                                albumName: 'MyChat');
                          } catch (e) {
                            log('An error occured while saving image: $e');
                            Dialogs.showSnackBar(context, 'An error occured!');
                          }
                        }),

                // DIVIDER TO SEPARATE OPTIONS
                Divider(
                  color: Colors.grey,
                  endIndent: mq.width * 0.05,
                  indent: mq.width * 0.05,
                ),
                if (isMe)
                  // DELETE
                  _OptionItem(
                      icon: const Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.red,
                      ),
                      name: 'Delete Message',
                      onTap: () {
                        APIs.deleteMessage(widget.message).then((val) {
                          // HIDINNG BOTTOM SHEET

                          Navigator.pop(context);
                        });
                      }),
                if (widget.message.type == Type.text && isMe)
                  // EDIT MESSAGE
                  _OptionItem(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      name: 'Edit Message',
                      onTap: () {}),
                if (isMe)
                  // DIVIDER TO SEPARATE OPTIONS
                  Divider(
                    color: Colors.grey,
                    endIndent: mq.width * 0.05,
                    indent: mq.width * 0.05,
                  ),

                // SENT AT
                _OptionItem(
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.green,
                    ),
                    name:
                        'Sent at: ${MyDateUtil.getMessageTime(context, widget.message.sent)}',
                    onTap: () {}),

                // READ AT
                _OptionItem(
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.blue,
                    ),
                    name: widget.message.read.isEmpty
                        ? 'Read At: Not seen yet'
                        : 'Read At: ${MyDateUtil.getMessageTime(context, widget.message.read)}',
                    onTap: () {}),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {super.key, required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * 0.02,
            top: mq.height * 0.01,
            bottom: mq.height * 0.01),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '     $name',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ))
          ],
        ),
      ),
    );
  }
}
