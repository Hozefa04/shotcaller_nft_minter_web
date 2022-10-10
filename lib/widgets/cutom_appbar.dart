import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/app_styles.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final bool hasBackButton;

  CustomAppBar({Key? key, this.title, this.hasBackButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? AppStrings.appName,
        style: AppStyles.appBarStyle,
      ),
      leading: hasBackButton ? const BackButton() : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (() => Navigator.of(context).pop()),
      icon: const Icon(
        Icons.arrow_back_ios_new_sharp,
      ),
    );
  }
}
