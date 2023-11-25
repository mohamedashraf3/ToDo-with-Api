import 'package:flutter/material.dart';
import 'package:note_application/model/todo_model.dart';
import '../../../view_model/utils/app_colors.dart';
import '../customs/text_custom.dart';

class ToDoWidget extends StatelessWidget {
  const ToDoWidget({
    Key? key,
    this.onTap,
    this.onPressedDelete,
    required this.task,
  }) : super(key: key);

  final void Function()? onTap;
  final void Function()? onPressedDelete;
  final Tasks task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 7, offset: const Offset(0, 10))],
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: TextCustom(text: task.title ?? "", fontSize: 24, color: AppColors.black, fontWeight: FontWeight.bold),
                subtitle: TextCustom(text: task.description ?? "", fontSize: 18, color: AppColors.grey),
                trailing: IconButton(onPressed: onPressedDelete, icon: const Icon(Icons.delete, color: AppColors.black, size: 34)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(text: task.startDate ?? "", fontSize: 14, color: AppColors.grey),
                    TextCustom(text: task.endDate ?? "", fontSize: 14, color: AppColors.grey),
                  ],
                ),
              ),
              if (task.image != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      border: Border.all(width: 1, color: AppColors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      child: Image.network(task.image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.centerRight, child: TextCustom(text: task.status ?? "", color: AppColors.grey,fontWeight: FontWeight.bold,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
