import 'package:flutter/material.dart';

class PageTitleBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPress;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showShadow;

  const PageTitleBar({
    super.key,
    required this.title,
    this.onBackPress,
    this.textColor = Colors.white,
    this.fontSize = 22,
    this.fontWeight = FontWeight.bold,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: onBackPress ?? () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
              shadows: showShadow
                  ? [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}