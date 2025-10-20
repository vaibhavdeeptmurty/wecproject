import 'package:flutter/material.dart';
import 'package:mychat/models/message.dart';

import '../api/api.dart';
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
    return APIs.user.uid == widget.message.fromId
        ? _sentMessage()
        : _receivedMessage();
  }

  //
  // RECEIVED MESSAGE CARD DESIGN
  Widget _receivedMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.03),
            child: Text(
              widget.message.msg,
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            widget.message.sent,
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
              // DOUBLE TICK BLUE ICON
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
                '${widget.message.read}12:01AM',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.03),
            child: Text(
              widget.message.msg,
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ),
      ],
    );
  }
}
