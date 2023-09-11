import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/helper/my_date_util.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenViewProfile extends StatefulWidget {
  final ChatUser user;
  const ScreenViewProfile({super.key, required this.user});

  @override
  State<ScreenViewProfile> createState() => _ScreenViewProfileState();
}

class _ScreenViewProfileState extends State<ScreenViewProfile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //* Hide keyboard while tap anywhere in the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 206, 240, 238),
        //* AppBar
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 77, 179, 162),
          //* Home Icon
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 26,
              color: Colors.white,
            ),
          ),

          //* App Title
          title: Text(widget.user.name),
        ),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joined on: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              MyDateUtil.getLastMessageTime(
                context: context,
                time: widget.user.createdAt,
                showYear: true,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        //* Body
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),

                  //* User profile picture 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      imageUrl: widget.user.image,
                      height: mq.height * .2,
                      width: mq.height * .2,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          CupertinoIcons.person,
                        ),
                      ),
                    ),
                  ),
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .1,
                  ),

                  //* User About
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 66, 88, 79),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white54,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'About: ',
                            style: TextStyle(
                              color:Color.fromARGB(255, 43, 70, 58),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.user.about,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 66, 88, 79),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //* Adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),

                  //* User Email
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 66, 88, 79),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white54),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.email,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 66, 88, 79),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
