import 'package:chatzone/api/apis.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _outMessage()
        : _inMessage();
  }

  //* Sender or another user message
  Widget _inMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //* Message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              mq.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[100],
              border: Border.all(
                color: Colors.indigo,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),

        //* Message received time
        Padding(
          padding: EdgeInsets.only(
            right: mq.width * .04,
          ),
          child: Text(
            widget.message.sent,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  //* our or user message
  Widget _outMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //* Message received time
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            //* Double tick
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),

            //* For adding some space
            const SizedBox(
              width: 2,
            ),

            Text(
              '${widget.message.read}12:22 pm',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        //* Message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              mq.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: Colors.indigoAccent[100],
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
