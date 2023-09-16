import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hukibu/Screen/setting_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../API/api_client.dart';
import '../model/get_children.dart';
import '../services/storage.dart';

class EditChild extends StatefulWidget {
  final Children child;
  const EditChild({super.key, required this.child});

  @override
  State<EditChild> createState() => _EditChildState();
}

class _EditChildState extends State<EditChild> {

  late String selectedGender = '';
  late String selectedRelation = '';
  late DateTime selectedDate;
  final picker = ImagePicker();
  String? imageURL;
  File? _image;
  String? name;
  String? pdf;

  TextEditingController fullName = TextEditingController();
  TextEditingController nickName = TextEditingController();
  @override
  void initState() {
    fullName.text = widget.child.name;
    nickName.text = widget.child.nickname;
    selectedDate = widget.child.dob;
    selectedGender = widget.child.gender[0].toUpperCase()+widget.child.gender.substring(1);
    selectedRelation = widget.child.relation[0].toUpperCase()+widget.child.relation.substring(1);
    print(selectedRelation);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 90, 32, 100),
        title: const Text(
          'Edit Child Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: showDeleteConfirmationDialog, icon: const Icon(Icons.delete,color: Colors.white))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Center(
              child: InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) => BottomSheet2());
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
            ),
            const SizedBox(
              height: 18,
            ),
            TextField(
              controller: fullName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                  hintText: 'Enter Child Name'),
            ),
            const SizedBox(
              height: 18,
            ),
            TextField(
              controller: nickName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nick Name',
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Date of Birth',
              ),
              initialValue: selectedDate,
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
              height: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text('Gender :'),
            const SizedBox(
              height: 8,
            ),
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
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Your relation with kid :'),
            const SizedBox(
              height: 8,
            ),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          saveDetails();
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 16,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 103, 43, 215),
              borderRadius: BorderRadius.circular(30)),
          child: const Center(
              child: Text(
                'Save',
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

  Future<bool> saveDetails() async {

    try{
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://139.59.68.139:3000/admin-updateChild/${widget.child.id}'));
      request.fields.addAll({
        "name": fullName.text,
        "nickname": nickName.text,
        "relation": selectedRelation,
        "gender": selectedGender,
        'dob': DateFormat('yyyy-MM-dd').format(selectedDate),
        'age':'${DateTime.now().difference(selectedDate).inDays}',
        'questions':widget.child.setOfQuestions,
      });
      if(_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('childImage', _image!.path));
      }
      print(request.toString());
      print(request.fields.toString());
      print(request.files.toString());

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      print(response.reasonPhrase);


      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('success');
        Get.back();
        Get.back();
        Get.to(() => const SettingScreen());
        return true;
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
        return false;
      }
    }catch (error) {
      print(error);
      Get.snackbar(
        "Auth Failed",
        '$error',
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
      return false;
    }
  }

  Widget BottomSheet2() {
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

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform delete action here
                print('Deleting...');
                Navigator.of(context).pop(); // Close the dialog
                deleteChild();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  void deleteChild() async {

    var request = http.Request('GET', Uri.parse('http://139.59.68.139:3000/admin-deleteChildByChildId/${widget.child.id}'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('success');
      Get.back();
      Get.back();
      Get.to(() => const SettingScreen());
    }
    else {
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
}
