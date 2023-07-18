import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app/constants/constants.dart';

class StoryWidget extends StatelessWidget {
  final String name;
  final bool isActive;

  StoryWidget({this.name = "Story", this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: PADDING_SM),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: isActive ? ACTIVE_BORDER_COLOR : NORMAL_TEXT_CLR),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/images/story.png',
                fit: BoxFit.cover,
                height: 44,
                width: 44,
              ),
            ),
          ),
          // Text(name),
          SizedBox(
            width: 60, // Replace 200 with your desired fixed width
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
