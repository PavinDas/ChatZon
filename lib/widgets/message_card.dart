import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/api/apis.dart';
import 'package:chatzone/helper/dialogs.dart';
import 'package:chatzone/helper/my_date_util.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _outMessage() : _inMessage(),
    );
  }

  //! Received message
  Widget _inMessage() {
    //* Update message read status
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('\n Read status updated');
      setState(() {});
    }

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
              color: const Color.fromARGB(255, 194, 227, 235),
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text

                //* Show text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )

                //* Show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.image,
                          size: 70,
                        );
                      },
                    ),
                  ),
          ),
        ),

        //* Message received time
        Padding(
          padding: EdgeInsets.all(
            widget.message.type == Type.image ? mq.width * .03 : mq.width * .04,
          ),
          child: Text(
            MyDateUtil.getFormatedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  //! Sended message
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

            //* Double tick for message read indication
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            //* For adding some space
            const SizedBox(
              width: 2,
            ),

            //* Sent time
            Text(
              MyDateUtil.getFormatedTime(
                context: context,
                time: widget.message.sent,
              ),
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
              widget.message.type == Type.image
                  ? mq.width * .03
                  : mq.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 219, 236, 236),
              border: Border.all(
                color: Colors.green,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text

                //* Show text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )

                //* Show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.image,
                          size: 70,
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  //* Bottom sheet for modifying message details
  _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            //* Black devider
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: mq.height * .02,
                horizontal: mq.width * .4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            //! Options

            widget.message.type == Type.text
                ? //* Copy option
                _OptionItem(
                    icon: const Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Copy text',
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.message.msg),
                      ).then(
                        //* For hiding bottom sheet
                        (value) => Navigator.pop(context),
                      );

                      //* For alert dialog
                      Dialogs.showSnackbar(context, 'Text copied!');
                    },
                  )
                :
                //* Save option
                _OptionItem(
                    icon: const Icon(
                      Icons.download_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Save image',
                    onTap: () {},
                  ),

            //* Separation
            Divider(
              color: Colors.black45,
              indent: mq.width * .04,
              endIndent: mq.width * .04,
            ),

            //* Edit option
            if (widget.message.type == Type.text && isMe)
              _OptionItem(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 26,
                ),
                name: 'Edit message',
                onTap: () {},
              ),

            //* Delete option

            if (isMe)
              _OptionItem(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 26,
                ),
                name: 'Delete message',
                onTap: () async {
                  await APIs.deleteMessage(widget.message).then(
                    //* For hiding bottom sheet
                    Navigator.pop(context),

                    //* For alert dialog
                    Dialogs.showSnackbar(context, 'Message deleted!'),
                  );

                  //* For alert dialog
                  Dialogs.showSnackbar(context, 'Message deleted!');
                },
              ),

            //* Separation
            if (isMe)
              Divider(
                color: Colors.black45,
                indent: mq.width * .04,
                endIndent: mq.width * .04,
              ),

            //* Sent time
            _OptionItem(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
              ),
              name:
                  'Sent at: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),

            //* Read time
            _OptionItem(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.indigo,
                size: 26,
              ),
              name: widget.message.read.isEmpty
                  ? 'Read at: Not seen yet'
                  : 'Read at: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: mq.width * .05,
          top: mq.height * .015,
          bottom: mq.height * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '   $name',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  letterSpacing: .5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
