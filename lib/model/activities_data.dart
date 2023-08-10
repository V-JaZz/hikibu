class ActivityModel {
  final Activity activity;
  final List<MaterialData> materialData;
  final List<StepData> stepData;

  ActivityModel({
    required this.activity,
    required this.materialData,
    required this.stepData,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activity: Activity.fromJson(json['activity']),
      materialData: List<MaterialData>.from(json['materialData'].map((data) => MaterialData.fromJson(data))),
      stepData: List<StepData>.from(json['stepData'].map((data) => StepData.fromJson(data))),
    );
  }
}

class Activity {
  final int id;
  final String name;
  final String image;
  final String timeDuration;

  Activity({
    required this.id,
    required this.name,
    required this.image,
    required this.timeDuration,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      timeDuration: json['time_duration'],
    );
  }
}

class MaterialData {
  final int id;
  final int activityId;
  final String materialName;

  MaterialData({
    required this.id,
    required this.activityId,
    required this.materialName,
  });

  factory MaterialData.fromJson(Map<String, dynamic> json) {
    return MaterialData(
      id: json['id'],
      activityId: json['activity_id'],
      materialName: json['material_name'],
    );
  }
}

class StepData {
  final int id;
  final int activityId;
  final String stepDescription;

  StepData({
    required this.id,
    required this.activityId,
    required this.stepDescription,
  });

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      id: json['id'],
      activityId: json['activity_id'],
      stepDescription: json['step_description'],
    );
  }
}
