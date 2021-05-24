import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mixin_bot_sdk_dart/mixin_bot_sdk_dart.dart';
import 'package:provider/provider.dart';

import '../../../account/account_server.dart';
import '../../../db/mixin_database.dart';
import '../../../enum/message_action.dart';
import '../../../generated/l10n.dart';
import '../../brightness_observer.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageItem message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: BrightnessData.dynamicColor(
                  context,
                  const Color.fromRGBO(202, 234, 201, 1),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Text(
                  generateSystemText(
                    actionName: message.actionName,
                    senderIsCurrentUser:
                        message.userId == context.read<AccountServer>().userId,
                    relationship: message.relationship,
                    participantFullName: message.participantFullName,
                    senderFullName: message.userFullName,
                    groupName: message.groupName,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: BrightnessData.dynamicColor(
                      context,
                      const Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

String generateSystemText({
  required MessageAction? actionName,
  required bool senderIsCurrentUser,
  required UserRelationship? relationship,
  required String? participantFullName,
  required String? senderFullName,
  required String? groupName,
}) {
  String text;
  switch (actionName) {
    case MessageAction.join:
      text = Localization.current.chatGroupJoin(
        senderIsCurrentUser
            ? Localization.current.youStart
            : participantFullName ?? '',
      );
      break;
    case MessageAction.exit:
      text = Localization.current.chatGroupExit(
        senderIsCurrentUser
            ? Localization.current.youStart
            : participantFullName ?? '',
      );
      break;
    case MessageAction.add:
      text = Localization.current.chatGroupAdd(
        relationship == UserRelationship.me
            ? Localization.current.youStart
            : senderFullName!,
        senderIsCurrentUser
            ? Localization.current.you
            : participantFullName ?? '',
      );
      break;
    case MessageAction.remove:
      text = Localization.current.chatGroupRemove(
        relationship == UserRelationship.me
            ? Localization.current.youStart
            : senderFullName!,
        senderIsCurrentUser
            ? Localization.current.you
            : participantFullName ?? '',
      );
      break;
    case MessageAction.create:
      text = Localization.current.chatGroupCreate(
        relationship == UserRelationship.me
            ? Localization.current.youStart
            : senderFullName!,
        groupName!,
      );
      break;
    case MessageAction.role:
      text = Localization.current.chatGroupRole;
      break;
    default:
      text = Localization.current.chatNotSupport;
      break;
  }
  return text;
}
