import 'dart:async';
import 'package:dismov_app/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:relative_time/relative_time.dart';
import 'custom_image.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(
    this.chatData, {
    super.key,
    this.onTap,
    this.isNotified = true,
    this.profileSize = 50,
  });

  final ChatModel chatData;
  final bool isNotified;
  final GestureTapCallback? onTap;
  final double profileSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPhoto(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  buildNameAndTime(),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildTextAndNotified(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAndNotified() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            chatData.recentMessageContent ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoto() {
    return CustomImage(
      chatData.petImageURL,
      width: profileSize,
      height: profileSize,
    );
  }

  Widget buildNameAndTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            '${chatData.petName} - ${chatData.shelterName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 5),
        StreamBuilder(
          stream: Stream.periodic(const Duration(minutes: 1)),
          builder: (context, snapshot) {
            return Text(
              _getTimeAgo(chatData.recentMessageTime),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            );
          },
        ),
      ],
    );
  }

  String _getTimeAgo(int? timestamp) {
    if (timestamp == null) return '';
    final timeAgo = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return RelativeTime.locale(const Locale('es')).format(timeAgo);
  }
}
