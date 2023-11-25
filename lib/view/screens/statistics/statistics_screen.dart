import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_application/view/components/customs/custom_button.dart';
import 'package:note_application/view/screens/home_screen/home.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_cubit.dart';
import 'package:note_application/view_model/bloc/cubit/to_do_states.dart';
import 'package:note_application/view_model/data/local/shared_prefrence/shared_keys.dart';
import 'package:note_application/view_model/data/local/shared_prefrence/shared_prefrence.dart';
import 'package:note_application/view_model/utils/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../components/customs/statistic_component.dart';
import '../../components/customs/text_custom.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ToDoCubit.get(context);
    return BlocProvider.value(
      value: cubit..showStatistics(),
      child: SafeArea(
        child: BlocConsumer<ToDoCubit, ToDoStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const TextCustom(text: "To Do Dashboard"),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextCustom(
                        text: "Welcome ${LocalData.get(SharedKeys.name)}",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TextCustom(text: "Dashboard Tasks"),
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 160.0,
                              lineWidth: 11.0,
                              animation: true,
                              percent: (cubit.statisticsModel?.newTasks ?? 0)
                                      .toDouble() /
                                  (cubit.total ?? 0).toDouble(),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: AppColors.purple,
                              center: CircularPercentIndicator(
                                radius: 140,
                                lineWidth: 10,
                                animation: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent:
                                    (cubit.statisticsModel?.doingTasks ?? 0)
                                            .toDouble() /
                                        (cubit.total ?? 0).toDouble(),
                                progressColor: AppColors.blueDegree,
                                center: CircularPercentIndicator(
                                  radius: 120,
                                  lineWidth: 10,
                                  animation: true,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  percent:
                                      (cubit.statisticsModel?.completedTasks ??
                                                  0)
                                              .toDouble() /
                                          (cubit.total ?? 0).toDouble(),
                                  progressColor: AppColors.green,
                                  center: CircularPercentIndicator(
                                    radius: 100,
                                    lineWidth: 10,
                                    animation: true,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    percent:
                                        (cubit.statisticsModel?.outdatedTasks ??
                                                    0)
                                                .toDouble() /
                                            (cubit.total ?? 0).toDouble(),
                                    progressColor: AppColors.brown,
                                    center: TextCustom(
                                        text: "${cubit.total ?? 0} Tasks",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const DashBoardDetails(
                              status: 'New Tasks',
                              color: AppColors.purple,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const DashBoardDetails(
                              status: 'In Progress Tasks',
                              color: AppColors.blueDegree,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const DashBoardDetails(
                              status: 'Completed Tasks',
                              color: AppColors.green,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const DashBoardDetails(
                              status: 'OutDated Tasks',
                              color: AppColors.brown,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomButton(
                            onPressed: state is! ShowStatisticsLoadingState
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Home(),
                                        ));
                                  }
                                : null,
                            color: AppColors.deepPurple,
                            child: Visibility(
                                visible: state is! ShowStatisticsLoadingState,
                                replacement: const CircularProgressIndicator(),
                                child: const TextCustom(
                                  text: "Go To Tasks",
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
