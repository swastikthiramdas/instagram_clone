import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Commentcard extends StatefulWidget {
  final snap;
  Commentcard({required this.snap , Key? key}) : super(key: key);

  @override
  State<Commentcard> createState() => _CommentcardState();
}

class _CommentcardState extends State<Commentcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(DateFormat().add_yMMMd().format(widget.snap['datePublished'].toDate()),
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite),
          )
        ],
      ),
    );
  }
}
