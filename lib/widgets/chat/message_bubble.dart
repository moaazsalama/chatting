import 'package:flutter/material.dart';
class MessageBubble extends StatelessWidget {

  final Key key;
  final String message;
  final String usernamel;
  final bool isMe;
  final image;
  MessageBubble(this.message,this.usernamel,this.image,this.isMe,{this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Row(
          mainAxisAlignment: !isMe?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: !isMe?Colors.grey[300]:Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft: isMe?Radius.circular(0):Radius.circular(14),
                    bottomRight: !isMe?Radius.circular(0):Radius.circular(14),
                  )
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
              child: Column(
                crossAxisAlignment: !isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  Text(
                    usernamel,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isMe?Colors.black:Theme.of(context).accentTextTheme.headline6.color
                    ),
                    textAlign: isMe?TextAlign.end:TextAlign.start,
                  ),
                  Text(
                    message,
                    style: TextStyle(

                        color: !isMe?Colors.black:Theme.of(context).accentTextTheme.headline6.color
                    ),
                    textAlign: isMe?TextAlign.end:TextAlign.start,
                  )
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: 0,
          left: isMe?120:null,
          right: !isMe?120:null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(image),
          ),
        )
      ],
    );
  }
}
