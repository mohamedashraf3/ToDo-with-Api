import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_application/model/todo_model.dart';
import 'package:note_application/view_model/data/local/shared_prefrence/shared_keys.dart';
import 'package:note_application/view_model/data/local/shared_prefrence/shared_prefrence.dart';
import 'package:note_application/view_model/data/network/dio_helper.dart';
import 'package:note_application/view_model/data/network/end_points.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/functions.dart';
import 'to_do_states.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(NoteInitialState());
  List<String> status = ["new ", "doing", "outdated", "compeleted"];
  String? statusSelected;
  num? total;
  ScrollController? controller = ScrollController();
  bool isLoading = false;
  bool hasMoreTasks = true;

  static ToDoCubit get(context) => BlocProvider.of<ToDoCubit>(context);

  void initController() {
    controller = ScrollController();
  }

  void controllerListener({required context}) {
    controller?.addListener(() {
      if (controller!.position.atEdge &&
          controller!.position.pixels != 0 &&
          !isLoading &&
          hasMoreTasks) {
        fetchNewTasks(context: context);
      }
    });
  }

  void changeIndex(int index) {
    currentindex = index;
    titleController.text = toDoModel?.data!.tasks?[currentindex].title ?? "";
    descriptionController.text =
        toDoModel?.data!.tasks?[currentindex].description ?? "";
    startDateController.text =
        toDoModel?.data!.tasks?[currentindex].startDate ?? "";
    endDateController.text =
        toDoModel?.data!.tasks?[currentindex].endDate ?? "";
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  XFile? image;
  int currentindex = 0;

  void restControllers() {
    titleController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    image = null;
  }

  void selectTaskStatus(String selectedStatuses) {
    statusSelected = selectedStatuses;
    emit(SelectTaskStatusState());
  }

  ToDoModel? toDoModel;

  Future<void> getAllTasks({required context}) async {
    toDoModel = null;
    hasMoreTasks = true;
    emit(GetAllTasksLoadingState());
    await DioHelper.get(
      endpoint: EndPoints.tasks,
      token: LocalData.get(SharedKeys.token),
    ).then((value) {
      toDoModel = ToDoModel.fromJson(value?.data);
      if ((toDoModel?.data?.meta?.lastPage ?? 0) ==
          (toDoModel?.data?.meta?.currentPage ?? 0)) {
        hasMoreTasks = false;
      }
      emit(GetAllTasksSuccessState());
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response);
      }
      emit(GetAllTasksErrorState());
    });
  }

  Future<void> fetchNewTasks({required context}) async {
    isLoading = true;
    emit(GetMoreTasksLoadingState());
    await DioHelper.get(
        endpoint: EndPoints.tasks,
        token: LocalData.get(SharedKeys.token),
        prams: {
          'page': (toDoModel?.data?.meta?.currentPage ?? 0) + 1,
        }).then((value) {
      isLoading = false;
      ToDoModel newToDoModel = ToDoModel.fromJson(value?.data);

      toDoModel?.data?.meta = newToDoModel.data?.meta;
      toDoModel?.data?.tasks?.addAll(newToDoModel.data!.tasks ?? []);
      if ((toDoModel?.data?.meta?.lastPage ?? 0) ==
          (toDoModel?.data?.meta?.currentPage ?? 0)) {
        hasMoreTasks = false;
      }
      emit(GetMoreTasksSuccessState());
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        isLoading = false;
        print(error.response);
      }
      emit(GetMoreTasksErrorState());
    });
  }

  Future<void> addNewTask({required context}) async {
    emit(AddNewTasksLoadingState());
    await DioHelper.post(
        endpoint: EndPoints.tasks,
        token: LocalData.get(SharedKeys.token),
        formData: FormData.fromMap({
          "title": titleController.text,
          "description": descriptionController.text,
          "start_date": startDateController.text,
          "end_date": endDateController.text,
          if (image != null) "image": await MultipartFile.fromFile(image!.path),
          "status": statusSelected.toString()
        })).then((value) {
      print(value?.data);
      emit(AddNewTasksSuccessState());
      getAllTasks(context: context);
      restControllers();
      Functions.showSuccessToast(
          msg: "Task Added successfully", context: context);
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response?.data);
        Functions.showErrorToast(
          msg: error.response!.data['message'].toString(),
          context: context,
        );
      }
      emit(AddNewTasksErrorState());
      throw error;
    });
  }

  Future<void> editeTask({required context}) async {
    emit(EditeTasksLoadingState());
    await DioHelper.post(
        endpoint:
            "${EndPoints.tasks}/${toDoModel?.data?.tasks?[currentindex].id}",
        token: LocalData.get(SharedKeys.token),
        formData: FormData.fromMap({
          "_method": "PUT",
          "title": titleController.text,
          "description": descriptionController.text,
          "start_date": startDateController.text,
          "end_date": endDateController.text,
          if (image != null) "image": await MultipartFile.fromFile(image!.path),
          "status": statusSelected.toString()
        })).then((value) {
      emit(EditeTasksSuccessState());
      getAllTasks(context: context);
      restControllers();
      Functions.showSuccessToast(
          msg: "Task Updated Successfully", context: context);
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response?.data);
        Functions.showErrorToast(
            msg: error.response?.data['message'], context: context);
      }
      emit(EditeTasksErrorState());
      throw error;
    });
  }

  Future<void> deleteTask({required int id, required context}) async {
    emit(EditeTasksLoadingState());
    await DioHelper.delete(
      endpoint: "${EndPoints.tasks}/$id",
      token: LocalData.get(SharedKeys.token),
    ).then((value) {
      print(value?.data);
      emit(DeleteTasksSuccessState());
      getAllTasks(context: context);
      Functions.showSuccessToast(
          msg: "Task Deleted Successfully", context: context);
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        print(error.response?.data);
        Functions.showErrorToast(msg: error.response?.data, context: context);
      }
      emit(EditeTasksErrorState());
      throw error;
    });
  }

  StatisticsModel? statisticsModel;

  Future<void> showStatistics() async {
    statisticsModel = null;
    total = 0;
    emit(ShowStatisticsLoadingState());
    print(SharedKeys.token);
    await DioHelper.get(
            endpoint: "${EndPoints.tasks}-${EndPoints.statistics}",
            token: LocalData.get(SharedKeys.token))
        .then((value) {
      print(value?.data);
      statisticsModel = StatisticsModel.fromJson(value?.data['data']);
      total = (statisticsModel?.newTasks ?? 0) +
          (statisticsModel?.doingTasks ?? 0) +
          (statisticsModel?.completedTasks ?? 0) +
          (statisticsModel?.outdatedTasks ?? 0);
      emit(ShowStatisticsSuccessState());
    }).catchError((error) {
      print(error);
      emit(ShowStatisticsErrorState());
      throw error;
    });
  }

  void takePhotoFromUser({required context}) async {
    emit(TakeImageLoadingState());
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print("Permission granted");
    } else {
      try {
        image = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
        emit(TakeImageSuccessState());
      } catch (e) {
        print(e);
        emit(TakeImageErrorState());
        Functions.showErrorToast(context: context, msg: "Error picking image");
      }
    }
    if (image == null) {
      emit(TakeImageErrorState());
      Functions.showErrorToast(
        context: context,
        msg: "Choose Image",
      );
    }
  }
}
