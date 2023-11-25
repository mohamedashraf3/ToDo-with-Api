import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_application/view/components/customs/custom_button.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_states.dart';
import '../../../view_model/utils/app_colors.dart';
import '../../components/customs/text_custom.dart';
import '../../components/customs/textfeild_custom.dart';

class AddNote extends StatelessWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ToDoCubit.get(context);
    cubit.restControllers();
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ListView(
          children: [
            Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  const TextCustom(text: "Add Task"),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              CustomTextField(
                                labelText: 'Title',
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: cubit.titleController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "The Title can not be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                labelText: 'Description',
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.none,
                                controller: cubit.descriptionController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "The Description can not be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                labelText: 'Start Date',
                                readOnly: true,
                                textInputAction: TextInputAction.none,
                                controller: cubit.startDateController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "The Start Date can not be empty";
                                  }
                                  return null;
                                },
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022, 2, 11),
                                    lastDate: DateTime(2025),
                                  ).then((value) {
                                    if (value != null) {
                                      cubit.startDateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                labelText: 'End Date',
                                readOnly: true,
                                keyboardType: TextInputType.none,
                                textInputAction: TextInputAction.none,
                                controller: cubit.endDateController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "The End Date can not be empty";
                                  }
                                  return null;
                                },
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022, 2, 11),
                                    lastDate: DateTime(2025),
                                  ).then((value) {
                                    if (value != null) {
                                      cubit.endDateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: DropdownButton(
                                  borderRadius: BorderRadius.circular(8),
                                  items: cubit.status.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: TextCustom(text: status),
                                    );
                                  }).toList(),
                                  value: cubit.statusSelected,
                                  onChanged: (selectedStatus) {
                                    cubit.selectTaskStatus(
                                        selectedStatus as String);
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Material(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
                              child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24)),
                                  onTap: () {
                                    ToDoCubit.get(context).takePhotoFromUser(context: context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(24)),
                                        border: Border.all(
                                            width: 1, color: AppColors.grey)),
                                    child: Visibility(
                                      visible: cubit.image == null,
                                      replacement: Image.file(
                                        File(cubit.image?.path ?? ""),
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                      child:  const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            size: 200,
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          TextCustom(text: "Add Photo"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onPressed:
                          state is !AddNewTasksLoadingState?
                          () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.addNewTask(context: context).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      }:null,
                  child: Visibility(
                    visible: state is !AddNewTasksLoadingState,
                      replacement: const CircularProgressIndicator(),
                      child: const TextCustom(text:"Add Note",fontSize: 21,fontWeight: FontWeight.bold,)),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
