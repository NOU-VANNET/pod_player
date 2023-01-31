import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subText;
  final Widget? iconWidget;
  final void Function()? onTap;
  final EdgeInsets? margin;
  const OptionTile({
    Key? key,
    required this.title,
    required this.icon,
    this.subText,
    this.onTap,
    this.margin,
    this.iconWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ListTile(
        leading: iconWidget ?? Icon(icon),
        onTap: onTap,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                title,
              ),
              if (subText != null) const SizedBox(width: 6),
              if (subText != null)
                const SizedBox(
                  height: 4,
                  width: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (subText != null) const SizedBox(width: 6),
              if (subText != null)
                Text(
                  subText!,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
