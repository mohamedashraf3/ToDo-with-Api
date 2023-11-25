import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_application/view/components/customs/custom_button.dart';
import 'package:note_application/view_model/bloc/cubit/auth/auth_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_states.dart';
import 'package:note_application/view_model/utils/app_colors.dart';
import '../../../view_model/utils/imgs.dart';
import '../../components/customs/text_custom.dart';
import '../../components/customs/textfeild_custom.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return BlocProvider.value(
      value: cubit..restControllers(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const TextCustom(text: "Register"),
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: cubit.registerFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Imgs.logo,
                          width: 250,
                          height: 230,
                        ),
                        const TextCustom(
                          text: "ToDo App",
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          labelText: "Name",
                          controller: cubit.nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email must not be empty";
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          labelText: "Email",
                          controller: cubit.emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email must not be empty";
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          labelText: "Password",
                          controller: cubit.passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password must not be empty";
                            } else if (value !=
                                cubit.confirmPassController.text) {
                              return "Password not match";
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          labelText: "Confirm Password",
                          controller: cubit.confirmPassController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password must not be empty";
                            } else if (value != cubit.passwordController.text) {
                              return "Password not match";
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                            onPressed: state is! RegisterLoadingState
                                ? () {
                                    if (cubit.registerFormKey.currentState!
                                        .validate()) {
                                      cubit
                                          .registerWithApi(context: context)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                  }
                                : null,
                            color: AppColors.deepPurple,
                            child: Visibility(
                                visible: state is! RegisterLoadingState,
                                replacement: const CircularProgressIndicator(),
                                child: const TextCustom(
                                  text: "Register",
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
