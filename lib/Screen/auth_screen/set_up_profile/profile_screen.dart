// ignore_for_file: unused_field, non_constant_identifier_names, duplicate_ignore, unused_catch_clause

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hukibu/API/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../model/get_user.dart';
import '../../../model/user_model.dart';

import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../services/storage.dart';
import '../../setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AsyncSnapshot<UserData> user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedImage;
  String? imagePaths;
  String? userImage;
  late UserModel userModel;

  final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final gendercontroller = TextEditingController();
  final areacontroller = TextEditingController();
  final mobilecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final educationcontroller = TextEditingController();
  final jobcontroller = TextEditingController();
  final vocationcontroller = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    _getDataFromDatabase();

    namecontroller.text = widget.user.data?.name??'';
    agecontroller.text = widget.user.data?.age.toString()??'';
    gendercontroller.text = widget.user.data?.gender??'';
    areacontroller.text = widget.user.data?.area??'';
    educationcontroller.text = widget.user.data?.education??'';
    jobcontroller.text = widget.user.data?.job??'';
    vocationcontroller.text = widget.user.data?.vocation??'';
    emailcontroller.text = widget.user.data?.email??'';
    mobilecontroller.text = widget.user.data?.mobile??'';

    super.initState();
  }

  _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(const GetOptions(source: Source.cache))
        .then((snapshot) async {
      if (snapshot.exists && snapshot.get('phonenumber') != null) {
        setState(() {
          userModel = UserModel.fromJson(snapshot.data()!);
        });
      } else {
        setState(() {});
      }
    });
  }

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref('New Child');

  Future pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          pickedImage = File(pickedFile.path);
          imagePaths = (pickedImage!.path);
        }
      });
      if (pickedImage == null) return null;
      setState(() {});
    } on Exception catch (e) {
      return const Text('Uploading Failed');
    }
  }

  Widget BottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
            child: const ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text('Camera'),
            ),
          ),
          InkWell(
            onTap: () {
              pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
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

  Future<void> editProfile() async {

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('http://139.59.68.139:3000/update/${StorageService.to.getString('userIdKey')}')
    );
    request.fields.addAll({
      if(namecontroller.text != '')'name': namecontroller.text,
      if(agecontroller.text != '')'age': agecontroller.text,
      if(gendercontroller.text != '')'gender': gendercontroller.text,
      if(areacontroller.text != '')'area': areacontroller.text,
      if(educationcontroller.text != '')'education': educationcontroller.text,
      if(jobcontroller.text != '')'job': jobcontroller.text,
      if(vocationcontroller.text != '')'vocation': vocationcontroller.text,
      if(mobilecontroller.text != '')'mobile': mobilecontroller.text,
      if(emailcontroller.text != '')'email': emailcontroller.text
    }) ;
    if(pickedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', pickedImage!.path));
    }
    request.headers.addAll(headers);

    print(request.toString());
    print(request.fields.toString());
    print(request.files.toString());

  http.StreamedResponse response = await request.send();
    print(response.statusCode);
    print(response.reasonPhrase);

    setState(() {
      loading = true;
    });
  var res = await http.Response.fromStream(response);
    log('This is the  auth response: ${res.body}');

    if (res.statusCode == 200) {
      // Success
      print('Data submitted successfully');
      Get.back();
      Get.back();
      Get.to(() => const SettingScreen());
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
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  print(imagePaths);
                  showModalBottomSheet(
                      context: context, builder: (builder) => BottomSheet());
                },
                child: widget.user.data?.image !=null && widget.user.data?.image != ""? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'http://139.59.68.139:3000/uploads/${widget.user.data!.image}'),
                ):(imagePaths != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(imagePaths!)),
                      )
                    : const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/empty.webp'),
                  backgroundColor: Colors.white,
                )),
              ),
              TextFormField(
                controller: namecontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Name/Surname',
                    labelText: 'Name/Surname'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name Required';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: agecontroller,
                keyboardType: TextInputType.number,
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
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8.0,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text(
                        'Male',
                      ),
                      selected: gendercontroller.text.toLowerCase() == 'male',
                      selectedColor: const Color.fromARGB(255, 158, 100, 169),
                      onSelected: (bool selected) {
                        setState(() {
                          gendercontroller.text = (selected ? 'Male' : null)!;
                          print(gendercontroller.text);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Female'),
                      selected: gendercontroller.text.toLowerCase() == 'female',
                      selectedColor: const Color.fromARGB(255, 158, 100, 169),
                      onSelected: (bool selected) {
                        setState(() {
                          gendercontroller.text = (selected ? 'Female' : null)!;
                          print(gendercontroller.text);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Other'),
                      selected: gendercontroller.text.toLowerCase() == 'other',
                      selectedColor: const Color.fromARGB(255, 158, 100, 169),
                      onSelected: (bool selected) {
                        setState(() {
                          gendercontroller.text = (selected ? 'Other' : null)!;
                          print(gendercontroller.text);
                        });
                      },
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: mobilecontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Mobile number', labelText: 'Mobile'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mobile number Required';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Email', labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email Required';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: areacontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Area', labelText: 'Area'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Area Required';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: educationcontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Education', labelText: 'Education'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Education Required';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: jobcontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Job', labelText: 'Job'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Job Required';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: vocationcontroller,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Vocation', labelText: 'Vocation'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vocation Required';
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if(!loading){
            editProfile();
            setState(() {
              loading = true;
            });
          }
          // await updateToFirebase().then((value) => Navigator.pop(context));
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 16,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 103, 43, 215),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
              child: loading ?
              const CircularProgressIndicator(color: Colors.white)
              :const Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  Future<void> updateToFirebase() async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePaths.toString());

    if (imagePaths != null) {
      await ref.putFile(File(pickedImage!.path));
      ref.getDownloadURL().then((value) async {
        setState(() {
          userImage = value;
        });
      });
    }

    FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(UserModel(
          relation: userModel.relation,
          age: agecontroller.text != '' ? agecontroller.text : userModel.age,
          gender: gendercontroller.text != ''
              ? gendercontroller.text
              : userModel.gender,
          mobile: userModel.mobile,
          area:
              areacontroller.text != '' ? areacontroller.text : userModel.area,
          education: educationcontroller.text != ''
              ? educationcontroller.text
              : userModel.education,
          job: jobcontroller.text != '' ? jobcontroller.text : userModel.job,
          vocation: vocationcontroller.text != ''
              ? vocationcontroller.text
              : userModel.vocation,
          name: namecontroller.text != ''
              ? namecontroller.text
              : userModel.name,
          image: userImage ?? userModel.image,
        ).toJson());
  }
}
