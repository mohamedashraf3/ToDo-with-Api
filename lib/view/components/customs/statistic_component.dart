import 'package:flutter/material.dart';
import 'package:note_application/view/components/customs/text_custom.dart';
class DashBoardDetails extends StatelessWidget {
  final String status;
  final Color? color;
  const DashBoardDetails({super.key, this.color, required this.status});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(width: 8,),
            Container(
              height: 20,
              width:20 ,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                color: color
              ),
            ),
            const SizedBox(width: 5,),
             TextCustom(text: status)
          ],
        )
      ],
    );
  }
}
