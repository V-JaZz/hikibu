class CourseModel {
  final Course course;
  final List<InstructorData> instructorData;
  final List<CourseVideo> courseVideo;

  CourseModel({
    required this.course,
    required this.instructorData,
    required this.courseVideo,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      course: Course.fromJson(json['course']),
      instructorData: List<InstructorData>.from(
        json['instructorData'].map((data) => InstructorData.fromJson(data)),
      ),
      courseVideo: List<CourseVideo>.from(
        json['coursevideo'].map((video) => CourseVideo.fromJson(video)),
      ),
    );
  }
}

class Course {
  final int id;
  final String courseName;
  final String courseDesc;
  final int price;
  final String images;
  final List<String> whatYouGet;
  final String createdAt;

  Course({
    required this.id,
    required this.courseName,
    required this.courseDesc,
    required this.price,
    required this.images,
    required this.whatYouGet,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    List<String> whatYouGetList = [];
    if (json['whatYouGet'] is List<dynamic>) {
      whatYouGetList = List<String>.from(json['whatYouGet']);
    } else if (json['whatYouGet'] is String) {
      whatYouGetList = (json['whatYouGet'] as String)
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map((e) => e.trim())
          .toList();
    }

    return Course(
      id: json['id'],
      courseName: json['courseName'],
      courseDesc: json['courseDesc'],
      price: json['price'],
      images: json['images'],
      whatYouGet: whatYouGetList,
      createdAt: json['createdAt'],
    );
  }
}

class InstructorData {
  final int id;
  final int courseId;
  final String name;
  final String description;
  final String image;
  final String occupation;
  final String date;

  InstructorData({
    required this.id,
    required this.courseId,
    required this.name,
    required this.description,
    required this.image,
    required this.occupation,
    required this.date,
  });

  factory InstructorData.fromJson(Map<String, dynamic> json) {
    return InstructorData(
      id: json['id'],
      courseId: json['course_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      occupation: json['occupation'],
      date: json['date'],
    );
  }
}

class CourseVideo {
  final int id;
  final int courseId;
  final String name;
  final String image;
  final String videoUrl;
  final String description;
  final String date;

  CourseVideo({
    required this.id,
    required this.courseId,
    required this.name,
    required this.image,
    required this.videoUrl,
    required this.description,
    required this.date,
  });

  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(
      id: json['id'],
      courseId: json['course_id'],
      name: json['name'],
      image: json['image'],
      videoUrl: json['videoUrl'],
      description: json['description'],
      date: json['date'],
    );
  }
}
