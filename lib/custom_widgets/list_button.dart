import 'package:flutter/material.dart';

class ListButton extends StatefulWidget {
  final void Function() onPressed;
  final String title;
  final Color textColor;
  final Color iconColor;

  const ListButton({super.key, required this.onPressed, required this.title, this.textColor = Colors.black, this.iconColor = Colors.black});

  @override
  State<ListButton> createState() => _ListButtonState();

}

class _ListButtonState extends State<ListButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  color: widget.textColor
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward_ios_rounded, color: widget.iconColor),
            )
          ],
        ),
      ),
    );
  }

}