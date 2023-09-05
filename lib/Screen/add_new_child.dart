// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable, duplicate_ignore, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:hukibu/components/survey_question.dart';
import 'package:hukibu/model/add_a_child.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../API/api_client.dart';
import '../routes/route_paths.dart';
import 'package:http/http.dart' as http;

import '../services/storage.dart';

class AddNewChild extends StatefulWidget {
  const AddNewChild({super.key});

  @override
  State<AddNewChild> createState() => _AddNewChildState();
}

class _AddNewChildState extends State<AddNewChild> {
  String? imageURL;
  File? _image;
  final picker = ImagePicker();
  String? name;
  String? pdf;

  // final firebase_storage.FirebaseStorage _storage =
  //     firebase_storage.FirebaseStorage.instance;

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        name = (_image!.path);
      }
    });
    Reference ref = FirebaseStorage.instance.ref().child(name.toString());

    await ref.putFile(File(_image!.path));
    ref.getDownloadURL().then((value) async {
      setState(() {
        imageURL = value;
      });
    });
  }

  // ignore: non_constant_identifier_names
  Widget BottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 13,
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              getImageFromGallery();
            },
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  final namecontroller = TextEditingController();
  final areacontroller = TextEditingController();
  final surnamecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final gendercontroller = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('New Child');
  final ref = FirebaseFirestore.instance.collection('New Child');

  Future<void> addAChild() async {
    Response res = await ApiClient.to.postData('insert url here', {
      "name": namecontroller.text,
      "area": areacontroller.text,
      'surname': surnamecontroller.text,
      'age': agecontroller.text,
      'gender': gendercontroller.text,
    });
    log('This is the  auth response: ${res.body}');
    if (res.body['status'] == true) {
      // Success
      print('Data submitted successfully');
    } else {
      Fluttertoast.showToast(
        msg: "Unknown error occurred",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[300],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 60),
            child: Text(
              'Add New Child',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context, builder: (builder) => BottomSheet());
                    // Navigator.pop(context);
                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref('/Folder');
                    firebase_storage.UploadTask uploadTask =
                        ref.putFile(_image!.absolute);

                    Future.value(uploadTask).then((value) {
                      // ignore: unused_local_variable
                      var newUrl = ref.getDownloadURL();

                      // databaseRef
                      //     .child('1')
                      //     .set({'id': '1212', 'title': newUrl.toString()});

                      Fluttertoast.showToast(msg: 'Uploaded');
                    }).onError((error, stackTrace) {
                      Fluttertoast.showToast(msg: 'Image Was Not Uploaded');
                    });
                  },
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: _image != null
                          ? ClipOval(
                              child: Image.file(
                                _image!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.asset('assets/images/empty.webp'),
                            ))),

              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: namecontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your name', labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: surnamecontroller,
                // onSaved: (value) {
                //   surnamecontroller.text;
                // },
                decoration: const InputDecoration(
                    hintText: 'Enter Your Surname', labelText: 'SurName'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'SurName Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: agecontroller,
                // onSaved: (value) {
                //   agecontroller.text;
                // },
                decoration: const InputDecoration(
                    hintText: 'Enter Your Age', labelText: 'Age'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Age Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                hint: const Text('Select Gender'),
                items: ['Male', 'Female'].map(
                        (e) => DropdownMenuItem(
                          value: e,
                            child: Text(e),
                        ),
                ).toList(),
                onChanged: (value){
                  gendercontroller.text = value!;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: areacontroller,

                // onSaved: (value) {
                //   surnamecontroller.text;
                // },
                decoration: InputDecoration(
                    suffix: InkWell(
                      onTap:() async {
                        final path = await FlutterDocumentPicker.openDocument();
                        print(path);
                        File file = File(path!);
                        String downloadUrl = await uploadPDFToFirebaseStorage(
                            'filename.pdf', file);
                        setState(() {
                          pdf = downloadUrl;
                        });
                        print('Download URL: $downloadUrl');

                        // Navigator.pop(context);
                      },
                        child: const Icon(Icons.attach_file_rounded)
                    ),
                    hintText: 'Interested Area',
                    labelText: 'Interested Area'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Area Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              //const SurveyQuestion(title: 'title'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        loading = loading;
                      });
                      final uid = DateTime.now().millisecondsSinceEpoch.toString();
                      // setState(() {
                      //   loading = true;
                      // });
                      fireStore.doc(uid).set({
                        'uid': uid,
                        'name': namecontroller.text.toString(),
                        'surname': surnamecontroller.text.toString(),
                        'age': agecontroller.text.toString(),
                        'gender': gendercontroller.text.toString(),
                        'area': areacontroller.text.toString(),
                        'image': imageURL.toString(),
                        'pdf': pdf,
                      }).then((value) {
                        Fluttertoast.showToast(msg: 'New Child Added');
                        Navigator.of(context).pop();
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(
                          msg: '$error Something Want Wrong',
                        );
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 103, 43, 215),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (ctx) => AddAChild()));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) =>
                      //             const SurveyQuestion(title: '')));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 103, 43, 215),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text(
                        'Quiz',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadPDFToFirebaseStorage(String fileName, File file) async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('pdfs/$fileName');
      TaskSnapshot taskSnapshot = await storageReference.putFile(file);
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return 'null';
    }
  }
}

class AddANewChild extends StatefulWidget {
  const AddANewChild({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddANewChild> {
// we have initialized active step to 0 so that
// our stepper widget will start from first step
  int _activeCurrentStep = 0;
  late String selectedGender = '';
  late String selectedRelation = '';
  late DateTime selectedDate;

  TextEditingController fullName = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController gender = TextEditingController();

  String? imageURL;
  File? _image;
  final picker = ImagePicker();
  String? name;
  String? pdf;

  // final firebase_storage.FirebaseStorage _storage =
  //     firebase_storage.FirebaseStorage.instance;

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        name = (_image!.path);
      }
    });
  }

  // ignore: non_constant_identifier_names
  Widget BottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              getImageFromGallery();
            },
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  // void submitButtonClicked() async {
  //   if (_image != null) {
  //     // Prepare data
  //     final data = AddAChild(
  //       childImage: _image!,
  //       name: fullName.text,
  //       nickname: nickName.text,
  //       relation: selectedRelation,
  //       gender: selectedGender,
  //       dob: selectedDate.toString(),
  //       age: '',
  //       questions: questionResponses.valuesList(),
  //     );

  //     // Convert data to JSON
  //     final jsonData =
  //         data.toJson().map((key, value) => MapEntry(key, value.toString()));

  //     // Send POST request
  //     await postChildData(jsonData);
  //   } else {
  //     print('Image not selected');
  //   }
  // }

  // void submitButtonClicked() async {
  //   if (_image != null) {
  //     // Prepare data
  //     final data = AddAChild(
  //       childImage: _image!,
  //       name: fullName.text,
  //       nickname: nickName.text,
  //       relation: selectedRelation,
  //       gender: selectedGender,
  //       dob: selectedDate.toString(),
  //       age: '',
  //       questions: questionResponses.valuesList(),
  //     );

  //     // Send POST request
  //     await postChildData(data);
  //   } else {
  //     print('Image not selected');
  //   }
  // }

  void submitButtonClicked() async {
    if (_image != null) {
      // Prepare data
      final data = AddAChild(
        childImage: _image!,
        name: fullName.text,
        nickname: nickName.text,
        relation: selectedRelation,
        gender: selectedGender,
        dob: selectedDate.toString(),
        age: '',
        questions: questionResponses.valuesList(),
      );

      // Convert data to JSON
      final jsonData = data.toJson();

      // Send POST request
      await postChildData(jsonData);
    } else {
      print('Image not selected');
    }
  }

  postchild() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://139.59.68.139:3000/addChild/${StorageService.to.getString('userIdKey')}'));
    request.fields.addAll({
      'name': fullName.text,
      'nickname': nickName.text,
      'relation': selectedRelation,
      'gender': selectedGender,
      'dob': DateFormat('yyyy-MM-dd').format(selectedDate),
      // 'age': selectedDate.difference(DateTime.now()).toString(),
      'age':'${DateTime.now().difference(selectedDate).inDays}',
      'questions': questionResponses.valuesList().toString(),
    });
    request.files
        .add(await http.MultipartFile.fromPath('childImage', _image!.path));
    print(request.toString());
    print(request.fields.toString());
    print(request.files.toString());

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    print(response.reasonPhrase);

    setState(() {
      adding = false;
    });
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('success');
      Get.back();
      Get.back();
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const SettingScreen()));
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
        msg: "${response.statusCode} : ${response.reasonPhrase}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey[300],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  Future<void> postChildData(Map<String, dynamic> jsonData) async {
    const url = 'http://139.59.68.139:3000/addChild/1';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Add file to the request
      request.files.add(await http.MultipartFile.fromPath(
          'childImage', jsonData['childImage']));

      // Convert jsonData to Map<String, String>
      final stringData =
          jsonData.map((key, value) => MapEntry(key, value.toString()));

      // Add other data to the request
      request.fields.addAll(stringData);

      final response = await request.send();

      if (response.statusCode == 200) {
        // Request successful
        print('Data sent successfully');
      } else {
        // Request failed
        print('Failed to send data. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  // Future<void> postChildData(AddAChild childData) async {
  //   const url = 'http://13.126.205.178:3000/addChild/1';

  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(url));

  //     // Add file to the request
  //     request.files.add(await http.MultipartFile.fromPath(
  //         'childImage', childData.childImage.path));

  //     // Convert AddAChild object to JSON and add it as a field in the request
  //     request.fields['jsonData'] = jsonEncode(childData.toJson());

  //     final response = await request.send();

  //     if (response.statusCode == 200) {
  //       // Request successful
  //       print('Data sent successfully');
  //     } else {
  //       // Request failed
  //       print('Failed to send data. Error: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error sending data: $e');
  //   }
  // }

  // Future<void> postChildData(Map<String, String> jsonData) async {
  //   const url = 'http://13.126.205.178:3000/addChild/1';

  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(url));

  //     // Add file to the request
  //     request.files
  //         .add(await http.MultipartFile.fromPath('childImage', _image!.path));

  //     // Add other data to the request
  //     request.fields.addAll(jsonData);

  //     final response = await request.send();

  //     if (response.statusCode == 200) {
  //       // Request successful
  //       print('Data sent successfully');
  //     }
  //      else {
  //       // Request failed
  //       print('Failed to send data. Error: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error sending data: $e');
  //   }
  // }

  // void submitButtonClicked() {
  //   // Prepare data
  //   final data = AddAChild(
  //     childImage: _image!,
  //     name: fullName.text,
  //     nickname: nickName.text,
  //     relation: selectedRelation,
  //     gender: selectedGender,
  //     dob: selectedDate.toString(),
  //     age: '',
  //     questions: questionResponses.valuesList(),
  //   );

  //   // Convert data to JSON
  //   final jsonData = data.toJson();

  //   // Send POST request
  //   postChildData(jsonData);
  // }

  // void postChildData(Map<String, dynamic> jsonData) async {
  //   const url = 'http://13.126.205.178:3000/addChild/1';

  //   try {
  //     final response = await http.post(Uri.parse(url),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode(jsonData));

  //     if (response.statusCode == 200) {
  //       // Request successful
  //       print('Data sent successfully');
  //     } else {
  //       // Request failed
  //       print('Failed to send data. Error: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error sending data: $e');
  //   }
  // }

  // onSaveClick() async {
  //   if (fullName.text.isEmpty ||
  //       nickName.text.trim().isEmpty ||
  //       _image == null) {
  //     Fluttertoast.showToast(
  //       msg: "Unknown error occurred",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 3,
  //       backgroundColor: Colors.grey[300],
  //       textColor: Colors.black,
  //       fontSize: 16.0,
  //     );
  //     return;
  //   }
  //   var result = await postChildData(AddAChild(
  //       childImage: _image!,
  //       name: fullName.text,
  //       nickname: nickName.text,
  //       relation: selectedRelation,
  //       gender: selectedGender,
  //       dob: selectedDate.toString(),
  //       age: '',
  //       questions: questionResponses.valuesList()));

  //   // if (result != null) {
  //   //   Fluttertoast.showToast(
  //   //     msg: "Child Added!",
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.BOTTOM,
  //   //     timeInSecForIosWeb: 3,
  //   //     backgroundColor: Colors.grey[300],
  //   //     textColor: Colors.black,
  //   //     fontSize: 16.0,
  //   //   );
  //   // } else {
  //   //   print('failed');
  //   //   return;
  //   // }
  // }

  Map<String, bool> questionResponses = {
    "calm himself by bringing hand to mouth?": false,
    "express emotions like pleasure and discomfort": false,
    "try to look for his parent": false,
    "recognize family faces": false,
    "smile at familiar faces": false,
    "respond positively to touch": false,
    "make gurgling sound": false,
    "cry differently on different need": false,
    "try to imitate sound": false,
    "follow people with his eyes": false,
    "follow object with his eyes": false,
    "observe faces with interest": false,
    "raise his head lying on his stomach": false,
    "bring his hand to his mouth": false,
    "try to touch dangling objects": false,
    "has started to smile at others": false
  };

// Here we have created list of steps
// that are required to complete the form
  List<Step> stepList() => [
        // This is step1 which is called Account.
        // Here we will fill our personal details
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: const Text('Step 1'),
          content: Container(
            child: Column(
              children: [
                InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) => BottomSheet());
                      // Navigator.pop(context);
                    },
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: _image != null
                            ? ClipOval(
                                child: Image.file(
                                  _image!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipOval(
                                child: Image.asset('assets/images/empty.webp'),
                              ))),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: fullName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                      hintText: 'Enter Child Name'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: nickName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nick Name',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                //  GenderSelector()
                Wrap(
                  spacing: 8.0,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text(
                        'Male',
                      ),
                      selected: selectedGender == 'Male',
                      selectedColor: const Color.fromARGB(255, 158, 100, 169),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedGender = (selected ? 'Male' : null)!;
                          print(selectedGender);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Female'),
                      selected: selectedGender == 'Female',
                      selectedColor: const Color.fromARGB(255, 158, 100, 169),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedGender = (selected ? 'Female' : null)!;
                          print(selectedGender);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Other'),
                      selected: selectedGender == 'Other',
                      selectedColor: const Color.fromARGB(255, 158, 100, 169),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedGender = (selected ? 'Other' : null)!;
                          print(selectedGender);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // This is Step2 here we will enter our address
        Step(
            state: _activeCurrentStep <= 1
                ? StepState.editing
                : StepState.complete,
            isActive: _activeCurrentStep >= 1,
            title: const Text('Step 2'),
            content: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Date of Birth',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    // onDateSelected: (DateTime selectedDate) {
                    //   print(selectedDate);
                    // },

                    onDateSelected: (DateTime value) {
                      setState(() {
                        print(value);
                        selectedDate = value;
                        print(
                            ">>>>>>>>>>>>>>>>>>>>selectedDate : $selectedDate");
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // RelationSelector()
                  const Text('Your relation with kid :'),
                  Wrap(
                    spacing: 8.0,
                    children: <Widget>[
                      ChoiceChip(
                        label: const Text(
                          'MOM',
                        ),
                        selected: selectedRelation == 'Mom',
                        selectedColor: const Color.fromARGB(255, 158, 100, 169),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedRelation = (selected ? 'Mom' : null)!;
                            print(selectedRelation);
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('DAD'),
                        selected: selectedRelation == 'Dad',
                        selectedColor: const Color.fromARGB(255, 158, 100, 169),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedRelation = (selected ? 'Dad' : null)!;
                            print(selectedRelation);
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Other'),
                        selected: selectedRelation == 'Other',
                        selectedColor: const Color.fromARGB(255, 158, 100, 169),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedRelation = (selected ? 'Other' : null)!;
                            print(selectedRelation);
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            )),

        // This is Step3 here we will display all the details
        // that are entered by the user
        Step(
            state: StepState.complete,
            isActive: _activeCurrentStep >= 2,
            title: const Text('Quiz'),
            content: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: questionResponses.entries.map((entry) {
                final question = entry.key;
                final response = entry.value;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: response
                            ? const Color.fromARGB(255, 103, 43, 215)
                            : Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SwitchListTile(
                      activeColor: const Color.fromARGB(255, 103, 43, 215),
                      title: Text(question),
                      value: response,
                      onChanged: (value) {
                        // Update the response

                        questionResponses[question] = value;

                        setState(() {});
                      },
                    ),
                  ),
                );
              }).toList(),
            )
        )
      ];

  bool adding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 90, 32, 100),
        title: const Text(
          'Enter Child Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // Here we have initialized the stepper widget
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _activeCurrentStep,
        physics: const AlwaysScrollableScrollPhysics(),
        steps: stepList(),

        // onStepContinue takes us to the next step
        controlsBuilder: (context, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){

                    print(_activeCurrentStep);

                    if (_activeCurrentStep == 0 && _image?.path == null) {
                      Get.snackbar(
                        'Error',
                        'Select an image to continue',
                        snackStyle: SnackStyle.FLOATING,
                        icon: const Icon(
                          Icons.person,
                          color: Color(0xff28282B),
                        ),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey[200],
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        colorText: const Color(0xff28282B),
                        duration: const Duration(seconds: 4),
                        isDismissible: true,
                        forwardAnimationCurve: Curves.easeOutBack,
                      );
                      return;
                    }

                    if (_activeCurrentStep < (stepList().length - 1)) {
                      setState(() {
                        _activeCurrentStep += 1;
                      });
                    }

                    if (_activeCurrentStep == stepList().length - 1) {

                      if(_image?.path != null){
                        if(!adding){
                          setState(() {
                            adding = true;
                          });
                          postchild();
                        }
                      }else{
                        Get.snackbar(
                          'Error',
                          'Select an image in step 1 to continue',
                          snackStyle: SnackStyle.FLOATING,
                          icon: const Icon(
                            Icons.person,
                            color: Color(0xff28282B),
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.grey[200],
                          borderRadius: 10,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(15),
                          colorText: const Color(0xff28282B),
                          duration: const Duration(seconds: 4),
                          isDismissible: true,
                          forwardAnimationCurve: Curves.easeOutBack,
                        );
                      }
                    }

                  },
                  child: Text(adding?'Please Wait..':'Continue')
              ),
            ],
          );
        },

        // onStepCancel takes us to the previous step
        // onStepCancel: () {
        //   if (_activeCurrentStep == 0) {
        //     return;
        //   }
        //   setState(() {
        //     _activeCurrentStep -= 1;
        //   });
        // },

        // onStepTap allows to directly click on the particular step we want
        onStepTapped: (int index) {
          setState(() {
            _activeCurrentStep = index;
          });
          print(_activeCurrentStep);
        },
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       InkWell(
      //           onTap: () async {
      //             showModalBottomSheet(
      //                 context: context, builder: (builder) => BottomSheet());
      //             // Navigator.pop(context);
      //           },
      //           child: CircleAvatar(
      //               radius: 50,
      //               backgroundColor: Colors.white,
      //               child: _image != null
      //                   ? ClipOval(
      //                       child: Image.file(
      //                         _image!,
      //                         width: double.infinity,
      //                         fit: BoxFit.cover,
      //                       ),
      //                     )
      //                   : ClipOval(
      //                       child: Image.asset('assets/images/empty.webp'),
      //                     ))),
      //       TextField(
      //         controller: fullName,
      //         decoration: const InputDecoration(
      //             border: OutlineInputBorder(),
      //             labelText: 'Full Name',
      //             hintText: 'Enter Child Name'),
      //       ),
      //       const SizedBox(
      //         height: 8,
      //       ),
      //       TextField(
      //         controller: nickName,
      //         decoration: const InputDecoration(
      //           border: OutlineInputBorder(),
      //           labelText: 'Nick Name',
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 8,
      //       ),
      //       //  GenderSelector()
      //       Wrap(
      //         spacing: 8.0,
      //         children: <Widget>[
      //           ChoiceChip(
      //             label: Text(
      //               'Male',
      //             ),
      //             selected: selectedGender == 'Male',
      //             selectedColor: Color.fromARGB(255, 158, 100, 169),
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 selectedGender = (selected ? 'Male' : null)!;
      //                 print(selectedGender);
      //               });
      //             },
      //           ),
      //           ChoiceChip(
      //             label: Text('Female'),
      //             selected: selectedGender == 'Female',
      //             selectedColor: Color.fromARGB(255, 158, 100, 169),
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 selectedGender = (selected ? 'Female' : null)!;
      //                 print(selectedGender);
      //               });
      //             },
      //           ),
      //           ChoiceChip(
      //             label: Text('Other'),
      //             selected: selectedGender == 'Other',
      //             selectedColor: Color.fromARGB(255, 158, 100, 169),
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 selectedGender = (selected ? 'Other' : null)!;
      //                 print(selectedGender);
      //               });
      //             },
      //           ),
      //         ],
      //       ),
      //       const SizedBox(
      //         height: 8,
      //       ),
      //       DateTimeFormField(
      //         decoration: const InputDecoration(
      //           hintStyle: TextStyle(color: Colors.black45),
      //           errorStyle: TextStyle(color: Colors.redAccent),
      //           border: OutlineInputBorder(),
      //           suffixIcon: Icon(Icons.event_note),
      //           labelText: 'Date of Birth',
      //         ),
      //         mode: DateTimeFieldPickerMode.date,
      //         autovalidateMode: AutovalidateMode.always,
      //         validator: (e) =>
      //             (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
      //         // onDateSelected: (DateTime selectedDate) {
      //         //   print(selectedDate);
      //         // },

      //         onDateSelected: (DateTime value) {
      //           setState(() {
      //             print(value);
      //             selectedDate = value;
      //             print(">>>>>>>>>>>>>>>>>>>>selectedDate : $selectedDate");
      //           });
      //         },
      //       ),
      //       const SizedBox(
      //         height: 8,
      //       ),
      //       // RelationSelector()
      //       Text('Your relation with kid :'),
      //       Wrap(
      //         spacing: 8.0,
      //         children: <Widget>[
      //           ChoiceChip(
      //             label: Text(
      //               'MOM',
      //             ),
      //             selected: selectedRelation == 'Mom',
      //             selectedColor: Color.fromARGB(255, 158, 100, 169),
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 selectedRelation = (selected ? 'Mom' : null)!;
      //                 print(selectedRelation);
      //               });
      //             },
      //           ),
      //           ChoiceChip(
      //             label: Text('DAD'),
      //             selected: selectedRelation == 'Dad',
      //             selectedColor: Color.fromARGB(255, 158, 100, 169),
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 selectedRelation = (selected ? 'Dad' : null)!;
      //                 print(selectedRelation);
      //               });
      //             },
      //           ),
      //           ChoiceChip(
      //             label: Text('Other'),
      //             selected: selectedRelation == 'Other',
      //             selectedColor: Color.fromARGB(255, 158, 100, 169),
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 selectedRelation = (selected ? 'Other' : null)!;
      //                 print(selectedRelation);
      //               });
      //             },
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: MediaQuery.of(context).size.height,
      //         child: ListView(
      //           shrinkWrap: true,
      //           children: questionResponses.entries.map((entry) {
      //             final question = entry.key;
      //             final response = entry.value;

      //             return Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   border: Border.all(
      //                     color: response
      //                         ? const Color.fromARGB(255, 103, 43, 215)
      //                         : Colors.grey,
      //                     width: 1.0,
      //                   ),
      //                   borderRadius: BorderRadius.circular(8.0),
      //                 ),
      //                 child: SwitchListTile(
      //                   activeColor: const Color.fromARGB(255, 103, 43, 215),
      //                   title: Text(question),
      //                   value: response,
      //                   onChanged: (value) {
      //                     // Update the response

      //                     questionResponses[question] = value;

      //                     setState(() {});
      //                   },
      //                 ),
      //               ),
      //             );
      //           }).toList(),
      //         ),
      //       ),

      //       SizedBox(
      //         height: 90,
      //       ),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ElevatedButton(
      //       onPressed: () {
      //         submitButtonClicked();
      //       },
      //       child: Text('Submit')),
      // ),
    );
  }
}

class GenderSelector extends StatefulWidget {
  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  late String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: <Widget>[
        ChoiceChip(
          label: const Text(
            'Male',
          ),
          selected: selectedGender == 'Male',
          selectedColor: const Color.fromARGB(255, 158, 100, 169),
          onSelected: (bool selected) {
            setState(() {
              selectedGender = (selected ? 'Male' : null)!;
              print(selectedGender);
            });
          },
        ),
        ChoiceChip(
          label: const Text('Female'),
          selected: selectedGender == 'Female',
          selectedColor: const Color.fromARGB(255, 158, 100, 169),
          onSelected: (bool selected) {
            setState(() {
              selectedGender = (selected ? 'Female' : null)!;
              print(selectedGender);
            });
          },
        ),
        ChoiceChip(
          label: const Text('Other'),
          selected: selectedGender == 'Other',
          selectedColor: const Color.fromARGB(255, 158, 100, 169),
          onSelected: (bool selected) {
            setState(() {
              selectedGender = (selected ? 'Other' : null)!;
              print(selectedGender);
            });
          },
        ),
      ],
    );
  }
}

class RelationSelector extends StatefulWidget {
  @override
  _RelationSelectorState createState() => _RelationSelectorState();
}

class _RelationSelectorState extends State<RelationSelector> {
  late String selectedRelation = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: <Widget>[
        ChoiceChip(
          label: const Text(
            'MOM',
          ),
          selected: selectedRelation == 'Mom',
          selectedColor: const Color.fromARGB(255, 158, 100, 169),
          onSelected: (bool selected) {
            setState(() {
              selectedRelation = (selected ? 'Mom' : null)!;
              print(selectedRelation);
            });
          },
        ),
        ChoiceChip(
          label: const Text('DAD'),
          selected: selectedRelation == 'Dad',
          selectedColor: const Color.fromARGB(255, 158, 100, 169),
          onSelected: (bool selected) {
            setState(() {
              selectedRelation = (selected ? 'Dad' : null)!;
              print(selectedRelation);
            });
          },
        ),
        ChoiceChip(
          label: const Text('Other'),
          selected: selectedRelation == 'Other',
          selectedColor: const Color.fromARGB(255, 158, 100, 169),
          onSelected: (bool selected) {
            setState(() {
              selectedRelation = (selected ? 'Other' : null)!;
              print(selectedRelation);
            });
          },
        ),
      ],
    );
  }
}
