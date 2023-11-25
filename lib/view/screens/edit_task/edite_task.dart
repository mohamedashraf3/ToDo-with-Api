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

class EditeNote extends StatelessWidget {
  const EditeNote({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ToDoCubit.get(context);
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const TextCustom(text: 'Update Task'), // Corrected spelling
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      CustomTextField(
                                        controller: cubit.titleController,
                                        labelText: 'Title',
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: cubit.descriptionController,
                                        labelText: 'Description',
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.none,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        labelText: 'Start Date',
                                        readOnly: true,
                                        textInputAction: TextInputAction.none,
                                        controller: cubit.startDateController,
                                        validator: (value){
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
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        labelText: 'End Date',
                                        readOnly: true,
                                        keyboardType: TextInputType.none,
                                        textInputAction: TextInputAction.none,
                                        controller: cubit.endDateController,
                                        validator: (value){
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
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            cubit.selectTaskStatus(selectedStatus as String);
                          },
                        ),
                      ),
                      Material(
                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                          child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                              onTap: () {
                                ToDoCubit.get(context).takePhotoFromUser(context: context);
                              },
                              child: Container(
                                height:250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(24)),
                                    border: Border.all(
                                        width: 1, color: AppColors.grey)),
                                child: Visibility(visible: cubit.image == null,
                                  replacement: Image.file(
                                    File(cubit.image?.path ?? ""),
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if((cubit.toDoModel?.data?.tasks?[cubit.currentindex].image?.isNotEmpty??false))
                                          Image.network(
                                        cubit.toDoModel?.data?.tasks?[cubit.currentindex].image ?? "", width: double.infinity, height: 200,),
                                      if((cubit.toDoModel?.data?.tasks?[cubit.currentindex].image?.isEmpty??true))
                                        ...[const Icon(
                                            Icons.photo,
                                            size: 200,
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          const TextCustom(text: "Add Photo"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ]

                                    ],
                                  ),
                                ),
                              ))),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                          onPressed:
                              state is !EditeTasksLoadingState?
                              () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.editeTask(context: context).then((value) {
                                Navigator.pop(context);
                              });
                            }
                          }:null,
                        child:Visibility(
                            visible: state is !EditeTasksLoadingState,
                            replacement: const CircularProgressIndicator(),
                            child: const TextCustom(text:"Edit Your Note",fontSize: 21,fontWeight: FontWeight.bold,)),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
