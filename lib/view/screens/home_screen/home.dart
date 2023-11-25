import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:note_application/model/todo_model.dart';
import 'package:note_application/view/screens/login/login.dart';
import 'package:note_application/view/screens/statistics/statistics_screen.dart';
import 'package:note_application/view_model/bloc/cubit/auth/auth_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_states.dart';
import 'package:note_application/view_model/utils/imgs.dart';
import '../../../view_model/utils/app_colors.dart';
import '../../components/customs/text_custom.dart';
import '../../components/widgets/todo_widget.dart';
import '../add_task/add_task.dart';
import '../edit_task/edite_task.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ToDoCubit.get(context);
    return BlocProvider.value(
      value: cubit
        ..getAllTasks(context: context)
        ..initController()
        ..controllerListener(context: context),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text("ToDo App"),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ));
                },
                icon: const Icon(Icons.analytics)),
            IconButton(
                onPressed: () {
                  AuthCubit.get(context)
                      .logoutWithApi(context: context)
                      .then((value) {
                    if (AuthCubit.get(context).state is LogoutSuccessState) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  });
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: BlocConsumer<ToDoCubit, ToDoStates>(
          listener: (BuildContext context, ToDoStates state) {},
          builder: (BuildContext context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                await cubit.getAllTasks(context: context);
              },
              child: Column(
                children: [
                  Expanded(
                    child: Visibility(
                        visible:
                            cubit.toDoModel?.data?.tasks?.isNotEmpty ?? true,
                        replacement: Center(
                          child: Lottie.network(
                            Imgs.lottei,
                            width: 500,
                            height: 300,
                          ),
                        ),
                        child: ListView.builder(
                          controller: cubit.controller,
                          itemBuilder: (context, index) => ToDoWidget(
                            onPressedDelete: () {
                              cubit.deleteTask(
                                  context: context,
                                  id: cubit.toDoModel!.data!.tasks![index].id!);
                            },
                            task:
                                cubit.toDoModel?.data!.tasks?[index] ?? Tasks(),
                            onTap: () {
                              cubit.changeIndex(index);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const EditeNote();
                              }));
                            },
                          ),
                          itemCount: cubit.toDoModel?.data?.tasks?.length ?? 0,
                        )),
                  ),
                  if (cubit.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  if (!cubit.hasMoreTasks)
                    Visibility(
                      visible:
                          cubit.toDoModel?.data?.tasks?.isNotEmpty ?? false,
                      replacement: const SizedBox(),
                      child: const TextCustom(text: "No More Tasks "),
                    ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return BlocListener<ToDoCubit, ToDoStates>(
                  listener: (BuildContext context, state) {
                    if (state is AddNoteState) {
                      Navigator.pop(context);
                    }
                  },
                  child: const SizedBox(
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AddNote(),
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: AppColors.grey,
          child: const Icon(Icons.add_rounded, color: AppColors.white),
        ),
      ),
    );
  }
}
