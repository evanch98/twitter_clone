import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:twitter_clone/constants/assets_constants.dart";
import "package:twitter_clone/core/core.dart";
import "package:twitter_clone/models/models.dart" as model;
import "package:twitter_clone/theme/theme.dart";

class NotificationTile extends StatelessWidget {
  final model.Notification notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetsConstants.likeFilledIcon,
                  colorFilter: const ColorFilter.mode(
                    Pallete.redColor,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetsConstants.retweetIcon,
                      colorFilter: const ColorFilter.mode(
                        Pallete.whiteColor,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                    )
                  : notification.notificationType == NotificationType.reply
                      ? SvgPicture.asset(
                          AssetsConstants.commentIcon,
                          colorFilter: const ColorFilter.mode(
                            Pallete.whiteColor,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                        )
                      : null,
    );
  }
}
