class ToDoModel {
  Data? data;
  String? message;
  List<dynamic>? error;
  int? status;

  ToDoModel({this.data, this.message, this.error, this.status});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'] != null ? List<dynamic>.from(json['error']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['error'] = error;
    data['status'] = status;
    return data;
  }
}

class Data {
  List<Tasks>? tasks;
  Meta? meta;
  Links? links;
  List<String>? pages;

  Data({this.tasks, this.meta, this.links, this.pages});

  Data.fromJson(Map<String, dynamic> json) {
    tasks = (json['tasks'] as List<dynamic>)
        .map((task) => Tasks.fromJson(task))
        .toList();
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    pages = List<String>.from(json['pages']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tasks'] = tasks?.map((task) => task.toJson()).toList();
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    data['pages'] = pages;
    return data;
  }
}

class Tasks {
  int? id;
  String? title;
  String? description;
  dynamic image;
  String? startDate;
  String? endDate;
  String? status;

  Tasks({
    this.id,
    this.title,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
    this.status,
  });

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    return data;
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Meta({this.total, this.perPage, this.currentPage, this.lastPage});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    return data;
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first'] = first;
    data['last'] = last;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
}

class StatisticsModel {
  num? newTasks;
  num? outdatedTasks;
  num? doingTasks;
  num? completedTasks;

  StatisticsModel(
      {this.newTasks,
      this.outdatedTasks,
      this.doingTasks,
      this.completedTasks});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    newTasks = json['new'];
    outdatedTasks = json['outdated'];
    doingTasks = json['doing'];
    completedTasks = json['compeleted'];
  }
}
